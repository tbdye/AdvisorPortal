<!--- Thomas Dye, July 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<!--- Load page --->
<cfinclude template="model/degreeSearch.cfm">
<cfreturn>