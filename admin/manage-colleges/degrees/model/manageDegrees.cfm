<!--- Manage Degree Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../header.cfm"

	pagetitle="Advisor Services Portal - Manage Degrees">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Manage Degrees for <cfoutput>#qManageGetCollege.college_name#</cfoutput> </h1>
	        </header>

			<div class="breadcrumb">
				<a href="../..">Home</a>
				&raquo; <a href="..">Manage Colleges</a>
				&raquo; <a href="../edit/?college=<cfoutput>#qManageGetCollege.id#</cfoutput>"><cfoutput>#qManageGetCollege.college_name#</cfoutput></a>
				&raquo; Manage Degrees
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Manage Degrees" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<cfif IsUserInRole("administrator")>
				    		<h2>Add a Degree</h2>
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
											<td></td>
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
				    					<td width="125px"><label for="degreeName">Name:</label></td>
				    					<td><cfinput type="text" id="degreeName" name="degreeName"></td>
				    				</tr>
				    				<tr>
				    					<td><label for="degreeDepartment">Department:</label></td>
				    					<td>
				    						<cfselect name="degreeDepartment" query="qManageGetAllDepartments" display="department_name" value="id" queryPosition="below">
												<option value="0">Select a department</option>
											</cfselect>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td><label for="degreeType">Type:</label></td>
				    					<td><cfinput type="text" id="degreeType" name="degreeType"></td>
				    				</tr>
				    				<tr>
				    					<td></td>
				    					<td><cfinput type="submit" name="addDegreeButton" value="Add degree"></td>
				    				</tr>
				    			</table>
				    		</cfform>
				    		
				    	</cfif>
						
						<hr/>

				    	<h2>Find a Degree to Edit by Department</h2>
			    		<table>
			    			<cfform>
						    	<cfif messageBean.hasErrors() && isDefined("form.selectDegreeButton")>
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
									<td><label for="selectDepartment">Filter:</td>
									<td>
										<cfselect name="selectDepartment" query="qManageGetSelectDepartments" display="department_name" value="id" queryPosition="below">
											<option value="0">Select a department</option>
										</cfselect>
										&nbsp;
										<cfinput type="submit" name="selectDegreeButton" value="Find">	
									</td>
								</tr>
							</cfform>	
						</table>
							
						<table>
							<cfif isDefined("qManageGetDegrees") && qManageGetDegrees.RecordCount>
								<tr>
									<th width="47%">Name</th>
									<th width="47%">Type</th>
									<th>Status</th>
								</tr>
								<cfloop query="qManageGetDegrees">
									<tr>
										<td>
											<cfoutput><a href="edit/?college=#URLEncodedFormat(qManageGetCollege.id)#&degree=#URLEncodedFormat(qManageGetDegrees.id)#" title="#qManageGetDegrees.degree_name#">#qManageGetDegrees.degree_name#</cfoutput></a>											
										</td>
										<td>
											<cfoutput>#qManageGetDegrees.degree_type#</cfoutput>
										</td>
										<cfif qManageGetDegrees.use_catalog>
											<td>Active</td>
										<cfelse>
											<td>Inactive</td>
										</cfif>
									</tr>
								</cfloop>
							<cfelse>	
								<p>No departments selected.</p>							
							</cfif>
						</table>

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