<!--- Account Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../header.cfm"
	pagetitle="Advisor Services Portal - Account Settings">
	
	<div class="resize-box">
	
		<article id="content-article" role="article">
			<header>
	            <h1>Account Settings</h1>
	        </header>

			<div class="breadcrumb">
				<a href="..">Home</a>
				&raquo; Account Settings
			</div>

			<div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Account Settings" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
						
						<div id="updateLoginForm">						
							<cfform>
								<h2>Update login</h2>								
								<table>
									<tr>	
										<td colspan="2">
											<div id="form-errors">
											<cfif messageBean.hasErrors() && isDefined("form.buttonUpdateEmail")>
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
										<td><label for="email">New email:</label></td>
										<td><cfinput type="text" name="emailAddress" id="emailAddress"></td>
									</tr>
									<tr>
										<td><label for="email">Confirm new email:</label></td>
										<td><cfinput type="text" name="emailAddress2" id="emailAddress2"></td>
									</tr>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="buttonUpdateEmail" value="Update email"></td>
									</tr>
								</table>
							</cfform>
						</div>
						
						<p/>
						
						<div id="updatePasswordForm">
							<cfform>
							<h2>Update password</h2>
								<table>
									<tr>	
										<td colspan="2">
											<div id="form-errors">											
											<cfif messageBean.hasErrors() && isDefined("form.buttonUpdatePassword")>
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
											</div>
										</td>
									</tr>
									<tr>
										<td width="160px"><label for="password">Current password:</label></td>
										<td><input type="password" name="password" id="password"></td>
									</tr>
									<tr>
										<td><label for="password">New password:</label></td>
										<td><input type="password" name="newPass" id="newPass"></td>
									</tr>
									<tr>
										<td><label for="password">Confirm new password:</label></td>
										<td><input type="password" name="newPass2" id="newPass2"></td>
									</tr>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="buttonUpdatePassword" value="Update password"></td>
									</tr>
								</table>
							</cfform>
						</div>
			
						<p/>

						<div id="updateAccountForm">
							<cfform>
							<h2>Update name</h2>								
								<table>
									<tr>	
										<td colspan="2">
										<div id="form-errors">										
											<cfif messageBean.hasErrors() && isDefined("form.buttonUpdateAccount")>
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
										</div>
										</td>
									</tr>
									<tr>
										<td width="160px">Current name:</td>
										<td><cfoutput>#qAccountGetAccount.first_name# #qAccountGetAccount.last_name#</cfoutput></td>
									</tr>
									<cfif IsUserInRole("student")>
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
	            <p/>
	        </div>
		</article>
		
		<aside id="content-sidebar">
		    <div class="region region-sidebar">			
                <div class="content">
                	<p>
                		<strong>Account Settings</strong>                		
                	</p>
					<p>Provide some instructions on how the account section works and initial steps to get started using the Advisor Services Portal.</p>
            	</div>
		    </div>
		</aside>

<cfmodule template="../../footer.cfm">