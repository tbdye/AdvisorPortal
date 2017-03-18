<!--- Create Plan Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Run when external page asks to create a degree plan --->
<cfif isDefined("url.degree") && isDefined("url.id") && IsNumeric("#URLDecode(url.id)#")>
	<!--- Validate url variables --->
	<cfquery name="qCheckDegree">
		SELECT id, degree_name, colleges_id
		FROM DEGREES
		WHERE use_catalog = 1
		AND id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
		AND degree_name = <cfqueryparam value="#url.degree#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif qCheckDegree.RecordCount>
		<cfset form.addDegreeButton = "Select">
		<cfset form.collegeId = qCheckDegree.colleges_id>
		<cfset form.degreeId = qCheckDegree.id>
		<cfset form.degreeName = qCheckDegree.degree_name>
	</cfif>
</cfif>

<!--- Define action for degree "select" button from search results --->
<cfif isDefined("form.addDegreeButton")>
	
	<!--- Create, then add all admission and graduation courses to this plan --->
	<cfstoredproc datasource="#GetApplicationMetaData().datasource#" procedure="createPLANS" returncode="true">
		<cfprocparam value="#session.accountId#" cfsqltype="cf_sql_integer">
		<cfprocparam value="#form.degreeId#" cfsqltype="cf_sql_integer">
		<cfprocparam value="#form.collegeId#" cfsqltype="cf_sql_integer">
		<cfprocparam value="#form.degreeName#" cfsqltype="cf_sql_varchar">
	</cfstoredproc>
	
	<!--- Clear the session state for plan creation --->
	<cfset StructDelete(session, "searchFilter")>
	<cfset StructDelete(session, "aColleges")>
	<cfset StructDelete(session, "aDepartments")>
	
	<!--- Redirect to the edit plan page for user confirmation --->
	<cflocation url="../edit/?plan=#URLEncodedFormat(cfstoredproc.statusCode)#">
</cfif>

<!--- Prepare filter lists --->
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

<!--- Define action for degree name "search" button --->
<cfif isDefined("form.searchButton")>
	<cfif isDefined("form.searchTerm") && len(trim(form.searchTerm))>
		<cfset session.searchFilter = form.searchTerm>
	<cfelse>
		<cfset StructDelete(session, "searchFilter")>
	</cfif>
</cfif>

<!--- Define action for colleges filter list "update" button --->
<cfif isDefined("form.filterCollegesButton")>
	<cfif isDefined("form.filterCollege")>
		<cfset session.aColleges = ListToArray(form.filterCollege)>
	<cfelse>
		<cfset StructDelete(session, "aColleges")>
	</cfif>
</cfif>

<!--- Define action for departments filter list "update" button --->
<cfif isDefined("form.filterDepartmentsButton")>
	<cfif isDefined("form.filterDepartment")>
		<cfset session.aDepartments = ListToArray(form.filterDepartment)>
	<cfelse>
		<cfset StructDelete(session, "aDepartments")>
	</cfif>
</cfif>

<!--- Build query to display search results --->
<cfquery name="qSearchGetFilteredDegrees">
	SELECT d.id, d.degree_name, d.degree_type, d.colleges_id, c.college_name, c.college_city
	FROM DEGREES d
	JOIN COLLEGES c
	ON d.colleges_id = c.id
	FULL JOIN DEGREE_RANKINGS r ON d.id = r.degrees_id
	WHERE d.use_catalog = 1
	AND c.use_catalog = 1
	<cfif isDefined("session.searchFilter")>
		AND d.degree_name LIKE <cfqueryparam value="%#trim(session.searchFilter)#%" cfsqltype="cf_sql_varchar">
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
	ORDER BY r.rank DESC
</cfquery>

<!--- Load page --->
<cfinclude template="model/createPlan.cfm">
<cfreturn>