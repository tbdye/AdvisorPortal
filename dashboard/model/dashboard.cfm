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

						<hr/>

						<p/>

						<cfif qDashboardGetActivePlan.RecordCount && qDashboardGetCourses.RecordCount>
							<h2>Courses remaining for this plan</h2>
						<cfelse>
							<h2>There are no courses specified in this plan</h2>
						</cfif>

						<cfif arrayLen(aCategoryC)>
							<h3>English Composition</h3></td>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryC)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryC[Counter][5])#" title="#aCategoryC[Counter][1]#">#aCategoryC[Counter][1]#</a></td>
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
							</table>
							</div>
						</cfif>
						
						<cfif arrayLen(aCategoryW)>
							<h3>Writing and Additional Composition</h3>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryW)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryW[Counter][5])#" title="#aCategoryW[Counter][1]#">#aCategoryW[Counter][1]#</a></td>
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
							</table>
							</div>
						</cfif>
						
						<cfif arrayLen(aCategoryQSR)>
							<h3>Quantitative and Symbolic Reasoning</h3>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryQSR)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryQSR[Counter][5])#" title="#aCategoryQSR[Counter][1]#">#aCategoryQSR[Counter][1]#</a></td>
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
							</table>
							</div>
						</cfif>
						
						<cfif arrayLen(aCategoryNW)>
							<h3>The Natural World</h3>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryNW)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryNW[Counter][5])#" title="#aCategoryNW[Counter][1]#">#aCategoryNW[Counter][1]#</a></td>
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
							</table>
							</div>
						</cfif>
						
						<cfif arrayLen(aCategoryVLPA)>
							<h3>Visual, Literary, and Performing Arts</h3>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryVLPA)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryVLPA[Counter][5])#" title="#aCategoryVLPA[Counter][1]#">#aCategoryVLPA[Counter][1]#</a></td>
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
							</table>
							</div>
						</cfif>
						
						<cfif arrayLen(aCategoryIS)>
							<h3>Individuals and Societies</h3>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryIS)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryIS[Counter][5])#" title="#aCategoryIS[Counter][1]#">#aCategoryIS[Counter][1]#</a></td>
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
							</table>
							</div>
						</cfif>
							
						<cfif arrayLen(aCategoryDIV)>
							<h3>Diversity</h3>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryDIV)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryDIV[Counter][5])#" title="#aCategoryDIV[Counter][1]#">#aCategoryDIV[Counter][1]#</a></td>
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
							</table>
							</div>
						</cfif>
							
						<cfif arrayLen(aCategoryE)>
							<h3>General Electives</h3>
							<div id="h4-box">
							<table>
								<tr>
									<th width="20%">Code</th>
									<th>Title</th>
									<th width="15%">Credits</th>
									<th width="20%">Status</th>
								</tr>
								<cfloop from=1 to="#arrayLen(aCategoryE)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../view/courses/?course=#URLEncodedFormat(aCategoryE[Counter][5])#" title="#aCategoryE[Counter][1]#">#aCategoryE[Counter][1]#</a></td>
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
							</table>
							</div>
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