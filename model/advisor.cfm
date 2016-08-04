<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"

	pagetitle="Advisor Services Portal - Advising">
				
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Advising</h1>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Advising" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
						<cfif IsUserInRole("editor")>
							<h2>Manage Portal</h2>
							<a href="manageColleges.cfm" title="Manage Colleges">Manage Colleges</a><br>
							<a href="manageCourses.cfm" title="Manage Courses">Manage Courses</a><br>
							<a href="manageDegrees.cfm" title="Manage Degrees">Manage Degrees</a><br>
						</cfif>

						<h2>Select a student to advise</h2>

						<cfform>
							<table>
								<tr>
									<td colspan="2">
										<cfif errorBean.hasErrors() && isDefined("form.selectButton")>
											<div id="form-errors">
												<ul>
													<cfloop array="#errorBean.getErrors()#" index="error">
														<cfoutput><li>#error.message#</li></cfoutput>
													</cfloop>
												</ul>
											</div>
										</cfif>
									</td>
									<td></td>
								</tr>
								<tr>
									<td colspan="2"><strong>Find a student by name, student ID, or email address</strong></td>
								</tr>
								<tr>
									<td width="120px"><cfinput type="text" id="searchTerm" name="searchTerm"></td>
									<td><cfinput type="submit" name="selectButton" value="Search"></td>								
								</tr>
								<tr>
									<td colspan="2">
										<cfif isDefined("url.search") || isDefined("qAdvisorGetStudent") && qAdvisorGetStudent.RecordCount>
											<a href="advisor.cfm" title="hide all students">Hide all students</a>
										<cfelse>
											<a href="?search=all" title="view all students">View all students</a>
										</cfif>
									</td>
									<td></td>
								</tr>						
							</table>
						</cfform>

						<cfif errorBean.hasErrors() && isDefined("url.advise")>
							<div id="form-errors">		
								<ul>
								<cfloop array="#errorBean.getErrors()#" index="error">
									<cfoutput><li>#error.message#</li></cfoutput>
								</cfloop>
								</ul>
							</div>
						<cfelseif isDefined("qAdvisorGetStudent") && qAdvisorGetStudent.RecordCount>
							<h2>Search results</h2>
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
										<td><a href="?advise=<cfoutput>#qAdvisorGetStudent.student_id#</cfoutput>" title="Advise">Advise</a></td>
									</tr>
								</cfloop>
							</table>
						<cfelse>
							<cfif isDefined("session.studentId")>
								<p><a href="?advise=end" title="End advising session">Stop advising <cfoutput>#session.studentName#</cfoutput></a></p>
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
	
<cfmodule template="../includes/footer.cfm">