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
						<h2>Degree search</h2>
						<table>
							<cfif messageBean.hasErrors() && isDefined("form.searchButton")>
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
									<td></td>
								</tr>
							</cfif>
							<cfform preserveData="yes">
								<tr>
									<td colspan="2">Search by degree name</td>
								</tr>
								<tr>
									<td width="120px"><cfinput type="text" id="searchTerm" name="searchTerm"></td>
									<td><cfinput type="submit" name="searchButton" value="Search"></td>								
								</tr>
							</cfform>			
						</table>

						<table>
							<cfif isDefined("form.searchButton") || isDefined("session.aColleges") || isDefined("session.aDepartments")>
								<cfif qSearchGetFilteredDegrees.RecordCount>
									<cfloop query="qSearchGetFilteredDegrees">
										<cfform>
											<tr>
												<td>
													<cfoutput><a href="?view=#qSearchGetFilteredDegrees.id#" title="#qSearchGetFilteredDegrees.degree_name#">#qSearchGetFilteredDegrees.degree_name#</a></cfoutput><br>
													<cfoutput>#qSearchGetFilteredDegrees.college_name# - #qSearchGetFilteredDegrees.college_city#</cfoutput><br>
													<cfoutput>#qSearchGetFilteredDegrees.degree_type#</cfoutput>
												</td>
												<td>
													<cfinput type="hidden" name="degreeId" value="#qSearchGetFilteredDegrees.id#">
													<cfinput type="submit" name="addDegreeButton" value="Select">
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
						
						
						<h3>Filters</h3>
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
									<td><cfinput type="submit" name="filterCollegesButton" value="Update"></td>
									<td></td>
								</tr>
							</cfform>
						</table>
						
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
									<td><cfinput type="submit" name="filterDepartmentsButton" value="Update"></td>
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