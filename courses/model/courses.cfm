<!--- Courses Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../header.cfm"

	pagetitle="Advisor Services Portal - Completed Courses">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <!--- Alter page header depending if in an adivisng session or not. --->
				<cfif IsUserInRole("advisor")>
					<h1>Completed Courses for <cfoutput>#session.studentName#</cfoutput></h1>
				<cfelse>
					<h1>Completed Courses</h1>
				</cfif>
	        </header>

			<div class="breadcrumb">
				<a href="../dashboard/">Home</a>
				&raquo; Completed Courses for <cfoutput>#session.studentName#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Completed Courses" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
	                	
	                	<!-- Form START -->
						<cfform>
							<h2>Add a Course by Number</h2>

							<cfif messageBean.hasErrors() && isDefined("form.searchButton")>
								<table>
									<tr>
										<td colspan="2">
											<div id="form-errors">
												<ul>
													<cfloop array="#messageBean.getErrors()#" index="error">
														<cfoutput><li>#error.message#</li></cfoutput>
													</cfloop>
												</ul>
											</div>											
										</td>
									</tr>
								</table>
							</cfif>
							<p>
								<cfinput width="275px" type="text" id="searchTerm" name="searchTerm">&nbsp;<cfinput type="submit" name="searchButton" value="Search">
							</p>
							<p>
								<a href="https://www.everettcc.edu/catalog/" title="View official course catalog" target="_blank">View official course catalog</a>
							</p>	
						</cfform>
	                	<!-- Form END -->
	                	
	                	

	                	<!-- Search Results START -->
						<!--- After search form is submitted, display results. --->
						<div id="search-results">
						<cfif isDefined("form.searchButton") && isDefined("qCoursesGetCourse") && qCoursesGetCourse.RecordCount>
							<h2>Search Results</h2>
							<cfif isDefined("url.add") || isDefined("qCoursesGetCourse") && qCoursesGetCourse.RecordCount>
								<a href="../courses/" title="Clear search">Clear search</a>
							<cfelse>
							</cfif>
							<table>
								<tr>
									<th width="125px">Number</th>
									<th>Title</th>
									<th>Credits</th>
									<th></th>
								</tr>
								<cfloop query="qCoursesGetCourse">
									<tr>
										<td><cfoutput><a href="../view/courses/?course=#URLEncodedFormat(qCoursesGetCourse.id)#" title="#qCoursesGetCourse.course_number#">#qCoursesGetCourse.course_number#</a></cfoutput></td>
										<td><cfoutput>#qCoursesGetCourse.title#</cfoutput></td>
										<cfif !len(qCoursesGetCourse.min_credit)>
											<td><cfoutput>#qCoursesGetCourse.max_credit#</cfoutput></td>
										<cfelse>
											<td><cfoutput>#qCoursesGetCourse.min_credit# - #qCoursesGetCourse.max_credit#</cfoutput></td>
										</cfif>
										<td>
											<cfform>
												<cfinput type="hidden" name="thisCourseId" value="#qCoursesGetCourse.id#">
												<cfinput type="hidden" name="thisCourseNumber" value="#qCoursesGetCourse.course_number#">
												<cfinput type="submit" name="addButton" value="Add">
											</cfform>
										</td>
									</tr>
								</cfloop>
							</table>
						</cfif>
						</div>						
	                	<!-- Search Results END -->

	                	<!-- Course Validation START -->
						<!--- The course was valid.  Verify student eligibility before adding the course. --->
						<div id="search-results">
						<cfif isDefined("qCoursesCheckCourse") && qCoursesCheckCourse.RecordCount>
							<cfif IsNumeric(qCoursesCheckCourse.min_credit) || qCoursesGetPrerequisite.RecordCount || qCoursesGetPermission.RecordCount || qCoursesGetPlacement.RecordCount>
								<h2>Verify Course Eligibility</h2>
								<h3><cfoutput>#qCoursesCheckCourse.course_number# - #qCoursesCheckCourse.title#</cfoutput></h3>
								<table>
									<cfif messageBean.hasErrors() && isDefined("form.addCourseButton")>
										<tr>
											<td colspan="2">
												<div id="form-errors">
													<ul>
														<cfloop array="#messageBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</div>											
											</td>
										</tr>
									</cfif>
									<cfform>
										<!--- Determine student course credit for variable credit courses. --->
										<cfif IsNumeric(qCoursesCheckCourse.min_credit)>
											<tr>
												<td width="180px"><label for="courseCredit">Credits taken <cfoutput>(#qCoursesCheckCourse.min_credit# - #qCoursesCheckCourse.max_credit#)</cfoutput>:</label></td>
												<td><cfinput type="text" id="courseCredit" name="courseCredit"></td>
											</tr>
										</cfif>
										<cfif ArrayLen(aPrerequisites)>
											<tr>
												<td colspan="2">
													<p><strong>Prerequisites:</strong></p>
													<cfinput type="hidden" id="numOfPrereqGroups" name="numOfPrereqGroups" value="#ArrayLen(aPrerequisites)#">
												</td>
												<td></td>
											</tr>
											<tr>
												<td colspan="2">
													<cfloop index="i" from=1 to=#ArrayLen(aPrerequisites)#>
														<cfinput type="radio" id="prereq#i#" name="prereq" value="#i#">
														<cfoutput><label for="prereq#i#">#aPrerequisites[i]#</label></cfoutput><br>
													</cfloop>
												</td>
												<td></td>
											</tr>
										</cfif>
										<tr>
											<td><cfinput type="submit" name="addCourseButton" value="Add course"></td>
											<td></td>
										</tr>
									</cfform>
								</table>
							</cfif>
						</cfif>
						</div>						
	                	<!-- Course Validation END -->

	                	<!-- Completed Courses START -->
						<!--- Display student's completed courses --->
						<div id="search-results">
							<cfif isDefined("qCoursesGetStudentCourses")>
								<h2>Completed Courses</h2>
								<cfif qCoursesGetStudentCourses.RecordCount>
									<table>
										<tr>
											<th width="125px">Number</th>
											<th>Title</th>
											<th>Credits</th>
											<th></th>
										</tr>
										<cfloop query="qCoursesGetStudentCourses">
											<tr>
												<td><cfoutput><a href="../view/courses/?course=#URLEncodedFormat(qCoursesGetStudentCourses.id)#" title="#qCoursesGetStudentCourses.course_number#">#qCoursesGetStudentCourses.course_number#</a></cfoutput></td>
												<td><cfoutput>#qCoursesGetStudentCourses.title#</cfoutput></td>
												<td><cfoutput>#qCoursesGetStudentCourses.credit#</cfoutput></td>
												<td>
													<cfform>
														<cfinput type="hidden" name="thisCourseId" value="#qCoursesGetStudentCourses.completed_id#">
														<cfinput type="submit" name="deleteCourseButton" value="Delete">
													</cfform>
												</td>
											</tr>
										</cfloop>
									</table>
								<cfelse>
									<p>No completed courses added yet.</p>
								</cfif>
							</cfif>
						</div>
	                	<!-- Completed Courses END -->						
						<p/>
	                </div>
	            </div>
	        </div>
	    </article>                   

		<aside id="content-sidebar">
		    <div class="region region-sidebar">			
                <div class="content">
                	<p>
                		<strong>About</strong>                		
                	</p>
			    	<p>The Advising Services Portal is an online student-transfer information system... describe some info, helps with visits with faculty advisors.</p>
					<p>More description... explain about intended use.  Private system, info is not shared or sold.</p>
            	</div>
		    </div>
		</aside>
	
<cfmodule template="../../footer.cfm">