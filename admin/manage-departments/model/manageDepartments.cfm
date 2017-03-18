<!--- Manage Departments Model --->
<!--- Karan Kalra, November 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm">
	
	<pagetitle="Advisor Services Portal - Manage Departments">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>Manage Departments</h1>
	        </header>

			<div class="breadcrumb">
				<a href="../">Home</a>
				&raquo; Manage Departments
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	            	
	            	<!-- Search Form START -->
					<cfform>
						<h2>Search by Department Name</h2>
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
							<a href="https://www.everettcc.edu/programs/" title="View all Programs/Departments" target="_blank">View all Programs/Departments</a>
						</p>
					</cfform>	
					<!-- Search Form END -->
					
					<!-- Search Results START -->
					<!--- After search form is submitted, display results. --->
					<div id="search-results">
					<cfif isDefined("form.searchButton") && isDefined("qDepartmentsGetDepartment") && qDepartmentsGetDepartment.RecordCount>

						
						<h2>Search Results</h2>
						<a href="./" title="Clear search">Clear</a>
						
						<table>
							<tr>
								<th width="120px">Number</th>
								<th>Title</th>
								<th>Intro</th>
								<th>Status</th>
							</tr>
							<cfloop query="qDepartmentsGetDepartment">
								<tr>
									<td><cfoutput><a href="edit/?department=#URLEncodedFormat(qDepartmentsGetDepartment.id)#" title="#qDepartmentsGetDepartment.department_name#">#qDepartmentsGetDepartment.department_name#</a></cfoutput></td>
									<td><cfoutput>#qDepartmentsGetDepartment.department_name#</cfoutput></td>
									<td>
										<cfoutput>#qDepartmentsGetDepartment.dept_intro#</cfoutput>
									</td>
									<td>
										<cfif qDepartmentsGetDepartment.use_catalog>
											Active
										<cfelse>
											Inactive
										</cfif>
									</td>
								</tr>
							</cfloop>
						</table>
					</cfif>
					</div>						
                	<!-- Search Results END -->
	            
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

<cfmodule template="../../../footer.cfm">