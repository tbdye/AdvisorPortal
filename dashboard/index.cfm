<!--- Dashboard Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<cfinclude template="model/dashboard.cfm">
<cfreturn>