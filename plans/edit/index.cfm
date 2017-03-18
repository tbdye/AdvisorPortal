<!--- Edit Plan Controller --->
<!--- Thomas Dye, September 2016, February 2017 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student"))>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Do basic validation --->
<cfif !isDefined("url.plan") || !IsNumeric("#URLDecode(url.plan)#")>
	<cflocation url="..">
</cfif>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetPlan">
	SELECT p.id, p.plan_name, s.degrees_id, d.degree_name, d.colleges_id, c.college_name, c.college_city, d.degree_type
	FROM PLANS p, PLAN_SELECTEDDEGREES s, DEGREES d, COLLEGES c
	WHERE p.id = s.plans_id
	AND d.id = s.degrees_id
	AND c.id = d.colleges_id
	AND p.id = <cfqueryparam value="#url.plan#" cfsqltype="cf_sql_integer">
	AND p.students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the plan ID is not valid --->
<cfif !qEditGetPlan.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Define the "Save" button action --->
<cfif isDefined("form.saveButton")>
	<cfset planName=canonicalize(trim(form.planName), true, true)>
		
	<cfif planName NEQ qEditGetPlan.plan_name>
		
		<!--- Update college name --->
		<cfif len(trim(planName))>
			<cfquery>
				UPDATE PLANS
				SET plan_name = <cfqueryparam value="#planName#" cfsqltype="cf_sql_varchar">
				WHERE id = <cfqueryparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelse>
			<cfset messageBean.addError('A plan name is required.', 'planName')>
		</cfif>
	<cfelse>
		<!--- Exit edit screen --->
		<cflocation url="..">
	</cfif>
	
	<!--- Refresh if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="./?plan=#URLEncodedFormat(qEditGetPlan.id)#">
	</cfif>
</cfif>

<!--- Display default contents of page --->
<cfquery name="qEditGetSelectDegreeCategories">
	SELECT id, category
	FROM DEGREE_CATEGORIES
	WHERE degrees_id = <cfqueryparam value="#qEditGetPlan.degrees_id#" cfsqltype="cf_sql_integer">
	ORDER BY
		CASE
			WHEN category = 'College Admission Courses' THEN '1'
			ELSE id
		END ASC
</cfquery>

<!--- Get all courses saved for this plan --->
<cfquery name="qEditGetCourses">
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
			WHERE degrees_id = <cfqueryparam value="#qEditGetPlan.degrees_id#" cfsqltype="cf_sql_integer">) AS degreeGraduationCourses
		ON planSelectedCourses.courses_id = degreeGraduationCourses.courses_id
		LEFT JOIN (SELECT id, credit
			FROM STUDENTS_COMPLETEDCOURSES
			WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS studentCompletedCourses
		ON planSelectedCourses.completedcourses_id = studentCompletedCourses.id
	WHERE planSelectedCourses.plans_id = <cfqueryparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">
	ORDER BY courses.id
</cfquery>

<cfquery name="qEditGetCategories">
	SELECT d.id, d.category
	FROM DEGREE_CATEGORIES d
	JOIN (SELECT DISTINCT plans_id, degree_categories_id
		FROM PLAN_SELECTEDCOURSES
		WHERE plans_id = <cfqueryparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">) AS p
	ON d.id = p.degree_categories_id
	WHERE d.degrees_id = <cfqueryparam value="#qEditGetPlan.degrees_id#" cfsqltype="cf_sql_integer">
	ORDER BY
		CASE
			WHEN d.category = 'College Admission Courses' THEN '1'
			ELSE d.id
		END ASC
</cfquery>

<!--- Define "Update" button behavior --->
<cfif isDefined("form.updateCourseButton")>

	<!--- Process credit select boxes --->
	<cfif isDefined("form.courseCredit")>
		<cfset aCredit=listToArray(trim(form.courseCredit), ",", false, false)>
		<cfset aCreditId=listToArray(trim(form.creditId), ",", false, false)>
		
		<cfloop from="1" to="#arrayLen(aCredit)#" index="row">
			<cfif aCredit[row]>
				<cfquery>
					UPDATE PLAN_SELECTEDCOURSES
					SET credit = <cfqueryparam value="#aCredit[row]#" cfsqltype="cf_sql_decimal">
					WHERE id = <cfqueryparam value="#aCreditId[row]#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfloop>
		
		<!--- Check to see if we can mark this as complete now --->
		<cfif form.courseCredit NEQ 0>
			<cfstoredproc datasource="#GetApplicationMetaData().datasource#" procedure="updatePLAN_SELECTEDCOURSES">
				<cfprocparam value="#session.accountId#" cfsqltype="cf_sql_integer">
				<cfprocparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">
			</cfstoredproc>
		</cfif>
	</cfif>
	
	<!--- Process status select boxes --->
	<cfif isDefined("form.status")>
		<cfset aStatus=listToArray(trim(form.status), ",", false, false)>
		<cfset aStatusId=listToArray(trim(form.statusId), ",", false, false)>
		
		<cfloop from="1" to="#arrayLen(aStatus)#" index="row">
			<cfif aStatus[row]>
				<cfquery>
					UPDATE PLAN_SELECTEDCOURSES
					SET completedcourses_id = <cfqueryparam value="#aStatus[row]#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#aStatusId[row]#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<!--- Process remove checkboxes last --->
	<cfif isDefined("form.remove")>
		<cfset aRemove=listToArray(trim(form.remove), ",", false, false)>

		<!--- Build a singe query to delete one to many rows --->
		<cfquery>
			<cfloop from="1" to="#arrayLen(aRemove)#" index="row">
				DELETE
				FROM PLAN_SELECTEDCOURSES
				WHERE id = <cfqueryparam value="#aRemove[row]#" cfsqltype="cf_sql_integer">
			</cfloop>
		</cfquery>
	</cfif>
	
	<!--- Refresh page --->
	<cflocation url="./?plan=#URLEncodedFormat(qEditGetPlan.id)#">
</cfif>

<!--- Define "Add" button behavior --->
<cfif isDefined("form.addCourseButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.courseNumber))>
		<cfset messageBean.addError('A course number is required.', 'courseNumber')>
	</cfif>
	
	<cfif form.category EQ 0>
		<cfset messageBean.addError('Please select a category.', 'category')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editPlan.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the course, if exists --->
	<cfquery name="qEditGetCourse">
		SELECT id, min_credit, max_credit
		FROM COURSES
		WHERE use_catalog = 1
		AND course_number = <cfqueryparam value="#trim(form.courseNumber)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif !qEditGetCourse.RecordCount>
		<cfset messageBean.addError('The course could not be found.', 'courseNumber')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editPlan.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so add course to plan --->
	<cfquery>
		INSERT INTO PLAN_SELECTEDCOURSES (
			plans_id, courses_id, degree_categories_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.category#" cfsqltype="cf_sql_integer">,
			<cfif len(qEditGetCourse.min_credit)>
				NULL
			<cfelse>
				<cfqueryparam value="#qEditGetCourse.max_credit#" cfsqltype="cf_sql_decimal">
			</cfif>
		)
	</cfquery>
	
	<!--- Update the list of completed courses for this plan --->
	<cfstoredproc datasource="#GetApplicationMetaData().datasource#" procedure="updatePLAN_SELECTEDCOURSES">
		<cfprocparam value="#session.accountId#" cfsqltype="cf_sql_integer">
		<cfprocparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">
	</cfstoredproc>
	
	<!--- Refresh the page --->
	<cflocation url="./?plan=#URLEncodedFormat(qEditGetPlan.id)#">
</cfif>

<!--- Load page --->
<cfinclude template="model/editPlan.cfm">
<cfreturn>