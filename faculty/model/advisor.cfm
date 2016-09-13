<!--- Advisor Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../header.cfm"

	pagetitle="Advisor Services Portal - Advise Student">
				
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Advise Student</h1>
	        </header>

			<div class="breadcrumb">
				<a href="">Home</a>
				&raquo; Advise Student
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Advising" class="rdf-meta element-hidden"></span>
	
	                <div class="content">

					<!-- Form START -->
						<cfform>
							<p>
								<p><strong>Search for a student by name, student ID, or email address to advise</strong></p>
							</p>
							<p>
								<cfinput type="text" id="searchTerm" name="searchTerm">&nbsp;<cfinput type="submit" name="selectButton" value="Search">
							</p>
							<p>
								<cfif isDefined("url.search") || isDefined("qAdvisorGetStudent") && qAdvisorGetStudent.RecordCount>
									<a href="" title="hide all students">Hide all students</a>
								<cfelse>
									<a href="?search=all" title="view all students">View all students</a>
								</cfif>	
							</p>
							
							<table>
								<cfif messageBean.hasErrors() && isDefined("form.selectButton")>
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
							</table>	
						</cfform>
	                	<!-- Form END -->



						<cfif messageBean.hasErrors() && isDefined("url.advise")>
							<div id="form-errors">		
								<ul>
								<cfloop array="#messageBean.getErrors()#" index="error">
									<cfoutput><li>#error.message#</li></cfoutput>
								</cfloop>
								</ul>
							</div>
						<cfelseif isDefined("qAdvisorGetStudent") && qAdvisorGetStudent.RecordCount>
							<h2>Search results</h2>
							<div id="search-results">
								<table>
									<tr>
										<th>Name</th>
										<th>Student ID</th>
										<th>Email</th>
										<th></th>
									</tr>
									<cfloop query="qAdvisorGetStudent">
										<tr>
											<td><cfoutput>#qAdvisorGetStudent.full_name#</cfoutput></td>
											<td><cfoutput>#qAdvisorGetStudent.student_id#</cfoutput></td>
											<td><cfoutput>#qAdvisorGetStudent.email#</cfoutput></td>
											<td>
												<cfform>
													<cfinput type="hidden" name="studentId" value="#qAdvisorGetStudent.student_id#">
													<cfinput type="submit" name="adviseButton" value="Advise">
												</cfform>
											</td>
										</tr>
									</cfloop>
								</table>
							</div>

						<cfelse>
							<cfif isDefined("session.studentId")>
								<cfform>
									<cfinput type="submit" name="stopAdvisingButton" value="Stop advising #session.studentName#">
								</cfform>
							<cfelse>
								<p>No student selected.</p>
							</cfif>
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
                		<strong>Advise Student</strong>                		
                	</p>
					<p>Provide some instructions on how the advisor student selector works and initial steps to get started using the Advisor Services Portal.</p>
            	</div>
		    </div>
		</aside>
	
<cfmodule template="../../footer.cfm">