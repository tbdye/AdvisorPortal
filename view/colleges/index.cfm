<!--- View College Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Do basic validation --->
<cfif !isDefined("url.college") || !IsNumeric("#URLDecode(url.college)#")>
	<cflocation url="..">
</cfif>

<!--- Prepare basic contents of the page --->
<cfquery name="qViewGetCollege">
	SELECT college_name, college_city, college_website
	FROM COLLEGES
	WHERE use_catalog = 1
	AND id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the college ID is not valid --->
<cfif !qViewGetCollege.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Prepare college content --->
<cfquery name="qViewGetCollegeNotes">
	SELECT courses_note, departments_note, codekeys_note
	FROM COLLEGE_NOTES
	WHERE colleges_id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetAdmissionCourses">
	SELECT a.foreign_course_number, c.id, c.course_number, cat.category, cat.description
	FROM COLLEGE_ADMISSION_COURSES a, COURSES c, CATEGORIES cat
	WHERE a.courses_id = c.id
	AND a.categories_id = cat.id
	AND a.colleges_id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetAdmissionDepartments">
	SELECT a.credit, d.id, d.department_name
	FROM COLLEGE_ADMISSION_DEPARTMENTS a
	JOIN DEPARTMENTS d
	ON a.departments_id = d.id
	WHERE a.colleges_id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetAdmissionCodekeys">
	SELECT a.credit, c.id, c.description
	FROM COLLEGE_ADMISSION_CODEKEYS a
	JOIN CODEKEYS c
	ON a.codekeys_id = c.id
	WHERE a.colleges_id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Display page --->
<cfinclude template="model/viewCollege.cfm">
<cfreturn>