<!--- Thomas Dye, July 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('AdvisorPortal.cfc.errorBean').init()>

<!--- Always display courses completed by the student. --->
<cfquery name="qCoursesGetStudentCourses">
	SELECT c.course_number, c.title, s.id AS completed_id, s.credit
	FROM STUDENTS_COMPLETEDCOURSES s
	JOIN COURSES c
	ON c.id = s.courses_id
	WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Define form action for "Add" button. --->
<cfif isDefined("form.addButton")>
	<cfinclude template="courses/formAddButton.cfm">
</cfif>

<!--- Add course. --->	
<cfif isDefined("url.add") && isDefined("url.id") && IsNumeric("#URLDecode(url.id)#")>

	<!--- Add a course with eligibility requirements --->
	<cfif isDefined("form.verifyButton")>
		<cfinclude template="courses/formVerifyButton.cfm">
	</cfif>
	
	<!--- Validate the url variables to ensure the course exists --->
	<cfquery name="qCoursesCheckCourse">
		SELECT id, course_number, title, min_credit, max_credit
		FROM COURSES
		WHERE id = <cfqueryparam value="#URLDecode(url.id)#" cfsqltype="cf_sql_integer">
		AND course_number = <cfqueryparam value="#URLDecode(url.add)#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<!--- Stop here if the course is not valid. --->
	<cfif !qCoursesCheckCourse.RecordCount>
		<cfset errorBean.addError('There was an error adding this course; course cannot be added.', 'courseId')>
		<cfinclude template="model/courses.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Before adding the course, determine eligibility requirements exist.
		  Build a UI element to display areas requiring user input or verification.
		  First, collect relevant information from the database. --->
	<cfquery name="qCoursesGetPrerequisite">
		SELECT p.id, p.courses_id, p.group_id, p.courses_prerequisite_id, c.course_number
		FROM PREREQUISITES p
		JOIN COURSES c
		ON p.courses_prerequisite_id = c.id
		WHERE p.courses_id = <cfqueryparam value="#qCoursesCheckCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="qCoursesGetPermission">
		SELECT courses_id
		FROM PREREQUISITE_PERMISSIONS
		WHERE courses_id = <cfqueryparam value="#qCoursesCheckCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="qCoursesGetPlacement">
		SELECT courses_id, placement
		FROM PREREQUISITE_PLACEMENTS
		WHERE courses_id = <cfqueryparam value="#qCoursesCheckCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Build dynamic content for radio labels here as strings to be displayed in the UI. --->
	<cfset aPrerequisites = arrayNew(1)>
	
	<!--- Format prerequisite class groups --->
	<cfif qCoursesGetPrerequisite.RecordCount>
		<cfset group=qCoursesGetPrerequisite.group_id>
		<cfset firstInGroup="true">
		
		<!--- Display individual course groups --->
		<cfloop query="qCoursesGetPrerequisite">
			<cfif group EQ qCoursesGetPrerequisite.group_id>
				
				<!--- add from the same group --->
				<cfif firstInGroup EQ 'true'>
					<cfset classes=qCoursesGetPrerequisite.course_number>
					<cfset firstInGroup="false">
				<cfelse>
					<cfset classes=classes & " and " & qCoursesGetPrerequisite.course_number>
				</cfif>
			<cfelse>
			
				<!--- the group changed, so end the string --->
				<cfset classes=classes & " with a grade of C or higher">
				<cfset ArrayAppend(aPrerequisites, classes)>
				
				<!--- begin the next string --->
				<cfset group=qCoursesGetPrerequisite.group_id>
				<cfset classes=qCoursesGetPrerequisite.course_number>
			</cfif>	
		</cfloop>
		<cfset classes=classes & " with a grade of C or higher">
		<cfset ArrayAppend(aPrerequisites, classes)>
		
		<!--- Display instructor permission option --->
		<cfif qCoursesGetPermission.RecordCount>
			<cfset ArrayAppend(aPrerequisites, "Instructor permission")>
		</cfif>
		
		<!--- Display placement exam option --->
		<cfif qCoursesGetPlacement.RecordCount>
			<cfset ArrayAppend(aPrerequisites, "Placement into <cfoutput>#qCoursesCheckCourse.course_number#</cfoutput> by assessment.")>
		</cfif>
		
		<!--- Stop here to get input --->
		<cfinclude template="model/courses.cfm">
		<cfreturn>
	
	<!--- The course just has variable credit --->
	<cfelseif IsNumeric(qCoursesCheckCourse.min_credit)>
		<!--- Stop here to get input --->
		<cfinclude template="model/courses.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Add course to student for when no eligibility check is necessary. --->
	<cfquery>
		INSERT INTO	STUDENTS_COMPLETEDCOURSES (
			students_accounts_id, courses_id, credit)
		VALUES (
			<cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qCoursesCheckCourse.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qCoursesCheckCourse.max_credit#" cfsqltype="cf_sql_decimal">)
	</cfquery>
	
	<!--- Done, reset page. --->
	<cflocation url="courses.cfm">
</cfif>

<!--- Delete course. --->
<cfif isDefined("url.delete") && isDefined("url.id") && IsNumeric("#URLDecode(url.id)#")>
	
	<!--- Validate the url variables to ensure the course exists in the student's record. --->
	<cfquery name="qCoursesCheckCourse">
		SELECT s.id
		FROM STUDENTS_COMPLETEDCOURSES s
		JOIN COURSES c
		ON c.id = s.courses_id
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
		AND c.course_number = <cfqueryparam value="#URLDecode(url.delete)#" cfsqltype="cf_sql_varchar">
		AND s.id = <cfqueryparam value="#URLDecode(url.id)#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Stop here if the course is not valid. --->
	<cfif !qCoursesCheckCourse.RecordCount>
		<cfset errorBean.addError('There was an error deleting this course; course cannot be deleted.', 'courseId')>
		<cfinclude template="model/courses.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Delete the course from the student record --->
	<cfquery>
		DELETE
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE id = <cfqueryparam value="#qCoursesCheckCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cflocation url="courses.cfm">
</cfif>

<!--- Always display student's courses from qCoursesGetStudentCourses --->
<cfinclude template="model/courses.cfm">
<cfreturn>