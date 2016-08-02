<!--- Thomas Dye, August 2016 --->
<cfset errorBean=createObject('cfc.errorBean').init()>

<cfquery name="qAccountGetAccount">
	<cfif IsUserInRole("student")>
		SELECT a.id, a.email, a.first_name, a.last_name, a.password, a.salt, s.accounts_id, s.student_id
		FROM ACCOUNTS a
		JOIN STUDENTS s
		ON a.id = s.accounts_id
		WHERE a.id = <cfqueryparam value="#session.loginId#" cfsqltype="cf_sql_integer">
	<cfelse>
		SELECT id, email, first_name, last_name, password, salt
		FROM ACCOUNTS
		WHERE id = <cfqueryparam value="#session.loginId#" cfsqltype="cf_sql_integer">
	</cfif>
</cfquery>

<cfset session.loginName="#qAccountGetAccount.first_name# #qAccountGetAccount.last_name#">

<cfif isDefined("form.buttonUpdateEmail")>
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.password))>
		<cfset errorBean.addError('Please enter your password.', 'password')>
	<cfelse>
		<cfset password = Hash(trim(form.password) & qAccountGetAccount.salt, "SHA-512")>
		<cfif password NEQ qAccountGetAccount.password>
			<cfset errorBean.addError('The password is incorrect.', 'password')>
		</cfif>
	</cfif>
	
	<cfif !len(trim(form.emailAddress))>
		<cfset errorBean.addError('An email address is required.', 'emailAddress')>
	<cfelseif !IsValid("email", trim(form.emailAddress))>
		<cfset errorBean.addError('The email address is not valid.', 'emailAddress')>
	<cfelseif trim(form.emailAddress) NEQ trim(form.emailAddress2)>
		<cfset errorBean.addError('The email addresses do not match.', 'emailAddress')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/account.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Perform uniqueness validation on form fields --->
	<cfset emailAddress=canonicalize(trim(form.emailAddress), true, true, true)>
	
	<cfquery name="qAccountCheckEmail">
		SELECT email
		FROM ACCOUNTS
		WHERE email = <cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif qAccountCheckEmail.RecordCount>
		<cfset errorBean.addError('This email address is already in use.', 'emailAddress')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/account.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update email --->
	<cfquery>
		UPDATE ACCOUNTS
		SET email = <cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar">
		WHERE id = <cfqueryparam value="#session.loginId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh the page --->
	<cflocation url="account.cfm">
</cfif>

<cfif isDefined("form.buttonUpdatePassword")>
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.password))>
		<cfset errorBean.addError('Please enter your password.', 'password')>
	<cfelse>
		<cfset password=Hash(trim(form.password) & qAccountGetAccount.salt, "SHA-512")>
		<cfif password NEQ qAccountGetAccount.password>
			<cfset errorBean.addError('The password is incorrect.', 'password')>
		</cfif>
	</cfif>
	
	<cfif !len(trim(form.newPass))>
		<cfset errorBean.addError('A new password is required.', 'newPass')>
	<cfelseif trim(form.newPass) NEQ trim(form.newPass2)>
		<cfset errorBean.addError('The passwords do not match.', 'newPass')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/account.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update password --->
	<cfset password=Hash(trim(form.newPass) & qAccountGetAccount.salt, "SHA-512")>
	
	<cfquery>
		UPDATE ACCOUNTS
		SET password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">
		WHERE id = <cfqueryparam value="#session.loginId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh the page --->
	<cflocation url="account.cfm">
</cfif>

<cfif isDefined("form.buttonUpdateAccount")>
	<!--- Update student ID --->
	<cfif IsUserInRole("student")>
		
		<!--- Perform simple validation on form fields --->
		<cfif len(trim(form.studentId))>
			<cfif !IsValid("integer", trim(form.studentId))>
				<cfset errorBean.addError('Enter the student ID as a number with no spaces', 'studentId')>
			</cfif>
			
			<cfif !errorBean.hasErrors()>
				<!--- Perform uniqueness validation on form fields --->
				<cfquery name="qAccountCheckStudentId">
					SELECT student_id
					FROM STUDENTS
					WHERE student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
				</cfquery>
							
				<cfif qAccountCheckStudentId.RecordCount>
					<cfset errorBean.addError('This student ID is already in use.', 'studentId')>
				</cfif>
			</cfif>

			<!--- Stop here if errors were detected --->
			<cfif errorBean.hasErrors()>
				<cfinclude template="model/account.cfm">
				<cfreturn>
			</cfif>
			
			<!--- Looks good, so update student ID --->
			<cfquery>
				UPDATE STUDENTS
				SET student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
				WHERE accounts_id = <cfqueryparam value="#session.loginId#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Update first name --->
	<cfif len(trim(form.firstName))>
		<cfset firstName=canonicalize(trim(form.firstName), true, true, true)>
		
		<cfquery>
			UPDATE ACCOUNTS
			SET first_name = <cfqueryparam value="#firstName#" cfsqltype="cf_sql_varchar">
			WHERE id = <cfqueryparam value="#session.loginId#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Update last name --->
	<cfif len(trim(form.lastName))>
		<cfset lastName=canonicalize(trim(form.lastName), true, true, true)>
		
		<cfquery>
			UPDATE ACCOUNTS
			SET last_name = <cfqueryparam value="#lastName#" cfsqltype="cf_sql_varchar">
			WHERE id = <cfqueryparam value="#session.loginId#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh the page --->
	<cflocation url="account.cfm">
</cfif>

<!--- Display page --->
<cfinclude template="model/account.cfm">
<cfreturn>