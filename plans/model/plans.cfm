<!--- Plans Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../header.cfm">
	
	<pagetitle="Advisor Services Portal - Degree Plans">

	<!--- Alter page header depending if in an adivisng session or not. --->
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<cfif IsUserInRole("advisor")>
					<h1>Degree Plans for <cfoutput>#session.studentName#</cfoutput></h1>
				<cfelse>
					<h1>Degree Plans</h1>
				</cfif>
	        </header>

			<div class="breadcrumb">
				<a href="../dashboard/">Home</a>
				&raquo; Degree Plans for <cfoutput>#session.studentName#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	            	
					<cfif qPlanGetPlans.RecordCount>
						
						<h2>Active Degree Plan</h2>
							<div id="h4-box">
							<cfform>							
							<p>
							<cfoutput><a href="../view/degrees/?degree=#qPlanGetActivePlan.degrees_id#" title="#qPlanGetActivePlan.degree_name#">#qPlanGetActivePlan.degree_name#</a></cfoutput><br>
                			<cfoutput><a href="../view/colleges/?college=#qPlanGetActivePlan.colleges_id#" title="#qPlanGetActivePlan.college_name# - #qPlanGetActivePlan.college_city#">#qPlanGetActivePlan.college_name# - #qPlanGetActivePlan.college_city#</a></cfoutput><br>
                			<cfoutput>#qPlanGetActivePlan.degree_type#</cfoutput>
							</p>
							
							<p>
							<cfinput type="hidden" name="currentPlanId" value="#qPlanGetActivePlan.id#">
							<cfselect name="activePlanId" query="qPlanGetPlans" display="plan_name" value="id" selected="#qPlanGetActivePlan.id#"></cfselect>&nbsp;
							<cfinput type="submit" name="updateActivePlanButton" value="Change">
							</p>
							
							</cfform>
							</div>
														
						<h2>Saved Degree Plans</h2>
						<div id="search-results">						
						<table>
							<cfif messageBean.hasErrors() && isDefined("form.deletePlanButton")>
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
								<th>Plan details</th>
								<th>Created</th>
								<th>Updated</th>
								<th></th>
								<th></th>
							</tr>
							<cfloop query="qPlanGetPlans">
								<tr>
									<td><cfoutput><a href="edit/?plan=#qPlanGetPlans.id#" title="#qPlanGetPlans.plan_name#">#qPlanGetPlans.plan_name#</a></cfoutput></td>
									<td><cfoutput>#TimeFormat(qPlanGetPlans.time_created, "short")# - #DateFormat(qPlanGetPlans.time_created, "short")#</cfoutput></td>
									<cfif len(qPlanGetPlans.time_updated)>
										<td><cfoutput>#TimeFormat(qPlanGetPlans.time_updated, "short")# - #DateFormat(qPlanGetPlans.time_updated, "short")#</cfoutput></td>
									<cfelse>
										<td></td>
									</cfif>
									<td>
										<cfform>
											<cfinput type="hidden" name="thisPlanId" value="#qPlanGetPlans.id#">
											<cfinput type="hidden" name="activePlanId" value="#qPlanGetActivePlan.id#">
											<cfinput type="submit" name="deletePlanButton" value="Delete">
										</cfform>
									</td>
									<td>
										<cfform>
											<cfinput type="submit" name="copyPlanButton" value="Copy">
										</cfform>
									</td>
								</tr>
							</cfloop>
						</table>
						</div>
					</cfif>
					
					<h2>Create a New Degree Plan</h2>
						<p>
							<a href="create-plan/" title="Create a new degree plan">Create a new degree plan</a>
						</p>
					
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