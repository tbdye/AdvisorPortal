<!--- Thomas Dye, July 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('ASP.cfc.errorBean').init()>

<!--- Define form action for "Select" button. --->
<cfif isDefined("form.addButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.courseNumber))>
		<cfset errorBean.addError('A course number is required.', 'courseNumber')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="../model/courses.cfm">
		<cfreturn>
	</cfif>

	<!--- Find the student, if exists --->
	<cfquery name="qGetCourse">
		SELECT
			id,
			course_number,
			title,
			min_credit,
			max_credit
		FROM
			COURSES
		WHERE
			use_catalog = 1
		AND
			course_number = <cfqueryparam value="#trim(form.courseNumber)#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<!--- Handle student ID search results. --->
	<cfif !qGetCourse.RecordCount>
		<cfset errorBean.addError('Course not found.', 'courseNumber')>
	</cfif>
	
	<cfinclude template="../model/courses.cfm">
	<cfreturn>

<!--- Add a course --->
<cfelseif isDefined("url.course") && isDefined("url.id") && IsNumeric("#URLDecode(url.id)#")>
	<!--- Validate the url variables to ensure the course exists --->
	<cfquery name="qCheckCourse">
		SELECT
			id,
			course_number,
			title,
			min_credit,
			max_credit
		FROM
			COURSES
		WHERE
			id = <cfqueryparam value="#URLDecode(url.id)#" cfsqltype="cf_sql_varchar">
		AND
			course_number = <cfqueryparam value="#URLDecode(url.course)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<!--- Stop here if the course is not valid. --->
	<cfif !qCheckCourse.RecordCount>
		<cfset errorBean.addError('There was an error adding this course; course cannot be added.', 'courseId')>
		<cfinclude template="../model/courses.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Determine if eligibility requirements exist before adding course --->
	<cfquery name="qGetPrerequisite">
		SELECT
			p.id,
			p.courses_id,
			p.group_id,
			p.courses_prerequisite_id,
			c.course_number
		FROM
			PREREQUISITES p
		JOIN
			COURSES c
		ON
			p.courses_prerequisite_id = c.id
		WHERE
			p.courses_id = <cfqueryparam value="#qCheckCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="qGetPermission">
		SELECT
			courses_id
		FROM
			PREREQUISITE_PERMISSIONS
		WHERE
			courses_id = <cfqueryparam value="#qCheckCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="qGetPlacement">
		SELECT
			courses_id,
			placement
		FROM
			PREREQUISITE_PLACEMENTS
		WHERE
			courses_id = <cfqueryparam value="#qCheckCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif isDefined("form.addButton")>
		<!--- Left off here --->
	</cfif>
	
	<cfinclude template="../model/courses.cfm">
	<cfreturn>

<!--- Display default landing page. --->
<cfelse>
	<cfinclude template="../model/courses.cfm">
	<cfreturn>
</cfif>