<!--- Edit Plan Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student"))>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

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
<cfquery name="qEditGetSelectCategories">
	SELECT id, category, description
	FROM CATEGORIES
</cfquery>

<cfquery name="qEditGetDepartmentCreditsE">
	SELECT d.id, d.department_name, cad.credit
	FROM DEPARTMENTS d
	JOIN COLLEGE_ADMISSION_DEPARTMENTS cad
	ON d.id = cad.departments_id
	WHERE cad.colleges_id = <cfqueryparam value="#qEditGetPlan.colleges_id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Use arrays to store page output for courses --->
<cfset aCategoryC=arraynew(2)>
<cfset aCategoryW=arraynew(2)>
<cfset aCategoryQSR=arraynew(2)>
<cfset aCategoryNW=arraynew(2)>
<cfset aCategoryVLPA=arraynew(2)>
<cfset aCategoryIS=arraynew(2)>
<cfset aCategoryDIV=arraynew(2)>
<cfset aCategoryE=arraynew(2)>

<!--- Get all courses saved for this plan --->
<cfquery name="qEditGetCourses">
	SELECT c.course_number, c.title, sc.credit, sc.id AS sc_id,
		c.id AS c_id, c.departments_id, sc.categories_id,
		gc.courses_id AS gc_id, cc.id AS cc_id, cc.credit AS cc_credit,
		c.min_credit, c.max_credit
	FROM PLAN_SELECTEDCOURSES sc
	JOIN COURSES c
	ON c.id = sc.courses_id
	LEFT JOIN (SELECT id, credit
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS cc
	ON sc.completedcourses_id = cc.id
	LEFT JOIN DEGREE_GRADUATION_COURSES gc
	ON c.id = gc.courses_id
	WHERE sc.plans_id = <cfqueryparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">
	ORDER BY c.course_number
</cfquery>

<!--- Sort courses into storage arrays by category --->
<cfloop query="qEditGetCourses">
	<cfswitch expression="#qEditGetCourses.categories_id#">
		<cfcase value="1">
			<cfset row = #arrayLen(aCategoryC)# + 1>
			<cfset aCategoryC[row][1]=course_number>
			<cfset aCategoryC[row][2]=title>
			<cfset aCategoryC[row][3]=credit>
			<cfset aCategoryC[row][4]=sc_id>
			<cfset aCategoryC[row][5]=c_id>
			<cfset aCategoryC[row][6]=departments_id>
			<cfset aCategoryC[row][7]=categories_id>
			<cfset aCategoryC[row][8]=gc_id>
			<cfset aCategoryC[row][9]=cc_id>
			<cfset aCategoryC[row][10]=cc_credit>
			<cfset aCategoryC[row][11]=min_credit>
			<cfset aCategoryC[row][12]=max_credit>
		</cfcase>
		<cfcase value="2">
			<cfset row = #arrayLen(aCategoryW)# + 1>
			<cfset aCategoryW[row][1]=course_number>
			<cfset aCategoryW[row][2]=title>
			<cfset aCategoryW[row][3]=credit>
			<cfset aCategoryW[row][4]=sc_id>
			<cfset aCategoryW[row][5]=c_id>
			<cfset aCategoryW[row][6]=departments_id>
			<cfset aCategoryW[row][7]=categories_id>
			<cfset aCategoryW[row][8]=gc_id>
			<cfset aCategoryW[row][9]=cc_id>
			<cfset aCategoryW[row][10]=cc_credit>
			<cfset aCategoryW[row][11]=min_credit>
			<cfset aCategoryW[row][12]=max_credit>
		</cfcase>
		<cfcase value="3">
			<cfset row = #arrayLen(aCategoryQSR)# + 1>
			<cfset aCategoryQSR[row][1]=course_number>
			<cfset aCategoryQSR[row][2]=title>
			<cfset aCategoryQSR[row][3]=credit>
			<cfset aCategoryQSR[row][4]=sc_id>
			<cfset aCategoryQSR[row][5]=c_id>
			<cfset aCategoryQSR[row][6]=departments_id>
			<cfset aCategoryQSR[row][7]=categories_id>
			<cfset aCategoryQSR[row][8]=gc_id>
			<cfset aCategoryQSR[row][9]=cc_id>
			<cfset aCategoryQSR[row][10]=cc_credit>
			<cfset aCategoryQSR[row][11]=min_credit>
			<cfset aCategoryQSR[row][12]=max_credit>
		</cfcase>
		<cfcase value="4">
			<cfset row = #arrayLen(aCategoryNW)# + 1>
			<cfset aCategoryNW[row][1]=course_number>
			<cfset aCategoryNW[row][2]=title>
			<cfset aCategoryNW[row][3]=credit>
			<cfset aCategoryNW[row][4]=sc_id>
			<cfset aCategoryNW[row][5]=c_id>
			<cfset aCategoryNW[row][6]=departments_id>
			<cfset aCategoryNW[row][7]=categories_id>
			<cfset aCategoryNW[row][8]=gc_id>
			<cfset aCategoryNW[row][9]=cc_id>
			<cfset aCategoryNW[row][10]=cc_credit>
			<cfset aCategoryNW[row][11]=min_credit>
			<cfset aCategoryNW[row][12]=max_credit>
		</cfcase>
		<cfcase value="5">
			<cfset row = #arrayLen(aCategoryVLPA)# + 1>
			<cfset aCategoryVLPA[row][1]=course_number>
			<cfset aCategoryVLPA[row][2]=title>
			<cfset aCategoryVLPA[row][3]=credit>
			<cfset aCategoryVLPA[row][4]=sc_id>
			<cfset aCategoryVLPA[row][5]=c_id>
			<cfset aCategoryVLPA[row][6]=departments_id>
			<cfset aCategoryVLPA[row][7]=categories_id>
			<cfset aCategoryVLPA[row][8]=gc_id>
			<cfset aCategoryVLPA[row][9]=cc_id>
			<cfset aCategoryVLPA[row][10]=cc_credit>
			<cfset aCategoryVLPA[row][11]=min_credit>
			<cfset aCategoryVLPA[row][12]=max_credit>
		</cfcase>
		<cfcase value="6">
			<cfset row = #arrayLen(aCategoryIS)# + 1>
			<cfset aCategoryIS[row][1]=course_number>
			<cfset aCategoryIS[row][2]=title>
			<cfset aCategoryIS[row][3]=credit>
			<cfset aCategoryIS[row][4]=sc_id>
			<cfset aCategoryIS[row][5]=c_id>
			<cfset aCategoryIS[row][6]=departments_id>
			<cfset aCategoryIS[row][7]=categories_id>
			<cfset aCategoryIS[row][8]=gc_id>
			<cfset aCategoryIS[row][9]=cc_id>
			<cfset aCategoryIS[row][10]=cc_credit>
			<cfset aCategoryIS[row][11]=min_credit>
			<cfset aCategoryIS[row][12]=max_credit>
		</cfcase>
		<cfcase value="7">
			<cfset row = #arrayLen(aCategoryDIV)# + 1>
			<cfset aCategoryDIV[row][1]=course_number>
			<cfset aCategoryDIV[row][2]=title>
			<cfset aCategoryDIV[row][3]=credit>
			<cfset aCategoryDIV[row][4]=sc_id>
			<cfset aCategoryDIV[row][5]=c_id>
			<cfset aCategoryDIV[row][6]=departments_id>
			<cfset aCategoryDIV[row][7]=categories_id>
			<cfset aCategoryDIV[row][8]=gc_id>
			<cfset aCategoryDIV[row][9]=cc_id>
			<cfset aCategoryDIV[row][10]=cc_credit>
			<cfset aCategoryDIV[row][11]=min_credit>
			<cfset aCategoryDIV[row][12]=max_credit>
		</cfcase>
		<cfcase value="8">
			<cfset row = #arrayLen(aCategoryE)# + 1>
			<cfset aCategoryE[row][1]=course_number>
			<cfset aCategoryE[row][2]=title>
			<cfset aCategoryE[row][3]=credit>
			<cfset aCategoryE[row][4]=sc_id>
			<cfset aCategoryE[row][5]=c_id>
			<cfset aCategoryE[row][6]=departments_id>
			<cfset aCategoryE[row][7]=categories_id>
			<cfset aCategoryE[row][8]=gc_id>
			<cfset aCategoryE[row][9]=cc_id>
			<cfset aCategoryE[row][10]=cc_credit>
			<cfset aCategoryE[row][11]=min_credit>
			<cfset aCategoryE[row][12]=max_credit>
		</cfcase>
	</cfswitch>
</cfloop>

<cfquery name="qEditGetSelectCoursesC">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 1)
</cfquery>

