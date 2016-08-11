<!--- Degrees Search Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<cfquery name="qGetAllDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	WHERE use_catalog = 1
	ORDER BY department_name
</cfquery>

<cfquery name="qGetPopularDepartments">
	SELECT d.id, d.department_name, r.rank
	FROM DEPARTMENTS d
	JOIN DEPARTMENT_RANKINGS r
	ON d.id = r.departments_id
	WHERE d.use_catalog = 1
	ORDER BY r.rank DESC
</cfquery>

<cfquery name="qGetAllColleges">
	SELECT id, college_name, college_city
	FROM COLLEGES
	WHERE use_catalog = 1
	ORDER BY college_name
</cfquery>

<cfquery name="qGetPopularColleges">
	SELECT c.id, c.college_name, c.college_city, r.rank
	FROM COLLEGES c
	JOIN COLLEGE_RANKINGS r
	ON c.id = r.colleges_id
	WHERE c.use_catalog = 1
	ORDER BY r.rank DESC
</cfquery>

<cfif isDefined("form.filterDepartmentsButton")>
	<cfif isDefined("form.filterDepartment")>
		<cfset session.aDepartments = ListToArray(form.filterDepartment)>
	<cfelse>
		<cfset StructDelete(session, "aDepartments")>
	</cfif>
	
	<!--- Refresh the page --->
	<cflocation url="">
</cfif>

<cfif isDefined("form.filterCollegesButton")>
	<cfif isDefined("form.filterCollege")>
		<cfset session.aColleges = ListToArray(form.filterCollege)>
	<cfelse>
		<cfset StructDelete(session, "aColleges")>
	</cfif>
	
	<!--- Refresh the page --->
	<cflocation url="">
</cfif>

<!--- Load page --->
<cfinclude template="model/degreeSearch.cfm">
<cfreturn>