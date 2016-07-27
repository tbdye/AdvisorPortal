<!--- Thomas Dye, July 2016 --->
<cfparam name="form.submitted" default="0" />
<cfparam name="form.redirectPage" default="index.cfm" />

<cfparam name="form.firstName" default="" />
<cfparam name="form.lastName" default="" />
<cfparam name="form.studentId" default="" />
<cfparam name="form.emailAddress" default="" />
<cfparam name="form.password" default="" />

<cfset errorBean=createObject('ASP.cfc.errorBean').init() />

<cfif form.submitted>
	<!--- Do data validation before submitting the form --->
	
	<cfif !len(trim(form.firstName))>
		<cfset errorBean.addError('A first name is required.', 'firstName') />
	</cfif>	
	
	<cfif !len(trim(form.lastName))>
		<cfset errorBean.addError('A last name is required.', 'lastName') />
	</cfif>	
	
	<cfif !len(trim(form.studentId))>
		<cfset errorBean.addError('A student ID is required.', 'studentId') />
	</cfif> <!--- Todo:  Need to also validate input format and if it is unique --->
	
	<cfif !len(trim(form.emailAddress))>
		<cfset errorBean.addError('An email address is required.', 'emailAddress') />
	<cfelse>
		<cfquery name="qEmailCheck">
			SELECT
				email
			FROM
				ACCOUNTS
			WHERE
				email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfif qEmailCheck.recordcount>
			<cfset errorBean.addError('This email address is already in use.', 'emailAddress') />
		</cfif>
	</cfif>
	
	<cfif !len(trim(form.password))>
		<cfset errorBean.addError('A password is required.', 'password') />
	</cfif>
	
	<cfif trim(form.password) neq trim(form.password2)>
		<cfset errorBean.addError('Passwords do not match.', 'password') />
	</cfif>
	
	<!--- If no errors, create account --->
	<cfif !errorBean.hasErrors()>
		<cfif len(trim(form.password))>
			<cfset salt=Hash(GenerateSecretKey("AES"), "SHA-512") />
			<cfset password = Hash(form.password & salt, "SHA-512") />
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
					<cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(form.firstName)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#trim(form.lastName)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#password#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar" />
				)
		</cfquery>
		<cfquery name="qGetID">
			SELECT
				id
			FROM
				ACCOUNTS
			WHERE
				email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfquery>
			INSERT INTO
				STUDENTS (
					accounts_id,
					student_id
				) VALUES (
					<cfqueryparam value="#qGetId.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#trim(form.studentId)#" cfsqltype="cf_sql_integer" />
				)
		</cfquery>
		
		<cfif qGetId.recordcount>
			<cfform>
				<p>Account created.</p>
				<cfinput type="submit" name="okButton" value="Ok">
				<input type="hidden" name="submitted" value="1" />
				<input type="hidden" name="redirectPage" value="#form.redirectPage#" />
			</cfform>
		</cfif>
	</cfif>
</cfif>

<!--- Display create account page content --->
<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Create Account"
	includenavbar="false">
	
	<h1>Create an account</h1>
	
	<cfform>
		<table>
			<tr>
				<td><label for="firstName">First name:</label></td>
				<td><cfinput type="text" id="firstName" name="firstName" value="#form.firstName#"></td>
			</tr>
			<tr>
				<td><label for="lastName">Last name:</label></td>
				<td><cfinput type="text" id="lastName" name="lastName" value="#form.lastName#"></td>
			</tr>
			<tr>
				<td><label for="studentId">Student ID:</label></td>
				<td><cfinput type="text" id="studentId" name="studentId" value="#form.studentId#"></td>
			</tr>
			<tr>
				<td><label for="emailAddress">Email address:</label></td>
				<td><cfinput type="text" id="emailAddress" name="emailAddress" value="#form.emailAddress#"></td>
			</tr>
			<tr>
				<td><label for="password">Password:</label></td>
				<td><cfinput type="password" id="password" name="password" value=""></td>
			</tr>
			<tr>
				<td><label for="password2">Confirm password:</label></td>
				<td><cfinput type="password" id="password2" name="password2" value=""></td>
			</tr>
		</table>
		<p>An email confirmation will be sent to you.</p> <!--- Todo:  implement this --->
		<cfinput type="submit" name="createButton" value="Create an account"></td>
		<input type="hidden" name="submitted" value="1" />
		<input type="hidden" name="redirectPage" value="#form.redirectPage#" />
	</cfform>
	
	<!--- Report errors encountered after form submission --->
	<cfif errorBean.hasErrors()>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>
<cfmodule template="../includes/footer.cfm">