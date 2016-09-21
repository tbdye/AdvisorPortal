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
<cfset aCategoryC=arraynew(2)>
<cfset aCategoryW=arraynew(2)>
<cfset aCategoryQSR=arraynew(2)>
<cfset aCategoryNW=arraynew(2)>
<cfset aCategoryVLPA=arraynew(2)>
<cfset aCategoryIS=arraynew(2)>
<cfset aCategoryDIV=arraynew(2)>
<cfset aCategoryE=arraynew(2)>

<!--- Populate arrays to render display output --->
<cfif qDashboardGetActivePlan.RecordCount>
	<!--- Get all courses saved for this plan --->
	<cfquery name="qDashboardGetCourses">
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
	WHERE sc.plans_id = <cfqueryparam value="#qDashboardGetActivePlan.plans_id#" cfsqltype="cf_sql_integer">
	ORDER BY c.course_number
</cfquery>
	
	<!--- Sort courses into storage arrays by category --->
	<cfloop query="qDashboardGetCourses">
		<cfswitch expression="#qDashboardGetCourses.categories_id#">
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
</cfif>

<!--- Display page --->
<cfinclude template="model/dashboard.cfm">
<cfreturn>