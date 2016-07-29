<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../home/courses.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Completed courses">
	
	<cfif IsUserInRole("advisor")>
		<h2>Completed courses for <cfoutput>#session.studentName#</cfoutput></h2>
	<cfelse>
		<h2>Completed courses</h2>
	</cfif>
	<p>Provide some instructions on how the completed courses section works and initial steps to get started using the Advisor Services Portal.</p>

<cfmodule template="../includes/footer.cfm">