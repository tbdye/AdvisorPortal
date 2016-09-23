<!--- Manage Departments Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Display page --->
<cfinclude template="model/manageDepartments.cfm">
<cfreturn>