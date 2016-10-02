<!--- Create Plan Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm">

<pagetitle="Advisor Services Portal - Create Plan">

	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>Create Plan</h1>
			</header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <a href="..">Degree Plans</a>
				&raquo; Create Plan
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Create Plan" class="rdf-meta element-hidden"></span>
	
	                <div class="content">

						<cfform>
							<h2>
								Search for a Degree
							</h2>			
							<p>
								<cfif isDefined("session.searchFilter")>
									<cfinput type="text" id="searchTerm" name="searchTerm" value="#session.searchFilter#">
								<cfelse>
									<cfinput type="text" id="searchTerm" name="searchTerm">
								</cfif>&nbsp;
							<cfinput type="submit" name="searchButton" value="Search"></p>
						</cfform>

						<p></p>

						<div id="search-results">
						<table>
							<cfif isDefined("session.searchFilter") || isDefined("session.aColleges") || isDefined("session.aDepartments")>
								<cfif qSearchGetFilteredDegrees.RecordCount>
									<h3>
										Search Results
									</h3>
									<cfloop query="qSearchGetFilteredDegrees">
										<cfform>
											<tr>
												<td>
													<cfoutput><a href="../../view/degrees/?degree=#qSearchGetFilteredDegrees.id#" title="#qSearchGetFilteredDegrees.degree_name#">#qSearchGetFilteredDegrees.degree_name#</a></cfoutput><br>
													<cfoutput><a href="../../view/colleges/?college=#qSearchGetFilteredDegrees.colleges_id#" title="#qSearchGetFilteredDegrees.college_name# - #qSearchGetFilteredDegrees.college_city#">#qSearchGetFilteredDegrees.college_name# - #qSearchGetFilteredDegrees.college_city#</a></cfoutput><br>
													<cfoutput>#qSearchGetFilteredDegrees.degree_type#</cfoutput>
												</td>
												<td>
													<cfinput type="hidden" name="collegeId" value="#qSearchGetFilteredDegrees.colleges_id#">
													<cfinput type="hidden" name="degreeId" value="#qSearchGetFilteredDegrees.id#">
													<cfinput type="hidden" name="degreeName" value="#qSearchGetFilteredDegrees.degree_name#">
													<cfinput type="submit" name="addDegreeButton" value="Select">
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<hr/>
												</td>
											</tr>
										</cfform>
									</cfloop>
								<cfelse>
									<tr>
										<td>No results.  Search may be too restrictive.</td>
										<td></td>
									</tr>
								</cfif>
							</cfif>
						</table>
						</div>
						
						
						<!-- Cut from here -->
						
	                </div>
	            </div>
	        </div>
	    </article>                   


		<aside id="content-sidebar">
		    <div class="region region-sidebar">			
                <div class="content">
					<p><strong>Filters</strong></p>
						<table>
							<tr>
								<td><strong>Colleges</strong></td>
								<td style="text-align:right;">
									<cfif isDefined("url.colleges") && url.colleges EQ 'all'>
										<a href="./" title="see fewer colleges">see less</a>
									<cfelse>
										<a href="?colleges=all" title="see all colleges">see more</a>
									</cfif>
								</td>
							</tr>
							<cfform>
								<tr>
									<td colspan="2">
										<!--- Display all colleges and recheck previously selected checkboxes --->
										<cfif isDefined("url.colleges") && url.colleges EQ 'all'>
											<cfloop query="qSearchGetAllColleges">
												<cfif isDefined("session.aColleges") && ArrayFind(session.aColleges, qSearchGetAllColleges.id)>
													<cfinput type="checkbox" id="#qSearchGetAllColleges.id#" name="filterCollege" value="#qSearchGetAllColleges.id#" checked="yes">
												<cfelse>
													<cfinput type="checkbox" id="#qSearchGetAllColleges.id#" name="filterCollege" value="#qSearchGetAllColleges.id#">
												</cfif>
												<cfoutput><label for="#qSearchGetAllColleges.id#"> #qSearchGetAllColleges.college_name# - #qSearchGetAllColleges.college_city#</label></cfoutput><br>
											</cfloop>
											
										<!--- Display most popular colleges only --->
										<cfelse>
											<cfset collegeMax=6>
											<cfset collegeCounter=0>
											
											<!--- Always display colleges previously selected --->
											<cfif isDefined("session.aColleges")>
												<cfloop query="qSearchGetAllColleges">
													<cfif ArrayFind(session.aColleges, qSearchGetAllColleges.id)>
														<cfinput type="checkbox" id="#qSearchGetAllColleges.id#" name="filterCollege" value="#qSearchGetAllColleges.id#" checked="yes">
														<cfoutput><label for="#qSearchGetAllColleges.id#"> #qSearchGetAllColleges.college_name# - #qSearchGetAllColleges.college_city#</label></cfoutput><br>
														<cfset collegeCounter = collegeCounter + 1>
													</cfif>
												</cfloop>
											</cfif>
											
											<!--- After displaying any previously selected colleges, fill the list with popular college options --->
											<cfloop query="qSearchGetPopularColleges">
												<cfif collegeCounter LT collegeMax>
													<cfif isDefined("session.aColleges")>
														<!--- Do not duplicate listings of colleges already selected --->
														<cfif ArrayFind(session.aColleges, qSearchGetPopularColleges.id)>
															<cfset collegeCounter = collegeCounter - 1>
														<cfelse>
															<cfinput type="checkbox" id="#qSearchGetPopularColleges.id#" name="filterCollege" value="#qSearchGetPopularColleges.id#">
															<cfoutput><label for="#qSearchGetPopularColleges.id#"> #qSearchGetPopularColleges.college_name# - #qSearchGetPopularColleges.college_city#</label></cfoutput><br>
														</cfif>
													<cfelse>
														<cfinput type="checkbox" id="#qSearchGetPopularColleges.id#" name="filterCollege" value="#qSearchGetPopularColleges.id#">
														<cfoutput><label for="#qSearchGetPopularColleges.id#"> #qSearchGetPopularColleges.college_name# - #qSearchGetPopularColleges.college_city#</label></cfoutput><br>
													</cfif>
												</cfif>
												<cfset collegeCounter = collegeCounter + 1>
											</cfloop>
										</cfif>
									</td>
									<td></td>
								</tr>
								<tr>
									<td colspan="2"><cfinput type="submit" name="filterCollegesButton" value="Update"></td>
								</tr>
							</cfform>
						</table>
						
						<p/>
						
						<table>
							<tr>
								<td><strong>Departments</strong></td>
								<td style="text-align:right;">
									<cfif isDefined("url.departments") && url.departments EQ 'all'>
										<a href="./" title="see fewer departments">see less</a>
									<cfelse>
										<a href="?departments=all" title="see all departments">see more</a>
									</cfif>
								</td>
							</tr>
							<cfform>
								<tr>
									<td colspan="2">
										<!--- Display all departments and recheck previously selected checkboxes --->
										<cfif isDefined("url.departments") && url.departments EQ 'all'>
											<cfloop query="qSearchGetAllDepartments">
												<cfif isDefined("session.aDepartments") && ArrayFind(session.aDepartments, qSearchGetAllDepartments.id)>
													<cfinput type="checkbox" id="#qSearchGetAllDepartments.id#" name="filterDepartment" value="#qSearchGetAllDepartments.id#" checked="yes">
												<cfelse>
													<cfinput type="checkbox" id="#qSearchGetAllDepartments.id#" name="filterDepartment" value="#qSearchGetAllDepartments.id#">
												</cfif>
												<cfoutput><label for="#qSearchGetAllDepartments.id#"> #qSearchGetAllDepartments.department_name#</label></cfoutput><br>
											</cfloop>
											
										<!--- Display most popular departments only --->
										<cfelse>
											<cfset departmentMax=6>
											<cfset departmentCounter=0>
											
											<!--- Always display departments previously selected --->
											<cfif isDefined("session.aDepartments")>
												<cfloop query="qSearchGetAllDepartments">
													<cfif ArrayFind(session.aDepartments, qSearchGetAllDepartments.id)>
														<cfinput type="checkbox" id="#qSearchGetAllDepartments.id#" name="filterDepartment" value="#qSearchGetAllDepartments.id#" checked="yes">
														<cfoutput><label for="#qSearchGetAllDepartments.id#"> #qSearchGetAllDepartments.department_name#</label></cfoutput><br>
														<cfset departmentCounter = departmentCounter + 1>
													</cfif>
												</cfloop>
											</cfif>
											
											<!--- After displaying any previously selected departments, fill the list with popular department options --->
											<cfloop query="qSearchGetPopularDepartments">
												<cfif departmentCounter LT departmentMax>
													<cfif isDefined("session.aDepartments")>
														<!--- Do not duplicate listings of departments already selected --->
														<cfif ArrayFind(session.aDepartments, qSearchGetPopularDepartments.id)>
															<cfset departmentCounter = departmentCounter - 1>
														<cfelse>
															<cfinput type="checkbox" id="#qSearchGetPopularDepartments.id#" name="filterDepartment" value="#qSearchGetPopularDepartments.id#">
															<cfoutput><label for="#qSearchGetPopularDepartments.id#"> #qSearchGetPopularDepartments.department_name#</label></cfoutput><br>
														</cfif>
													<cfelse>
														<cfinput type="checkbox" id="#qSearchGetPopularDepartments.id#" name="filterDepartment" value="#qSearchGetPopularDepartments.id#">
														<cfoutput><label for="#qSearchGetPopularDepartments.id#"> #qSearchGetPopularDepartments.department_name#</label></cfoutput><br>
													</cfif>
												</cfif>
												<cfset departmentCounter = departmentCounter + 1>
											</cfloop>
										</cfif>
									</td>
									<td></td>
								</tr>
								<tr>
									<td colspan="2"><cfinput type="submit" name="filterDepartmentsButton" value="Update"></td>
								</tr>
							</cfform>
						</table>
            	</div>
		    </div>
		</aside>

	</div>

<cfmodule template="../../../footer.cfm">