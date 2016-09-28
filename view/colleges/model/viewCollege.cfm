<!--- View Degree Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm">
	
	<pagetitle="Advisor Services Portal - View College">

	<!--- Alter page header depending if in an adivisng session or not. --->
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1><cfoutput>#qViewGetCollege.college_name#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <cfoutput>#qViewGetCollege.college_name#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	            	<h2>Basic Details</h2>
	            	<table>
	            		<tr>
							<td width="90px">Name:</td>
							<td><cfoutput>#qViewGetCollege.college_name#</cfoutput></td>
						</tr>
						<tr>
		            		<td>City:</td>
							<td><cfoutput>#qViewGetCollege.college_city#</cfoutput></td>
						</tr>
						<tr>
							<td>Website:</td>
		    				<td><cfoutput><a href="#qViewGetCollege.college_website#" target="_blank">#qViewGetCollege.college_website#</a></cfoutput></td>
						</tr>
	            	</table>
	            	
	            	<cfif len(qViewGetCollegeNotes.courses_note) || qViewGetAdmissionCourses.RecordCount>
	            		
	            		<h2>Admission Requirements by Course</h2>
	            		<table>
		            		<cfif len(qViewGetCollegeNotes.courses_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="3"><cfoutput>#qViewGetCollegeNotes.courses_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetAdmissionCourses.RecordCount>
		            			<tr>
									<th width="33%">EvCC Course</th>
									<th width="33%">Category</th>
									<th width="33%">Equivalent Course</th>
								</tr>
								<cfloop query="qViewGetAdmissionCourses">
									<tr>
										<td><cfoutput><a href="../courses/?course=#URLEncodedFormat(qViewGetAdmissionCourses.id)#" title="#qViewGetAdmissionCourses.course_number#">#qViewGetAdmissionCourses.course_number#</a></cfoutput></td>
										<td><cfoutput>#qViewGetAdmissionCourses.category# (#qViewGetAdmissionCourses.description#)</cfoutput></td>
										<td><cfoutput>#qViewGetAdmissionCourses.foreign_course_number#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
		            	</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetCollegeNotes.departments_note) || qViewGetAdmissionDepartments.RecordCount>
	            	
	            		<h2>Admission Requirements by Department</h2>
	            		<table>
	            			<cfif len(qViewGetCollegeNotes.departments_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetCollegeNotes.departments_note#</cfoutput></td>
		            			</tr>
		            		</cfif>
		            		<cfif qViewGetAdmissionDepartments.RecordCount>
		            			<tr>
									<th width="66%">EvCC Department</th>
									<th width="33%">Credit Required</th>
								</tr>
								<cfloop query="qViewGetAdmissionDepartments">
									<tr>
										<td><cfoutput>#qViewGetAdmissionDepartments.department_name#</cfoutput></td>
										<td><cfoutput>#qViewGetAdmissionDepartments.credit#</cfoutput></td>
									</tr>
								</cfloop>
		            		</cfif>
	            		</table>
	            	</cfif>
	            	
	            	<cfif len(qViewGetCollegeNotes.codekeys_note) || qViewGetAdmissionCodekeys.RecordCount>
	            		
	            		<h2>Admission Requirements by Academic Discipline</h2>
	            		<table>
	            			<cfif len(qViewGetCollegeNotes.codekeys_note)>
		            			<tr>
		            				<!--- ToDo:  convert this to preformatted text --->
		            				<td colspan="2"><cfoutput>#qViewGetCollegeNotes.codekeys_note#</cfoutput></td>
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