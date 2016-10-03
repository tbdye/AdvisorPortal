<!--- View Degree Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Do basic validation --->
<cfif !isDefined("url.degree") || !IsNumeric("#URLDecode(url.degree)#")>
	<cflocation url="..">
</cfif>

<!--- Define action for degree "Create plan from degree" button --->
<cfif isDefined("form.addDegreeButton")>
	<cflocation url="../../plans/create-plan/?degree=#URLEncodedFormat(form.degreeName)#&id=#form.degreeId#">
</cfif>

<!--- Prepare basic contents of the page --->
<cfquery name="qViewGetDegree">
	SELECT
		deg.id, deg.colleges_id, deg.degree_name, deg.degree_type,
		dept.department_name,
		col.college_name, col.college_city
	FROM DEGREES deg, DEPARTMENTS dept, COLLEGES col
	WHERE dept.id = deg.departments_id
	AND col.id = deg.colleges_id
	AND deg.use_catalog = 1
	AND col.use_catalog = 1
	AND deg.id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the degree ID is not valid --->
<cfif !qViewGetDegree.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Prepare degree content --->
<cfquery name="qViewGetDegreeNotes">
	SELECT
		admission_courses_note, admission_codekeys_note,
		graduation_courses_note, graduation_codekeys_note, general_note
	FROM DEGREE_NOTES
	WHERE degrees_id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetAdmissionCourses">
	SELECT a.courses_id, a.foreign_course_number, c.id, c.course_number, cat.category, cat.description
	FROM DEGREE_ADMISSION_COURSES a, COURSES c, CATEGORIES cat
	WHERE a.courses_id = c.id
	AND a.categories_id = cat.id
	AND a.degrees_id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetAdmissionCodekeys">
	SELECT a.codekeys_id, a.credit, c.id, c.description
	FROM DEGREE_ADMISSION_CODEKEYS a
	JOIN CODEKEYS c
	ON a.codekeys_id = c.id
	WHERE a.degrees_id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetGraduationCourses">
	SELECT g.courses_id, g.foreign_course_number, c.id, c.course_number, cat.category, cat.description
	FROM DEGREE_GRADUATION_COURSES g, COURSES c, CATEGORIES cat
	WHERE g.courses_id = c.id
	AND g.categories_id = cat.id
	AND g.degrees_id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetGraduationCodekeys">
	SELECT g.codekeys_id, g.credit, c.id, c.description
	FROM DEGREE_GRADUATION_CODEKEYS g
	JOIN CODEKEYS c
	ON g.codekeys_id = c.id
	WHERE g.degrees_id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Display page --->
<cfinclude template="model/viewDegree.cfm">
<cfreturn>