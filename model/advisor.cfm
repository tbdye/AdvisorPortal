<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../home/advisor.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Advise student">
	
	<h2>Advise student</h2>
	<p>Provide some instructions on how the advisor student selector works and initial steps to get started using the Advisor Services Portal.</p>
	
	<h3>Look up by student ID number</h3>
	<cfform>
		<cfinput type="text" id="studentId" name="studentId">
		<cfinput type="submit" name="selectButton" value="Select">
	</cfform>
	
	<a href="?search=all" title="Search all names">Search all names</a>
	
	<cfif errorBean.hasErrors() && isDefined("form.selectButton")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>
	
	<cfif errorBean.hasErrors() && isDefined("url.advise")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	<cfelseif isDefined("qGetStudent")>
		<table>
			<tr>
				<th>Name</th>
				<th>Student ID</th>
				<th>Email</th>
				<th></th>
			</tr>
			<cfloop query="qGetStudent">
				<tr>
					<td><cfoutput>#qGetStudent.full_name#</cfoutput></td>
					<td><cfoutput>#qGetStudent.student_id#</cfoutput></td>
					<td><cfoutput>#qGetStudent.email#</cfoutput></td>
					<td><a href="?advise=<cfoutput>#qGetStudent.student_id#</cfoutput>" title="Advise">Advise</a></td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		<p>No student selected.</p>
	</cfif>
	
<cfmodule template="../includes/footer.cfm">