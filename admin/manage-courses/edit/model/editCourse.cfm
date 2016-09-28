<!--- Edit Course Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit Course">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit <cfoutput>#qEditGetCourse.course_number#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../">Home</a>
				&raquo; <a href="../">Manage Courses</a>
				&raquo; Edit Course - <cfoutput>#qEditGetCourse.course_number#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Course" class="rdf-meta element-hidden"></span>
	
	                <div class="content">

						<h2>Basic Details</h2>
				    	<table>
				    		<cfform>
						    	<cfif messageBean.hasErrors() && isDefined("form.updateCourseInfoButton")>
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
						    		<td width="125px"><label for="courseNumber">Number:</label></td>
						    		<td colspan="2"><cfinput type="text" id="courseNumber" name="courseNumber" value="#qEditGetCourse.course_number#"></td>
						    	</tr>
						    	<tr>
						    		<td><label for="courseTitle">Title:</label></td>
						    		<td colspan="2"><cfinput type="text" id="courseTitle" name="courseTitle" value="#qEditGetCourse.title#"></td>
						    	</tr>
						    	<tr>
						    		<td><label for="courseDepartment">Department:</label></td>
						    		<td colspan="2">
						    			<cfselect name="courseDepartment" query="qEditGetSelectDepartments" display="department_name" value="id" selected="#qEditGetCourse.departments_id#"></cfselect>
						    		</td>
						    	</tr>
						    	<cfif IsUserInRole("administrator")>
							    	<tr>
							    		<td>Availability:</td>
											<td>
												<cfinput type="radio" id="active" name="courseAvailability" value="1" checked="#status1#">
												<cfoutput><label for="active"> available</label></cfoutput> </br>
												<cfinput type="radio" id="inactive" name="courseAvailability" value="0" checked="#status2#">
												<cfoutput><label for="inactive"> hidden</label></cfoutput><br>
											</td>
							    	</tr>
						    	</cfif>
						    	<tr>
						    		<td>Credit:</td>
						    		<td>Min: <cfinput type="text" id="courseMinCredit" name="courseMinCredit" value="#qEditGetCourse.min_credit#"></td>
						    		<td>Max: <cfinput type="text" id="courseMaxCredit" name="courseMaxCredit" value="#qEditGetCourse.max_credit#"></td>
						    	</tr>
						    	<tr>
						    		<td></td>
						    		<td colspan="2"><cfinput type="submit" name="updateCourseInfoButton" value="Update details"></td>
						    	</tr>
				    		</cfform>
				    	</table>
				    	
						<!--------------------- course description ---------------------------->	
					
						<h3>Course Description</h3>
				    	<table>
				    		<cfform>
						    	<tr>
						    		<td><textarea name="courseDescription" rows="5" cols="70"><cfoutput>#qEditGetCourse.course_description#</cfoutput></textarea></td>
						    	</tr>
						    	<tr>
						    		<td><cfinput type="submit" name="updateCourseDescButton" value="Update description"></td>
						    	</tr>
						    </cfform>
				    	</table>
						
						
						<!--------------------- prerequisites ---------------------------->	
				    	<h3>Prerequisites</h3>
			    		
			    		<div id="h4-box">
			    			<table>
								<tr>
						    		<th width="45%">Grouping</th>
						    		<th width="45%">Course</th>
						    		<th></th>
					    		</tr>
					    		<cfloop query="qEditGetPrerequisites">
						    		<tr>
							    		<cfform>
								    		<td><cfoutput>#qEditGetPrerequisites.group_id#</cfoutput></td>
								    		<td><cfoutput>#qEditGetPrerequisites.course_number#</cfoutput></td>
								    		<td>
									    		<cfinput type="hidden" name="prerequisiteId" value="#qEditGetPrerequisites.id#">
									    		<cfinput type="submit" name="removePrerequisiteButton" value="Remove">
								    		</td>
							    		</cfform>
						    		</tr>
					    		</cfloop>			    				
			    			</table>
			    		</div>
			    		
			    		<div id="h4-box">
				    		<table>
				    			<tr>
									<td colspan="2"><h4>Add New Prerequisite</h4></td>
								</tr>
								<cfif messageBean.hasErrors() && isDefined("form.addPrerequisiteButton")>
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
						    			<td width="125px">Grouping: </td>
							    		<td>
							    			<cfselect name="groupId" query="qEditGetSelectGroups" display="group_id" value="group_id" queryPosition="above" >
												<option value="0">New group</option>
											</cfselect>
							    		</td>
							    	</tr>
							    	<tr>
							    		<td>Course: </td>
							    		<td><cfinput type="text" id="coursePrerequisite" name="coursePrerequisite"></td>
							    	</tr>
							    	<tr>
							    		<td></td>
							    		<td><cfinput type="submit" name="addPrerequisiteButton" value="Add prerequisite"></td>
						    		</cfform>
					    		</tr>
							</table>
			    		</div>
			    		</table>
			    		
			    		<!--------------------- placement scores ---------------------------->	
						<h3>Placement Scores</h3>
						<table>
							<cfform>
								<cfif messageBean.hasErrors() && isDefined("form.addPlacementButton")>
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
									<cfif qEditGetPlacement.RecordCount>
										<td width="125px"><cfoutput>#qEditGetPlacement.placement#</cfoutput></td>
										<td><cfinput type="submit" name="removePlacementButton" value="Remove"></td>
									<cfelse>
										<td width="125px">Score: </td>
										<td><cfinput type="text" id="coursePlacement" name="coursePlacement"></td>
										</tr>
										<tr>
										<td>
										<td><cfinput type="submit" name="addPlacementButton" value="Add score"></td>
									</cfif>
								</tr>
							</cfform>
						</table>
						
						<!--------------------- enrollment ---------------------------->	

						<h3>Enrollment</h3>
						<table>
							<cfform>
								<tr>
									<td>
										<cfinput type="checkbox" id="courseEnrollment" name="courseEnrollment" checked="#checked#">
										<label for="courseEnrollment">Allow enrollment by instructor permission</label>
									</td>
								</tr>
								<tr>
									<td><cfinput type="submit" name="updateEnrollmentButton" value="Update enrollment"></td>
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