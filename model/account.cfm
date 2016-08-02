<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Account settings">
	
	<div class="resize-box">
	
		<article id="content-article" role="article">
			<header>
	            <h1>Account settings</h1>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a> &raquo; <a href="account.cfm">Account settings</a> 
			</div>

			<div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Account settings" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
						<h2>Update login</h2>
						<div id="updateLoginForm">
							<cfform>
								<table>
									<tr>
										<td colspan="2">
											<div id="form-errors">
												<cfif errorBean.hasErrors() && isDefined("form.buttonUpdateEmail")>
													<ul>
														<cfloop array="#errorBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</cfif>
											</div>											
										</td>
									</tr>
									<tr>
										<td width="160px">Current email:</td>
										<td><cfoutput>#qAccountGetAccount.email#</cfoutput></td>
									</tr>
									<tr>
										<td><label for="password">Password:</label></td>
										<td><cfinput type="password" name="password" id="password"></td>
									</tr>
									<tr>
										<td><label for="email">New Email:</label></td>
										<td><cfinput type="email" name="emailAddress" id="emailAddress"></td>
									</tr>
									<tr>
										<td><label for="email">Re-enter New Email:</label></td>
										<td><cfinput type="email" name="emailAddress2" id="emailAddress2"></td>
									</tr>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="buttonUpdateEmail" value="Update email"></td>
									</tr>
								</table>
							</cfform>
						</div>
						
						<h2>Update password</h2>
						<div id="updatePasswordForm">
							<cfform>
								<table>
									<tr>
										<td colspan="2">
											<div id="form-errors">
												<cfif errorBean.hasErrors() && isDefined("form.buttonUpdatePassword")>
													<ul>
														<cfloop array="#errorBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</cfif>
											</div>											
										</td>
									</tr>
									<tr>
										<td width="160px"><label for="password">Current Password:</label></td>
										<td><input type="password" name="password" id="password"></td>
									</tr>
									<tr>
										<td><label for="password">New Password:</label></td>
										<td><input type="password" name="newPass" id="newPass"></td>
									</tr>
									<tr>
										<td><label for="password">Confirm Password:</label></td>
										<td><input type="password" name="newPass2" id="newPass2"></td>
									</tr>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="buttonUpdatePassword" value="Update password"></td>
									</tr>
								</table>
							</cfform>
						</div>
			
						<h2>Update account</h2>
						<div id="updateAccountForm">
							<cfform>
								<table>
									<tr>
										<td colspan="2">
											<div id="form-errors">
												<cfif errorBean.hasErrors() && isDefined("form.buttonUpdateAccount")>
													<ul>
														<cfloop array="#errorBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</cfif>
											</div>											
										</td>
									</tr>
									<tr>
										<td width="160px">Current name:</td>
										<td><cfoutput>#qAccountGetAccount.first_name# #qAccountGetAccount.last_name#</cfoutput></td>
									</tr>
									<cfif IsUserInRole("")>
										<tr>
											<td>Current student ID:</td>
											<td><cfoutput>#qAccountGetAccount.student_id#</cfoutput></td>
										</tr>
									</cfif>
									<tr>
										<td><label for="firstName">New first name:</label></td>
										<td><input type="text" name="firstName" id="firstName"></td>
									</tr>
									<tr>
										<td><label for="lastName">New last name:</label></td>
										<td><input type="text" name="lastName" id="lastName"></td>
									</tr>
									<cfif IsUserInRole("student")>
										<tr>
											<td><label for="studentId">New student ID:</label></td>
											<td><input type="text" name="studentId" id="studentId"></td>
										</tr>
									</cfif>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="buttonUpdateAccount" value="Update account"></td>
									</tr>
								</table>
							</cfform>
						</div>
			        </div>
	            </div>
	            <br>
	        </div>
		</article>
		
		<aside id="content-sidebar">
		    <div class="region region-sidebar">			
                <div class="content">
                	<p>
                		<strong>Account settings</strong>                		
                	</p>
					<p>Provide some instructions on how the account section works and initial steps to get started using the Advisor Services Portal.</p>
            	</div>
		    </div>
		</aside>

<cfmodule template="../includes/footer.cfm">