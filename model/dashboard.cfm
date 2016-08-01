<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../dashboard.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Dashboard">
	
	<cfif IsUserInRole("advisor")>
		<h2>Dashboard for <cfoutput>#session.studentName#</cfoutput></h2>
	<cfelse>
		<h2>Dashboard</h2>
	</cfif>
	<p>Provide some instructions on how the dashboard works and initial steps to get started using the Advisor Services Portal.</p>

	<cfif !isDefined("qGetPlan")>
		<h3>Getting started</h3>
		<a href="courses.cfm" title="Completed courses">Completed courses</a>
		<p>or</p>
		<a href="degrees.cfm" title="Degree plans">Degree plans</a>
	<cfelse>
		
	</cfif>

<cfmodule template="../includes/footer.cfm">