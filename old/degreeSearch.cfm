<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<cfinclude template="degrees/filters.cfm" >
		<section aria-label="Degree search" id="degreeSearch">
			<h2>Degree search</h2>
				<p>Provide some instructions on how the degree search works and initial steps to get started using the Advisor Services Portal.</p>
		</section>
		<cfinclude template="degrees/searchResults.cfm" >
    </body>
</html>