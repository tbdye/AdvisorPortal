<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="index.cfm">
</cfif>

<cfquery name="qCoursesGetCourse">
	SELECT id, min_credit, max_credit
	FROM COURSES
	WHERE id = <cfqueryparam value="#URLDecode(url.id)#" cfsqltype="cf_sql_integer">
	AND course_number = <cfqueryparam value="#URLDecode(url.add)#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- ToDo:  verify form data --->
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
	
	<!--- Done --->
	<cflocation url="courses.cfm">
</cfif>