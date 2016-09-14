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
						<h2><cfoutput>#qDashboardGetActivePlan.plan_name#</cfoutput></h2>
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
								<tr>
									<cfoutput>
                                    	<td>#aCategoryC[Counter][1]#</td>
										<td>#aCategoryC[Counter][2]#</td>
										<td>#aCategoryC[Counter][3]#</td>
										<td>
											<cfif aCategoryC[Counter][4] NEQ 0>
												Complete
											</cfif>
										</td>
										<td></td>
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
								<tr>
									<cfoutput>
                                    	<td>#aCategoryW[Counter][1]#</td>
										<td>#aCategoryW[Counter][2]#</td>
										<td>#aCategoryW[Counter][3]#</td>
										<td>
											<cfif aCategoryW[Counter][4] NEQ 0>
												Complete
											</cfif>
										</td>
										<td></td>
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
								<tr>
									<cfoutput>
                                    	<td>#aCategoryQSR[Counter][1]#</td>
										<td>#aCategoryQSR[Counter][2]#</td>
										<td>#aCategoryQSR[Counter][3]#</td>
										<td>
											<cfif aCategoryQSR[Counter][4] NEQ 0>
												Complete
											</cfif>
										</td>
										<td></td>
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
								<tr>
									<cfoutput>
                                    	<td>#aCategoryNW[Counter][1]#</td>
										<td>#aCategoryNW[Counter][2]#</td>
										<td>#aCategoryNW[Counter][3]#</td>
										<td>
											<cfif aCategoryNW[Counter][4] NEQ 0>
												Complete
											</cfif>
										</td>
										<td></td>
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
								<tr>
									<cfoutput>
                                    	<td>#aCategoryVLPA[Counter][1]#</td>
										<td>#aCategoryVLPA[Counter][2]#</td>
										<td>#aCategoryVLPA[Counter][3]#</td>
										<td>
											<cfif aCategoryVLPA[Counter][4] NEQ 0>
												Complete
											</cfif>
										</td>
										<td></td>
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
								<tr>
									<cfoutput>
                                    	<td>#aCategoryIS[Counter][1]#</td>
										<td>#aCategoryIS[Counter][2]#</td>
										<td>#aCategoryIS[Counter][3]#</td>
										<td>
											<cfif aCategoryIS[Counter][4] NEQ 0>
												Complete
											</cfif>
										</td>
										<td></td>
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