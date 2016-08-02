<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

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
<cfquery name="qAdvisorGetStudent">
	SELECT a.id, a.first_name + ' ' + a.last_name AS full_name, a.email, s.student_id
	FROM ACCOUNTS a
	JOIN STUDENTS s
	ON a.id = s.accounts_id
	WHERE s.student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Handle student ID search results. --->
<cfif !qAdvisorGetStudent.RecordCount>
	<cfset errorBean.addError('No records found for that student ID.', 'studentId')>
</cfif>

<cfinclude template="../model/advisor.cfm">
<cfreturn>