<!--- Dashboard Model --->
<!--- Thomas Dye, September 2016 --->
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
	
                	<cfif qDashboardGetActivePlan.RecordCount>
						<h2>Active plan: <cfoutput>#qDashboardGetActivePlan.plan_name#</cfoutput></h2>
						<cfoutput><a href="../plans/degrees/?degree=#qDashboardGetActivePlan.degrees_id#" title="#qDashboardGetActivePlan.degree_name#">#qDashboardGetActivePlan.degree_name#</a></cfoutput><br>
						<cfoutput><a href="../plans/colleges/?college=#qDashboardGetActivePlan.colleges_id#" title="#qDashboardGetActivePlan.college_name# - #qDashboardGetActivePlan.college_city#">#qDashboardGetActivePlan.college_name# - #qDashboardGetActivePlan.college_city#</a></cfoutput><br>
						<cfoutput>#qDashboardGetActivePlan.degree_type#</cfoutput></p>
						
						<!---My schedule [<][>]
						[Quarter 1 | Quarter 2 | Quarter 3 | Quarter 4]
						[Edit | Edit | Edit | Edit]
						
						Edit courses for Quarter 1
						Unscheduled courses | Courses in Quarter 1
						[list 1] [>][<] [list 2]
										[Update][Cancel]--->
						
						<cfform>
							<p>
								<strong>Add a course to this degree plan by course number</strong>
							</p>
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
						
						<h3>Courses remaining for this plan</h3>
						<table>
							<tr>
								<td colspan="5"><h4>English Composition</h4></td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryC)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryC[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryC[Counter][2]#</td>
											<!--- Display title --->
											<td>#aCategoryC[Counter][3]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryC[Counter][6])>
													<!--- The course number will exist if the student has completed this course --->
													<cfif len(aCategoryC[Counter][7])>
														<!--- Display credit information from the completed course --->
														#aCategoryC[Counter][8]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryC[Counter][6]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed this course --->
												<cfif len(aCategoryC[Counter][7])>
													Complete
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryC[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryC[Counter][1]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
						
							<tr>
								<td colspan="5">
									<hr>
									<h4>Writing and Additional Composition</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryW)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryW[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryW[Counter][2]#</td>
											<!--- Display title --->
											<td>#aCategoryW[Counter][3]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryW[Counter][6])>
													<!--- The course number will exist if the student has completed this course --->
													<cfif len(aCategoryW[Counter][7])>
														<!--- Display credit information from the completed course --->
														#aCategoryW[Counter][8]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryW[Counter][6]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed this course --->
												<cfif len(aCategoryW[Counter][7])>
													Complete
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryW[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryW[Counter][1]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
						
							<tr>
								<td colspan="5">
									<hr>
									<h4>Quantitative and Symbolic Reasoning</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryQSR)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryQSR[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryQSR[Counter][2]#</td>
											<!--- Display title --->
											<td>#aCategoryQSR[Counter][3]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryQSR[Counter][6])>
													<!--- The course number will exist if the student has completed this course --->
													<cfif len(aCategoryQSR[Counter][7])>
														<!--- Display credit information from the completed course --->
														#aCategoryQSR[Counter][8]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryQSR[Counter][6]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed this course --->
												<cfif len(aCategoryQSR[Counter][7])>
													Complete
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryQSR[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryQSR[Counter][1]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
						
							<tr>
								<td colspan="5">
									<hr>
									<h4>The Natural World</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryNW)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryNW[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryNW[Counter][2]#</td>
											<!--- Display title --->
											<td>#aCategoryNW[Counter][3]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryNW[Counter][6])>
													<!--- The course number will exist if the student has completed this course --->
													<cfif len(aCategoryNW[Counter][7])>
														<!--- Display credit information from the completed course --->
														#aCategoryNW[Counter][8]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryNW[Counter][6]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed this course --->
												<cfif len(aCategoryNW[Counter][7])>
													Complete
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryNW[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryNW[Counter][1]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
						
							<tr>
								<td colspan="5">
									<hr>
									<h4>Visual, Literary, and Performing Arts</h4>
									(You need X more credits)
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryVLPA)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryVLPA[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryVLPA[Counter][2]#</td>
											<!--- Display title --->
											<td>#aCategoryVLPA[Counter][3]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryVLPA[Counter][6])>
													<!--- The course number will exist if the student has completed this course --->
													<cfif len(aCategoryVLPA[Counter][7])>
														<!--- Display credit information from the completed course --->
														#aCategoryVLPA[Counter][8]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryVLPA[Counter][6]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed this course --->
												<cfif len(aCategoryVLPA[Counter][7])>
													Complete
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryVLPA[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryVLPA[Counter][1]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
						
							<tr>
								<td colspan="5">
									<hr>
									<h4>Individuals and Societies</h4>
									(You need X more credits)
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryIS)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryIS[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryIS[Counter][2]#</td>
											<!--- Display title --->
											<td>#aCategoryIS[Counter][3]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryIS[Counter][6])>
													<!--- The course number will exist if the student has completed this course --->
													<cfif len(aCategoryIS[Counter][7])>
														<!--- Display credit information from the completed course --->
														#aCategoryIS[Counter][8]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryIS[Counter][6]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed this course --->
												<cfif len(aCategoryIS[Counter][7])>
													Complete
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryIS[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryIS[Counter][1]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
						</table>
						
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