<!--- Dashboard Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

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

<!--- Use arrays to store page output for courses --->
<cfset aCategoryVLPA=arraynew(2)>
<cfset aCategoryIS=arraynew(2)>
<cfset aCategoryNW=arraynew(2)>
<cfset aCategoryC=arraynew(2)>
<cfset aCategoryQSR=arraynew(2)>
<cfset aCategoryW=arraynew(2)>
<cfset aCategoryDIV=arraynew(2)>

<!--- Populate arrays to render display output --->
<cfif qDashboardGetActivePlan.RecordCount>
	<!--- Get all courses saved for this plan --->
	<cfquery name="qDashboardGetCourses">
		SELECT c.id, c.course_number, c.title,
			sc.id AS sc_id, sc.categories_id, sc.credit,
			cc.courses_id AS cc_id, cc.credit AS cc_credit
		FROM PLAN_SELECTEDCOURSES sc
		JOIN COURSES c
		ON c.id = sc.courses_id
		LEFT JOIN STUDENTS_COMPLETEDCOURSES cc
		ON c.id = cc.courses_id
		WHERE sc.plans_id = <cfqueryparam value="#qDashboardGetActivePlan.plans_id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Sort courses into storage arrays by category --->
	<cfloop query="qDashboardGetCourses">
		<cfswitch expression="#qDashboardGetCourses.categories_id#">
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
</cfif>

<!--- Display page --->
<cfinclude template="model/dashboard.cfm">
<cfreturn>