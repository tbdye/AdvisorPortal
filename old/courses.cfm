<!--- Thomas Dye, July 2016 --->
<!doctype html>
<html>
	<cfinclude template="styles/default.cfm" >
    <body>
		<cfinclude template="common/header.cfm" >
		<cfinclude template="common/navbar.cfm" >
		<section aria-label="Completed courses" id="courses">
			<h2>Completed courses<!--- for User Name---></h2>
				<p>Provide some instructions on how the completed courses section works and initial steps to get started using the Advisor Services Portal.</p>
		</section>
		<cfinclude template="courses/addCourse.cfm" >
		<cfinclude template="courses/viewCourses.cfm" >
    </body>
</html>