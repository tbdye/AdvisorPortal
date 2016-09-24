<!--- Plans Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Define the active plan "Change" button --->
<cfif isDefined("form.updateActivePlanButton")>
	<cfif form.currentPlanId NEQ form.activePlanId>
		<cfquery>
			DELETE
			FROM PLAN_ACTIVEPLANS
			WHERE plans_id = <cfqueryparam value="#form.currentPlanId#" cfsqltype="cf_sql_integer">
			AND students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
		
			INSERT INTO PLAN_ACTIVEPLANS (
				plans_id, students_accounts_id
			) VALUES (
				<cfqueryparam value="#form.activePlanId#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
			)
		</cfquery>
	</cfif>
</cfif>

<!--- Define the saved degree plans "Delete" button --->
<cfif isDefined("form.deletePlanButton")>
	<cfif form.thisPlanId EQ form.activePlanId>
		<cfset messageBean.addError('Cannot delete the active plan.', 'activePlanId')>
	<cfelse>
		<cfquery>
			DELETE
			FROM PLANS
			WHERE id = <cfqueryparam value="#form.thisPlanId#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
</cfif>

<!--- Define the saved degree plans "Copy" button --->
<cfif isDefined("form.copyPlanButton")>
	<!--- ToDo:  implement this --->
</cfif>

<!--- Prepare basic contents of the page --->
<cfquery name="qPlanGetPlans">
	SELECT id, plan_name, time_created, time_updated
	FROM PLANS
	WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qPlanGetActivePlan">
	SELECT p.id, p.plan_name, s.degrees_id, d.degree_name, d.colleges_id, c.college_name, c.college_city, d.degree_type
	FROM PLANS p, PLAN_SELECTEDDEGREES s, DEGREES d, COLLEGES c
	WHERE p.id = s.plans_id
	AND d.id = s.degrees_id
	AND c.id = d.colleges_id
	AND p.id = (SELECT plans_id
		FROM PLAN_ACTIVEPLANS
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">)
</cfquery>

<!--- Always display student's plans from qDegreesGetStudentPlans --->
<cfinclude template="model/plans.cfm">
<cfreturn>