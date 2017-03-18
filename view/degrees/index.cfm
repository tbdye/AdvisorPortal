<!--- View Degree Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

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
		admission_courses_note, admission_categories_note,
		graduation_courses_note, graduation_categories_note, general_note
	FROM DEGREE_NOTES
	WHERE degrees_id = <cfqueryparam value="#qViewGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetAdmissionCourses">
	SELECT a.courses_id, a.foreign_course_number, a.degree_categories_id, c.id, c.course_number, d.category
	FROM DEGREE_ADMISSION_COURSES a
	JOIN COURSES c
	ON c.id = a.courses_id
	JOIN DEGREE_CATEGORIES d
	ON d.id = a.degree_categories_id
	WHERE a.degrees_id = <cfqueryparam value="#qViewGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetAdmissionCategories">
	SELECT a.degree_categories_id, a.credit, d.category
	FROM DEGREE_ADMISSION_CATEGORIES a
	JOIN DEGREE_CATEGORIES d
	ON d.id = a.degree_categories_id
	WHERE a.degrees_id = <cfqueryparam value="#qViewGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetGraduationCourses">
	SELECT g.courses_id, g.foreign_course_number, g.degree_categories_id, c.id, c.course_number, d.category
	FROM DEGREE_GRADUATION_COURSES g
	JOIN COURSES c
	ON c.id = g.courses_id
	JOIN DEGREE_CATEGORIES d
	ON d.id = g.degree_categories_id
	WHERE g.degrees_id = <cfqueryparam value="#qViewGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetGraduationCategories">
	SELECT g.degree_categories_id, g.credit, d.category
	FROM DEGREE_GRADUATION_CATEGORIES g
	JOIN DEGREE_CATEGORIES d
	ON d.id = g.degree_categories_id
	WHERE g.degrees_id = <cfqueryparam value="#qViewGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Display page --->
<cfinclude template="model/viewDegree.cfm">
<cfreturn>