<!--- Manage Colleges Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm"

	pagetitle="Advisor Services Portal - Manage Colleges">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Manage Colleges</h1>
	        </header>

			<div class="breadcrumb">
				<a href="..">Home</a> &raquo; Manage Colleges
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Manage Colleges" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<cfif IsUserInRole("administrator")>
				    		<h2>Add a New College</h2>
				
				    			<table>
									<tr>
										<td colspan="2">
										    <div id="form-errors">				    				
						    				<cfif messageBean.hasErrors() && isDefined("form.addCollegeButton")>
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
										</td>
									</tr>
									<cfform>
				    				<tr>
				    					<td width="90px"><label for="collegeName">Name:</label></td>
				    					<td><cfinput type="text" id="collegeName" name="collegeName"></td>
				    				</tr>
				    				<tr>
				    					<td><label for="collegeCity">City:</label></td>
				    					<td><cfinput type="text" id="collegeCity" name="collegeCity"></td>
				    				</tr>
				    				<tr>
				    					<td><label for="collegeWebsite">Website:</label></td>
				    					<td><cfinput type="text" id="collegeWebsite" name="collegeWebsite"></td>
				    				</tr>
				    				<tr>
				    					<td></td>
				    					<td><cfinput type="submit" name="addCollegeButton" value="Add college"></td>
				    				</tr>
				    				</cfform>
				    			</table>
				    	</cfif>
				    	
				    	<hr>
				    	
				    	<cfif isDefined("qManageGetColleges") && qManageGetColleges.RecordCount>
				    		<h2>Select a College to Edit</h2>
				    		<table>
				    			<tr>
				    				<th width="60%">Name</th>
				    				<th width="30%">City</th>
				    				<th >Status</th>

				    			</tr>
				    			<cfloop query="qManageGetColleges">
				    				<tr>
					    				<td width="60%"><a href="edit/?college=<cfoutput>#URLEncodedFormat(qManageGetColleges.id)#</cfoutput>" title="<cfoutput>#qManageGetColleges.college_name#, #qManageGetColleges.college_city#</cfoutput>"><cfoutput>#qManageGetColleges.college_name#</cfoutput></a></td>
					    				<td width="30%"><cfoutput>#qManageGetColleges.college_city#</cfoutput></td>
				    					<td width="10%">
					    					<cfset status="">
											<cfif qManageGetColleges.use_catalog>
												<cfset status="Active">
											<cfelse>
												<cfset status="Inactive">
											</cfif>
											<cfoutput>#status#</cfoutput>
					    				</td>
					    			</tr>
				    			</cfloop>
				    		</table>
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