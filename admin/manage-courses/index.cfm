<!--- Manage Courses Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("administrator")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Display page --->
<cfinclude template="model/manageCourses.cfm">
<cfreturn>