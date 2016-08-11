<!--- Degrees Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !(isDefined("session.studentId") || IsUserInRole("student")) >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Always display degree plans by the student. --->
<cfquery name="qPlansGetStudentPlans">
	SELECT id, plan_name, time_created, time_updated
	FROM PLANS
	WHERE students_accounts_id = <cfqueryparam value="#session.accountId#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Always display student's plans from qDegreesGetStudentPlans --->
<cfinclude template="model/plans.cfm">
<cfreturn>