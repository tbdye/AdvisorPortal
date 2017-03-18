<!--- Edit Department Model --->
<!--- Karan	Kalra, November 2016 --->
<!--- Thomas Dye, March 2017 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit Department">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit <cfoutput>#qEditGetDepartment.department_name#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../">Home</a>
				&raquo; <a href="../">Manage Departments</a>
				&raquo; Edit Department - <cfoutput>#qEditGetDepartment.department_name#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Department" class="rdf-meta element-hidden"></span>
	
	                <div class="content">

						<h2>Basic Details</h2>
				    	<table>
				    		<cfform>
						    	<cfif messageBean.hasErrors() && isDefined("form.updateDepartmentInfoButton")>
									<tr>
										<td colspan="3">
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
						    		<td width="125px"><label for="departmentName">Name:</label></td>
						    		<td colspan="2"><cfinput type="text" id="departmentName" name="departmentName" value="#qEditGetDepartment.department_name#"></td>
						    	</tr>
						    	<tr>
						    		<td><label for="">See Also:</label></td>
						    		<td colspan="2"><cfinput type="text" id="departmentSeeAlso" name="departmentSeeAlso" value="#qEditGetDepartment.see_also#"></td>
						    	</tr>
						    	<tr>
						    		<td><label for="">Abv Title:</label></td>
						    		<td colspan="2"><cfinput type="text" id="departmentAbvTitle" name="departmentAbvTitle" value="#qEditGetDepartment.abv_title#"></td>
						    	</tr>
						    	<tr>
						    		<td><label for="">Abv Title2:</label></td>
						    		<td colspan="2"><cfinput type="text" id="departmentAbvTitle2" name="departmentAbvTitle2" value="#qEditGetDepartment.abv_title2#"></td>
						    	</tr>
						    	<cfif IsUserInRole("administrator")>
							    	<tr>
							    		<td>Availability:</td>
										<td>
											<cfinput type="radio" id="active" name="departmentAvailability" value="1" checked="#status1#">
											<cfoutput><label for="active"> available</label></cfoutput> </br>
											<cfinput type="radio" id="inactive" name="departmentAvailability" value="0" checked="#status2#">
											<cfoutput><label for="inactive"> hidden</label></cfoutput><br>
										</td>
							    	</tr>
						    	</cfif>
						    	<tr>
						    		<td></td>
						    		<td colspan="2"><cfinput type="submit" name="updateDepartmentInfoButton" value="Update details"></td>
						    	</tr>
				    		</cfform>
				    	</table>
				    	
						<!--------------------- department intro ---------------------------->	
					
						<h3>Department Intro</h3>
				    	<table>
				    		<cfform>
						    	<tr>
						    		<td><textarea name="departmentIntro" rows="5" cols="70"><cfoutput>#qEditGetDepartment.dept_intro#</cfoutput></textarea></td>
						    	</tr>
						    	<tr>
						    		<td><cfinput type="submit" name="updateDepartmentIntroButton" value="Update description"></td>
						    	</tr>
						    </cfform>
				    	</table>
						
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
	
<cfmodule template="../../../../footer.cfm">