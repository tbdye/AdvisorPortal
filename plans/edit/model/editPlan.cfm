<!--- Edit Plan Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit Plan">

	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>Edit Plan - "<cfoutput>#qEditGetPlan.plan_name#</cfoutput>"</h1>
			</header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <a href="..">Degree Plans</a>
				&raquo; Edit Plan - "<cfoutput>#qEditGetPlan.plan_name#</cfoutput>"
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Plan" class="rdf-meta element-hidden"></span>
	
					
	                <div class="content">               	
						<h2>Basic Details</h2>

						<table>
							<cfif messageBean.hasErrors() && isDefined("form.saveButton")>
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
	                			<td>Degree:</td>
	                			<td>
	                				<cfoutput><a href="../../view/degrees/?degree=#qEditGetPlan.degrees_id#" title="#qEditGetPlan.degree_name#">#qEditGetPlan.degree_name#</a></cfoutput><br>
	                				<cfoutput><a href="../../view/colleges/?college=#qEditGetPlan.colleges_id#" title="#qEditGetPlan.college_name# - #qEditGetPlan.college_city#">#qEditGetPlan.college_name# - #qEditGetPlan.college_city#</a></cfoutput><br>
	                				<cfoutput>#qEditGetPlan.degree_type#</cfoutput>
	                			</td>
	                		</tr>
	                		<tr>
		                			<td width="125px"><label for="planName">Plan name:</label></td>
		                			<td><cfinput type="text" id="planName" name="planName" value="#qEditGetPlan.plan_name#"></td>			                			
		                		</tr>
	                		<tr>
	                			<td></td>
	                			<td><cfinput type="submit" name="saveButton" value="Save"></td>
	                		</tr>
		                	</cfform>
						</table>
						
						
						<h2>Courses Remaining for Plan</h2>
						<h3>Add a Course to Plan</h3>

						<table>
							<cfif messageBean.hasErrors() && isDefined("form.addCourseButton")>
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
									<td width="125px"><label for="courseNumber">Course number:</label></td>
									<td><cfinput width="275px" type="text" id="courseNumber" name="courseNumber"></td>
								</tr>
								<tr>
									<td><label for="category">Category:</label></td>
									<td>
										<cfselect name="category" query="qEditGetSelectCategories" display="description" value="id" queryPosition="below" >
											<option value="0">Select a category</option>
										</cfselect>
									</td>
								</tr>
								<tr>
									<td></td>
									<td><cfinput type="submit" name="addCourseButton" value="Add"></td>
								</tr>
							</cfform>
							<tr>
								<td></td>
								<td>
									<a href="https://www.everettcc.edu/catalog/" title="View official course catalog" target="_blank">View official course catalog</a>
								</td>
							</tr>
						</table>
						
						<hr/>
						
						<h3>English Composition</h3>
						
						<div id = "h4-box">
						<table>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryC)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryC[Counter][5])#" title="#aCategoryC[Counter][1]#">#aCategoryC[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryC[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryC[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryC[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryC[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryC[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryC[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryC[Counter][12]) - Val(aCategoryC[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryC[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesC.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryC[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesC" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryC[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryC[Counter][9])>
													Complete
												<cfelseif len(aCategoryC[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryC[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryC)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
							</cfform>
						</table>
						</div>
						
						<h3>Writing and Additional Composition</h3>
						<div id = "h4-box">						
						<table>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryW)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryW[Counter][5])#" title="#aCategoryW[Counter][1]#">#aCategoryW[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryW[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryW[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryW[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryW[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryW[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryW[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryW[Counter][12]) - Val(aCategoryW[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryW[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesW.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryW[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesW" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryW[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryW[Counter][9])>
													Complete
												<cfelseif len(aCategoryW[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryW[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryW)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
							</cfform>
						</table>
						</div>
						
						<h3>Quantitative and Symbolic Reasoning</h3>
						<div id = "h4-box">
						<table>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryQSR)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryQSR[Counter][5])#" title="#aCategoryQSR[Counter][1]#">#aCategoryQSR[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryQSR[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryQSR[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryQSR[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryQSR[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryQSR[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryQSR[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryQSR[Counter][12]) - Val(aCategoryQSR[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryQSR[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesQSR.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryQSR[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesQSR" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryQSR[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryQSR[Counter][9])>
													Complete
												<cfelseif len(aCategoryQSR[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryQSR[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryQSR)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
							</cfform>
						</table>
						</div>
						
						<h3>The Natural World</h3>
						<div id = "h4-box">
						<table>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryNW)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryNW[Counter][5])#" title="#aCategoryNW[Counter][1]#">#aCategoryNW[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryNW[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryNW[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryNW[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryNW[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryNW[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryNW[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryNW[Counter][12]) - Val(aCategoryNW[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryNW[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesNW.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryNW[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesNW" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryNW[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryNW[Counter][9])>
													Complete
												<cfelseif len(aCategoryNW[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryNW[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryNW)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
							</cfform>
						</table>
						</div>
							
						<h3>Visual, Literary, and Performing Arts</h3>
						<div id = "h4-box">
						<table>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryVLPA)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryVLPA[Counter][5])#" title="#aCategoryVLPA[Counter][1]#">#aCategoryVLPA[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryVLPA[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryVLPA[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryVLPA[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryVLPA[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryVLPA[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryVLPA[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryVLPA[Counter][12]) - Val(aCategoryVLPA[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryVLPA[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesVLPA.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryVLPA[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesVLPA" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryVLPA[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryVLPA[Counter][9])>
													Complete
												<cfelseif len(aCategoryVLPA[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryVLPA[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryVLPA)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
							</cfform>
						</table>
						</div>
						
						<h3>Individuals and Societies</h3>
						<div id = "h4-box">
						<table>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryIS)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryIS[Counter][5])#" title="#aCategoryIS[Counter][1]#">#aCategoryIS[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryIS[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryIS[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryIS[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryIS[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryIS[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryIS[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryIS[Counter][12]) - Val(aCategoryIS[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryIS[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesIS.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryIS[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesIS" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryIS[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryIS[Counter][9])>
													Complete
												<cfelseif len(aCategoryIS[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryIS[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryIS)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
							</cfform>
						</table>
						</div>
						
						<h3>Diversity</h3>
						<div id = "h4-box">
						<table>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryDIV)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryDIV[Counter][5])#" title="#aCategoryDIV[Counter][1]#">#aCategoryDIV[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryDIV[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryDIV[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryDIV[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryDIV[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryDIV[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryDIV[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryDIV[Counter][12]) - Val(aCategoryDIV[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryDIV[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesDIV.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryDIV[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesDIV" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryDIV[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryDIV[Counter][9])>
													Complete
												<cfelseif len(aCategoryDIV[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryDIV[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryDIV)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
							</cfform>
						</table>
						</div>
						
						<h3>General Electives</h3>
						<div id = "h4-box">
						<table>
							<tr>
								<td colspan="5">
									<!--- Evaluate required department credits --->
									<cfif qEditGetDepartmentCreditsE.RecordCount>
										<!--- Evaluate for each department specified --->
										<cfloop query="qEditGetDepartmentCreditsE">
											<cfset creditsRemaining = qEditGetDepartmentCreditsE.credit>
											<cfloop from=1 to="#arrayLen(aCategoryE)#" index="Counter">
												<!--- Match department --->
												<cfif creditsRemaining GT 0 && qEditGetDepartmentCreditsE.id EQ aCategoryE[Counter][6]>
													<cfif IsNumeric(aCategoryE[Counter][10])>
														<!--- Subtract department credits from matching completed course credits --->
														<cfset creditsRemaining = creditsRemaining - aCategoryE[Counter][10]>
													<cfelseif IsNumeric(aCategoryE[Counter][3])>
														<!--- Subtract department credits from matching course credits --->
														<cfset creditsRemaining = creditsRemaining - aCategoryE[Counter][3]>
													</cfif>
												</cfif>
											</cfloop>
											<cfif creditsRemaining GT 0>
												(You need <cfoutput>#creditsRemaining#</cfoutput> more credits in <cfoutput>#qEditGetDepartmentCreditsE.department_name#</cfoutput>)<br>
											</cfif>
										</cfloop>
									</cfif>
								</td>
							</tr>
							<tr>
								<th width="20%">Code</th>
								<th>Title</th>
								<th width="15%">Credits</th>
								<th width="20%">Status</th>
								<th width="10%">Remove</th>
							</tr>
							<cfform>
								<cfloop from=1 to="#arrayLen(aCategoryE)#" index="Counter">
									<tr>
										<cfoutput>
	                                    	<!--- Display code --->
	                                    	<td><a href="../../view/courses/?course=#URLEncodedFormat(aCategoryE[Counter][5])#" title="#aCategoryE[Counter][1]#">#aCategoryE[Counter][1]#</a></td>
											<!--- Display title --->
											<td>#aCategoryE[Counter][2]#</td>
											<td>
												<!--- Check to see if this course is marked as completed --->
												<cfif len(aCategoryE[Counter][9])>
													<!--- Display the completed course credits by default --->
													#aCategoryE[Counter][10]#
												<!--- If selected course credit was variable, cell is blank --->
												<cfelseif !len(aCategoryE[Counter][3])>
													<cfinput type="hidden" name="creditId" value="#aCategoryE[Counter][4]#">
													<!--- Use a selector box to choose the variable credits --->
													<cfselect name="courseCredit">
														<option value="0">
															Choose
														</option>
														<!--- Set the minimum credit --->
														<cfset credit=Val(aCategoryE[Counter][11])>
														<!--- Display the available range of credits as integers --->
														<cfloop from=1 to="#Val(aCategoryE[Counter][12]) - Val(aCategoryE[Counter][11]) + 1#" index="i">
															<option value="#credit#">
																#credit#
															</option>
															<cfset credit=credit + 1>
														</cfloop>
													</cfselect>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryE[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif qEditGetSelectCoursesE.RecordCount>
													<cfinput type="hidden" name="statusId" value="#aCategoryE[Counter][4]#">
													<!--- Use a selector box to map the filtered available completed courses --->
													<cfselect name="status" query="qEditGetSelectCoursesE" display="course_number" value="id" queryPosition="below">
														<option value="0">
															<cfif len(aCategoryE[Counter][9])>
																Completed
															<cfelse>
																Select course
															</cfif>
														</option>
													</cfselect>
												<!--- Display by default when no unmapped courses are available --->
												<cfelseif len(aCategoryE[Counter][9])>
													Complete
												<cfelseif len(aCategoryE[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display remove checkboxes --->
												<cfinput type="checkbox" name="remove" value="#aCategoryE[Counter][4]#">
											</td>
	                                    </cfoutput>
									</tr>
								</cfloop>
								<cfif arrayLen(aCategoryE)>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td><cfinput type="submit" name="updateCourseButton" value="Update"></td>
									</tr>
								</cfif>
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

	</div>

<cfmodule template="../../../footer.cfm">