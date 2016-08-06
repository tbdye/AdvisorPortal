<!--- Edit User Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit User">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit User</h1>
	        </header>

			<div class="breadcrumb">
				<a href="../..">Home</a>
				&raquo; <a href="..">Manage Users</a>
				&raquo; <a href="?edit=<cfoutput>#URLDecode(url.edit)#</cfoutput>">Edit User</a>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Administration" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<h2><cfoutput>#qUserGetAccount.first_name# #qUserGetAccount.last_name#</cfoutput></h2>
						<div id="createForm">
							<cfform>
								<table>
									<cfif messageBean.hasErrors()>
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
										<h3>Status</h3>
										<cfinput type="radio" id="active" name="status" value="1" checked="#status1#">
										<cfoutput><label for="active">Account is available for use.</label></cfoutput><br>
										<cfinput type="radio" id="inactive" name="status" value="0" checked="#status2#">
										<cfoutput><label for="inactive">Account is deactivated.</label></cfoutput><br>
									</tr>
									<cfif IsValid("integer", qUserGetAccount.f_accounts_id)>
										<tr>
											<h3>Role</h3>
											<cfinput type="radio" id="advisor" name="role" value="1" checked="#role1#">
											<cfoutput><label for="advisor">Advisor</label></cfoutput><br>
											<cfinput type="radio" id="editor" name="role" value="2" checked="#role2#">
											<cfoutput><label for="editor">Editor</label></cfoutput><br>
											<cfinput type="radio" id="administrator" name="role" value="3" checked="#role3#">
											<cfoutput><label for="administrator">Administrator</label></cfoutput>
										</tr>
									</cfif>
									<tr>
										<h3>Account</h3>
										<td width="130px"><label for="emailAddress">Email address:</label></td>
										<td><cfinput type="text" id="emailAddress" name="emailAddress" value="#qUserGetAccount.email#"></td>
									</tr>
									<tr>
										<td><label for="firstName">First name:</label></td>
										<td><cfinput type="text" id="firstName" name="firstName" value="#qUserGetAccount.first_name#"></td>
									</tr>
									<tr>
										<td><label for="lastName">Last name:</label></td>
										<td><cfinput type="text" id="lastName" name="lastName" value="#qUserGetAccount.last_name#"></td>
									</tr>
									<cfif IsValid("integer", qUserGetAccount.s_accounts_id)>
										<tr>
											<td><label for="studentId">Student ID:</label></td>
											<td><cfinput type="text" id="studentId" name="studentId" value="#qUserGetAccount.student_id#"></td>
										</tr>
									</cfif>
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
											<cfinput type="submit" name="saveButton" value="Save changes">										
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<p>Accounts cannot be switched between students and faculty.</p>
										</td>
									</tr>
								</table>
							</cfform>
						</div>
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
	
<cfmodule template="../../../../footer.cfm">