<cfquery name="qEditGetSelectCoursesW">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 2)
</cfquery>

<cfquery name="qEditGetSelectCoursesQSR">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 3)
</cfquery>

<cfquery name="qEditGetSelectCoursesNW">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 4)
</cfquery>

<cfquery name="qEditGetSelectCoursesVLPA">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 5)
</cfquery>

<cfquery name="qEditGetSelectCoursesIS">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 6)
</cfquery>

<cfquery name="qEditGetSelectCoursesDIV">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 7)
</cfquery>

<cfquery name="qEditGetSelectCoursesE">
	SELECT c.course_number, sc.id, sc.courses_id
	FROM COURSES c JOIN (SELECT id, courses_id
		FROM STUDENTS_COMPLETEDCOURSES
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">) AS sc
	ON c.id = sc.courses_id
	WHERE sc.id NOT IN (SELECT completedcourses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE completedcourses_id IS NOT NULL)
	AND sc.courses_id IN (SELECT courses_id
		FROM PLAN_SELECTEDCOURSES
		WHERE categories_id = 8)
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
			plans_id, courses_id, categories_id, credit
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
	
	<!--- Refresh the page --->
	<cflocation url="./?plan=#URLEncodedFormat(qEditGetPlan.id)#">
</cfif>

<!--- Load page --->
<cfinclude template="model/editPlan.cfm">
<cfreturn>