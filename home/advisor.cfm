<!--- Thomas Dye, July 2016 --->
<cfif !IsUserInRole("advisor")>
	<cflocation url="../login/logout.cfm">
</cfif>

<cfset errorBean=createObject('ASP.cfc.errorBean').init()>

<!--- Define form action for "Select" button. --->
<cfif isDefined("form.selectButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.studentId))>
		<cfset errorBean.addError('A student ID number is required.', 'studentId')>
	<cfelseif !IsValid("integer", trim(form.studentId))>
		<cfset errorBean.addError('Enter the student ID as a number with no spaces', 'studentId')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="../model/advisor.cfm">
		<cfreturn>
	</cfif>

	<!--- Find the student, if exists --->
	<cfquery name="qGetStudent">
		SELECT
			a.id,
			a.first_name + ' ' + a.last_name AS full_name,
			a.email,
			s.student_id
		FROM
			ACCOUNTS a
		JOIN
			STUDENTS s ON a.id = s.accounts_id
		WHERE
			s.student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
	</cfquery>

	<!--- Handle student ID search results. --->
	<cfif !qGetStudent.RecordCount>
		<cfset errorBean.addError('No records found for that student ID.', 'studentId')>
	</cfif>
	
	<cfinclude template="../model/advisor.cfm">
	<cfreturn>
	
<!--- Display all students --->
<cfelseif isDefined("url.search") && url.search EQ 'all'>
	<cfquery name="qGetStudent">
		SELECT
			a.id,
			a.first_name + ' ' + a.last_name AS full_name,
			a.email,
			s.student_id
		FROM
			ACCOUNTS a
		JOIN
			STUDENTS s ON a.id = s.accounts_id
	</cfquery>
	<cfinclude template="../model/advisor.cfm">
	<cfreturn>
	
<!--- Advise student --->
<cfelseif isDefined('url.advise') && url.advise NEQ 'end'>
	<cfquery name="qGetStudent">
		SELECT
			a.id,
			a.first_name + ' ' + a.last_name AS full_name,
			a.email,
			s.student_id
		FROM
			ACCOUNTS a
		JOIN
			STUDENTS s ON a.id = s.accounts_id
	</cfquery>
	
	<!--- Don't trust url variables, so passively validate the student ID in the URL against known students. --->
	<cfloop query="qGetStudent">
		<cfif url.advise EQ qGetStudent.student_id>
			<!--- Student matched, so setup the advising session. --->
			<cfset session.studentId = qGetStudent.student_id>
			<cfset session.studentName = qGetStudent.full_name>
			<cflocation url="../home/dashboard.cfm">
		</cfif>
	</cfloop>
	
	<!--- The student ID did not match any known student, so stop here. --->
	<cfset errorBean.addError('Unable to advise this student.', 'studentId')>
	<cfinclude template="../model/advisor.cfm">
	<cfreturn>

<!--- End the advising session. --->
<cfelseif isDefined('url.advise') && url.advise EQ 'end'>
	<cfset StructDelete(session, "studentId")>
	<cfset StructDelete(session, "studentName")>
	<cflocation url="../home/advisor.cfm">
	
<!--- Display default landing page. --->
<cfelse>
	<cfinclude template="../model/advisor.cfm">
	<cfreturn>
</cfif>