<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<section aria-label="Account settings" id="accountSettings">
			<h2>Dashboard</h2>
				<p>Provide some instructions on how the account settings page works. Repeating for space, provide some instructions on how the account settings page works.</p>
		</section>
		<section aria-label="Update email" id="updateEmail">
			<h3>Update login</h3>
				<p>Information regarding this step</p>
				<form action="" method="get" autocomplete="off">
					<p>Current email:</p>
					<p>user@domain.tld</p>
					<label for="password">Password:</label>
					<input type="password" name="password" id="password"><br>
					<label for="email">New Email:</label>
					<input type="email" name="email" id="email"><br>
					<label for="email">Re-enter New Email:</label>
					<input type="email" name="email2" id="email2"><br>
					<input type="submit" value="Update email"><br>
				</form>
		</section>
		<section aria-label="Update password" id="updatePassword">
			<h3>Update password</h3>
				<p>Information regarding this step</p>
				<form action="" method="get" autocomplete="off">
					<label for="password">Current Password:</label>
					<input type="password" name="password" id="password"><br>
					<label for="password">New Password:</label>
					<input type="password" name="newPass" id="newPass"><br>
					<label for="password">Confirm Password:</label>
					<input type="password" name="newPass2" id="newPass2"><br>
					<input type="submit" value="Update password"><br>
				</form>
		</section>
		<section aria-label="Update identity" id="updateIdentity">
			<h3>Update identity</h3>
			<p>Information regarding this step</p>
				<form action="" method="get" autocomplete="on">
					<label for="firstName">First name:</label>
					<input type="text" name="firstName" id="firstName"><br>
					<label for="lastName">Last name:</label>
					<input type="text" name="lastName" id="lastName"><br>
					<label for="studentId">Student ID:</label>
					<input type="text" name="studentId" id="studentId"><br>
					<input type="submit" value="Update identity">
				</form>
		</section>
    </body>
</html>