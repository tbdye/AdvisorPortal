<!--- Dashboard Controller --->
<!--- Thomas Dye, September 2016, February 2017 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qDashboardGetActivePlan">
	SELECT pla.id AS plans_id, pla.plan_name, deg.id AS degrees_id, deg.degree_name, deg.degree_type, col.id AS colleges_id, col.college_name, col.college_city
	FROM DEGREES deg, COLLEGES col, PLANS pla
	WHERE pla.id = (SELECT plans_id
		FROM PLAN_ACTIVEPLANS
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">)
	AND deg.id = (SELECT degrees_id
		FROM PLAN_SELECTEDDEGREES
		WHERE plans_id = (SELECT plans_id
			FROM PLAN_ACTIVEPLANS
			WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">))
	AND col.id = (SELECT colleges_id
		FROM DEGREES
		WHERE id = (SELECT degrees_id
			FROM PLAN_SELECTEDDEGREES
			WHERE plans_id = (SELECT plans_id
				FROM PLAN_ACTIVEPLANS
				WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">)))
</cfquery>

<!--- Get valid math and english courses if placement courses have not been entered --->
<cfquery name="qDashboardGetPlacementCourses">
	SELECT math_courses_id, english_courses_id
	FROM STUDENT_PLACEMENTCOURSES
	WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif !qDashboardGetPlacementCourses.RecordCount>
	<cfquery name="qDashboardGetMathCourses">
		SELECT id, course_number
		FROM COURSES
		WHERE use_catalog = 1
		AND course_number LIKE 'MATH%'
		ORDER BY course_number
	</cfquery>
	
	<cfquery name="qDashboardGetEnglishCourses">
		SELECT id, course_number
		FROM COURSES
		WHERE use_catalog = 1
		AND course_number LIKE 'ENGL%'
		ORDER BY course_number
	</cfquery>
</cfif>

<!--- Populate arrays to render display output --->
<cfif qDashboardGetActivePlan.RecordCount>
	<!--- Get all courses saved for this plan --->
	<cfquery name="qDashboardGetCourses">
		SELECT planSelectedCourses.id AS sc_id, planSelectedCourses.degree_categories_id, planSelectedCourses.credit,
			courses.id AS c_id, courses.course_number, courses.title, courses.min_credit, courses.max_credit, courses.departments_id,
			degreeCategories.category,
			degreeGraduationCourses.courses_id AS gc_id,
			studentCompletedCourses.id AS cc_id, studentCompletedCourses.credit AS cc_credit
		FROM PLAN_SELECTEDCOURSES planSelectedCourses
			JOIN COURSES courses
			ON planSelectedCourses.courses_id = courses.id
			JOIN DEGREE_CATEGORIES degreeCategories
			ON planSelectedCourses.degree_categories_id = degreeCategories.id
			LEFT JOIN (SELECT courses_id
				FROM DEGREE_GRADUATION_COURSES
				WHERE degrees_id = <cfqueryparam value="#qDashboardGetActivePlan.degrees_id#" cfsqltype="cf_sql_integer">) AS degreeGraduationCourses
			ON planSelectedCourses.courses_id = degreeGraduationCourses.courses_id
			LEFT JOIN (SELECT id, credit
				FROM STUDENTS_COMPLETEDCOURSES
				WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS studentCompletedCourses
			ON planSelectedCourses.completedcourses_id = studentCompletedCourses.id
		WHERE planSelectedCourses.plans_id = <cfqueryparam value="#qDashboardGetActivePlan.plans_id#" cfsqltype="cf_sql_integer">
		ORDER BY courses.id
	</cfquery>
	
	<cfquery name="qDashboardGetCategories">
		SELECT d.id, d.category
		FROM DEGREE_CATEGORIES d
		JOIN (SELECT DISTINCT plans_id, degree_categories_id
			FROM PLAN_SELECTEDCOURSES
			WHERE plans_id = <cfqueryparam value="#qDashboardGetActivePlan.plans_id#" cfsqltype="cf_sql_integer">) AS p
		ON d.id = p.degree_categories_id
		WHERE d.degrees_id = <cfqueryparam value="#qDashboardGetActivePlan.degrees_id#" cfsqltype="cf_sql_integer">
		ORDER BY
			CASE
				WHEN d.category = 'College Admission Courses' THEN '1'
				ELSE d.id
			END ASC
	</cfquery>
</cfif>

<!--- Define the placement courses "add" button action --->
<cfif isDefined("form.addPlacementButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.mathCourse EQ 0>
		<cfset messageBean.addError('Please select a math course.', 'mathCourse')>
	</cfif>
	<cfif form.englishCourse EQ 0>
		<cfset messageBean.addError('Please select an english course.', 'englishCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/dashboard.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so create record for placement courses --->
	<cfquery>
		INSERT INTO STUDENT_PLACEMENTCOURSES (
			students_accounts_id, math_courses_id, english_courses_id
		) VALUES (
			<cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.mathCourse#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.englishCourse#" cfsqltype="cf_sql_integer">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="./">
	</cfif>
</cfif>

<!--- Display page --->
<cfinclude template="model/dashboard.cfm">
<cfreturn>