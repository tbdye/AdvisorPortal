<!--- Edit Course Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !IsUserInRole("editor") >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Load page --->
<cfinclude template="model/editCourse.cfm">
<cfreturn>