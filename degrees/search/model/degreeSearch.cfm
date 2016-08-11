<!--- Degrees Search Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm">

<pagetitle="Advisor Services Portal - Degree Search">

	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>Degree Search</h1>
			</header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <a href="..">Degree Plans</a>
				&raquo; Degree Search
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Degree Search" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
						<h3>Filters</h3>
						<table>
							<tr>
								<th>Departments</th>
								<th>
									<cfif isDefined("url.departments") && url.departments EQ 'all'>
										<a href="" title="see fewer departments">see less</a>
									<cfelse>
										<a href="?departments=all" title="see all departments">see more</a>
									</cfif>
								</th>
							</tr>
							<cfform>
								<tr>
									<td colspan="2">
										<!--- Display all departments and recheck previously selected checkboxes --->
										<cfif isDefined("url.departments") && url.departments EQ 'all'>
											<cfloop query="qGetAllDepartments">
												<cfif isDefined("session.aDepartments") && ArrayFind(session.aDepartments, qGetAllDepartments.id)>
													<cfinput type="checkbox" id="#qGetAllDepartments.id#" name="filterDepartment" value="#qGetAllDepartments.id#" checked="yes">
												<cfelse>
													<cfinput type="checkbox" id="#qGetAllDepartments.id#" name="filterDepartment" value="#qGetAllDepartments.id#">
												</cfif>
												<cfoutput><label for="#qGetAllDepartments.id#"> #qGetAllDepartments.department_name#</label></cfoutput><br>
											</cfloop>
											
										<!--- Display most popular departments only --->
										<cfelse>
											<cfset departmentMax=6>
											<cfset departmentCounter=0>
											
											<!--- Always display departments previously selected --->
											<cfif isDefined("session.aDepartments")>
												<cfloop query="qGetAllDepartments">
													<cfif ArrayFind(session.aDepartments, qGetAllDepartments.id)>
														<cfinput type="checkbox" id="#qGetAllDepartments.id#" name="filterDepartment" value="#qGetAllDepartments.id#" checked="yes">
														<cfoutput><label for="#qGetAllDepartments.id#"> #qGetAllDepartments.department_name#</label></cfoutput><br>
														<cfset departmentCounter = departmentCounter + 1>
													</cfif>
												</cfloop>
											</cfif>
											
											<!--- After displaying any previously selected departments, fill the list with popular department options --->
											<cfloop query="qGetPopularDepartments">
												<cfif departmentCounter LT departmentMax>
													<cfif isDefined("session.aDepartments")>
														<!--- Do not duplicate listings of departments already selected --->
														<cfif ArrayFind(session.aDepartments, qGetPopularDepartments.id)>
															<cfset departmentCounter = departmentCounter - 1>
														<cfelse>
															<cfinput type="checkbox" id="#qGetPopularDepartments.id#" name="filterDepartment" value="#qGetPopularDepartments.id#">
															<cfoutput><label for="#qGetPopularDepartments.id#"> #qGetPopularDepartments.department_name#</label></cfoutput><br>
														</cfif>
													<cfelse>
														<cfinput type="checkbox" id="#qGetPopularDepartments.id#" name="filterDepartment" value="#qGetPopularDepartments.id#">
														<cfoutput><label for="#qGetPopularDepartments.id#"> #qGetPopularDepartments.department_name#</label></cfoutput><br>
													</cfif>
												</cfif>
												<cfset departmentCounter = departmentCounter + 1>
											</cfloop>
										</cfif>
									</td>
									<td></td>
								</tr>
								<tr>
									<td><cfinput type="submit" name="filterDepartmentsButton" value="Update"></td>
									<td></td>
								</tr>
							</cfform>
						</table>
						
						<table>
							<tr>
								<th>Colleges</th>
								<th>
									<cfif isDefined("url.colleges") && url.colleges EQ 'all'>
										<a href="" title="see fewer colleges">see less</a>
									<cfelse>
										<a href="?colleges=all" title="see all colleges">see more</a>
									</cfif>
								</th>
							</tr>
							<cfform>
								<tr>
									<td colspan="2">
										<!--- Display all colleges and recheck previously selected checkboxes --->
										<cfif isDefined("url.colleges") && url.colleges EQ 'all'>
											<cfloop query="qGetAllColleges">
												<cfif isDefined("session.aColleges") && ArrayFind(session.aColleges, qGetAllColleges.id)>
													<cfinput type="checkbox" id="#qGetAllColleges.id#" name="filterCollege" value="#qGetAllColleges.id#" checked="yes">
												<cfelse>
													<cfinput type="checkbox" id="#qGetAllColleges.id#" name="filterCollege" value="#qGetAllColleges.id#">
												</cfif>
												<cfoutput><label for="#qGetAllColleges.id#"> #qGetAllColleges.college_name# - #qGetAllColleges.college_city#</label></cfoutput><br>
											</cfloop>
											
										<!--- Display most popular colleges only --->
										<cfelse>
											<cfset collegeMax=6>
											<cfset collegeCounter=0>
											
											<!--- Always display colleges previously selected --->
											<cfif isDefined("session.aColleges")>
												<cfloop query="qGetAllColleges">
													<cfif ArrayFind(session.aColleges, qGetAllColleges.id)>
														<cfinput type="checkbox" id="#qGetAllColleges.id#" name="filterCollege" value="#qGetAllColleges.id#" checked="yes">
														<cfoutput><label for="#qGetAllColleges.id#"> #qGetAllColleges.college_name# - #qGetAllColleges.college_city#</label></cfoutput><br>
														<cfset collegeCounter = collegeCounter + 1>
													</cfif>
												</cfloop>
											</cfif>
											
											<!--- After displaying any previously selected colleges, fill the list with popular college options --->
											<cfloop query="qGetPopularColleges">
												<cfif collegeCounter LT collegeMax>
													<cfif isDefined("session.aColleges")>
														<!--- Do not duplicate listings of colleges already selected --->
														<cfif ArrayFind(session.aColleges, qGetPopularColleges.id)>
															<cfset collegeCounter = collegeCounter - 1>
														<cfelse>
															<cfinput type="checkbox" id="#qGetPopularColleges.id#" name="filterCollege" value="#qGetPopularColleges.id#">
															<cfoutput><label for="#qGetPopularColleges.id#"> #qGetPopularColleges.college_name# - #qGetPopularColleges.college_city#</label></cfoutput><br>
														</cfif>
													<cfelse>
														<cfinput type="checkbox" id="#qGetPopularColleges.id#" name="filterCollege" value="#qGetPopularColleges.id#">
														<cfoutput><label for="#qGetPopularColleges.id#"> #qGetPopularColleges.college_name# - #qGetPopularColleges.college_city#</label></cfoutput><br>
													</cfif>
												</cfif>
												<cfset collegeCounter = collegeCounter + 1>
											</cfloop>
										</cfif>
									</td>
									<td></td>
								</tr>
								<tr>
									<td><cfinput type="submit" name="filterCollegesButton" value="Update"></td>
									<td></td>
								</tr>
							</cfform>
						</table>

	                </div>
	            </div>
	        </div>
	    </article>                   
	</div>

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

<cfmodule template="../../../footer.cfm">