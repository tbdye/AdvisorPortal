<!--- View Degree Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm">
<!--- Todo:  Add button to create degree plan from here, show which courses are done/not done w/r/t completed courses --->	
	<pagetitle="Advisor Services Portal - View Degree">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1><cfoutput>#qViewGetDegree.degree_name#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <cfoutput>#qViewGetDegree.degree_name#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	            	<h2>Basic Details</h2>
	            	<table>
	            		<tr>
							<td>College:</td>
		    				<td><cfoutput><a href="../colleges/?college=#qViewGetDegree.colleges_id#" title="#qViewGetDegree.college_name# - #qViewGetDegree.college_city#">#qViewGetDegree.college_name# - #qViewGetDegree.college_city#</a></cfoutput></td>
						</tr>
	            		<tr>
							<td width="90px">Degree:</td>
							<td><cfoutput>#qViewGetDegree.degree_name#</cfoutput></td>
						</tr>
						<tr>
		            		<td>Department:</td>
							<td><cfoutput>#qViewGetDegree.department_name#</cfoutput></td>
						</tr>
						<tr>
							<td>Type:</td>
		    				<td><cfoutput>#qViewGetDegree.degree_type#</cfoutput></td>
						</tr>
						<tr>
							<cfform>
								<td></td>
								<td>
									<cfinput type="hidden" name="degreeId" value="#qViewGetDegree.id#">
									<cfinput type="hidden" name="degreeName" value="#qViewGetDegree.degree_name#">
									<cfinput type="submit" name="addDegreeButton" value="Create new plan with degree">
								</td>
							</cfform>
						</tr>
	            	</table>
	            	
	            	<cfif len(qViewGetDegreeNotes.admission_courses_note) || qViewGetAdmissionCourses.RecordCount>
	            		
	            		<h2>Admission Requirements by Course</h2>
	            		<table>
		            		<cfif len(qViewGetDegreeNotes.admission_courses_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="3"><cfoutput>#qViewGetDegreeNotes.admission_courses_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetAdmissionCourses.RecordCount>
		            			<tr>
									<th>CC Course</th>
									<th>Category</th>
									<th>Equivalent Course</th>
								</tr>
								<cfloop query="qViewGetAdmissionCourses">
									<tr>
										<td width="20%"><cfoutput><a href="../courses/?course=#URLEncodedFormat(qViewGetAdmissionCourses.id)#" title="#qViewGetAdmissionCourses.course_number#">#qViewGetAdmissionCourses.course_number#</a></cfoutput></td>
										<td width="50%"><cfoutput>#qViewGetAdmissionCourses.category#</cfoutput></td>
										<td width="30%"><cfoutput>#qViewGetAdmissionCourses.foreign_course_number#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
		            	</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.admission_categories_note) || qViewGetAdmissionCategories.RecordCount>
	            		
	            		<h2>Admission Requirements by Degree Category</h2>
	            		<table>
	            			<cfif len(qViewGetDegreeNotes.admission_categories_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetDegreeNotes.admission_categories_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetAdmissionCategories.RecordCount>
		            			<tr>
									<th>CC Category</th>
									<th>Credit Required</th>
								</tr>
								<cfloop query="qViewGetAdmissionCategories">
									<tr>
										<td width="55%"><cfoutput>#qViewGetAdmissionCategories.category#</cfoutput></td>
										<td width="35%"><cfoutput>#qViewGetAdmissionCategories.credit#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
	            		</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.graduation_courses_note) || qViewGetGraduationCourses.RecordCount>
	            		
	            		<h2>Optional Graduation Requirements by Course</h2>
	            		<table>
		            		<cfif len(qViewGetDegreeNotes.graduation_courses_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="3"><cfoutput>#qViewGetDegreeNotes.graduation_courses_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetGraduationCourses.RecordCount>
		            			<tr>
									<th>CC Course</th>
									<th>Equivalent Course</th>
								</tr>
								<cfloop query="qViewGetGraduationCourses">
									<tr>
										<td width="20%"><cfoutput><a href="../courses/?course=#URLEncodedFormat(qViewGetGraduationCourses.id)#" title="#qViewGetGraduationCourses.course_number#">#qViewGetGraduationCourses.course_number#</a></cfoutput></td>
										<td width="50%"><cfoutput>#qViewGetGraduationCourses.category#</cfoutput></td>
										<td width="30%"><cfoutput>#qViewGetGraduationCourses.foreign_course_number#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
		            	</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.graduation_categories_note) || qViewGetGraduationCategories.RecordCount>
	            		
	            		<h2>Optional Graduation Requirements by Degree Category</h2>
	            		<table>
	            			<cfif len(qViewGetDegreeNotes.graduation_categories_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetDegreeNotes.graduation_categories_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetGraduationCategories.RecordCount>
		            			<tr>
									<th>CC Codekey</th>
									<th>Credit Required</th>
								</tr>
								<cfloop query="qViewGetGraduationCategories">
									<tr>
										<td width="55%"><cfoutput>#qViewGetGraduationCategories.category#</cfoutput></td>
										<td width="35%"><cfoutput>#qViewGetGraduationCategories.credit#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
	            		</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.general_note)>
	            		
	            		<h2>Notes</h2>
	            		<table>
	            			<tr>
            					<td colspan="2"><cfoutput>#qViewGetDegreeNotes.general_note#</cfoutput></td>
            				</tr>
	            		</table>
	            	</cfif>
	            	
	            <p/>
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