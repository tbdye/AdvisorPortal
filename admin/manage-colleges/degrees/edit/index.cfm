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
	SELECT id, degree_name
	FROM DEGREES
	WHERE id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the college ID is not valid --->
<cfif !qEditGetCollege.RecordCount || !qEditGetDegree.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Display page without errors --->
<cfinclude template="model/editDegree.cfm">
<cfreturn>