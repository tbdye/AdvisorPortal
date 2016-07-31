<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../home/courses.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Completed courses">
	
	<!--- Alter page header depending if in an adivisng session or not. --->
	<cfif IsUserInRole("advisor")>
		<h2>Completed courses for <cfoutput>#session.studentName#</cfoutput></h2>
	<cfelse>
		<h2>Completed courses</h2>
	</cfif>
	
	<p>Provide some instructions on how the completed courses section works and initial steps to get started using the Advisor Services Portal.</p>

	<!--- Add completed course UI textbox form. --->
	<h3>Add completed course</h3>
	<cfform>
		<cfinput type="text" id="courseNumber" name="courseNumber">
		<cfinput type="submit" name="addButton" value="Add">
	</cfform>
	
	<a href="https://www.everettcc.edu/catalog/" title="Look up course code" target="_blank">Look up course code</a>
	
	<!--- Display any validation errors under form. --->
	<cfif errorBean.hasErrors() && isDefined("form.addButton")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	
	<!--- After form is submitted, display results. --->
	<cfelseif isDefined("qGetCourse")>
		<table>
			<tr>
				<th>Course Number</th>
				<th>Title</th>
				<th>Credits</th>
				<th></th>
			</tr>
			<cfloop query="qGetCourse">
				<tr>
					<td><cfoutput>#qGetCourse.course_number#</cfoutput></td>
					<td><cfoutput>#qGetCourse.title#</cfoutput></td>
					<cfif !len(qGetCourse.min_credit)>
						<td><cfoutput>#qGetCourse.max_credit#</cfoutput></td>
					<cfelse>
						<td><cfoutput>#qGetCourse.min_credit# - #qGetCourse.max_credit#</cfoutput></td>
					</cfif>
					<td><cfoutput><a href="?add=#URLEncodedFormat(qGetCourse.course_number)#&id=#URLEncodedFormat(qGetCourse.id)#" title="Add">Add</a></cfoutput></td>
				</tr>
			</cfloop>
		</table>
	</cfif>
	
	<!--- Display an error if the user selection isn't a valid course. --->
	<cfif errorBean.hasErrors() && isDefined("qCheckCourse")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	
	<!--- The course was valid.  Verify student eligibility before adding the course. --->
	<cfelseif isDefined("qCheckCourse") && qCheckCourse.RecordCount>
		<cfif IsNumeric(qCheckCourse.min_credit) || qGetPrerequisite.RecordCount || qGetPermission.RecordCount || qGetPlacement.RecordCount>
			<h3>Verify course eligibility</h3>
			<h4><cfoutput>#qCheckCourse.course_number# - #qCheckCourse.title#</cfoutput></h4>
			
			<cfform>
				<!--- Determine student course credit for variable credit courses. --->
				<cfif IsNumeric(qCheckCourse.min_credit)>
					<label for="courseCredit">Credits taken <cfoutput>(#qCheckCourse.min_credit# - #qCheckCourse.max_credit#)</cfoutput>:</label>
					<cfinput type="text" id="courseCredit" name="courseCredit"><br>
				</cfif>

				<!--- Display prerequisite radio groups --->
				<cfif ArrayLen(aPrerequisites)>
					<p>Prerequisites:</p>
				</cfif>
				
				<cfloop index="i" from=1 to=#ArrayLen(aPrerequisites)#>
					<cfinput type="radio" id="prereq#i#" name="prereq#i#" value="prereq#i#">
					<cfoutput><label for="prereq#i#">#aPrerequisites[i]#</label></cfoutput><br>
				</cfloop>

				<cfinput type="submit" name="verifyButton" value="Add course">
			</cfform>
		</cfif>
	</cfif>

	<!--- Display completed courses --->
	<h3>Completed courses</h3>
	<cfif qGetStudentCourses.RecordCount>
		<table>
			<tr>
				<th>Course Number</th>
				<th>Title</th>
				<th>Credits</th>
				<th></th>
			</tr>
			<cfloop query="qGetStudentCourses">
				<tr>
					<td><cfoutput>#qGetStudentCourses.course_number#</cfoutput></td>
					<td><cfoutput>#qGetStudentCourses.title#</cfoutput></td>
					<td><cfoutput>#qGetStudentCourses.credit#</cfoutput></td>
					<td><cfoutput><a href="?delete=#URLEncodedFormat(qGetStudentCourses.course_number)#&id=#URLEncodedFormat(qGetStudentCourses.completed_id)#" title="Delete">Delete</a></cfoutput></td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		<p>No completed courses added yet.</p>
	</cfif>

<cfmodule template="../includes/footer.cfm">