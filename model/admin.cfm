<!--- Thomas Dye, July 2016 --->
<cfif !IsUserInRole("administrator")>
	<cflocation url="../login/logout.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Administration">

	<h2>Administration</h2>
	
<cfmodule template="../includes/footer.cfm">