<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"

	pagetitle="Advisor Services Portal - Edit College">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit College</h1>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a>
				&raquo; <a href="manageColleges.cfm">Manage Colleges</a>
				&raquo; <a href="editCollege.cfm?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>"><cfoutput>#qEditGetCollege.college_name#</cfoutput></a>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Colleges" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<h3><cfoutput>#qEditGetCollege.college_name# - #qEditGetCollege.college_city#</cfoutput></h3>
						<div id="createForm">
							<cfform>
								<table>
									<cfif errorBean.hasErrors() && isDefined("form.updateButton")>
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
										</tr>
									</cfif>
									<tr>
										<td width="80px"><label for="collegeName">Name:</label></td>
										<td><cfinput type="text" size="#len(qEditGetCollege.college_name)#" id="collegeName" name="collegeName" value="#qEditGetCollege.college_name#"></td>
									</tr>
									<tr>
										<td><label for="collegeCity">City:</label></td>
										<td><cfinput type="text" size="#len(qEditGetCollege.college_name)#" id="collegeCity" name="collegeCity" value="#qEditGetCollege.college_city#"></td>
									</tr>
									<tr>
										<td><label for="collegeWebsite">Website:</label></td>
										<td><cfinput type="text" size="#len(qEditGetCollege.college_name)#" id="collegeWebsite" name="collegeWebsite" value="#qEditGetCollege.college_website#"></td>
									</tr>
									<cfif IsUserInRole("administrator")>
										<tr>
											<td><label for="collegeAvailability">Availability:</label></td>
											<td>
												<cfinput type="radio" id="active" name="collegeAvailability" value="1" checked="#status1#">
												<cfoutput><label for="active"> College is available to users.</label></cfoutput><br>
												<cfinput type="radio" id="inactive" name="collegeAvailability" value="0" checked="#status2#">
												<cfoutput><label for="inactive">College is hidden.</label></cfoutput><br>
											</td>
										</tr>
									</cfif>
									<tr>
										<td></td>
										<td>
											<cfinput type="submit" name="updateButton" value="Update">										
										</td>
									</tr>
								</table>
							</cfform>
						</div>
						
						<h3>Degrees</h3>
						<a href="manageDegrees.cfm?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>" title="View Degrees">View Degrees</a>
						
						<h3>Admission Requirements</h3>
						<div id="createForm">
							<table>
								<cfform>
									<cfif errorBean.hasErrors() && isDefined("form.addCourseReq")>
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
										</tr>
									</cfif>
									<tr>
										<h4>Requirements by course</h4>
										<th>EvCC Equivalent</th>
										<th>Required Course</th>
										<th></th>
									</tr>
									<cfloop query="qEditGetAdmissionCourses">
										<tr>
											<td><cfoutput>#qEditGetAdmissionCourses.course_number#</cfoutput></td>
											<td><cfoutput>#qEditGetAdmissionCourses.foreign_course_number#</cfoutput></td>
											<td><a href="?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>&section=courses&remove=<cfoutput>#URLEncodedFormat(qEditGetAdmissionCourses.id)#</cfoutput>" title="<cfoutput>Remove #qEditGetAdmissionCourses.course_number#</cfoutput>">Remove</a></td>
										</tr>
									</cfloop>
									<tr>
										<td><cfinput type="text" id="localCourse" name="localCourse"></td>
										<td><cfinput type="text" id="foreignCourse" name="foreignCourse"></td>
										<td></td>
									</tr>
									<tr>
										<td><cfinput type="submit" name="addCourseReq" value="Add"></td>
										<td></td>
										<td></td>
									</tr>
								</cfform>
							</table>
						</div>
						
						<div id="createForm">
							<table>
								<cfform>
									<cfif errorBean.hasErrors() && isDefined("form.addDepartmentReq")>
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
										</tr>
									</cfif>
									<tr>
										<h4>Requirements by department</h4>
										<th>EvCC Department</th>
										<th>Credit required</th>
										<th></th>
									</tr>
									<cfloop query="qEditGetAdmissionDepartments">
										<tr>
											<td><cfoutput>#qEditGetAdmissionDepartments.department_name#</cfoutput></td>
											<td><cfoutput>#qEditGetAdmissionDepartments.credit#</cfoutput></td>
											<td><a href="?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>&section=departments&remove=<cfoutput>#URLEncodedFormat(qEditGetAdmissionDepartments.id)#</cfoutput>" title="<cfoutput>Remove #qEditGetAdmissionDepartments.department_name#</cfoutput>">Remove</a></td>
										</tr>
									</cfloop>
									<tr>
										<td>
											<cfselect name="localDepartment" query="qEditGetSelectDepartments" display="department_name" value="id" queryPosition="below">
												<option value="0">Select a department</option>
											</cfselect>
										</td>
										<td><cfinput type="text" id="departmentCredits" name="departmentCredits"></td>
										<td></td>
									</tr>
									<tr>
										<td><cfinput type="submit" name="addDepartmentReq" value="Add"></td>
										<td></td>
										<td></td>
									</tr>
								</cfform>
							</table>
						</div>
						
						<div id="createForm">
							<table>
								<cfform>
									<cfif errorBean.hasErrors() && isDefined("form.addCodekeyReq")>
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
										</tr>
									</cfif>
									<tr>
										<h4>Requirements by adademic discipline</h4>
										<th>EvCC Codekey</th>
										<th>Credit required</th>
										<th></th>
									</tr>
									<cfloop query="qEditGetAdmissionCodekeys">
										<tr>
											<td><cfoutput>#qEditGetAdmissionCodekeys.description#</cfoutput></td>
											<td><cfoutput>#qEditGetAdmissionCodekeys.credit#</cfoutput></td>
											<td><a href="?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>&section=codekeys&remove=<cfoutput>#URLEncodedFormat(qEditGetAdmissionCodekeys.id)#</cfoutput>" title="<cfoutput>Remove #qEditGetAdmissionCodekeys.description#</cfoutput>">Remove</a></td>
										</tr>
									</cfloop>
									<tr>
										<td>
											<cfselect name="localCodekey" query="qEditGetSelectCodekeys" display="description" value="id" queryPosition="below">
												<option value="0">Select a discipline</option>
											</cfselect>
										</td>
										<td><cfinput type="text" id="codekeyCredits" name="codekeyCredits"></td>
										<td></td>
									</tr>
									<tr>
										<td><cfinput type="submit" name="addCodekeyReq" value="Add"></td>
										<td></td>
										<td></td>
									</tr>
								</cfform>
							</table>
						</div>
						
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