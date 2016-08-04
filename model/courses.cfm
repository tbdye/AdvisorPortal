<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"

	pagetitle="Advisor Services Portal - Completed Courses">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <!--- Alter page header depending if in an adivisng session or not. --->
				<cfif IsUserInRole("advisor")>
					<h1>Completed courses for <cfoutput>#session.studentName#</cfoutput></h1>
				<cfelse>
					<h1>Completed Courses</h1>
				</cfif>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a> &raquo; <a href="courses.cfm">Completed Courses</a>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Completed Courses" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<h2>Add completed course</h2>
						<cfform>
							<table>
								<tr>
									<td colspan="2">
										<div id="form-errors">
											<cfif errorBean.hasErrors() && isDefined("form.searchButton")>
												<ul>
													<cfloop array="#errorBean.getErrors()#" index="error">
														<cfoutput><li>#error.message#</li></cfoutput>
													</cfloop>
												</ul>
											</cfif>
										</div>											
									</td>
								</tr>
								<tr>
									<td colspan="2"><strong>Find a course by course number</strong></td>
								</tr>
								<tr>
									<td width="120px"><cfinput type="text" id="searchTerm" name="searchTerm"></td>
									<td><cfinput type="submit" name="searchButton" value="Search"></td>								
								</tr>
								<tr>
									<cfif isDefined("url.add") || isDefined("qCoursesGetCourse") && qCoursesGetCourse.RecordCount>
										<td colspan="2"><a href="courses.cfm" title="Clear search">Clear search</a></td>
									<cfelse>
										<td colspan="2"><a href="https://www.everettcc.edu/catalog/" title="View official course catalog" target="_blank">View official course catalog</a></td>
									</cfif>
								</tr>
							</table>
						</cfform>

						<!--- After search form is submitted, display results. --->
						<cfif isDefined("form.searchButton") && isDefined("qCoursesGetCourse") && qCoursesGetCourse.RecordCount>
							<h2>Search results</h2>
							<table>
								<tr>
									<th width="120px">Course Number</th>
									<th>Title</th>
									<th>Credits</th>
									<th></th>
								</tr>
								<cfloop query="qCoursesGetCourse">
									<tr>
										<td><cfoutput>#qCoursesGetCourse.course_number#</cfoutput></td>
										<td><cfoutput>#qCoursesGetCourse.title#</cfoutput></td>
										<cfif !len(qCoursesGetCourse.min_credit)>
											<td><cfoutput>#qCoursesGetCourse.max_credit#</cfoutput></td>
										<cfelse>
											<td><cfoutput>#qCoursesGetCourse.min_credit# - #qCoursesGetCourse.max_credit#</cfoutput></td>
										</cfif>
										<td><cfoutput><a href="?add=#URLEncodedFormat(qCoursesGetCourse.course_number)#&id=#URLEncodedFormat(qCoursesGetCourse.id)#" title="Add">Add</a></cfoutput></td>
									</tr>
								</cfloop>
							</table>
						</cfif>
						
						<!--- The course was valid.  Verify student eligibility before adding the course. --->
						<cfif isDefined("qCoursesCheckCourse") && qCoursesCheckCourse.RecordCount>
							<cfif IsNumeric(qCoursesCheckCourse.min_credit) || qCoursesGetPrerequisite.RecordCount || qCoursesGetPermission.RecordCount || qCoursesGetPlacement.RecordCount>
								<h2>Verify course eligibility</h2>
								<h3><cfoutput>#qCoursesCheckCourse.course_number# - #qCoursesCheckCourse.title#</cfoutput></h3>
								<table>
									<tr>
										<td colspan="2">
											<div id="form-errors">
												<cfif errorBean.hasErrors() && isDefined("form.addCourseButton")>
													<ul>
														<cfloop array="#errorBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</cfif>
											</div>											
										</td>
									</tr>
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
											<td></td>
											<td><cfinput type="submit" name="addCourseButton" value="Add course"></td>
										</tr>
									</cfform>
								</table>
							</cfif>
						</cfif>

						<!--- Display student's completed courses --->
						<cfif isDefined("qCoursesGetStudentCourses")>
							<h2>Completed courses</h2>
							<cfif qCoursesGetStudentCourses.RecordCount>
								<table>
									<tr>
										<th width="120px">Course Number</th>
										<th>Title</th>
										<th>Credits</th>
										<th></th>
									</tr>
									<cfloop query="qCoursesGetStudentCourses">
										<tr>
											<td><cfoutput>#qCoursesGetStudentCourses.course_number#</cfoutput></td>
											<td><cfoutput>#qCoursesGetStudentCourses.title#</cfoutput></td>
											<td><cfoutput>#qCoursesGetStudentCourses.credit#</cfoutput></td>
											<td><cfoutput><a href="?delete=#URLEncodedFormat(qCoursesGetStudentCourses.course_number)#&id=#URLEncodedFormat(qCoursesGetStudentCourses.completed_id)#" title="Delete">Delete</a></cfoutput></td>
										</tr>
									</cfloop>
								</table>
							<cfelse>
								<p>No completed courses added yet.</p>
							</cfif>
						</cfif>
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
	
<cfmodule template="../includes/footer.cfm">