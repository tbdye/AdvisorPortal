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
				<h1>Edit Plan</h1>
			</header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <a href="..">Degree Plans</a>
				&raquo; Edit Plan
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Plan" class="rdf-meta element-hidden"></span>
	
	                <div class="content">               	
						<h2>Edit details for "<cfoutput>#qEditGetPlan.plan_name#</cfoutput>"</h2>

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
		                			<td><label for="planName">Plan name:</label></td>
		                			<td><cfinput type="text" size="#len(qEditGetPlan.plan_name)#" id="planName" name="planName" value="#qEditGetPlan.plan_name#"> &nbsp; <cfinput type="submit" name="saveButton" value="Save"></td>			                			
		                		</tr>
		                	</cfform>
	                		<tr>
	                			<td>Degree:</td>
	                			<td>
	                				<cfoutput><a href="../degrees/?degree=#qEditGetPlan.degrees_id#" title="#qEditGetPlan.degree_name#">#qEditGetPlan.degree_name#</a></cfoutput><br>
	                				<cfoutput><a href="../colleges/?college=#qEditGetPlan.colleges_id#" title="#qEditGetPlan.college_name# - #qEditGetPlan.college_city#">#qEditGetPlan.college_name# - #qEditGetPlan.college_city#</a></cfoutput><br>
	                				<cfoutput>#qEditGetPlan.degree_type#</cfoutput>
	                			</td>
	                		</tr>

							<tr>
								<td colspan="2"><h3>Add a course to this degree plan by course number</h3></td>
							</tr>
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
									<td><label for="courseNumber">Course number:</label></td>
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
						
						<h3>Courses remaining for this plan</h3>
						<table>
							<tr>
								<td colspan="5"><h4>English Composition</h4></td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryC)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryC[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryC[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryC[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryC[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryC[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryC[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryC[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryC[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryC[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryC[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryC[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
							
							<tr>
								<td colspan="5">
									<hr>
									<h4>Writing and Additional Composition</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryW)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryW[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryW[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryW[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryW[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryW[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryW[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryW[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryW[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryW[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryW[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryW[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
						
							<tr>
								<td colspan="5">
									<hr>
									<h4>Quantitative and Symbolic Reasoning</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryQSR)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryQSR[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryQSR[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryQSR[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryQSR[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryQSR[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryQSR[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryQSR[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryQSR[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryQSR[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryQSR[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryQSR[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
							
							<tr>
								<td colspan="5">
									<hr>
									<h4>The Natural World</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryNW)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryNW[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryNW[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryNW[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryNW[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryNW[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryNW[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryNW[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryNW[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryNW[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryNW[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryNW[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
							
							<tr>
								<td colspan="5">
									<hr>
									<h4>Visual, Literary, and Performing Arts</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryVLPA)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryVLPA[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryVLPA[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryVLPA[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryVLPA[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryVLPA[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryVLPA[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryVLPA[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryVLPA[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryVLPA[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryVLPA[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryVLPA[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
							
							<tr>
								<td colspan="5">
									<hr>
									<h4>Individuals and Societies</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryIS)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryIS[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryIS[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryIS[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryIS[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryIS[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryIS[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryIS[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryIS[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryIS[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryIS[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryIS[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
							
							<tr>
								<td colspan="5">
									<hr>
									<h4>Diversity</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryDIV)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryDIV[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryDIV[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryDIV[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryDIV[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryDIV[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryDIV[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryDIV[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryDIV[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryDIV[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryDIV[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryDIV[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
							
							<tr>
								<td colspan="5">
									<hr>
									<h4>General Electives</h4>
								</td>
							</tr>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th>Status</th>
								<th></th>
							</tr>
							<cfloop from=1 to="#arrayLen(aCategoryE)#" index="Counter">
								<!--- Tag and display errors for courses using sc_id --->
								<cfif messageBean.hasErrors() && messageBean.getErrors()[1].field EQ aCategoryE[Counter][4]>
									<tr>
										<td colspan="5">
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
									<cfoutput>
                                    	<cfform>
                                    		<cfset displayUpdate=false>
	                                    	<!--- Display code --->
	                                    	<td>#aCategoryE[Counter][1]#</td>
											<!--- Display title --->
											<td>#aCategoryE[Counter][2]#</td>
											<td>
												<!--- If selected course credit was variable, cell is blank --->
												<cfif !len(aCategoryE[Counter][3])>
													<!--- The completed course id will exist if the student has completed this course --->
													<cfif len(aCategoryE[Counter][9])>
														<!--- Display credit information from the completed course --->
														#aCategoryE[Counter][10]#
													<!--- Otherwise, ask user to update information --->
													<cfelse>
														<cfinput type="text" id="courseCredit" name="courseCredit">
														<cfset displayUpdate=true>
													</cfif>
												<!--- The selected course credit was not variable --->
												<cfelse>
													<!--- Display credit --->
													#aCategoryE[Counter][3]#
												</cfif>
											</td>
											<td>
												<!--- The course number will exist if the student has completed or verified this course --->
												<cfif len(aCategoryE[Counter][9])>
													Complete
												<!--- The course number will exist if the course is an optional graduation requirement --->
												<cfelseif len(aCategoryE[Counter][8])>
													Optional
												</cfif>
											</td>
											<td>
												<!--- Display buttons --->
												<cfinput type="hidden" name="scId" value="#aCategoryE[Counter][4]#">
												<cfif displayUpdate>
													<cfinput type="hidden" name="courseId" value="#aCategoryE[Counter][5]#">
													<cfinput type="submit" name="updateCourseButton" value="Update">
												<cfelse>
													<cfinput type="submit" name="removeCourseButton" value="Remove">
												</cfif>
											</td>
										</cfform>
                                    </cfoutput>
								</tr>
							</cfloop>
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

	</div>

<cfmodule template="../../../footer.cfm">