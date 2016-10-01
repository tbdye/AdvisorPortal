<!--- Edit Degree Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit Degree">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit <cfoutput>#qEditGetDegree.degree_name#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../..">Home</a>
				&raquo; <a href="../..">Manage Colleges</a>
				&raquo; <a href="../../edit/?college=<cfoutput>#qEditGetCollege.id#</cfoutput>"><cfoutput>#qEditGetCollege.college_name#</cfoutput></a>
				&raquo; <a href="../?college=<cfoutput>#qEditGetCollege.id#</cfoutput>"><cfoutput>Manage Degrees</cfoutput></a>
				&raquo; Edit Degree - <cfoutput>#qEditGetDegree.degree_name#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Degree" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
	                	<h2>Basic Details</h2>
	                	<cfform>
	                		<table>
	                			<cfif messageBean.hasErrors() && isDefined("form.updateDegreeButton")>
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
								<td width="125px"><label for="degreeName">Name:</label></td>
								<td><cfinput type="text" id="degreeName" name="degreeName" value="#qEditGetDegree.degree_name#"></td>
							</tr>	
							<tr>
								<td><label for="degreeDepartment">Department:</label></td>
								<td>
									<cfselect name="degreeDepartment" query="qEditGetAllDepartments" display="department_name" value="id" selected="#qEditGetDegree.departments_id#" queryPosition="below">
										<option value="0">Select a department</option>
									</cfselect>
								</td>
							</tr>
							<tr>
		    					<td><label for="degreeType">Type:</label></td>
		    					<td><cfinput type="text" id="degreeType" name="degreeType" value="#qEditGetDegree.degree_type#"></td>
		    				</tr>
		    				<cfif IsUserInRole("administrator")>
								<tr>
									<td><label for="degreeAvailability">Availability:</label></td>
									<td>
										<cfinput type="radio" id="active" name="degreeAvailability" value="1" checked="#status1#">
										<cfoutput><label for="active"> available</label></cfoutput> </br>
										<cfinput type="radio" id="inactive" name="degreeAvailability" value="0" checked="#status2#">
										<cfoutput><label for="inactive"> hidden</label></cfoutput><br>
									</td>
								</tr>
							</cfif>
		    				<tr>
		    					<td></td>
		    					<td><cfinput type="submit" name="updateDegreeButton" value="Update details"></td>
		    				</tr>
	                		</table>
	                	</cfform>
	                	
	                	
	                		
	                	<h2>Admission Requirements</h2>
	                	
						<!---------------------Admission requirements by course---------------------------->				
						<h3>By Course</h3>
						
						<cfif qEditGetAdmissionCourses.RecordCount>
							<div id="h4-box">
								<table>																
									<tr>
										<th>EvCC Course</th>
										<th>Category</th>
										<th>Equivalent Course</th>
										<th></th>
									</tr>
									<cfloop query="qEditGetAdmissionCourses">
										<cfform>
											<tr>
												<cfinput type="hidden" name="admCoursesId" value="#qEditGetAdmissionCourses.id#">
												<td width="40%"><cfoutput>#qEditGetAdmissionCourses.course_number#</cfoutput></td>
												<td width="15%"><cfoutput>#qEditGetAdmissionCourses.category#</cfoutput></td>
												<td width="35%"><cfoutput>#qEditGetAdmissionCourses.foreign_course_number#</cfoutput></td>
												<td width="10%"><cfinput type="submit" name="delAdmCourseReq" value="Remove"></td>
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
	                			<cfif messageBean.hasErrors() && isDefined("form.addAdmCourseReq")>
								<tr>
									<td colspan="4">
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
										<td width="125px">EvCC course:</td>
										<td><cfinput type="text" id="localAdmCourse" name="localAdmCourse"></td>
									</tr>
									<tr>
										<td>Category: </td>
										<td>
											<cfselect name="localAdmCourseCategory" query="qEditGetAllCategories" display="category" value="id" queryPosition="below" >
												<option value="0">Select a category</option>
											</cfselect>
										</td>
									</tr>
									<tr>
										<td>Equivalent course: </td>	
										<td><cfinput type="text" id="foreignAdmCourse" name="foreignAdmCourse"></td>
									</tr>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="addAdmCourseReq" value="Add course"></td>
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
	                					<td><textarea name="admCourseReqNote" rows="5" cols="50"><cfoutput>#qEditGetDegreeNotes.admission_courses_note#</cfoutput></textarea></td>
	                				</tr>
	                				<tr>
	                					<td></td>
	                					<td><cfinput type="submit" name="updateAdmCourseReqNoteButton" value="Update notes"></td>
	                				</tr>
	                			</cfform>	
		                	</table>							
						</div>
						
						
						<!---------------------Admission requirements by discipline ---------------------------->		
						
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
											<cfinput type="hidden" name="admCodekeysId" value="#qEditGetAdmissionCodekeys.id#">
											<td width="55%"><cfoutput>#qEditGetAdmissionCodekeys.description#</cfoutput></td>
											<td width="35%"><cfoutput>#qEditGetAdmissionCodekeys.credit#</cfoutput></td>
											<td width="10%"><cfinput type="submit" name="delAdmCodekeyReq" value="Remove"></td>
											</tr>
										</cfform>
									</cfloop>
								</table>		                			                		
		                	</div>
						</cfif>		                	
	                	
						<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add New Discipline</h4></td>
								</tr>
			                	<cfif messageBean.hasErrors() && isDefined("form.addAdmCodekeyReq")>
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
									<td>
										<cfselect name="localAdmCodekey" query="qEditGetAllCodekeys" display="description" value="id" queryPosition="below" >
											<option value="0">Select a discipline</option>
										</cfselect>
									</td>
								</tr>
								<tr>
									<td>Credits required:</td>
									<td>
										<cfinput type="text" id="codekeyAdmCredits" name="codekeyAdmCredits">
									</td>
								</tr>
								<tr>
									<td></td>
									<td><cfinput type="submit" name="addAdmCodekeyReq" value="Add discipline"></td>
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
                						<td><textarea name="admCodekeyReqNote" rows="5" cols="50"><cfoutput>#qEditGetDegreeNotes.admission_codekeys_note#</cfoutput></textarea></td>
	                				</tr>
	                				<tr>
	                					<td></td>
                					<td><cfinput type="submit" name="updateAdmCodekeyReqNoteButton" value="Update notes"></td>
	                				</tr>
	                			</cfform>
							</table>
						</div>	


						<p/>
              		
	                	<h2>Optional Graduation Requirements</h2>	                	
	                	
	                	<!---------------------Grad requirements by course---------------------------->				
						<h3>By Course</h3>
						
						<cfif qEditGetGraduationCourses.RecordCount>
							<div id="h4-box">
								<table>																
									<tr>
										<th>EvCC Course</th>
										<th>Category</th>
										<th>Equivalent Course</th>
										<th></th>
									</tr>
									<cfloop query="qEditGetGraduationCourses">
										<cfform>
											<tr>
												<cfinput type="hidden" name="grdCoursesId" value="#qEditGetGraduationCourses.id#">
												<td width="40%"><cfoutput>#qEditGetGraduationCourses.course_number#</cfoutput></td>
												<td width="15%"><cfoutput>#qEditGetGraduationCourses.category#</cfoutput></td>
												<td width="35%"><cfoutput>#qEditGetGraduationCourses.foreign_course_number#</cfoutput></td>
												<td width="10%"><cfinput type="submit" name="delGrdCourseReq" value="Remove"></td>
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
	                			<cfif messageBean.hasErrors() && isDefined("form.addGrdCourseReq")>
									<tr>
										<td colspan="4">
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
										<td width="125px">EvCC course:</td>
										<td><cfinput type="text" id="localGrdCourse" name="localGrdCourse"></td>
									</tr>
									<tr>
										<td>Category: </td>
										<td>
											<cfselect name="localGrdCourseCategory" query="qEditGetAllCategories" display="category" value="id" queryPosition="below" >
											<option value="0">Select a category</option>
											</cfselect>
										</td>
									</tr>
									<tr>
										<td>Equivalent course: </td>	
										<td><cfinput type="text" id="foreignGrdCourse" name="foreignGrdCourse"></td>
									</tr>
									<tr>
										<td></td>
										<td><cfinput type="submit" name="addGrdCourseReq" value="Add course"></td>
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
	                					<td><textarea name="grdCourseReqNote" rows="5" cols="50"><cfoutput>#qEditGetDegreeNotes.graduation_courses_note#</cfoutput></textarea></td>
	                				</tr>
	                				<tr>
	                					<td></td>
	                					<td><cfinput type="submit" name="updateGrdCourseReqNoteButton" value="Update notes"></td>
	                				</tr>
	                			</cfform>	
		                	</table>							
						</div>
	                	
	                	
	                	           	
	                	<!--------------------- Grad requirements by discipline---------------------------->		                	
	                	<h3>By Academic Discipline</h3>
	                	
	                	
	                	<cfif qEditGetGraduationCodekeys.RecordCount>	   	
							<div id="h4-box">
								<table>										
									<tr>
										<th width="47%">EvCC codekey</th>
										<th width="47%">Credit required</th>
										<th></th>
										<th></th>
									</tr>
								<cfloop query="qEditGetGraduationCodekeys">
									<cfform>
										<tr>
											<cfinput type="hidden" name="grdCodekeysId" value="#qEditGetGraduationCodekeys.id#">
											<td width="55%"><cfoutput>#qEditGetGraduationCodekeys.description#</cfoutput></td>
											<td width="35%"><cfoutput>#qEditGetGraduationCodekeys.credit#</cfoutput></td>
											<td width="10%"><cfinput type="submit" name="delGrdCodekeyReq" value="Remove"></td>
										</tr>
									</cfform>
								</cfloop>
								</table>							
							</div>
						</cfif>
	                	
	                	<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add New Discipline</h4></td>
								</tr>								

							
								<cfif messageBean.hasErrors() && isDefined("form.addGrdCodekeyReq")>
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
									<td><cfselect name="localGrdCodekey" query="qEditGetAllCodekeys" display="description" value="id" queryPosition="below" >
											<option value="0">Select a discipline</option>
										</cfselect>
									</td>
								</tr>
								<tr>
									<td>Credits required:</td>
										<td><cfinput type="text" id="codekeyGrdCredits" name="codekeyGrdCredits"></td>
								</tr>
								<tr>
									<td></td>
									<td><cfinput type="submit" name="addGrdCodekeyReq" value="Add discipline"></td>
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
                					<td><textarea name="grdCodekeyReqNote" rows="5" cols="50"><cfoutput>#qEditGetDegreeNotes.graduation_codekeys_note#</cfoutput></textarea></td>
                				</tr>
                				<tr>
                					<td></td>
                					<td><cfinput type="submit" name="updateGrdCodekeyReqNoteButton" value="Update notes"></td>
                				</tr>
                			</cfform>
                		</table>
	                	</div>

	                	<!---------------------General notes---------------------------->	
	                		                	
	                	<h2>General Notes</h2>
						<div id="h4-box">
							<table>
								<tr>
									<td colspan="2"><h4>Add Notes</h4></td>									
								</tr>	
								<cfform>
	                				<tr>
	                					<td width="125px">Notes:</td>
                						<td><textarea name="degreeGeneralNote" rows="5" cols="50"><cfoutput>#qEditGetDegreeNotes.general_note#</cfoutput></textarea></td>
	                				</tr>
	                				<tr>
	                					<td></td>
                					<td><cfinput type="submit" name="updateDegreeGeneralNoteButton" value="Update notes"></td>
	                				</tr>
	                			</cfform>
							</table>
						</div>	

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
	
<cfmodule template="../../../../../footer.cfm">