<!--- Thomas Dye, July 2016 --->
<cfif !IsUserInRole("advisor")>
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<!--- Define form action for "Select" button. --->
<cfif isDefined("form.selectButton")>
	<cfinclude template="advisor/formSelectButton.cfm">
	
<!--- Display all students --->
<cfelseif isDefined("url.search") && url.search EQ 'all'>
	<cfquery name="qAdvisorGetStudent">
		SELECT a.id, a.first_name + ' ' + a.last_name AS full_name, a.email, s.student_id
		FROM ACCOUNTS a
		JOIN STUDENTS s
		ON a.id = s.accounts_id
	</cfquery>
	<cfinclude template="model/advisor.cfm">
	<cfreturn>
	
<!--- Advise student --->
<cfelseif isDefined('url.advise') && url.advise NEQ 'end'>
	<cfquery name="qAdvisorGetStudent">
		SELECT a.first_name + ' ' + a.last_name AS full_name, a.email, s.accounts_id, s.student_id
		FROM ACCOUNTS a
		JOIN STUDENTS s ON a.id = s.accounts_id
	</cfquery>
	
	<!--- Don't trust url variables, so passively validate the student ID in the URL against known students. --->
	<cfloop query="qAdvisorGetStudent">
		<cfif url.advise EQ qAdvisorGetStudent.student_id>
			<!--- Student matched, so setup the advising session. --->
			<cfset session.accountId = qAdvisorGetStudent.accounts_id>
			<cfset session.studentId = qAdvisorGetStudent.student_id>
			<cfset session.studentName = qAdvisorGetStudent.full_name>
			<cflocation url="dashboard.cfm">
		</cfif>
	</cfloop>
	
	<!--- The student ID did not match any known student, so stop here. --->
	<cfset errorBean.addError('Unable to advise this student.', 'studentId')>
	<cfinclude template="model/advisor.cfm">
	<cfreturn>

<!--- End the advising session. --->
<cfelseif isDefined('url.advise') && url.advise EQ 'end'>
	<cfset StructDelete(session, "studentId")>
	<cfset StructDelete(session, "studentName")>
	<cflocation url="advisor.cfm">
	
<!--- Display default landing page. --->
<cfelse>
	<cfinclude template="model/advisor.cfm">
	<cfreturn>
</cfif>