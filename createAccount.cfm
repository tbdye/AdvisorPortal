<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="account/disclaimer.cfm" >
		<form action="" method="get" autocomplete="on" >
			<label for="firstName">First name:</label>
			<input type="text" name="firstName" id="firstName"><br>
			<label for="lastName">Last name:</label>
			<input type="text" name="lastName" id="lastName"><br>
			<label for="studentId">Student ID:</label>
			<input type="text" name="studentId" id="studentId"><br>
			<label for="email">Email address:</label>
			<input type="email" name="email" id="email"><br>
			<label for="password">Password:</label>
			<input type="password" name="password" id="password"><br>
			<label for="password2">Confirm password:</label>
			<input type="password" name="password2" id="password2">
			<p>An email confirmation will be sent to you.</p>
			<input type="submit" value="Create an account">
		</form>
    </body>
</html>