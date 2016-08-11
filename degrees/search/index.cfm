<!--- Degrees Search Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<cfquery name="qSearchGetAllColleges">
	SELECT id, college_name, college_city
	FROM COLLEGES
	WHERE use_catalog = 1
	ORDER BY college_name
</cfquery>

<cfquery name="qSearchGetPopularColleges">
	SELECT c.id, c.college_name, c.college_city, r.rank
	FROM COLLEGES c
	JOIN COLLEGE_RANKINGS r
	ON c.id = r.colleges_id
	WHERE c.use_catalog = 1
	ORDER BY r.rank DESC
</cfquery>

<cfquery name="qSearchGetAllDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	WHERE use_catalog = 1
	ORDER BY department_name
</cfquery>

<cfquery name="qSearchGetPopularDepartments">
	SELECT d.id, d.department_name, r.rank
	FROM DEPARTMENTS d
	JOIN DEPARTMENT_RANKINGS r
	ON d.id = r.departments_id
	WHERE d.use_catalog = 1
	ORDER BY r.rank DESC
</cfquery>

<cfif isDefined("form.filterCollegesButton")>
	<cfif isDefined("form.filterCollege")>
		<cfset session.aColleges = ListToArray(form.filterCollege)>
	<cfelse>
		<cfset StructDelete(session, "aColleges")>
	</cfif>
	
	<!--- Refresh the page --->
	<cflocation url="">
</cfif>

<cfif isDefined("form.filterDepartmentsButton")>
	<cfif isDefined("form.filterDepartment")>
		<cfset session.aDepartments = ListToArray(form.filterDepartment)>
	<cfelse>
		<cfset StructDelete(session, "aDepartments")>
	</cfif>
	
	<!--- Refresh the page --->
	<cflocation url="">
</cfif>

<cfquery name="qSearchGetFilteredDegrees">
	SELECT d.id, d.degree_name, d.degree_type, c.college_name, c.college_city
	FROM DEGREES d
	JOIN COLLEGES c
	ON d.colleges_id = c.id
	FULL JOIN DEGREE_RANKINGS r ON d.id = r.degrees_id
	WHERE d.use_catalog = 1
	AND c.use_catalog = 1
	<cfif isDefined("session.aDepartments")>
		AND departments_id IN (SELECT departments_id FROM DEGREES WHERE
		<cfloop from="1" to="#arrayLen(session.aDepartments)#" index="i">
			<cfif #i# EQ 1>
				departments_id = #session.aDepartments[i]#
			<cfelse>
				OR departments_id = #session.aDepartments[i]#
			</cfif>
		</cfloop>
		)
	</cfif>
	<cfif isDefined("session.aColleges")>
		AND colleges_id IN (SELECT colleges_id FROM DEGREES WHERE
		<cfloop from="1" to="#arrayLen(session.aColleges)#" index="i">
			<cfif #i# EQ 1>
				 colleges_id = #session.aColleges[i]#
			<cfelse>
				OR colleges_id = #session.aColleges[i]#
			</cfif>
		</cfloop>
		)
	</cfif>
	<cfif isDefined("form.searchButton")>
		AND d.degree_name LIKE <cfqueryparam value="%#trim(form.searchTerm)#%" cfsqltype="cf_sql_varchar">
	</cfif>
	ORDER BY r.rank DESC
</cfquery>

<!--- Load page --->
<cfinclude template="model/degreeSearch.cfm">
<cfreturn>