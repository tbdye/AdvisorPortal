<!--- Edit College Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit College">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit College - <cfoutput>#qEditGetCollege.college_name#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../..">Home</a>
				&raquo; <a href="..">Manage Colleges</a>
				&raquo; Edit College - <cfoutput>#qEditGetCollege.college_name#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit College" class="rdf-meta element-hidden"></span>
	
			    	<h2>Basic Details</h2>
						<cfform>
							<table>
								<cfif messageBean.hasErrors() && isDefined("form.updateButton")>
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
									<td width="125px"><label for="collegeName">Name:</label></td>
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
											<cfoutput><label for="active"> available</label></cfoutput> </br>
											<cfinput type="radio" id="inactive" name="collegeAvailability" value="0" checked="#status2#">
											<cfoutput><label for="inactive"> hidden</label></cfoutput><br>
										</td>
									</tr>
								</cfif>
								<tr>
									<td></td>
									<td>
										<cfinput type="submit" name="updateButton" value="Update details">										
									</td>
								</tr>
							</table>
						</cfform>
						
						
						
						<h2>Degrees</h2>
						<a href="../degrees/?college=<cfoutput>#qEditGetCollege.id#</cfoutput>" title="View Degrees">View Degrees</a><p/>
		
						<h2>Admission Requirements</h2>

						<!---------------------Requirements by course---------------------------->				
						<h3>By Course</h3>

						<cfif qEditGetAdmissionCourses.RecordCount>
							<div id="h4-box">
								<table>										
									<tr>
										<th width="35%">EvCC Course</th>
										<th width="25%">Category</th>
										<th width="35%">Equivalent Course</th>
										<th></th>
									</tr>
									<cfloop query="qEditGetAdmissionCourses">
										<cfform>
											<tr>
												<cfinput type="hidden" name="coursesId" value="#qEditGetAdmissionCourses.id#">
												<td><cfoutput>#qEditGetAdmissionCourses.course_number#</cfoutput></td>
												<td><cfoutput>#qEditGetAdmissionCourses.category#</cfoutput></td>
												<td><cfoutput>#qEditGetAdmissionCourses.foreign_course_number#</cfoutput></td>
												<td><cfinput type="submit" name="delCourseReq" value="Remove"></td>
											</tr>
										</cfform>
									</cfloop>
								</table>
							</div>
						</cfif>
						
						<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add New Course</h4></td>
								</tr>

								<cfif messageBean.hasErrors() && isDefined("form.addCourseReq")>
								<tr><td colspan="2">
									<div id="form-errors">
										<ul>
											<cfloop array="#messageBean.getErrors()#" index="error">
												<cfoutput><li>#error.message#</li></cfoutput>
											</cfloop>
										</ul>
									</div>											
								</td></tr>
								</cfif>									

								<cfform>
								<tr>
									<td width="125px">EvCC course:</td>
									<td><cfinput type="text" id="localCourse" name="localCourse"></td>
								</tr>
								<tr>
									<td>Category: </td>
									<td>
										<cfselect name="localCourseCategory" query="qEditGetSelectCategories" display="category" value="id" queryPosition="below" >
											<option value="0">Select a category</option>
										</cfselect>
									</td>
								</tr>
								<tr>
									<td>Equivalent course: </td>
									<td><cfinput type="text" id="foreignCourse" name="foreignCourse"></td>
								</tr>
								<tr>
									<td></td>
									<td><cfinput type="submit" name="addCourseReq" value="Add course"></td>
								</tr>
								</cfform>
							</table>
						</div>
			
						<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add Notes</h4></td>
								</tr>								
								<cfform>
									<tr>
										<td width="125px">Notes:</td>
										<td><textarea name="courseReqNote" rows="5" cols="50"><cfoutput>#qEditGetCollegeNotes.courses_note#</cfoutput></textarea>
	                					</td>
									</tr>
	                				<tr>
	                					<td></td>
	                					<td><cfinput type="submit" name="updateCourseReqNoteButton" value="Update notes"></td>
	                				</tr>
	                			</cfform>
							</table>
						</div>
						
						<!---------------------Requirements by department ---------------------------->		
						
						<h3>By Department</h3>						
						<cfif qEditGetAdmissionDepartments.RecordCount>
							<div id="h4-box">
								<table>										
									<tr>
										<th width="47%">EvCC Department</th>
										<th width="47%">Credit Required</th>
										<th></th>
									</tr>
									<cfloop query="qEditGetAdmissionDepartments">
										<cfform>
											<tr>
												<cfinput type="hidden" name="departmentsId" value="#qEditGetAdmissionDepartments.id#">
												<td><cfoutput>#qEditGetAdmissionDepartments.department_name#</cfoutput></td>
												<td><cfoutput>#qEditGetAdmissionDepartments.credit#</cfoutput></td>
												<td><cfinput type="submit" name="delDepartmentReq" value="Remove"></td>
											</tr>
										</cfform>
									</cfloop>
								</table>							
							</div>
						</cfif>											

						<div id="h4-box">

							<table>
								<tr>
									<td colspan="2"><h4>Add New Department</h4></td>
								</tr>

								<cfif messageBean.hasErrors() && isDefined("form.addDepartmentReq")>
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
								
								<cfform>
									<tr>
										<td width="125px">Department:</td>
										<td>
											<cfselect name="localDepartment" query="qEditGetSelectDepartments" display="department_name" value="id" queryPosition="below" >
												<option value="0">Select a department:</option>
											</cfselect>
										</td>
									</tr>
									<tr>
										<td>Credits</td>
										<td><cfinput type="text" id="departmentCredits" name="departmentCredits"></td>
									<tr>
									</tr>
										<td></td>
										<td><cfinput type="submit" name="addDepartmentReq" value="Add department"></td>
									</tr>
								</cfform>
							</table>														
						</div>												


						<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add Notes</h4></td>									
								</tr>	
								<cfform>
	                				<tr>
	                					<td width="125px">Notes:</td>
	                					<td><textarea name="departmentReqNote" rows="5" cols="50"><cfoutput>#qEditGetCollegeNotes.departments_note#</cfoutput></textarea></td>
	                				</tr>
	                				<tr>
	                					<td></td>
	                					<td><cfinput type="submit" name="updateDepartmentReqNoteButton" value="Update notes"></td>
	                				</tr>
	                			</cfform>
							</table>
						</div>												

												
						
						<!---------------------Requirements by discipline ---------------------------->
						
						<h3>By Academic Discipline</h3>
						
						<cfif qEditGetAdmissionCodekeys.RecordCount>
							<div id="h4-box">
								<table>										
									<tr>
										<th width="47%">EvCC codekey</th>
										<th width="47%">Credit required</th>
										<th></th>
										<th></th>
									</tr>
									<cfloop query="qEditGetAdmissionCodekeys">
										<cfform>
											<tr>
												<cfinput type="hidden" name="codekeysId" value="#qEditGetAdmissionCodekeys.id#">
												<td width="55%"><cfoutput>#qEditGetAdmissionCodekeys.description#</cfoutput></td>
												<td width="35%"><cfoutput>#qEditGetAdmissionCodekeys.credit#</cfoutput></td>
												<td width="10%"><cfinput type="submit" name="delCodekeyReq" value="Remove"></td>
											</tr>
										</cfform>
									</cfloop>
								</table>							
							</div>
						</cfif>	
						
						<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add new discipline</h4></td>
								</tr>								

								<cfif messageBean.hasErrors() && isDefined("form.addCodekeyReq")>
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

								<cfform>
								<tr>
									<td width="125px">EvCC codekey:</td>
									<td><cfselect name="localCodekey" query="qEditGetSelectCodekeys" display="description" value="id" queryPosition="below">
												<option value="0">Select a discipline</option>
											</cfselect>
									</td>
								</tr>
								<tr>
									<td>Credits required:</td>
									<td>
										<cfinput type="text" id="codekeyCredits" name="codekeyCredits">
									</td>
								</tr>
								<tr>
									<td></td>
									<td><cfinput type="submit" name="addCodekeyReq" value="Add discipline"></td>
								</tr>
								</cfform>
							</table>
						</div>
						
						<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add Notes</h4></td>									
								</tr>	
								<cfform>
	                				<tr>
	                					<td width="125px">Notes:</td>
	                					<td><textarea name="codekeyReqNote" rows="5" cols="50"><cfoutput>#qEditGetCollegeNotes.codekeys_note#</cfoutput></textarea></td>
	                				</tr>
	                				<tr>
	                					<td></td>
	                					<td><cfinput type="submit" name="updateCodekeyReqNoteButton" value="Update notes"></td>
	                				</tr>
	                			</cfform>
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