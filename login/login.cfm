<!--- Thomas Dye, July 2016 --->
<cfparam name="form.submitted" default="0" />
<cfparam name="form.emailAddress" default="" />
<cfparam name="form.redirectPage" default="index.cfm" />

<cfset errorBean=createObject('ASP.cfc.errorBean').init() />

<cfif form.submitted>
	
	<!--- If exists, store the query result for analysis--->
	<cfquery name="qLoginCheck">
		SELECT
			id,
			email,
			password,
			salt
		FROM
			ACCOUNTS
		WHERE
			email = <cfqueryparam value="#trim(form.emailAddress)#" cfsqltype="cf_sql_varchar" />
	</cfquery>	
	
	<!--- Check password.  If does not match, fail.  Otherwise, initalize user session --->
	<cfif !qLoginCheck.recordcount || qLoginCheck.password NEQ Hash(form.password & qLoginCheck.salt, "SHA-512")>
		<cfset errorBean.addError('Login incorrect', 'email') />
	<cfelse>
		<cfset session.userID = qLoginCheck.id />
		<cfset session.emailAddress = qLoginCheck.email />
		<cfset sessionRotate() />
		<cflocation url="#form.redirectPage#" addToken="no" />
	</cfif>
</cfif>	

<!--- Display login page content --->
<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Log in"
	includenavbar="false">
	
	<h1>Please log in</h1>
	
	<cfform>
		<table>
			<tr>
				<td><label for="emailAddress">Email:</label></td>
				<td><cfinput type="text" id="emailAddress" name="emailAddress" value="#form.emailAddress#"></td>
			</tr>
			<tr>
				<td><label for="password">Password:</label></td>
				<td><cfinput type="password" id="password" name="password" value=""></td>
			</tr>
			<tr>
				<td></td>
				<td><cfinput type="submit" name="loginButton" value="Log in"></td>
			</tr>
		</table>
		<input type="checkbox" name="rememberMe" id="rememberMe" value="rememberMe"> <!--- Todo:  Hook this up --->
		<label for="rememberMe">Remember me</label>
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
	
	<p>First time user?</p>
	<a href="../home/signup.cfm" title="Sign up">Sign up</a>
	
<cfmodule template="../includes/footer.cfm">