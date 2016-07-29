<!--- Thomas Dye, July 2016 --->
<cfif IsUserInRole("administrator")>
	<cflocation url="admin.cfm">
<cfelseif IsUserInRole("advisor") || IsUserInRole("editor")>
	<cflocation url="advisor.cfm">
<cfelseif IsUserInRole("student")>
	<cflocation url="dashboard.cfm">
<cfelse>
	<cflocation url="../login/logout.cfm">
</cfif>