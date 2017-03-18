<!--- Admin Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Display page --->
<cfinclude template="model/admin.cfm">
<cfreturn>