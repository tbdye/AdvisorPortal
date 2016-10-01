<!--- Manage Users Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm"

	pagetitle="Advisor Services Portal - Manage Users">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Manage Users</h1>
	        </header>

			<div class="breadcrumb">
				<a href="..">Home</a>
				&raquo; Manage Users
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Administration" class="rdf-meta element-hidden"></span>
    
							<h2>Add a User</h2>
						
							<div id="createForm">
								<cfform>
									<table>
										<cfif messageBean.hasErrors() && isDefined("form.createFacultyButton")>
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
											<td width="130px">Role:</td>
											<td>
												<cfinput type="radio" id="advisor" name="role" value="1" checked="yes">
												<cfoutput><label for="advisor"> Advisor</label></cfoutput><br>
												<cfinput type="radio" id="editor" name="role" value="2">
												<cfoutput><label for="editor">Editor</label></cfoutput><br>
												<cfinput type="radio" id="administrator" name="role" value="3">
												<cfoutput><label for="administrator">Administrator</label></cfoutput>
											</td>
										</tr>
										<tr>
											<td><label for="firstName">First name:</label></td>
											<td><cfinput type="text" id="firstName" name="firstName"></td>
										</tr>
										<tr>
											<td><label for="lastName">Last name:</label></td>
											<td><cfinput type="text" id="lastName" name="lastName"></td>
										</tr>
										<tr>
											<td><label for="emailAddress">Email address:</label></td>
											<td><cfinput type="text" id="emailAddress" name="emailAddress"></td>
										</tr>
										<tr>
											<td><label for="password">Password:</label></td>
											<td><cfinput type="password" id="password" name="password"></td>
										</tr>
										<tr>
											<td><label for="password2">Confirm password:</label></td>
											<td><cfinput type="password" id="password2" name="password2"></td>
										</tr>
										<tr>
											<td></td>
											<td>
												<cfinput type="submit" name="createFacultyButton" value="Add user">										
											</td>
										</tr>
									</table>
								</cfform>
							</div>
	
						<hr/>
	
				    	<h2>Search by Name, Student ID, or Email Address</h2>
						<cfform>
							<table>
								<cfif messageBean.hasErrors() && isDefined("form.searchButton")>
								<tr>
									<td>
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
									<td>
										<cfinput type="text" id="searchTerm" name="searchTerm">&nbsp;<cfinput type="submit" name="searchButton" value="Search">
									</td>								
								</tr>	
								<tr>
									<td>
									<cfif isDefined("url.search") || isDefined("qAdminSearchAccount") && qAdminSearchAccount.RecordCount>
											<a href="." title="hide all users">Hide all users</a>
										<cfelse>
											<a href="?search=all" title="view all users">View all users</a>
									</cfif>
									</td>
								</tr>		
							</table>
						</cfform>
						
						

						<cfif isDefined("qAdminSearchAccount") && qAdminSearchAccount.RecordCount>
							<h3>Search Results</h3>
							<table>
								<tr>
									<th>Name</th>
									<th>Student ID</th>
									<th>Email</th>
									<th>Role</th>
									<th>Status</th>
								</tr>
								<cfloop query="qAdminSearchAccount">
									<tr>
										<td><a href="edit/?edit=<cfoutput>#URLEncodedFormat(qAdminSearchAccount.id)#</cfoutput>" title="<cfoutput>#qAdminSearchAccount.full_name#</cfoutput>"><cfoutput>#qAdminSearchAccount.full_name#</cfoutput></a></td>
										<td><cfoutput>#qAdminSearchAccount.student_id#</cfoutput></td>
										<td><cfoutput>#qAdminSearchAccount.email#</cfoutput></td>
										<td>
											<cfset role="">
											<cfif IsValid("integer", qAdminSearchAccount.administrator) && qAdminSearchAccount.administrator>
												<cfset role="Administrator">
											<cfelseif IsValid("integer", qAdminSearchAccount.editor) && qAdminSearchAccount.editor>
												<cfset role="Editor">
											<cfelseif IsValid("integer", qAdminSearchAccount.f_accounts_id)>
												<cfset role="Advisor">
											<cfelseif IsValid("integer", qAdminSearchAccount.s_accounts_id)>
												<cfset role="Student">
											<cfelse>
												<cfset role="None">
											</cfif>
											<cfoutput>#role#</cfoutput>
										</td>
										<td>
											<cfset status="">
											<cfif qAdminSearchAccount.active>
												<cfset status="Active">
											<cfelse>
												<cfset status="Inactive">
											</cfif>
											<cfoutput>#status#</cfoutput>
										</td>
									</tr>
								</cfloop>
							</table>
						<cfelse>	
							<p>No users found.</p>
							
						</cfif>
						
						<p/>
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
	
<cfmodule template="../../../footer.cfm">