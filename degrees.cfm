<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<section aria-label="Degree plans" id="degrees">
			<h2>Degree plans</h2>
				<p>Provide some instructions on how the degree planner works and initial steps to get started using the Advisor Services Portal.</p>
		</section>
		<cfinclude template="degrees/activePlan.cfm" >
		<cfinclude template="degrees/newPlan.cfm" >
		<cfinclude template="degrees/savedPlans.cfm" >
    </body>
</html>