<!--- Manage Courses Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Define form action for "Search" button. --->
<cfif isDefined("form.searchButton")>
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.searchTerm))>
		<cfset messageBean.addError('A course number is required.', 'courseNumber')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageCourses.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the course, if exists --->
	<cfquery name="qCoursesGetCourse">
		SELECT id, course_number, title, min_credit, max_credit, use_catalog
		FROM COURSES
		WHERE course_number LIKE <cfqueryparam value="#trim(form.searchTerm)#%" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<!--- Handle student ID search results. --->
	<cfif !qCoursesGetCourse.RecordCount>
		<cfset messageBean.addError('No results.', 'courseNumber')>
	</cfif>
</cfif>

<!--- Display page --->
<cfinclude template="model/manageCourses.cfm">
<cfreturn>