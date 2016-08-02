<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<!--- Perform simple validation on form fields --->
<cfif !len(trim(form.searchTerm))>
	<cfset errorBean.addError('A search term is required.', 'searchTerm')>
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
</cfquery>

<!--- Handle student ID search results. --->
<cfif !qAdvisorGetStudent.RecordCount>
	<cfset errorBean.addError('No records.', 'searchTerm')>
</cfif>

<cfinclude template="../model/advisor.cfm">
<cfreturn>