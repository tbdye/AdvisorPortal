<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="index.cfm">
</cfif>

<!--- Perform simple validation on form fields --->
<cfif !len(trim(form.courseNumber))>
	<cfset errorBean.addError('A course number is required.', 'courseNumber')>
</cfif>

<!--- Stop here if errors were detected --->
<cfif errorBean.hasErrors()>
	<cfinclude template="../model/courses.cfm">
	<cfreturn>
</cfif>

<!--- Find the course, if exists --->
<cfquery name="qCoursesGetCourse">
	SELECT id, course_number, title, min_credit, max_credit
	FROM COURSES
	WHERE use_catalog = 1
	AND course_number = <cfqueryparam value="#trim(form.courseNumber)#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- Handle student ID search results. --->
<cfif !qCoursesGetCourse.RecordCount>
	<cfset errorBean.addError('Course not found.', 'courseNumber')>
</cfif>

<cfinclude template="../model/courses.cfm">
<cfreturn>