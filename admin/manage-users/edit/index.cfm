<!--- Edit User Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("administrator") || !IsDefined("url.edit")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qUserGetAccount">
	SELECT a.id, a.active, a.email, a.first_name, a.last_name,
			s.accounts_id AS s_accounts_id, s.student_id,
			f.accounts_id AS f_accounts_id, f.editor, f.administrator
	FROM accounts a
	FULL JOIN students s
	ON a.id = s.accounts_id
	FULL JOIN faculty f
	ON a.id = f.accounts_id
	WHERE a.id = <cfqueryparam value="#URLDecode(url.edit)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the user ID is not valid --->
<cfif !qUserGetAccount.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Set defaults for form data --->
<cfset status1="no">
<cfset status2="no">
<cfif qUserGetAccount.active>
	<cfset status1="yes">
<cfelse>
	<cfset status2="yes">
</cfif>

<cfset role1="no">
<cfset role2="no">
<cfset role3="no">
<cfif IsValid("integer", qUserGetAccount.administrator) && qUserGetAccount.administrator>
	<cfset role3="yes">
<cfelseif IsValid("integer", qUserGetAccount.editor) && qUserGetAccount.editor>
	<cfset role2="yes">
<cfelseif IsValid("integer", qUserGetAccount.f_accounts_id)>
	<cfset role1="yes">
</cfif>

<!--- Define the "Save" button action --->
<cfif isDefined("form.saveButton")>
	
	<!--- Prevent changes to own account --->
	<cfif qUserGetAccount.id EQ session.loginId>
		<cfset messageBean.addError('Cannot use this form to make changes to your own account.', 'loginId')>
	</cfif>
	
	<!--- Evaluate update for account activation status --->
	<cfif isDefined("form.status") && !messageBean.hasErrors()>
		<cfif (status1 EQ "yes" && form.status NEQ 1) || (status2 EQ "yes" && form.status NEQ 2)>
			<!--- Update faculty role --->
			<cfif form.status EQ 1>
				<cfquery>
					UPDATE ACCOUNTS
					SET active = 1
					WHERE id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery>
					UPDATE ACCOUNTS
					SET active = 0
					WHERE id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for faculty role --->
	<cfif isDefined("form.role") && !messageBean.hasErrors()>
		<cfif (role1 EQ "yes" && form.role NEQ 1) || (role2 EQ "yes" && form.role NEQ 2) || (role3 EQ "yes" && form.role NEQ 3)>
			
			<!--- Update faculty role --->
			<cfif form.role EQ 1>
				<cfquery>
					UPDATE FACULTY
					SET editor = 0, administrator = 0
					WHERE accounts_id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelseif form.role EQ 2>
				<cfquery>
					UPDATE FACULTY
					SET editor = 1, administrator = 0
					WHERE accounts_id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelseif form.role EQ 3>
				<cfquery>
					UPDATE FACULTY
					SET editor = 0, administrator = 1
					WHERE accounts_id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for email address --->
	<cfif isDefined("form.emailAddress") && !messageBean.hasErrors()>
		<cfset emailAddress=canonicalize(trim(form.emailAddress), true, true)>
		
		<cfif emailAddress NEQ qUserGetAccount.email>
			<cfif !IsValid("email", emailAddress)>
				<cfset messageBean.addError('The email address is not valid.', 'emailAddress')>
			<cfelse>
				
				<!--- Perform uniqueness validation on form fields --->
				<cfquery name="qUserCheckEmail">
					SELECT email
					FROM ACCOUNTS
					WHERE email = <cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar">
				</cfquery>
				
				<cfif qUserCheckEmail.RecordCount>
					<cfset messageBean.addError('This email address is already in use.', 'emailAddress')>
				<cfelse>
					
					<!--- Update email address --->
					<cfquery>
						UPDATE ACCOUNTS
						SET email = <cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for first name --->
	<cfif isDefined("form.firstName") && !messageBean.hasErrors()>
		<cfset firstName=canonicalize(trim(form.firstName), true, true)>
		
		<cfif firstName NEQ qUserGetAccount.first_name>
			
			<!--- Update first name --->
			<cfif len(trim(firstName))>
				<cfquery>
					UPDATE ACCOUNTS
					SET first_name = <cfqueryparam value="#firstName#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for last name --->
	<cfif isDefined("form.lastName") && !messageBean.hasErrors()>
		<cfset firstName=canonicalize(trim(form.lastName), true, true)>
		
		<cfif lastName NEQ qUserGetAccount.last_name>
			
			<!--- Update first name --->
			<cfif len(trim(lastName))>
				<cfquery>
					UPDATE ACCOUNTS
					SET last_name = <cfqueryparam value="#lastName#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for student ID --->
	<cfif isDefined("form.studentId") && !messageBean.hasErrors()>
		<cfif trim(form.studentId) NEQ qUserGetAccount.student_id>
			<cfif !IsValid("integer", trim(form.studentId))>
				<cfset messageBean.addError('Enter the student ID as a number with no spaces', 'studentId')>
			<cfelse>
				
				<!--- Perform uniqueness validation on form fields --->
				<cfquery name="qAccountCheckStudentId">
					SELECT student_id
					FROM STUDENTS
					WHERE student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
				</cfquery>
							
				<cfif qAccountCheckStudentId.RecordCount>
					<cfset messageBean.addError('This student ID is already in use.', 'studentId')>
				<cfelse>
					<!--- Looks good, so update student ID --->
					<cfquery>
						UPDATE STUDENTS
						SET student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
						WHERE accounts_id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update password --->
	<cfif isDefined("form.password") && !messageBean.hasErrors()>
		<cfif len(form.password)>
			<cfif !len(trim(form.password))>
				<cfset messageBean.addError('The new password cannot be blank.', 'password')>
			<cfelse>
				<cfif trim(form.password) NEQ trim(form.password2)>
					<cfset messageBean.addError('The passwords do not match.', 'password')>
				<cfelse>
					<!--- Update the password and change salt --->
					<cfset salt=Hash(GenerateSecretKey("AES"), "SHA-512")>
					<cfset password=Hash(trim(form.password) & salt, "SHA-512")>
					
					<cfquery>
						UPDATE ACCOUNTS
						SET salt = <cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar">,
							password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#qUserGetAccount.id#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Refresh form if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?edit=#URLDecode(url.edit)#">
	</cfif>
</cfif>

<!--- Display errors if they exist --->
<cfinclude template="model/editUser.cfm">
<cfreturn>