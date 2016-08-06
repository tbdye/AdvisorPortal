<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"

	pagetitle="Advisor Services Portal - Edit Degree">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit Degree</h1>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a>
				&raquo; <a href="manageColleges.cfm">Manage Colleges</a>
				&raquo; <a href="editCollege.cfm?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>">Edit College</a>
				&raquo; <a href="editDegree.cfm?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>">Edit Degree</a>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Degree" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<h3><cfoutput>#qEditGetCollege.college_name# - #qEditGetCollege.college_city#</cfoutput></h3>
				    	<h4>Add new degree</h4>
						<div id="createForm">
							<cfform>
								<table>
									<cfif messageBean.hasErrors() && isDefined("form.addDegreeButton")>
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
									<cfelseif messageBean.hasMessages() && isDefined("form.addDegreeButton")>
										<tr>
											<td colspan="2">
												<div id="form-messages">
													<ul>
														<cfloop array="#messageBean.getMessages()#" index="message">
															<cfoutput><li>#message.message#</li></cfoutput>
														</cfloop>
													</ul>
												</div>											
											</td>
										</tr>
									</cfif>
									<tr>
										<td><label for="degreeDepartment">Department:</label></td>
										<td>
											<cfselect name="degreeDepartment" query="qEditGetSelectDepartments" display="department_name" value="id" queryPosition="below">
												<option value="0">Select a department</option>
											</cfselect>
										</td>
									</tr>
									<tr>
										<td width="100px"><label for="degreeName">Name:</label></td>
										<td><cfinput type="text" id="degreeName" name="degreeName"></td>
									</tr>
									<tr>
										<td width="100px"><label for="degreeType">Type:</label></td>
										<td><cfinput type="text" id="degreeType" name="degreeType"></td>
									</tr>
									<tr>
										<td></td>
										<td>
											<cfinput type="submit" name="addDegreeButton" value="Add degree">										
										</td>
									</tr>
								</table>
							</cfform>
						</div>
						
						<cfloop query="qEditGetDepartments">
							<cfif isDefined("url.department") && url.department EQ qEditGetDepartments.id>
								<a href="?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>" title="<cfoutput>#qEditGetDepartments.department_name#</cfoutput>"><cfoutput>#qEditGetDepartments.department_name#</cfoutput></a><br>
								<ul>
									<cfloop query="qEditGetDegrees">
										<li><a href="?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>&department=<cfoutput>#qEditGetDepartments.id#</cfoutput>&view=<cfoutput>#qEditGetDegrees.id#</cfoutput>" title="<cfoutput>#qEditGetDegrees.degree_name#</cfoutput>"><cfoutput>#qEditGetDegrees.degree_name#</cfoutput></a></li>
									</cfloop>
								</ul>
							<cfelse>
								<a href="?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>&department=<cfoutput>#qEditGetDepartments.id#</cfoutput>" title="<cfoutput>#qEditGetDepartments.department_name#</cfoutput>"><cfoutput>#qEditGetDepartments.department_name#</cfoutput></a><br>
							</cfif>
						</cfloop>
						
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