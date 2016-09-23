<!--- View Course Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Do basic validation --->
<cfif !IsNumeric("#URLDecode(url.course)#")>
	<cflocation url="..">
</cfif>

<!--- Prepare basic contents of the page --->
<cfquery name="qViewGetCourse">
	SELECT c.id, c.course_number, c.title, c.min_credit, c.max_credit, c.course_description, d.department_name
	FROM COURSES c
	JOIN DEPARTMENTS d
	ON d.id = c.departments_id
	WHERE c.use_catalog = 1
	AND c.id = <cfqueryparam value="#URLDecode(url.course)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the course ID is not valid --->
<cfif !qViewGetCourse.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Get other page content --->
<cfquery name="qViewGetPlacement">
	SELECT placement
	FROM PREREQUISITE_PLACEMENTS
	WHERE courses_id = <cfqueryparam value="#qViewGetCourse.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qViewGetPrerequisites">
	SELECT p.id, p.courses_id, p.group_id, p.courses_prerequisite_id, c.course_number
	FROM PREREQUISITES p
	JOIN COURSES c
	ON p.courses_prerequisite_id = c.id
	WHERE p.courses_id = <cfqueryparam value="#qViewGetCourse.id#" cfsqltype="cf_sql_integer">
	ORDER BY p.group_id, c.course_number
</cfquery>

<cfquery name="qViewGetPermission">
	SELECT courses_id
	FROM PREREQUISITE_PERMISSIONS
	WHERE courses_id = <cfqueryparam value="#qViewGetCourse.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Build dynamic content for prerequisites as strings to be displayed --->
<cfset aPrerequisites = arrayNew(1)>

<!--- Format prerequisite class groups --->
<cfif qViewGetPrerequisites.RecordCount>
	<cfset group=qViewGetPrerequisites.group_id>
	<cfset firstInGroup="true">
	
	<!--- Display individual course groups --->
	<cfloop query="qViewGetPrerequisites">
		<cfif group EQ qViewGetPrerequisites.group_id>
			
			<!--- add from the same group --->
			<cfif firstInGroup EQ 'true'>
				<cfset classes=qViewGetPrerequisites.course_number>
				<cfset firstInGroup="false">
			<cfelse>
				<cfset classes=classes & " and " & qViewGetPrerequisites.course_number>
			</cfif>
		<cfelse>
		
			<!--- the group changed, so end the string --->
			<cfset classes=classes & " with a grade of C or higher">
			<cfset ArrayAppend(aPrerequisites, classes)>
			
			<!--- begin the next string --->
			<cfset group=qViewGetPrerequisites.group_id>
			<cfset classes=qViewGetPrerequisites.course_number>
		</cfif>	
	</cfloop>
	<cfset classes=classes & " with a grade of C or higher">
	<cfset ArrayAppend(aPrerequisites, classes)>
	
	<!--- Display instructor permission option --->
	<cfif qViewGetPermission.RecordCount>
		<cfset ArrayAppend(aPrerequisites, "Instructor permission")>
	</cfif>
	
	<!--- Display placement exam option --->
	<cfif qViewGetPlacement.RecordCount>
		<cfset ArrayAppend(aPrerequisites, "Placement into <cfoutput>#qViewGetCourse.course_number#</cfoutput> by assessment.")>
	</cfif>
</cfif>

<!--- Load page --->
<cfinclude template="model/viewCourse.cfm">
<cfreturn>