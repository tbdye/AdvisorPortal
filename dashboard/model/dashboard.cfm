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

						<cfif qDashboardGetActivePlan.RecordCount && qDashboardGetCourses.RecordCount>
							<h3>Courses remaining for this plan</h3>
						<cfelse>
							<h3>There are no courses specified in this plan</h3>
						</cfif>
						
						<table>
							<cfif arrayLen(aCategoryC)>
								<tr>
									<td colspan="4"><h4>English Composition</h4></td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryC)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryC[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryC[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryC[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryC[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryC[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryC[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryC[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryC[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryC[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
						
							<cfif arrayLen(aCategoryW)>
								<tr>
									<td colspan="4">
										<hr>
										<h4>Writing and Additional Composition</h4>
									</td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryW)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryW[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryW[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryW[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryW[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryW[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryW[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryW[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryW[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryW[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
						
							<cfif arrayLen(aCategoryQSR)>
								<tr>
									<td colspan="4">
										<hr>
										<h4>Quantitative and Symbolic Reasoning</h4>
									</td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryQSR)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryQSR[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryQSR[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryQSR[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryQSR[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryQSR[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryQSR[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryQSR[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryQSR[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryQSR[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
						
							<cfif arrayLen(aCategoryNW)>
								<tr>
									<td colspan="4">
										<hr>
										<h4>The Natural World</h4>
									</td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryNW)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryNW[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryNW[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryNW[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryNW[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryNW[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryNW[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryNW[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryNW[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryNW[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
						
							<cfif arrayLen(aCategoryVLPA)>
								<tr>
									<td colspan="4">
										<hr>
										<h4>Visual, Literary, and Performing Arts</h4>
									</td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryVLPA)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryVLPA[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryVLPA[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryVLPA[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryVLPA[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryVLPA[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryVLPA[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryVLPA[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryVLPA[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryVLPA[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
						
							<cfif arrayLen(aCategoryIS)>
								<tr>
									<td colspan="4">
										<hr>
										<h4>Individuals and Societies</h4>
									</td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryIS)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryIS[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryIS[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryIS[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryIS[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryIS[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryIS[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryIS[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryIS[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryIS[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
							
							<cfif arrayLen(aCategoryDIV)>
								<tr>
									<td colspan="4">
										<hr>
										<h4>Diversity</h4>
									</td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryDIV)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryDIV[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryDIV[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryDIV[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryDIV[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryDIV[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryDIV[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryDIV[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryDIV[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryDIV[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
							
							<cfif arrayLen(aCategoryE)>
								<tr>
									<td colspan="4">
										<hr>
										<h4>General Electives</h4>
									</td>
								</tr>
								<tr>
									<th>Code</th>
									<th>Title</th>
									<th>Credits</th>
									<th>Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryE)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryE[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryE[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryE[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryE[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryE[Counter][3])>
													<!--- Alert user to update information --->
													<a href="../plans/edit/?plan=#URLEncodedFormat(qDashboardGetActivePlan.plans_id)#" title="Update credits for #aCategoryE[Counter][1]#">Update</a>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryE[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryE[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryE[Counter][8])>
													Optional
												</cfif>
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
							</cfif>
							
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