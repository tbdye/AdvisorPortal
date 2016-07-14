<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="account/disclaimer.cfm" >
		<form action="" method="get" autocomplete="on" >
			<label for="email">Email:</label>
			<input type="email" name="email" id="email"><br>
			<label for="password">Password:</label>
			<input type="password" name="password" id="password"><br>
			<input type="checkbox" name="rememberMe" id="rememberMe" value="rememberMe">
			<label for="rememberMe">Remember me</label><br>
			<input type="submit" value="Log in"><br>
		</form>
		<a href="recover.cfm" title="Recover password">Forgot your password?</a><br>
		<p>First time user?</p>
		<input type="button" name="signUpButton" value="Sign up">
    </body>
</html>