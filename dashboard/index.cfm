<!--- Dashboard Controller --->
<!--- Thomas Dye, September 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qDashboardGetActivePlan">
	SELECT p.id, p.plan_name, s.degrees_id
	FROM PLANS p, PLAN_SELECTEDDEGREES s
	WHERE p.id = s.plans_id
	AND p.id = (SELECT plans_id
		FROM PLAN_ACTIVEPLANS
		WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">)
</cfquery>

<!--- Display page --->
<cfinclude template="model/dashboard.cfm">
<cfreturn>