<!--- Manage Users Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("administrator")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Display all students --->
<cfif isDefined("url.search") && url.search EQ 'all'>
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
</cfif>

<!--- Define form action for "Search" button --->
<cfif isDefined("form.searchButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.searchTerm))>
		<cfset messageBean.addError('A search term is required.', 'searchTerm')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
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
		<cfset messageBean.addError('No records.', 'searchTerm')>
	</cfif>
	
	<cfinclude template="model/manageUsers.cfm">
	<cfreturn>
</cfif>
	
<!---Define form action for "Create an account" button--->
<cfif isDefined("form.createFacultyButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.firstName))>
		<cfset messageBean.addError('A first name is required.', 'firstName')>
	</cfif>
	
	<cfif !len(trim(form.lastName))>
		<cfset messageBean.addError('A last name is required.', 'lastName')>
	</cfif>
	
	<cfif !len(trim(form.emailAddress))>
		<cfset messageBean.addError('An email address is required.', 'emailAddress')>
	<cfelseif !IsValid("email", trim(form.emailAddress))>
		<cfset messageBean.addError('The email address is not valid.', 'emailAddress')>
	</cfif>
	
	<cfif !len(trim(form.password))>
		<cfset messageBean.addError('The password cannot be blank.', 'password')>
	<cfelseif trim(form.password) NEQ trim(form.password2)>
		<cfset messageBean.addError('The passwords do not match.', 'password')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageUsers.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Perform uniqueness validation on form fields --->
	<cfquery name="qAdminCheckEmail">
		SELECT email
		FROM ACCOUNTS
		WHERE email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif qAdminCheckEmail.RecordCount>
		<cfset messageBean.addError('This email address is already in use.', 'emailAddress')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageUsers.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so create faculty account --->
	<cfif len(trim(form.password))>
		<cfset salt=Hash(GenerateSecretKey("AES"), "SHA-512")>
		<cfset password=Hash(trim(form.password) & salt, "SHA-512")>
	</cfif>
	
	<cfset emailAddress=canonicalize(trim(form.emailAddress), true, true)>
	<cfset firstName=canonicalize(trim(form.firstName), true, true)>
	<cfset lastName=canonicalize(trim(form.lastName), true, true)>
	
	<cfquery>
		INSERT INTO	ACCOUNTS (
			active, email, first_name, last_name, password, salt)
		VALUES (
			1,
			<cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#firstName#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#lastName#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar">)
	</cfquery>
	<cfquery name="qAdminGetAccount">
		SELECT id
		FROM ACCOUNTS
		WHERE email = <cfqueryparam value="#trim(emailAddress)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfquery>
		INSERT INTO	FACULTY (
			accounts_id, editor, administrator)
		VALUES (
			<cfqueryparam value="#qAdminGetAccount.id#" cfsqltype="cf_sql_integer">,
			<cfif form.role EQ 3>
				0, 1	
			<cfelseif form.role EQ 2>
				1, 0
			<cfelse>
				0, 0
			</cfif>
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="./">
	</cfif>
</cfif>

<!--- Display default landing page. --->
<cfinclude template="model/manageUsers.cfm">
<cfreturn>