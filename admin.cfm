<!--- Thomas Dye, July 2016 --->
<cfif !IsUserInRole("administrator")>
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('AdvisorPortal.cfc.errorBean').init()>

<cfinclude template="model/admin.cfm">
<cfreturn>