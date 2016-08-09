<!--- Edit Degree Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor") || !IsDefined("url.college") || !IsDefined("url.degree")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetCollege">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
	WHERE id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetDegree">
	SELECT id, degree_name, degree_type, use_catalog
	FROM DEGREES
	WHERE id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the college or degree ID is not valid --->
<cfif !qEditGetCollege.RecordCount || !qEditGetDegree.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Prepare degree update form contents --->
<cfquery name="qEditGetAllDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	WHERE use_catalog = 1
	ORDER BY department_name ASC
</cfquery>

<cfquery name="qEditGetAllCodekeys">
	SELECT id, description
	FROM CODEKEYS
</cfquery>

<cfquery name="qEditGetDegreeNotes">
	SELECT
		admission_courses_note, admission_codekeys_note,
		graduation_courses_note, graduation_codekeys_note, general_note
	FROM DEGREE_NOTES
	WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Set defaults for form data --->
<cfset status1="no">
<cfset status2="no">
<cfif qEditGetDegree.use_catalog>
	<cfset status1="yes">
<cfelse>
	<cfset status2="yes">
</cfif>

<!--- Prepare requirements contents --->
<cfquery name="qEditGetAdmissionCourses">
	SELECT a.foreign_course_number, c.id, c.course_number
	FROM DEGREE_ADMISSION_COURSES a
	JOIN COURSES c
	ON a.courses_id = c.id
	WHERE a.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetAdmissionCodekeys">
	SELECT a.credit, c.id, c.description
	FROM DEGREE_ADMISSION_CODEKEYS a
	JOIN CODEKEYS c
	ON a.codekeys_id = c.id
	WHERE a.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetGraduationCourses">
	SELECT g.foreign_course_number, c.id, c.course_number
	FROM DEGREE_GRADUATION_COURSES g
	JOIN COURSES c
	ON g.courses_id = c.id
	WHERE g.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetGraduationCodekeys">
	SELECT g.credit, c.id, c.description
	FROM DEGREE_GRADUATION_CODEKEYS g
	JOIN CODEKEYS c
	ON g.codekeys_id = c.id
	WHERE g.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Display page without errors --->
<cfinclude template="model/editDegree.cfm">
<cfreturn>