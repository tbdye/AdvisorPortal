<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<section aria-label="Degree plans" id="degrees">
			<h2>Degree plans<!--- for User Name---></h2>
				<p>Provide some instructions on how the degree planner works and initial steps to get started using the Advisor Services Portal.</p>
		</section>
		<cfinclude template="degrees/activePlan.cfm" >
		<section aria-label="Create a new degree plan" id="newPlan">
			<h3>Create a new degree plan</h3>
			<input type="button" value="Create">
		</section>
		<cfinclude template="degrees/savedPlans.cfm" >
    </body>
</html>