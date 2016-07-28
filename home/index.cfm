<!--- Thomas Dye, July 2016 --->
<cfscript>
	ormReload();
	accounts = EntityLoad("Accounts");
	students = EntityLoad("Students");
	faculty = EntityLoad("Faculty");
</cfscript>

<cfmodule template="../includes/header.cfm"
	pagetitle = "Advisor Service Portal - Home Page">
	
    <h1>Main page</h1>

	<a href="../login/logout.cfm">Logout</a>
<cfmodule template="../includes/footer.cfm">
