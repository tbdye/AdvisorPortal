<!--- Edit Plan Model --->
<!--- Thomas Dye, September 2016, February 2017 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit Plan">

	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>Edit Plan - "<cfoutput>#qEditGetPlan.plan_name#</cfoutput>"</h1>
			</header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <a href="..">Degree Plans</a>
				&raquo; Edit Plan - "<cfoutput>#qEditGetPlan.plan_name#</cfoutput>"
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Plan" class="rdf-meta element-hidden"></span>
	
					
	                <div class="content">               	
						<h2>Basic Details</h2>

						<table>
							<cfif messageBean.hasErrors() && isDefined("form.saveButton")>
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


	                		<tr>
	                			<td>Degree:</td>
	                			<td>
	                				<cfoutput><a href="../../view/degrees/?degree=#qEditGetPlan.degrees_id#" title="#qEditGetPlan.degree_name#">#qEditGetPlan.degree_name#</a></cfoutput><br>
	                				<cfoutput><a href="../../view/colleges/?college=#qEditGetPlan.colleges_id#" title="#qEditGetPlan.college_name# - #qEditGetPlan.college_city#">#qEditGetPlan.college_name# - #qEditGetPlan.college_city#</a></cfoutput><br>
	                				<cfoutput>#qEditGetPlan.degree_type#</cfoutput>
	                			</td>
	                		</tr>
	                		<tr>
		                			<td width="125px"><label for="planName">Plan name:</label></td>
		                			<td><cfinput type="text" id="planName" name="planName" value="#qEditGetPlan.plan_name#"></td>			                			
		                		</tr>
	                		<tr>
	                			<td></td>
	                			<td><cfinput type="submit" name="saveButton" value="Save"></td>
	                		</tr>
		                	</cfform>
						</table>
						
						
						<h2>Courses Remaining for Plan</h2>
						<h3>Add a Course to Plan</h3>

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
								<tr>
									<td width="125px"><label for="courseNumber">Course number:</label></td>
									<td><cfinput width="275px" type="text" id="courseNumber" name="courseNumber"></td>
								</tr>
								<tr>
									<td><label for="category">Category:</label></td>
									<td>
										<cfselect name="category" query="qEditGetSelectDegreeCategories" display="category" value="id" queryPosition="below" >
											<option value="0">Select a category</option>
										</cfselect>
									</td>
								</tr>
								<tr>
									<td></td>
									<td><cfinput type="submit" name="addCourseButton" value="Add"></td>
								</tr>
							</cfform>
							<tr>
								<td></td>
								<td>
									<a href="https://www.everettcc.edu/catalog/" title="View official course catalog" target="_blank">View official course catalog</a>
								</td>
							</tr>
						</table>

						<!--- Display courses by category --->
						<cfloop query="#qEditGetCategories#">
							<cfquery dbtype="query" name="qEditGetCategoryCourses">
								SELECT c_id, course_number, title, cc_id, cc_credit, credit, gc_id, sc_id, min_credit, max_credit
								FROM qEditGetCourses
								WHERE degree_categories_id = #qEditGetCategories.id#
							</cfquery>
							
							<hr/>
							
							<cfoutput>
								<h3>#qEditGetCategories.category#</h3>
							
								<div id = "h4-box">
									<table>
										<tr>
											<th width="20%">Code</th>
											<th>Title</th>
											<th width="15%">Credits</th>
											<th width="20%">Status</th>
											<th width="10%">Remove</th>
										</tr>
										<cfform>
											<cfloop query="qEditGetCategoryCourses">
												<tr>
													<!--- Display course number --->
													<td>
														<a href="../../view/courses/?course=#URLEncodedFormat(qEditGetCategoryCourses.c_id)#" title="#qEditGetCategoryCourses.course_number#">#qEditGetCategoryCourses.course_number#</a>
													</td>
													
													<!--- Display course title --->
													<td>
														#qEditGetCategoryCourses.title#
													</td>
													
													<!--- Display course credits --->
													<td>
														<!--- Check to see if this course is marked as completed --->
														<cfif len(qEditGetCategoryCourses.cc_id)>
															<!--- Display the completed course credits by default --->
															#qEditGetCategoryCourses.cc_credit#
														<!--- If selected course credit was variable, cell is blank --->
														<cfelseif !len(qEditGetCategoryCourses.credit)>
															<cfinput type="hidden" name="creditId" value="#qEditGetCategoryCourses.sc_id#">
															<!--- Set the minimum credit --->
															<cfset variableCredit="#Val(qEditGetCategoryCourses.min_credit)#">
															<!--- Use a selector box to choose the variable credits --->
															<cfselect name="courseCredit">
																<option value="0">
																	Choose
																</option>
																<!--- Display the available range of credits as integers --->
																<cfloop from=1 to="#Val(qEditGetCategoryCourses.max_credit) - Val(qEditGetCategoryCourses.min_credit) + 1#" index="i">
																	<option value="#variableCredit#">
																		#variableCredit#
																	</option>
																	<cfset variableCredit=variableCredit + 1>
																</cfloop>
															</cfselect>
														<!--- The selected course credit was not variable --->
														<cfelse>
															<!--- Display course credit --->
															#qEditGetCategoryCourses.credit#
														</cfif>
													</td>
													
													<!--- Display course status --->
													<td>
														<cfif len(qEditGetCategoryCourses.cc_id)>
															Complete
														<cfelseif len(qEditGetCategoryCourses.gc_id)>
															Optional
														</cfif>
													</td>
													
													<!--- Display remove checkboxes --->
													<td>
														<cfinput type="checkbox" name="remove" value="#qEditGetCategoryCourses.sc_id#">
													</td>
												</tr>
											</cfloop>
											<tr>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												
												<!--- Display "Update" button for this category's form --->
												<td>
													<cfinput type="submit" name="updateCourseButton" value="Update">
												</td>
											</tr>
										</cfform>
									</table>
								</div>
							</cfoutput>
						</cfloop>
						
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

	</div>

<cfmodule template="../../../footer.cfm">