<!--- Edit Plan Controller --->
<!--- Thomas Dye, August 2016 --->
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
	
	<!--- Redirect the user if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="..">
	</cfif>
</cfif>

<!--- Load page --->
<cfinclude template="model/editPlan.cfm">
<cfreturn>