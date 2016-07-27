<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<section aria-label="Advise student" id="advise">
			<h2>Advise student</h2>
				<p>Provide some instructions on how the advisor student selector works and initial steps to get started using the Advisor Services Portal.</p>
		</section>
		<cfinclude template="advisor/lookupStudent.cfm" >
		<cfinclude template="advisor/viewStudents.cfm" >
    </body>
</html>