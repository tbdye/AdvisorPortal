<!--- Thomas Dye, July 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<!--- Always display degree plans by the student. --->
<cfquery name="qDegreesGetStudentPlans">
	SELECT id, plan_name, time_created, time_updated
	FROM PLANS
	WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Always display student's plans from qDegreesGetStudentPlans --->
<cfinclude template="model/degrees.cfm">
<cfreturn>