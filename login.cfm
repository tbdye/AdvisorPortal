<!--- Login Model --->
<!--- Thomas Dye, August 2016 --->
<cfmodule template="header.cfm"

	pagetitle = "Advisor Services Portal - Log in"
	includeUserNavBar="false"
	includeNavBar="false">

	<div class="resize-box">		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Advising Services Portal</h1>
	        </header>

			<div class="breadcrumb">Log in
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Login" class="rdf-meta element-hidden"></span>
	
	                <div class="content">

						<h2>
							Log in to Advisor Services Portal
						</h2>					    	               		                		                	
					    <div id="loginAccountForm">				    		
								<table>
									<tr>
										<td colspan="2">
										    <div id="form-errors">
										    	<cfif messageBean.hasErrors() && isDefined("form.loginButton")>
													<ul>
														<cfloop array="#messageBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</cfif>
										    </div>											
										</td>
									</tr>
									<cfform>
									<tr>
										<td width="130px"><label for="emailAddress">Email:</label></td>
										<td><cfinput type="text" id="emailAddress" name="emailAddress"></td>
									</tr>
									<tr>
										<td><label for="password">Password:</label></td>
										<td><cfinput type="password" id="password" name="password"></td>
									</tr>
									<tr>
										<td></td>
										<td>
											<input type="checkbox" name="rememberMe" id="rememberMe" value="rememberMe"> <!--- Todo:  Hook this up --->
											<label for="rememberMe">Remember me</label>
										</td>
									</tr>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="loginButton" value="Log in"></td>
									</tr>
									</cfform>
								</table>
					    </div>
					    
						
						<h2>
							First Time User?
						</h2>
						
						<div id="createAccountForm">
								<table>
									<tr>
										<td colspan="2">
											<div id="form-errors">
												<cfif messageBean.hasErrors() && isDefined("form.createButton")>
													<ul>
														<cfloop array="#messageBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</cfif>
											</div>											
										</td>
									</tr>
									<cfform>
									<tr>
										<td width="130px"><label for="firstName">First name:</label></td>
										<td><cfinput type="text" id="firstName" name="firstName"></td>
									</tr>
									<tr>
										<td><label for="lastName">Last name:</label></td>
										<td><cfinput type="text" id="lastName" name="lastName"></td>
									</tr>
									<tr>
										<td><label for="studentId">Student ID:</label></td>
										<td><cfinput type="text" id="studentId" name="studentId"></td>
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
											<cfinput type="submit" name="createButton" value="Create an account">									
										</td>
									</tr>
									</cfform>	
									<!--- Todo:  implement this later
									<tr>
										<td></td>
										<td>
											<p>An email confirmation will be sent to you.</p> 								
										</td>
									</tr>
									 --->

								</table>
						</div>

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
			    	<p>
			    		The Advising Services Portal is an online student-transfer information system... describe some info, helps with visits with faculty advisors.
			    	</p>
					<p>
						<strong>Advising Center</strong><br>
						Rainier Hall, Room 108<br>
						425-388-9339<br>
						<a href="mailto:advising@everettcc.edu">advising@everettcc.edu</a>
					</p>
					<p>
						<strong>Special Opening Week Hours:</strong><br>
						Monday: 10&nbsp;a.m. to 2&nbsp;p.m.<br>
						Tuesday-Friday:&nbsp;9&nbsp;a.m. to 4:30 p.m.
					</p>
					
					<p>
						<strong>Fall&nbsp;Hours:</strong><br>
						Monday: 9&nbsp;a.m. to 6&nbsp;p.m.<br>
						Tuesday-Thursday:&nbsp;9&nbsp;a.m. to 4:30 p.m.<br>
						Friday: 10 a.m. to 4:30 p.m.<br>
					</p>
					<p>
						Arrive at least a half hour prior to closing&nbsp;in order to be properly served.						
					</p>
            	</div>
		    </div>
		</aside>
	
<cfmodule template="footer.cfm">