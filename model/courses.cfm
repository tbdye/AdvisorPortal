<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
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
	
	<!--- The course was valid.  Verify student eligibility before adding the course. --->
	<cfif isDefined("qCoursesCheckCourse") && qCoursesCheckCourse.RecordCount>
		<cfif IsNumeric(qCoursesCheckCourse.min_credit) || qCoursesGetPrerequisite.RecordCount || qCoursesGetPermission.RecordCount || qCoursesGetPlacement.RecordCount>
			<h3>Verify course eligibility</h3>
			<h4><cfoutput>#qCoursesCheckCourse.course_number# - #qCoursesCheckCourse.title#</cfoutput></h4>
			
			<cfform>
				<!--- Determine student course credit for variable credit courses. --->
				<cfif IsNumeric(qCoursesCheckCourse.min_credit)>
					<label for="courseCredit">Credits taken <cfoutput>(#qCoursesCheckCourse.min_credit# - #qCoursesCheckCourse.max_credit#)</cfoutput>:</label>
					<cfinput type="text" id="courseCredit" name="courseCredit"><br>
				</cfif>

				<!--- Display prerequisite radio groups --->
				<cfif ArrayLen(aPrerequisites)>
					<p>Prerequisites:</p>
					<cfinput type="hidden" id="numOfPrereqGroups" name="numOfPrereqGroups" value="#ArrayLen(aPrerequisites)#">
				</cfif>
				
				<cfloop index="i" from=1 to=#ArrayLen(aPrerequisites)#>
					<cfinput type="radio" id="prereq#i#" name="prereq" value="#i#">
					<cfoutput><label for="prereq#i#">#aPrerequisites[i]#</label></cfoutput><br>
				</cfloop>

				<cfinput type="submit" name="verifyButton" value="Add course">
			</cfform>
		</cfif>
	
	<!--- After form is submitted, display results. --->
	<cfelseif isDefined("qCoursesGetCourse")>
		<table>
			<tr>
				<th>Course Number</th>
				<th>Title</th>
				<th>Credits</th>
				<th></th>
			</tr>
			<cfloop query="qCoursesGetCourse">
				<tr>
					<td><cfoutput>#qCoursesGetCourse.course_number#</cfoutput></td>
					<td><cfoutput>#qCoursesGetCourse.title#</cfoutput></td>
					<cfif !len(qCoursesGetCourse.min_credit)>
						<td><cfoutput>#qCoursesGetCourse.max_credit#</cfoutput></td>
					<cfelse>
						<td><cfoutput>#qCoursesGetCourse.min_credit# - #qCoursesGetCourse.max_credit#</cfoutput></td>
					</cfif>
					<td><cfoutput><a href="?add=#URLEncodedFormat(qCoursesGetCourse.course_number)#&id=#URLEncodedFormat(qCoursesGetCourse.id)#" title="Add">Add</a></cfoutput></td>
				</tr>
			</cfloop>
		</table>
	</cfif>
	
	<!--- Display an error if the user selection isn't a valid course. --->
	<cfif errorBean.hasErrors()>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>

	<!--- Display completed courses --->
	<h3>Completed courses</h3>
	<cfif qCoursesGetStudentCourses.RecordCount>
		<table>
			<tr>
				<th>Course Number</th>
				<th>Title</th>
				<th>Credits</th>
				<th></th>
			</tr>
			<cfloop query="qCoursesGetStudentCourses">
				<tr>
					<td><cfoutput>#qCoursesGetStudentCourses.course_number#</cfoutput></td>
					<td><cfoutput>#qCoursesGetStudentCourses.title#</cfoutput></td>
					<td><cfoutput>#qCoursesGetStudentCourses.credit#</cfoutput></td>
					<td><cfoutput><a href="?delete=#URLEncodedFormat(qCoursesGetStudentCourses.course_number)#&id=#URLEncodedFormat(qCoursesGetStudentCourses.completed_id)#" title="Delete">Delete</a></cfoutput></td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		<p>No completed courses added yet.</p>
	</cfif>

<cfmodule template="../includes/footer.cfm">