<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"

	pagetitle="Advisor Services Portal - Manage Users">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Manage Users</h1>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a> &raquo; <a href="manageUsers.cfm">Manage Users</a> 
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Administration" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<h2>Select an account</h2>
						
						<cfif errorBean.hasErrors()>
							<div id="form-errors">
								<ul>
									<cfloop array="#errorBean.getErrors()#" index="error">
										<cfoutput><li>#error.message#</li></cfoutput>
									</cfloop>
								</ul>
							</div>
						</cfif>								
						
						<cfform>
							<table>
								<tr>
									<td colspan="2"><strong>Find an account by name, student ID, or email address</strong></td>
								</tr>
								<tr>
									<td width="120px"><cfinput type="text" id="searchTerm" name="searchTerm"></td>
									<td><cfinput type="submit" name="searchButton" value="Search"></td>								
								</tr>							
							</table>
						</cfform>
												
						<a href="?search=all" title="view all accounts">View all accounts</a>
						
			
						<cfif errorBean.hasErrors() && isDefined("url.user")>
							<div id="form-errors">		
								<ul>
								<cfloop array="#errorBean.getErrors()#" index="error">
									<cfoutput><li>#error.message#</li></cfoutput>
								</cfloop>
								</ul>
							</div>
						<cfelseif isDefined("qAdminSearchAccount") && qAdminSearchAccount.RecordCount>
							<table>
								<tr>
									<th>Name</th>
									<th>Student ID</th>
									<th>Email</th>
									<th>Role</th>
								</tr>
								<cfloop query="qAdminSearchAccount">
									<tr>
										<td><a href="editUser.cfm?edit=<cfoutput>#URLEncodedFormat(qAdminSearchAccount.id)#</cfoutput>" title="<cfoutput>#qAdminSearchAccount.full_name#</cfoutput>"><cfoutput>#qAdminSearchAccount.full_name#</cfoutput></a></td>
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
									</tr>
								</cfloop>
							</table>
						<cfelse>	
							<p>No account selected.</p>
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
	
<cfmodule template="../includes/footer.cfm">