<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<section aria-label="Dashboard" id="dashboard">
			<h2>Dashboard<!--- for User Name---></h2>
				<p>Provide some instructions on how the dashboard works and initial steps to get started using the Advisor Services Portal.</p>
		</section>
		<!---<cfinclude template="dashboard/gettingStarted.cfm" >--->
		<cfinclude template="degrees/activePlan.cfm" >
		<cfinclude template="dashboard/schedule.cfm" >
		<cfinclude template="dashboard/planner.cfm" >
    </body>
</html>