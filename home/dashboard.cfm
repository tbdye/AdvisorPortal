<!--- Thomas Dye, July 2016 --->
<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Dashboard">
	
	<cfif IsUserInRole("advisor")>
		<h2>Dashboard for <cfoutput>#session.studentName#</cfoutput></h2>
	<cfelse>
		<h2>Dashboard</h2>
	</cfif>
	<p>Provide some instructions on how the dashboard works and initial steps to get started using the Advisor Services Portal.</p>

<cfmodule template="../includes/footer.cfm">