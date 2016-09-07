<!--- View Degree Model --->
<!--- Thomas Dye, August 2016 --->
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
				&raquo; <a href="..">Degree Plans</a>
				&raquo; <cfoutput>#qViewGetDegree.degree_name#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	            	<h2>Degree Basics</h2>
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
	            	</table>
	            	
	            	<cfif len(qViewGetDegreeNotes.admission_courses_note) || qViewGetAdmissionCourses.RecordCount>
	            		<hr>
	            		<h2>Admission Requirements by Course</h2>
	            		<table>
		            		<cfif len(qViewGetDegreeNotes.admission_courses_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetDegreeNotes.admission_courses_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetAdmissionCourses.RecordCount>
		            			<tr>
									<th>EvCC Course</th>
									<th>Equivalent Course</th>
								</tr>
								<cfloop query="qViewGetAdmissionCourses">
									<tr>
										<td width="55%"><cfoutput>#qViewGetAdmissionCourses.course_number#</cfoutput></td>
										<td width="35%"><cfoutput>#qViewGetAdmissionCourses.foreign_course_number#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
		            	</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.admission_codekeys_note) || qViewGetAdmissionCodekeys.RecordCount>
	            		<hr>
	            		<h2>Admission Requirements by Academic Discipline</h2>
	            		<table>
	            			<cfif len(qViewGetDegreeNotes.admission_codekeys_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetDegreeNotes.admission_codekeys_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetAdmissionCodekeys.RecordCount>
		            			<tr>
									<th>EvCC Codekey</th>
									<th>Credit Required</th>
								</tr>
								<cfloop query="qViewGetAdmissionCodekeys">
									<tr>
										<td width="55%"><cfoutput>#qViewGetAdmissionCodekeys.description#</cfoutput></td>
										<td width="35%"><cfoutput>#qViewGetAdmissionCodekeys.credit#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
	            		</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.graduation_courses_note) || qViewGetGraduationCourses.RecordCount>
	            		<hr>
	            		<h2>Optional Graduation Requirements by Course</h2>
	            		<table>
		            		<cfif len(qViewGetDegreeNotes.graduation_courses_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetDegreeNotes.graduation_courses_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetGraduationCourses.RecordCount>
		            			<tr>
									<th>EvCC Course</th>
									<th>Equivalent Course</th>
								</tr>
								<cfloop query="qViewGetGraduationCourses">
									<tr>
										<td width="55%"><cfoutput>#qViewGetGraduationCourses.course_number#</cfoutput></td>
										<td width="35%"><cfoutput>#qViewGetGraduationCourses.foreign_course_number#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
		            	</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.graduation_codekeys_note) || qViewGetGraduationCodekeys.RecordCount>
	            		<hr>
	            		<h2>Optional Graduation Requirements by Academic Discipline</h2>
	            		<table>
	            			<cfif len(qViewGetDegreeNotes.graduation_codekeys_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetDegreeNotes.graduation_codekeys_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetGraduationCodekeys.RecordCount>
		            			<tr>
									<th>EvCC Codekey</th>
									<th>Credit Required</th>
								</tr>
								<cfloop query="qViewGetGraduationCodekeys">
									<tr>
										<td width="55%"><cfoutput>#qViewGetGraduationCodekeys.description#</cfoutput></td>
										<td width="35%"><cfoutput>#qViewGetGraduationCodekeys.credit#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
	            		</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetDegreeNotes.general_note)>
	            		<hr>
	            		<h2>Degree Notes</h2>
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