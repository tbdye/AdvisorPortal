<!--- Thomas Dye, July 2016 --->
<cfif !IsUserInRole("administrator")>
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<!--- Define form action for "Select" button. --->
<cfif isDefined("form.searchButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.searchTerm))>
		<cfset errorBean.addError('A search term is required.', 'searchTerm')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/manageUsers.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the account, if exists --->
	<cfquery name="qAdminSearchAccount">
		SELECT a.first_name, a.last_name, a.first_name + ' ' + a.last_name AS full_name,
				a.email, a.active, a.id, s.student_id, s.accounts_id AS s_accounts_id,
				f.accounts_id AS f_accounts_id, f.editor, f.administrator
		FROM accounts a
		FULL JOIN students s
		ON a.id = s.accounts_id
		FULL JOIN faculty f
		ON a.id = f.accounts_id
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
	<cfif !qAdminSearchAccount.RecordCount>
		<cfset errorBean.addError('No records.', 'searchTerm')>
	</cfif>
	
	<cfinclude template="model/manageUsers.cfm">
	<cfreturn>
	
<!--- Display all students --->
<cfelseif isDefined("url.search") && url.search EQ 'all'>
	<cfquery name="qAdminSearchAccount">
		SELECT a.first_name + ' ' + a.last_name AS full_name, a.email,
				a.id, a.active, s.student_id, s.accounts_id AS s_accounts_id,
				f.accounts_id AS f_accounts_id, f.editor, f.administrator
		FROM accounts a
		FULL JOIN students s
		ON a.id = s.accounts_id
		FULL JOIN faculty f
		ON a.id = f.accounts_id
	</cfquery>
	<cfinclude template="model/manageUsers.cfm">
	<cfreturn>

<!--- Display default landing page. --->
<cfelse>
	<cfinclude template="model/manageUsers.cfm">
	<cfreturn>
</cfif>