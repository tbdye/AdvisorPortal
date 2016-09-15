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
	</cfif>
	
	<!--- Refresh if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="./?plan=#URLEncodedFormat(qEditGetPlan.id)#">
	</cfif>
</cfif>

<!--- Define "Remove" button behavior --->
<cfif isDefined("form.removeCourseButton")>
	<cfquery>
		DELETE
		FROM PLAN_SELECTEDCOURSES
		WHERE id = <cfqueryparam value="#form.scId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Stop here and refresh page --->
	<cflocation url="./?plan=#URLEncodedFormat(qEditGetPlan.id)#">
</cfif>

<!--- Define "Update" button behavior --->
<cfif isDefined("form.updateCourseButton")>
	<cfquery name="qEditGetCourse">
		SELECT id, min_credit, max_credit
		FROM COURSES
		WHERE id = <cfqueryparam value="#form.courseId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Validate form data --->
	<cfif isDefined("form.courseCredit")>
		<cfif !len(trim(form.courseCredit))>
			<cfset messageBean.addError('The course credit field cannot be left blank.', #form.scId#)>
		<cfelseif !IsNumeric("#trim(form.courseCredit)#")>
			<cfset messageBean.addError('Credits must be entered in as a decimal number.', #form.scId#)>
		<cfelseif trim(form.courseCredit) LT qEditGetCourse.min_credit || trim(form.courseCredit) GT qEditGetCourse.max_credit>
			<cfset messageBean.addError('Credit must be between #qEditGetCourse.min_credit# and #qEditGetCourse.max_credit#.', #form.scId#)>
		</cfif>
	</cfif>
	
	<!--- Update proposed course credits on plan --->
	<cfif !messageBean.HasErrors()>
		<cfquery>
			UPDATE PLAN_SELECTEDCOURSES
			SET credit = <cfqueryparam value="#form.courseCredit#" cfsqltype="cf_sql_decimal">
			WHERE id = <cfqueryparam value="#form.scId#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
</cfif>

<!--- Use arrays to store page output for courses --->
<cfset aCategoryVLPA=arraynew(2)>
<cfset aCategoryIS=arraynew(2)>
<cfset aCategoryNW=arraynew(2)>
<cfset aCategoryC=arraynew(2)>
<cfset aCategoryQSR=arraynew(2)>
<cfset aCategoryW=arraynew(2)>
<cfset aCategoryDIV=arraynew(2)>

<!--- Get all courses saved for this plan --->
<cfquery name="qEditGetCourses">
	SELECT c.id, c.course_number, c.title,
		sc.id AS sc_id, sc.categories_id, sc.credit,
		cc.courses_id AS cc_id, cc.credit AS cc_credit
	FROM PLAN_SELECTEDCOURSES sc
	JOIN COURSES c
	ON c.id = sc.courses_id
	LEFT JOIN STUDENTS_COMPLETEDCOURSES cc
	ON c.id = cc.courses_id
	WHERE sc.plans_id = <cfqueryparam value="#qEditGetPlan.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Sort courses into storage arrays by category --->
<cfloop query="qEditGetCourses">
	<cfswitch expression="#qEditGetCourses.categories_id#">
		<cfcase value="1">
			<cfset row = #arrayLen(aCategoryVLPA)# + 1>
			<cfset aCategoryVLPA[row][1]=id>
			<cfset aCategoryVLPA[row][2]=course_number>
			<cfset aCategoryVLPA[row][3]=title>
			<cfset aCategoryVLPA[row][4]=sc_id>
			<cfset aCategoryVLPA[row][5]=categories_id>
			<cfset aCategoryVLPA[row][6]=credit>
			<cfset aCategoryVLPA[row][7]=cc_id>
			<cfset aCategoryVLPA[row][8]=cc_credit>
		</cfcase>
		<cfcase value="2">
			<cfset row = #arrayLen(aCategoryIS)# + 1>
			<cfset aCategoryIS[row][1]=id>
			<cfset aCategoryIS[row][2]=course_number>
			<cfset aCategoryIS[row][3]=title>
			<cfset aCategoryIS[row][4]=sc_id>
			<cfset aCategoryIS[row][5]=categories_id>
			<cfset aCategoryIS[row][6]=credit>
			<cfset aCategoryIS[row][7]=cc_id>
			<cfset aCategoryIS[row][8]=cc_credit>
		</cfcase>
		<cfcase value="3">
			<cfset row = #arrayLen(aCategoryNW)# + 1>
			<cfset aCategoryNW[row][1]=id>
			<cfset aCategoryNW[row][2]=course_number>
			<cfset aCategoryNW[row][3]=title>
			<cfset aCategoryNW[row][4]=sc_id>
			<cfset aCategoryNW[row][5]=categories_id>
			<cfset aCategoryNW[row][6]=credit>
			<cfset aCategoryNW[row][7]=cc_id>
			<cfset aCategoryNW[row][8]=cc_credit>
		</cfcase>
		<cfcase value="4">
			<cfset row = #arrayLen(aCategoryC)# + 1>
			<cfset aCategoryC[row][1]=id>
			<cfset aCategoryC[row][2]=course_number>
			<cfset aCategoryC[row][3]=title>
			<cfset aCategoryC[row][4]=sc_id>
			<cfset aCategoryC[row][5]=categories_id>
			<cfset aCategoryC[row][6]=credit>
			<cfset aCategoryC[row][7]=cc_id>
			<cfset aCategoryC[row][8]=cc_credit>
		</cfcase>
		<cfcase value="5">
			<cfset row = #arrayLen(aCategoryQSR)# + 1>
			<cfset aCategoryQSR[row][1]=id>
			<cfset aCategoryQSR[row][2]=course_number>
			<cfset aCategoryQSR[row][3]=title>
			<cfset aCategoryQSR[row][4]=sc_id>
			<cfset aCategoryQSR[row][5]=categories_id>
			<cfset aCategoryQSR[row][6]=credit>
			<cfset aCategoryQSR[row][7]=cc_id>
			<cfset aCategoryQSR[row][8]=cc_credit>
		</cfcase>
		<cfcase value="6">
			<cfset row = #arrayLen(aCategoryW)# + 1>
			<cfset aCategoryW[row][1]=id>
			<cfset aCategoryW[row][2]=course_number>
			<cfset aCategoryW[row][3]=title>
			<cfset aCategoryW[row][4]=sc_id>
			<cfset aCategoryW[row][5]=categories_id>
			<cfset aCategoryW[row][6]=credit>
			<cfset aCategoryW[row][7]=cc_id>
			<cfset aCategoryW[row][8]=cc_credit>
		</cfcase>
		<cfcase value="7">
			<cfset row = #arrayLen(aCategoryDIV)# + 1>
			<cfset aCategoryDIV[row][1]=id>
			<cfset aCategoryDIV[row][2]=course_number>
			<cfset aCategoryDIV[row][3]=title>
			<cfset aCategoryDIV[row][4]=sc_id>
			<cfset aCategoryDIV[row][5]=categories_id>
			<cfset aCategoryDIV[row][6]=credit>
			<cfset aCategoryDIV[row][7]=cc_id>
			<cfset aCategoryDIV[row][8]=cc_credit>
		</cfcase>
	</cfswitch>
</cfloop>

<!--- Load page --->
<cfinclude template="model/editPlan.cfm">
<cfreturn>