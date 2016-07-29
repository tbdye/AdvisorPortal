<!--- Thomas Dye, July 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('ASP.cfc.errorBean').init()>

<cfinclude template="../model/courses.cfm">
<cfreturn>