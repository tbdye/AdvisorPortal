<!--- Template Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("role") >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Load page --->
<cfinclude template="model/template.cfm">
<cfreturn>