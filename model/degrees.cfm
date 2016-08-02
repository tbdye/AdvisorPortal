<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Degree plans">
	
	<!--- Alter page header depending if in an adivisng session or not. --->
	<cfif IsUserInRole("advisor")>
		<h2>Degree plans for <cfoutput>#session.studentName#</cfoutput></h2>
	<cfelse>
		<h2>Degree plans</h2>
	</cfif>
	
	<p>Provide some instructions on how the degree plans section works and initial steps to get started using the Advisor Services Portal.</p>
	
	<a href="degreeSearch.cfm" title="Create a new degree plan">Create a new degree plan</a>
	
	<!--- Display completed courses --->
	<h3>Saved degree plans</h3>
	<cfif qDegreesGetStudentPlans.RecordCount>
		<table>
			<tr>
				<th>Plan details</th>
				<th>Created</th>
				<th>Updated</th>
				<th></th>
				<th></th>
			</tr>
			<cfloop query="qCoursesGetStudentCourses">
				<tr>
					<td><cfoutput>#qDegreesGetStudentPlans.plan_name#</cfoutput></td>
					<td><cfoutput>#qDegreesGetStudentPlans.time_created#</cfoutput></td>
					<td><cfoutput>#qDegreesGetStudentPlans.time_updated#</cfoutput></td>
					<td><cfoutput><a href="?delete=#URLEncodedFormat(qDegreesGetStudentPlans.plan_name)#&id=#URLEncodedFormat(qDegreesGetStudentPlans.id)#" title="Delete">Delete</a></cfoutput></td>
					<td><cfoutput><a href="?copy=#URLEncodedFormat(qDegreesGetStudentPlans.plan_name)#&id=#URLEncodedFormat(qDegreesGetStudentPlans.id)#" title="Copy">Copy</a></cfoutput></td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		<p>No degree plans created yet.</p>
	</cfif>

<cfmodule template="../includes/footer.cfm">