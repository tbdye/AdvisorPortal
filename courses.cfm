<!--- Thomas Dye, August 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<!--- Define form action for "Search" button. --->
<cfif isDefined("form.searchButton")>
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.searchTerm))>
		<cfset errorBean.addError('A course number is required.', 'courseNumber')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/courses.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the course, if exists --->
	<cfquery name="qCoursesGetCourse">
		SELECT id, course_number, title, min_credit, max_credit
		FROM COURSES
		WHERE use_catalog = 1
		AND course_number LIKE <cfqueryparam value="#trim(form.searchTerm)#%" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<!--- Handle student ID search results. --->
	<cfif !qCoursesGetCourse.RecordCount>
		<cfset errorBean.addError('No results.', 'courseNumber')>
	</cfif>
	
	<cfinclude template="model/courses.cfm">
	<cfreturn>
</cfif>

<!--- Add course. --->	
<cfif isDefined("url.add") && isDefined("url.id") && IsNumeric("#URLDecode(url.id)#")>

	<!--- Add a course with eligibility requirements --->
	<cfif isDefined("form.addCourseButton")>
		<cfquery name="qCoursesGetCourse">
			SELECT id, min_credit, max_credit
			FROM COURSES
			WHERE id = <cfqueryparam value="#URLDecode(url.id)#" cfsqltype="cf_sql_integer">
			AND course_number = <cfqueryparam value="#URLDecode(url.add)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- Validate form data --->
		<cfif isDefined("form.courseCredit")>
			<cfif !len(trim(form.courseCredit))>
				<cfset errorBean.addError('The course credit field cannot be left blank.', 'courseCredit')>
			<cfelseif !IsNumeric("#trim(form.courseCredit)#")>
				<cfset errorBean.addError('Credits must be entered in as a decimal number.', 'courseCredit')>
			<cfelseif trim(form.courseCredit) LT qCoursesGetCourse.min_credit || trim(form.courseCredit) GT qCoursesGetCourse.max_credit>
				<cfset errorBean.addError('Credit must be between #qCoursesGetCourse.min_credit# and #qCoursesGetCourse.max_credit#.', 'courseCredit')>
			</cfif>
		</cfif>
		<cfif isDefined("numOfPrereqGroups")>
			<cfif numOfPrereqGroups && !isDefined("prereq")>
				<cfset errorBean.addError('A prerequisite option must be selected.', 'prereq')>
			</cfif>
		</cfif>
		
		<!--- Add course --->
		<cfif !errorBean.HasErrors()>
			<cfset credit="">
		
			<cfif isDefined("form.courseCredit")>
				<cfset credit="#form.courseCredit#">
			<cfelse>
				<cfset credit="#qCoursesGetCourse.max_credit#">
			</cfif>
		
			<!--- Add course to student for when eligibility check was necessary. --->
			<cfquery>
				INSERT INTO	STUDENTS_COMPLETEDCOURSES (
					students_accounts_id, courses_id, credit)
				VALUES (
					<cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#qCoursesGetCourse.id#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#credit#" cfsqltype="cf_sql_decimal">)
			</cfquery>
			
			<!--- Done, reset page --->
			<cflocation url="courses.cfm">
		</cfif>
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

<!--- Display courses completed by the student. --->
<cfquery name="qCoursesGetStudentCourses">
	SELECT c.course_number, c.title, s.id AS completed_id, s.credit
	FROM STUDENTS_COMPLETEDCOURSES s
	JOIN COURSES c
	ON c.id = s.courses_id
	WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfinclude template="model/courses.cfm">
<cfreturn>