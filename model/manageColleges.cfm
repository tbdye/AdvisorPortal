<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"

	pagetitle="Advisor Services Portal - Manage Colleges">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Manage Colleges</h1>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a> &raquo; <a href="manageColleges.cfm">Manage Colleges</a> 
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Manage Colleges" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<cfif IsUserInRole("administrator")>
				    		<h2>Add a college</h2>
				    		<cfform>
				    			<table>
				    				<cfif errorBean.hasErrors() && isDefined("form.addCollegeButton")>
										<tr>
											<td colspan="2">
												<div id="form-errors">
													<ul>
														<cfloop array="#errorBean.getErrors()#" index="error">
															<cfoutput><li>#error.message#</li></cfoutput>
														</cfloop>
													</ul>
												</div>
											</td>
											<td></td>
										</tr>
									</cfif>
				    				<tr>
				    					<td width="120px"><label for="collegeName">College name:</label></td>
				    					<td><cfinput type="text" id="collegeName" name="collegeName"></td>
				    				</tr>
				    				<tr>
				    					<td><label for="collegeCity">College city:</label></td>
				    					<td><cfinput type="text" id="collegeCity" name="collegeCity"></td>
				    				</tr>
				    				<tr>
				    					<td><label for="collegeWebsite">College website:</label></td>
				    					<td><cfinput type="text" id="collegeWebsite" name="collegeWebsite"></td>
				    				</tr>
				    				<tr>
				    					<td></td>
				    					<td><cfinput type="submit" name="addCollegeButton" value="Add college"></td>
				    				</tr>
				    			</table>
				    		</cfform>
				    	</cfif>
				    	<cfif isDefined("qManageGetColleges") && qManageGetColleges.RecordCount>
				    		<h2>Select a college</h2>
				    		<table>
				    			<tr>
				    				<th width="240px">College name</th>
				    				<th width="120px">College city</th>
				    				<th></th>
				    			</tr>
				    			<cfloop query="qManageGetColleges">
				    				<tr>
					    				<td><cfoutput>#qManageGetColleges.college_name#</cfoutput></td>
					    				<td><cfoutput>#qManageGetColleges.college_city#</cfoutput></td>
					    				<td><a href="editCollege.cfm?edit=<cfoutput>#URLEncodedFormat(qManageGetColleges.id)#</cfoutput>" title="<cfoutput>#qManageGetColleges.college_name#, #qManageGetColleges.college_city#</cfoutput>">Edit</a></td>
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
	
<cfmodule template="../includes/footer.cfm">