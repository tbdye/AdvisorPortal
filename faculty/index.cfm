<!--- Advisor Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !IsUserInRole("advisor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Define form action for "Select" button. --->
<cfif isDefined("form.selectButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.searchTerm))>
		<cfset messageBean.addError('A search term is required.', 'searchTerm')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/advisor.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the student, if exists --->
	<cfquery name="qAdvisorGetStudent">
		SELECT a.id, a.first_name + ' ' + a.last_name AS full_name, a.email, s.student_id
		FROM ACCOUNTS a
		JOIN STUDENTS s
		ON a.id = s.accounts_id
		<!--- Determine the type of search to perform --->
		<cfif IsValid("integer", trim(form.searchTerm))>
			WHERE s.student_id = <cfqueryparam value="#trim(form.searchTerm)#" cfsqltype="cf_sql_integer">
		<cfelseif IsValid("email", trim(form.searchTerm))>
			WHERE a.email = <cfqueryparam value="#trim(form.searchTerm)#" cfsqltype="cf_sql_varchar">
		<cfelse>
			<cfset nameArray=listToArray(trim(form.searchTerm), " ", false, false)>
			<cfif ArrayLen(nameArray) GT 1>
				WHERE a.first_name LIKE <cfqueryparam value="#trim(nameArray[1])#%" cfsqltype="cf_sql_varchar">
				AND a.last_name LIKE <cfqueryparam value="#trim(nameArray[2])#%" cfsqltype="cf_sql_varchar">
			<cfelse>
				WHERE a.first_name LIKE <cfqueryparam value="#trim(nameArray[1])#%" cfsqltype="cf_sql_varchar">
				OR a.last_name LIKE <cfqueryparam value="#trim(nameArray[1])#%" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfif>
			AND a.active = 1
	</cfquery>
	
	<!--- Handle student ID search results. --->
	<cfif !qAdvisorGetStudent.RecordCount>
		<cfset messageBean.addError('No records.', 'searchTerm')>
	</cfif>
	
	<cfinclude template="model/advisor.cfm">
	<cfreturn>
</cfif>

<!--- Advise student --->
<cfif isDefined("form.adviseButton")>
	<cfquery name="qAdvisorGetStudent">
		SELECT a.first_name + ' ' + a.last_name AS full_name, a.email, s.accounts_id, s.student_id
		FROM ACCOUNTS a
		JOIN STUDENTS s
		ON a.id = s.accounts_id
		WHERE s.student_id = <cfqueryparam value="#form.studentId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qAdvisorGetStudent.RecordCount>
		<!--- Student matched, so setup the advising session. --->
		<cfset session.accountId = qAdvisorGetStudent.accounts_id>
		<cfset session.studentId = qAdvisorGetStudent.student_id>
		<cfset session.studentName = qAdvisorGetStudent.full_name>
		<cflocation url="../dashboard/">
	<cfelse>
		<!--- The student ID did not match any known student, so stop here. --->
		<cfset messageBean.addError('Unable to advise this student.', 'studentId')>
		<cfinclude template="model/advisor.cfm">
		<cfreturn>
	</cfif>
</cfif>
	
<!--- End the advising session. --->
<cfif isDefined("form.stopAdvisingButton")>
	<cfset StructDelete(session, "accountId")>
	<cfset StructDelete(session, "studentId")>
	<cfset StructDelete(session, "studentName")>
</cfif>

<!--- Display all students --->
<cfif isDefined("url.search") && url.search EQ 'all'>
	<cfquery name="qAdvisorGetStudent">
		SELECT a.id, a.first_name + ' ' + a.last_name AS full_name, a.email, s.student_id
		FROM ACCOUNTS a
		JOIN STUDENTS s
		ON a.id = s.accounts_id
		WHERE a.active = 1
	</cfquery>
	<cfinclude template="model/advisor.cfm">
	<cfreturn>
	
<!--- Display default landing page. --->
<cfelse>
	<cfinclude template="model/advisor.cfm">
	<cfreturn>
</cfif>