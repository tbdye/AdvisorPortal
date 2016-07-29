<!--- Thomas Dye, July 2016 --->
<cfcomponent>
	<cfset this.name='AdvisorPortal'>
	<cfset this.datasource='advisorPortal'>
	<cfset this.applicationTimeout=CreateTimeSpan(10, 0, 0, 0)>
	<cfset this.sessionManagement=true>
	<cfset this.sessionTimeout=CreateTimeSpan(0, 0, 30, 0)>
	<cfset this.loginStorage='session'>
	<cfset this.ormEnabled=true>
	<cfset this.ormSettings={logsql=true, cfclocation="model/orm"}>
	<cfset this.invokeImplicitAccessor=true>
	<cfset this.sessionCookie.httpOnly=true>
	<cfset this.sessionCookie.timeout='10'>
	<cfset this.sessionCookie.disableupdate=true>
	
	<!--- Intercept all page requests by website users --->
	<cffunction name="onRequest">
		<cfargument name="templatename">

		<!--- Display the login form if users aren't logged in. --->
		<cflogin>
			<cfset errorBean=createObject('ASP.cfc.errorBean').init()>
			<cfset StructClear(session)>
			
			<!--- Define form action for "Log in" button. --->
			<cfif isDefined("form.loginButton")>
				
				<!--- Perform simple validation on form fields --->
				<cfif !len(trim(form.emailAddress))>
					<cfset errorBean.addError('An email address is required.', 'emailAddress')>
				<cfelseif !IsValid("email", trim(form.emailAddress))>
					<cfset errorBean.addError('The email address is not valid.', 'emailAddress')>
				</cfif>
				
				<cfif !len(trim(form.password))>
					<cfset errorBean.addError('A password is required.', 'password')>
				</cfif>
				
				<!--- Stop here if errors were detected --->
				<cfif errorBean.hasErrors()>
					<cfinclude template="login/login.cfm">
					<cfreturn>
				</cfif>
				
				<!--- Find the account, if exists --->
				<cfquery name="qGetAccount">
					SELECT
						id,
						first_name,
						last_name,
						email,
						password,
						salt
					FROM
						ACCOUNTS
					WHERE
						email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
				</cfquery>
				
				<!--- Check password.  If does not match, fail.  Otherwise, evaluate student or faculty account --->
				<cfif !qGetAccount.RecordCount || qGetAccount.password NEQ Hash(form.password & qGetAccount.salt, "SHA-512")>
					<!--- The user login credentials were incorrect, so stop here --->
					<cfset errorBean.addError('User or password were incorrect; please try again', 'email')>
					<cfinclude template="login/login.cfm">
					<cfreturn>
				<cfelse>
					<cfquery name="qGetStudent">
				      	SELECT
				      		accounts_id,
				      		student_id
				  		FROM
				  			STUDENTS
				  		WHERE
				  			accounts_id = <cfqueryparam value="#qGetAccount.id#" cfsqltype="cf_sql_integer">
				    </cfquery>
				    <cfif qGetStudent.RecordCount>
				    	<!--- Found student record, so log in --->
				    	<cfloginuser name="#qGetAccount.first_name# #qGetAccount.last_name#" password="#form.password#" roles="student">
				    	<cfset session.accountId="#qGetAccount.id#">
						<cfset session.studentId="#qGetStudent.student_id#">
						<cfset session.studentName="#qGetAccount.first_name# #qGetAccount.last_name#">
				    <cfelse>
				    	<cfquery name="qGetFaculty">
					      	SELECT
					      		accounts_id,
					      		editor,
					      		administrator
				      		FROM
				      			FACULTY
				      		WHERE
				      			accounts_id = <cfqueryparam value="#qGetAccount.id#" cfsqltype="cf_sql_integer">
					    </cfquery>
				
				    	<cfif qGetFaculty.RecordCount && qGetFaculty.administrator>
				    		<!--- Log in as a faculty administrator --->
				    		<cfloginuser name="#qGetAccount.first_name# #qGetAccount.last_name#" password="#form.password#" roles="administrator,editor,advisor">
				    		<cfset session.accountId="#qGetAccount.id#">
				    	<cfelseif qGetFaculty.RecordCount && qGetFaculty.editor>
				    		<!--- Log in as a faculty editor --->
				    		<cfloginuser name="#qGetAccount.first_name# #qGetAccount.last_name#" password="#form.password#" roles="editor,advisor">
				    		<cfset session.accountId="#qGetAccount.id#">
				    	<cfelseif qGetFaculty.RecordCount>
				    		<!--- Log in as a faculty advisor --->
				    		<cfloginuser name="#qGetAccount.first_name# #qGetAccount.last_name#" password="#form.password#" roles="advisor">
				    		<cfset session.accountId="#qGetAccount.id#">
				    	<cfelse>
				    		<!--- An account record exists, but a faculty record does not, so stop here --->
				    		<cfset errorBean.addError('The account could not be loaded; please contact the administrator.', 'accounts_id')>
				    		<cfinclude template="login/login.cfm">
							<cfreturn>
				    	</cfif>
				    </cfif>
				</cfif>
			
			<!--- Define form action for "Create an account" button. --->
			<cfelseif isDefined("form.createButton")>
				
				<!--- Perform simple validation on form fields --->
				<cfif !len(trim(form.firstName))>
					<cfset errorBean.addError('A first name is required.', 'firstName')>
				</cfif>
				
				<cfif !len(trim(form.lastName))>
					<cfset errorBean.addError('A last name is required.', 'lastName')>
				</cfif>
				
				<cfif !len(trim(form.studentId))>
					<cfset errorBean.addError('A student ID number is required.', 'studentId')>
				<cfelseif !IsValid("integer", trim(form.studentId))>
					<cfset errorBean.addError('Enter the student ID as a number with no spaces', 'studentId')>
				</cfif>
				
				<cfif !len(trim(form.emailAddress))>
					<cfset errorBean.addError('An email address is required.', 'emailAddress')>
				<cfelseif !IsValid("email", trim(form.emailAddress))>
					<cfset errorBean.addError('The email address is not valid.', 'emailAddress')>
				</cfif>
				
				<cfif !len(trim(form.password))>
					<cfset errorBean.addError('A password is required.', 'password')>
				<cfelseif trim(form.password) NEQ trim(form.password2)>
					<cfset errorBean.addError('The passwords do not match.', 'password')>
				</cfif>
				
				<!--- Stop here if errors were detected --->
				<cfif errorBean.hasErrors()>
					<cfinclude template="login/login.cfm">
					<cfreturn>
				</cfif>
				
				<!--- Perform uniqueness validation on form fields --->
				<cfquery name="qCheckStudentId">
					SELECT
						accounts_id,
						student_id
					FROM
						STUDENTS
					WHERE
						student_id = <cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="qCheckEmail">
					SELECT
						email
					FROM
						ACCOUNTS
					WHERE
						email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
				</cfquery>
				
				<cfif qCheckStudentId.RecordCount>
					<cfset errorBean.addError('This student ID is already in use.', 'studentId')>
				<cfelseif qCheckEmail.RecordCount>
					<cfset errorBean.addError('This email address is already in use.', 'emailAddress')>
				</cfif>
				
				<!--- Stop here if errors were detected --->
				<cfif errorBean.hasErrors()>
					<cfinclude template="login/login.cfm">
					<cfreturn>
				</cfif>
				
				<!--- Looks good, so create account --->
				<cfif len(trim(form.password))>
					<cfset salt=Hash(GenerateSecretKey("AES"), "SHA-512")>
					<cfset password = Hash(form.password & salt, "SHA-512")>
				</cfif>
				
				<cfquery>
					INSERT INTO
						ACCOUNTS (
							email,
							first_name,
							last_name,
							password,
							salt
						) VALUES (
							<cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#trim(form.firstName)#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#trim(form.lastName)#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar">
						)
				</cfquery>
				<cfquery name="qGetAccount">
					SELECT
						id,
						first_name,
						last_name,
						email,
						password,
						salt
					FROM
						ACCOUNTS
					WHERE
						email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfquery>
					INSERT INTO
						STUDENTS (
							accounts_id,
							student_id
						) VALUES (
							<cfqueryparam value="#qGetAccount.id#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer">
						)
				</cfquery>
				<cfquery name="qGetStudent">
					SELECT
						student_id
					FROM
						STUDENTS
					WHERE
						accounts_id = <cfqueryparam value="#qGetAccount.id#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<!--- Log in the user in if the account was created successfully --->
				<cfif qGetStudent.RecordCount>
					<cfloginuser name="#qGetAccount.first_name# #qGetAccount.last_name#" password="#form.password#" roles="student">
					<cfset session.accountId="#qGetAccount.id#">
					<cfset session.studentId="#qGetStudent.student_id#">
					<cfset session.studentName="#qGetAccount.first_name# #qGetAccount.last_name#">
				<cfelse>
					<cfset errorBean.addError('Unable to create account.', 'emailAddress')>
				</cfif>
			
			<!--- Display default landing page. --->
			<cfelse>
				<cfinclude template="login/login.cfm">
				<cfreturn>
			</cfif>
		</cflogin>
		
		<cfinclude template="#arguments.templatename#">
		
	</cffunction>
</cfcomponent>