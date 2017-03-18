<!--- Dashboard Model --->
<!--- Thomas Dye, September 2016, February 2017 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../header.cfm"

	pagetitle="Advisor Services Portal - Dashboard">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <cfif IsUserInRole("advisor")>
					<h1>Dashboard for <cfoutput>#session.studentName#</cfoutput></h1>
				<cfelse>
					<h1>Dashboard</h1>
				</cfif>
	        </header>

			<div class="breadcrumb">
				<a href="">Home</a> &raquo;			
		            <cfif IsUserInRole("advisor")>
						Dashboard for <cfoutput>#session.studentName#</cfoutput>
					<cfelse>
						Dashboard
					</cfif>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Dashboard" class="rdf-meta element-hidden"></span>

					<cfif !qDashboardGetPlacementCourses.RecordCount>
						<h2>Add placement courses</h2>
						<cfform>
							<table>
								<cfif messageBean.hasErrors() && isDefined("form.addPlacementButton")>
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
								<tr>
									<th width="20%">Math</th>
									<th width="20%">English</th>
									<th></th>
								</tr>
								<tr>
									<td>
										<cfselect name="mathCourse" query="qDashboardGetMathCourses" display="course_number" value="id" queryPosition="below">
											<option value="0">Select course:</option>
										</cfselect>
									</td>
									<td>
										<cfselect name="englishCourse" query="qDashboardGetEnglishCourses" display="course_number" value="id" queryPosition="below">
											<option value="0">Select course:</option>
										</cfselect>
									</td>
									<td>
										<cfinput type="submit" name="addPlacementButton" value="Add">
									</td>
								</tr>
							</table>
						</cfform>
                	<cfelseif qDashboardGetActivePlan.RecordCount>
						<h2>Active Plan: <cfoutput>#qDashboardGetActivePlan.plan_name#</cfoutput></h2>

						<p>
						<cfoutput><a href="../view/degrees/?degree=#qDashboardGetActivePlan.degrees_id#" title="#qDashboardGetActivePlan.degree_name#">#qDashboardGetActivePlan.degree_name#</a></cfoutput><br>
						<cfoutput><a href="../view/colleges/?college=#qDashboardGetActivePlan.colleges_id#" title="#qDashboardGetActivePlan.college_name# - #qDashboardGetActivePlan.college_city#">#qDashboardGetActivePlan.college_name# - #qDashboardGetActivePlan.college_city#</a></cfoutput><br>
						<cfoutput>#qDashboardGetActivePlan.degree_type#</cfoutput>
						</p>
						
						<!---My schedule [<][>]
						[Quarter 1 | Quarter 2 | Quarter 3 | Quarter 4]
						[Edit | Edit | Edit | Edit]
						
						Edit courses for Quarter 1
						Unscheduled courses | Courses in Quarter 1
						[list 1] [>][<] [list 2]
										[Update][Cancel]--->

						<p/>

						<p/>

						<cfif qDashboardGetActivePlan.RecordCount && qDashboardGetCourses.RecordCount>
							<h2>Courses remaining for this plan</h2>
							
							<!--- Display courses by category --->
							<cfloop query="#qDashboardGetCategories#">
								<cfquery dbtype="query" name="qDashboardGetCategoryCourses">
									SELECT c_id, course_number, title, cc_id, cc_credit, credit, gc_id, sc_id, min_credit, max_credit
									FROM qDashboardGetCourses
									WHERE degree_categories_id = #qDashboardGetCategories.id#
								</cfquery>
								
								<hr/>
								
								<cfoutput>
									<h3>#qDashboardGetCategories.category#</h3></td>
									<div id="h4-box">
										<table>
											<tr>
												<th width="20%">Code</th>
												<th>Title</th>
												<th width="15%">Credits</th>
												<th width="20%">Status</th>
											</tr>
											<cfloop query="qDashboardGetCategoryCourses">
												<tr>
			                                    	<!--- Display code --->
			                                    	<td>
			                                    		<a href="../view/courses/?course=#URLEncodedFormat(qDashboardGetCategoryCourses.c_id)#" title="#qDashboardGetCategoryCourses.course_number#">#qDashboardGetCategoryCourses.course_number#</a>
			                                    	</td>
													
													<!--- Display title --->
													<td>
														#qDashboardGetCategoryCourses.title#
													</td>
													
													<!--- Display course credits --->
													<td>
														<!--- Check to see if this course is marked as completed --->
														<cfif len(qDashboardGetCategoryCourses.cc_id)>
															<!--- Display the completed course credits by default --->
															#qDashboardGetCategoryCourses.cc_credit#
														<!--- If selected course credit was variable, cell is blank --->
														<cfelseif !len(qDashboardGetCategoryCourses.credit)>
															<!--- Alert user to update information --->
															<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="#qDashboardGetCategoryCourses.course_number#">Update</a>
														<!--- The selected course credit was not variable --->
														<cfelse>
															<!--- Display credit --->
															#qDashboardGetCategoryCourses.credit#
														</cfif>
													</td>
													
													<!--- Display course status --->
													<td>
														<!--- The course number will exist if the student has completed or verified this course --->
														<cfif len(qDashboardGetCategoryCourses.cc_id)>
															Complete
														<!--- The course number will exist if the course is an optional graduation requirement --->
														<cfelseif len(qDashboardGetCategoryCourses.gc_id)>
															Optional
														</cfif>
													</td>
												</tr>
											</cfloop>
										</table>
									</div>
								</cfoutput>
							</cfloop>
						<cfelse>
							<h2>There are no courses specified in this plan</h2>
						</cfif>
					<cfelse>
						<h2>Get Started</h2>
						<a href="../courses/" title="Enter your completed courses">Enter your completed courses</a>
						<p>or</p>
						<a href="../plans/" title="Manage your degree plans">Manage your degree plans</a>
					</cfif>
					<p/>

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