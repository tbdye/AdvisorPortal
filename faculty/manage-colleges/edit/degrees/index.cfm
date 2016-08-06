<!--- Manage Degree Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor") || !IsDefined("url.edit")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetCollege">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
	WHERE id = <cfqueryparam value="#URLDecode(url.edit)#" cfsqltype="cf_sql_integer">
	<cfif !IsUserInRole("administrator")>
		AND use_catalog = 1
	</cfif>
</cfquery>

<!--- Back out if the college ID is not valid --->
<cfif !qEditGetCollege.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Display errors if they exist --->
<cfinclude template="model/manageDegrees.cfm">
<cfreturn>