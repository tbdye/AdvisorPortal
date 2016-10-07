<!--- Application Controller --->
<!--- Thomas Dye, August 2016 --->
<cfcomponent>
	<cfset this.name='AdvisorPortal'>
	<cfset this.datasource='advisorPortal'>
	<cfset this.applicationTimeout=CreateTimeSpan(10, 0, 0, 0)>
	<cfset this.sessionManagement=true>
	<cfset this.sessionTimeout=CreateTimeSpan(0, 0, 30, 0)>
	<cfset this.loginStorage='session'>
	<cfset this.invokeImplicitAccessor=true>
	<cfset this.sessionCookie.httpOnly=true>
	<cfset this.sessionCookie.timeout='10'>
	<cfset this.sessionCookie.disableupdate=true>
	<cfset this.mappings['cfcMapping'] = "/AdvisorPortal/cfc" />
	
	<!--- Intercept all page requests by website users --->
	<cffunction name="onRequest">
		<cfargument name="templatename">

		<!--- Display the login form if users aren't logged in. --->
		<cflogin>
			<cfset messageBean=createObject('cfc.messageBean').init()>
			<cfset StructClear(session)>
			
			<!--- Define form action for "Log in" button. --->
			<cfif isDefined("form.loginButton")>
				
				<!--- Perform simple validation on form fields --->
				<cfif !len(trim(form.emailAddress))>
					<cfset messageBean.addError('An email address is required.', 'emailAddress')>
				<cfelseif !IsValid("email", trim(form.emailAddress))>
					<cfset messageBean.addError('The email address is not valid.', 'emailAddress')>
				</cfif>
				
				<cfif !len(trim(form.password))>
					<cfset messageBean.addError('A password is required.', 'password')>
				</cfif>
				
				<!--- Stop here if errors were detected --->
				<cfif messageBean.hasErrors()>
					<cfinclude template="login.cfm">
					<cfreturn>
				</cfif>
				
				<!--- Find the account, if exists --->
				<cftry>
					<!--- Try to contact the database --->
					<cfquery name="qLoginGetAccount">
						SELECT id, active, first_name, last_name, email, password, salt
						FROM ACCOUNTS
						WHERE email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfcatch type="database">
						<!--- If the connection timed out silently, try again --->
						<cftry>
							<cfquery name="qLoginGetAccount">
								SELECT id, active, first_name, last_name, email, password, salt
								FROM ACCOUNTS
								WHERE email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfcatch type="database">
								<!--- Generate a friendly error message and give up --->
								<cfset messageBean.addError('The server is not responding.  Please try again later.', 'email')>
								<cfinclude template="login.cfm">
								<cfreturn>
							</cfcatch>
						</cftry>
					</cfcatch>
				</cftry>
				
				<!--- Check password.  If does not match, fail.  Otherwise, evaluate student or faculty account --->
				<cfif !qLoginGetAccount.RecordCount || qLoginGetAccount.password NEQ Hash(form.password & qLoginGetAccount.salt, "SHA-512")>
					<!--- The user login credentials were incorrect, so stop here --->
					<cfset messageBean.addError('User or password were incorrect; please try again', 'email')>
					<cfinclude template="login.cfm">
					<cfreturn>
				<cfelseif !qLoginGetAccount.active>
					<!--- The user account is deactivated, so stop here --->
					<cfset messageBean.addError('The account could not be loaded; please contact the administrator.', 'email')>
					<cfinclude template="login.cfm">
					<cfreturn>
				<cfelse>
					<cfquery name="qLoginGetStudent">
				      	SELECT accounts_id, student_id
				  		FROM STUDENTS
				  		WHERE accounts_id = <cfqueryparam value="#qLoginGetAccount.id#" cfsqltype="cf_sql_integer">
				    </cfquery>
				    <cfif qLoginGetStudent.RecordCount>
				    	<!--- Found student record, so log in --->
				    	<cfloginuser name="#qLoginGetAccount.id#" password="#form.password#" roles="student">
				    	<cfset session.loginId="#qLoginGetAccount.id#">
				    	<cfset session.loginName="#qLoginGetAccount.first_name# #qLoginGetAccount.last_name#">
						<cfset session.accountId="#qLoginGetStudent.accounts_id#">
						<cfset session.studentId="#qLoginGetStudent.student_id#">
						<cfset session.studentName="#qLoginGetAccount.first_name# #qLoginGetAccount.last_name#">
				    <cfelse>
				    	<cfquery name="qLoginGetFaculty">
					      	SELECT accounts_id, editor, administrator
				      		FROM FACULTY
				      		WHERE accounts_id = <cfqueryparam value="#qLoginGetAccount.id#" cfsqltype="cf_sql_integer">
					    </cfquery>
				
				    	<cfif qLoginGetFaculty.RecordCount && qLoginGetFaculty.administrator>
				    		<!--- Log in as a faculty administrator --->
				    		<cfloginuser name="#qLoginGetAccount.id#" password="#form.password#" roles="administrator,editor,advisor">
				    		<cfset session.loginId="#qLoginGetAccount.id#">
				    		<cfset session.loginName="#qLoginGetAccount.first_name# #qLoginGetAccount.last_name#">
				    	<cfelseif qLoginGetFaculty.RecordCount && qLoginGetFaculty.editor>
				    		<!--- Log in as a faculty editor --->
				    		<cfloginuser name="#qLoginGetAccount.id#" password="#form.password#" roles="editor,advisor">
				    		<cfset session.loginId="#qLoginGetAccount.id#">
				    		<cfset session.loginName="#qLoginGetAccount.first_name# #qLoginGetAccount.last_name#">
				    	<cfelseif qLoginGetFaculty.RecordCount>
				    		<!--- Log in as a faculty advisor --->
				    		<cfloginuser name="#qLoginGetAccount.id#" password="#form.password#" roles="advisor">
				    		<cfset session.loginId="#qLoginGetAccount.id#">
				    		<cfset session.loginName="#qLoginGetAccount.first_name# #qLoginGetAccount.last_name#">
				    	<cfelse>
				    		<!--- An account record exists, but a faculty record does not, so stop here --->
				    		<cfset messageBean.addError('The account could not be loaded; please contact the administrator.', 'accounts_id')>
				    		<cfinclude template="login.cfm">
							<cfreturn>
				    	</cfif>
				    </cfif>
				</cfif>
			
			<!--- Define form action for "Create an account" button. --->
			<cfelseif isDefined("form.createButton")>
				
				<!--- Perform simple validation on form fields --->
				<cfif !len(trim(form.firstName))>
					<cfset messageBean.addError('A first name is required.', 'firstName')>
				</cfif>
				
				<cfif !len(trim(form.lastName))>
					<cfset messageBean.addError('A last name is required.', 'lastName')>
				</cfif>
				
				<cfif !len(trim(form.studentId))>
					<cfset messageBean.addError('A student ID number is required.', 'studentId')>
				<cfelseif !IsValid("integer", trim(form.studentId))>
					<cfset messageBean.addError('Enter the student ID as a number with no spaces', 'studentId')>
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
					<cfinclude template="login.cfm">
					<cfreturn>
				</cfif>
				
				<!--- Perform uniqueness validation on form fields --->
				<cftry>
					<!--- Try to contact the database --->
					<cfquery name="qLoginCheckStudentId">
						SELECT accounts_id, student_id
						FROM STUDENTS
						WHERE student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfcatch type="database">
						<!--- If the connection timed out silently, try again --->
						<cftry>
							<cfquery name="qLoginCheckStudentId">
								SELECT accounts_id, student_id
								FROM STUDENTS
								WHERE student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfcatch type="database">
								<!--- Generate a friendly error message and give up --->
								<cfset messageBean.addError('The server is not responding.  Please try again later.', 'studentId')>
								<cfinclude template="login.cfm">
								<cfreturn>
							</cfcatch>
						</cftry>
					</cfcatch>
				</cftry>
				
				<cfquery name="qLoginCheckEmail">
					SELECT email
					FROM ACCOUNTS
					WHERE email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
				</cfquery>
				
				<cfif qLoginCheckStudentId.RecordCount>
					<cfset messageBean.addError('This student ID is already in use.', 'studentId')>
				<cfelseif qLoginCheckEmail.RecordCount>
					<cfset messageBean.addError('This email address is already in use.', 'emailAddress')>
				</cfif>
				
				<!--- Stop here if errors were detected --->
				<cfif messageBean.hasErrors()>
					<cfinclude template="login.cfm">
					<cfreturn>
				</cfif>
				
				<!--- Looks good, so create account --->
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
				<cfquery name="qLoginGetAccount">
					SELECT id, first_name, last_name, email, password, salt
					FROM ACCOUNTS
					WHERE email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfquery>
					INSERT INTO	STUDENTS (
						accounts_id, student_id)
					VALUES (
						<cfqueryparam value="#qLoginGetAccount.id#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
					)
				</cfquery>
				<cfquery name="qLoginGetStudent">
					SELECT accounts_id, student_id
					FROM STUDENTS
					WHERE accounts_id = <cfqueryparam value="#qLoginGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<!--- Log in the user in if the account was created successfully --->
				<cfif qLoginGetStudent.RecordCount>
					<cfloginuser name="#qLoginGetAccount.id#" password="#form.password#" roles="student">
					<cfset session.loginId="#qLoginGetAccount.id#">
					<cfset session.loginName="#qLoginGetAccount.first_name# #qLoginGetAccount.last_name#">
					<cfset session.accountId="#qLoginGetStudent.accounts_id#">
					<cfset session.studentId="#qLoginGetStudent.student_id#">
					<cfset session.studentName="#qLoginGetAccount.first_name# #qLoginGetAccount.last_name#">
				<cfelse>
					<cfset messageBean.addError('Unable to create account.', 'emailAddress')>
				</cfif>
			
			<!--- Display default landing page. --->
			<cfelse>
				<cfinclude template="login.cfm">
				<cfreturn>
			</cfif>
		</cflogin>
		
		<cfinclude template="#arguments.templatename#">
		
	</cffunction>
</cfcomponent>