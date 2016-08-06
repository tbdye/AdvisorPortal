<!--- Index Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif IsUserInRole("administrator")>
	<cflocation url="admin/">
<cfelseif IsUserInRole("advisor") || IsUserInRole("editor")>
	<cflocation url="faculty/">
<cfelseif IsUserInRole("student")>
	<cflocation url="dashboard/">
<cfelse>
	<cflocation url="logout/">
</cfif>