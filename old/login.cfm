<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="account/disclaimer.cfm" >
		<cfinclude template="account/loginForm.cfm" >
		<a href="recover.cfm" title="Recover password">Forgot your password?</a>
		<p>First time user?</p>
		<input type="button" name="signUpButton" value="Sign up">
    </body>
</html>