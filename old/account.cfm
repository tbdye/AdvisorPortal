<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<section aria-label="Account settings" id="account">
			<h2>Dashboard</h2>
				<p>Provide some instructions on how the account settings page works. Repeating for space, provide some instructions on how the account settings page works.</p>
		</section>
		<cfinclude template="account/updateEmailForm.cfm" >
		<cfinclude template="account/updatePasswordForm.cfm" >
		<cfinclude template="account/updateIdentityForm.cfm" >
    </body>
</html>