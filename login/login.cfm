<!--- Thomas Dye, July 2016 --->
<cfmodule template="../includes/header.cfm"
	pagetitle = "Advisor Services Portal - Log in"
	includenavbar="false">
	
    <h1>Please Log In</h1>
    
    <cfform>
		<table>
			<tr>
				<td><label for="emailAddress">Email:</label></td>
				<td><cfinput type="text" id="emailAddress" name="emailAddress"></td>
			</tr>
			<tr>
				<td><label for="password">Password:</label></td>
				<td><cfinput type="password" id="password" name="password"></td>
			</tr>
			<tr>
				<td></td>
				<td><cfinput type="submit" name="loginButton" value="Log in"></td>
			</tr>
		</table>
		<input type="checkbox" name="rememberMe" id="rememberMe" value="rememberMe"> <!--- Todo:  Hook this up --->
		<label for="rememberMe">Remember me</label>
	</cfform>
    
    <cfif errorBean.hasErrors() && isDefined("form.loginButton")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>
	
	<h1>First time user?</h1>
	
	<cfform>
		<table>
			<tr>
				<td><label for="firstName">First name:</label></td>
				<td><cfinput type="text" id="firstName" name="firstName"></td>
			</tr>
			<tr>
				<td><label for="lastName">Last name:</label></td>
				<td><cfinput type="text" id="lastName" name="lastName"></td>
			</tr>
			<tr>
				<td><label for="studentId">Student ID:</label></td>
				<td><cfinput type="text" id="studentId" name="studentId"></td>
			</tr>
			<tr>
				<td><label for="emailAddress">Email address:</label></td>
				<td><cfinput type="text" id="emailAddress" name="emailAddress"></td>
			</tr>
			<tr>
				<td><label for="password">Password:</label></td>
				<td><cfinput type="password" id="password" name="password"></td>
			</tr>
			<tr>
				<td><label for="password2">Confirm password:</label></td>
				<td><cfinput type="password" id="password2" name="password2"></td>
			</tr>
		</table>
		<p>An email confirmation will be sent to you.</p> <!--- Todo:  implement this later --->
		<cfinput type="submit" name="createButton" value="Create an account"></td>
	</cfform>
	
	<cfif errorBean.hasErrors() && isDefined("form.createButton")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>
    
<cfmodule template="../includes/footer.cfm">