<!--- Create Plan Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Run when external page asks to create a degree plan --->
<cfif isDefined("url.degree") && isDefined("url.id") && IsNumeric("#URLDecode(url.id)#")>
	<!--- Validate url variables --->
	<cfquery name="qCheckDegree">
		SELECT id, degree_name, colleges_id
		FROM DEGREES
		WHERE use_catalog = 1
		AND id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
		AND degree_name = <cfqueryparam value="#url.degree#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif qCheckDegree.RecordCount>
		<cfset form.addDegreeButton = "Select">
		<cfset form.collegeId = qCheckDegree.colleges_id>
		<cfset form.degreeId = qCheckDegree.id>
		<cfset form.degreeName = qCheckDegree.degree_name>
	</cfif>
</cfif>

<!--- Define action for degree "select" button from search results --->
<cfif isDefined("form.addDegreeButton")>
	<!--- Create a student plan --->
	<cfquery>
		INSERT INTO PLANS (
			students_accounts_id, plan_name
		) VALUES (
			<cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.degreeName#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
	
	<!--- Retrieve the new plan ID --->
	<cfquery name=qGetPlan>
		SELECT @@identity AS id
		FROM PLANS
	</cfquery>
	
	<!--- Associate the degree with the new plan --->
	<cfquery>
		INSERT INTO PLAN_SELECTEDDEGREES (
			plans_id, degrees_id
		) VALUES (
			<cfqueryparam value="#qGetPlan.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.degreeId#" cfsqltype="cf_sql_integer">
		)
	</cfquery>
	
	<!--- Get all available admission and graduation courses for this college and degree --->
	<cfquery name=qGetCourses>
		SELECT cou.id, col.categories_id, cou.min_credit, cou.max_credit
		FROM COURSES cou
		JOIN COLLEGE_ADMISSION_COURSES col
		ON cou.id = col.courses_id
		WHERE cou.use_catalog = 1
		AND col.colleges_id = <cfqueryparam value="#form.collegeId#" cfsqltype="cf_sql_integer">
		UNION
		SELECT cou.id, deg.categories_id, cou.min_credit, cou.max_credit
		FROM COURSES cou
		JOIN DEGREE_ADMISSION_COURSES deg
		ON cou.id = deg.courses_id
		WHERE cou.use_catalog = 1
		AND deg.degrees_id = <cfqueryparam value="#form.degreeId#" cfsqltype="cf_sql_integer">
		UNION
		SELECT cou.id, deg.categories_id, cou.min_credit, cou.max_credit
		FROM COURSES cou
		JOIN DEGREE_GRADUATION_COURSES deg
		ON cou.id = deg.courses_id
		WHERE cou.use_catalog = 1
		AND deg.degrees_id = <cfqueryparam value="#form.degreeId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Add available courses to plan --->
	<cfif qGetCourses.RecordCount>
		<cfloop query="qGetCourses">
			<cfquery>
				INSERT INTO PLAN_SELECTEDCOURSES (
					plans_id, courses_id, categories_id, credit
				) VALUES (
					<cfqueryparam value="#qGetPlan.id#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#qGetCourses.id#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#qGetCourses.categories_id#" cfsqltype="cf_sql_integer">,
					<cfif len(qGetCourses.min_credit)>
						NULL
					<cfelse>
						<cfqueryparam value="#qGetCourses.max_credit#" cfsqltype="cf_sql_decimal">
					</cfif>
				)
			</cfquery>
		</cfloop>
	</cfif>
	
	<!--- If the student has no active plans, make this the active plan --->
	<cfquery name=qCheckActivePlans>
		SELECT plans_id
		FROM PLAN_ACTIVEPLANS
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif !qCheckActivePlans.RecordCount>
		<cfquery>
			INSERT INTO PLAN_ACTIVEPLANS (
				plans_id, students_accounts_id
			) VALUES (
				<cfqueryparam value="#qGetPlan.id#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
			)
		</cfquery>
	</cfif>
	
	<!--- Clear the session state for plan creation --->
	<cfset StructDelete(session, "searchFilter")>
	<cfset StructDelete(session, "aColleges")>
	<cfset StructDelete(session, "aDepartments")>
	
	<!--- Redirect to the edit plan page for user confirmation --->
	<cflocation url="../edit/?plan=#URLEncodedFormat(qGetPlan.id)#">
</cfif>

<!--- Prepare filter lists --->
<cfquery name="qSearchGetAllColleges">
	SELECT id, college_name, college_city
	FROM COLLEGES
	WHERE use_catalog = 1
	ORDER BY college_name
</cfquery>

<cfquery name="qSearchGetPopularColleges">
	SELECT c.id, c.college_name, c.college_city, r.rank
	FROM COLLEGES c
	JOIN COLLEGE_RANKINGS r
	ON c.id = r.colleges_id
	WHERE c.use_catalog = 1
	ORDER BY r.rank DESC
</cfquery>

<cfquery name="qSearchGetAllDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	WHERE use_catalog = 1
	ORDER BY department_name
</cfquery>

<cfquery name="qSearchGetPopularDepartments">
	SELECT d.id, d.department_name, r.rank
	FROM DEPARTMENTS d
	JOIN DEPARTMENT_RANKINGS r
	ON d.id = r.departments_id
	WHERE d.use_catalog = 1
	ORDER BY r.rank DESC
</cfquery>

<!--- Define action for degree name "search" button --->
<cfif isDefined("form.searchButton")>
	<cfif isDefined("form.searchTerm") && len(trim(form.searchTerm))>
		<cfset session.searchFilter = form.searchTerm>
	<cfelse>
		<cfset StructDelete(session, "searchFilter")>
	</cfif>
</cfif>

<!--- Define action for colleges filter list "update" button --->
<cfif isDefined("form.filterCollegesButton")>
	<cfif isDefined("form.filterCollege")>
		<cfset session.aColleges = ListToArray(form.filterCollege)>
	<cfelse>
		<cfset StructDelete(session, "aColleges")>
	</cfif>
</cfif>

<!--- Define action for departments filter list "update" button --->
<cfif isDefined("form.filterDepartmentsButton")>
	<cfif isDefined("form.filterDepartment")>
		<cfset session.aDepartments = ListToArray(form.filterDepartment)>
	<cfelse>
		<cfset StructDelete(session, "aDepartments")>
	</cfif>
</cfif>

<!--- Build query to display search results --->
<cfquery name="qSearchGetFilteredDegrees">
	SELECT d.id, d.degree_name, d.degree_type, d.colleges_id, c.college_name, c.college_city
	FROM DEGREES d
	JOIN COLLEGES c
	ON d.colleges_id = c.id
	FULL JOIN DEGREE_RANKINGS r ON d.id = r.degrees_id
	WHERE d.use_catalog = 1
	AND c.use_catalog = 1
	<cfif isDefined("session.searchFilter")>
		AND d.degree_name LIKE <cfqueryparam value="%#trim(session.searchFilter)#%" cfsqltype="cf_sql_varchar">
	</cfif>
	<cfif isDefined("session.aColleges")>
		AND colleges_id IN (SELECT colleges_id FROM DEGREES WHERE
		<cfloop from="1" to="#arrayLen(session.aColleges)#" index="i">
			<cfif #i# EQ 1>
				 colleges_id = #session.aColleges[i]#
			<cfelse>
				OR colleges_id = #session.aColleges[i]#
			</cfif>
		</cfloop>
		)
	</cfif>
	<cfif isDefined("session.aDepartments")>
		AND departments_id IN (SELECT departments_id FROM DEGREES WHERE
		<cfloop from="1" to="#arrayLen(session.aDepartments)#" index="i">
			<cfif #i# EQ 1>
				departments_id = #session.aDepartments[i]#
			<cfelse>
				OR departments_id = #session.aDepartments[i]#
			</cfif>
		</cfloop>
		)
	</cfif>
	ORDER BY r.rank DESC
</cfquery>

<!--- Load page --->
<cfinclude template="model/createPlan.cfm">
<cfreturn>