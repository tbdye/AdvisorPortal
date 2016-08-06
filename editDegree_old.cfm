<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor") || !IsDefined("url.edit")>
	<cflocation url="manageColleges.cfm">
</cfif>

<cfset messageBean=createObject('cfc.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetCollege">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
	WHERE id = <cfqueryparam value="#URLDecode(url.edit)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the college ID is not valid --->
<cfif !qEditGetCollege.RecordCount>
	<cflocation url="manageColleges.cfm">
</cfif>

<!--- Prepare new degree contents --->
<cfquery name="qEditGetSelectDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	ORDER BY department_name ASC
</cfquery>

<!--- Prepare degree list contents --->
<cfquery name="qEditGetDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	WHERE id
	IN (SELECT departments_id
		FROM DEGREES)
</cfquery>

<cfif isDefined("url.department")>
	<cfquery name="qEditGetDegrees">
		SELECT id, degree_name
		FROM DEGREES
		WHERE departments_id = <cfqueryparam value="#URLDecode(url.department)#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<!--- Define the Add new degree "add" button action --->
<cfif isDefined("form.addDegreeButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.degreeDepartment EQ 0>
		<cfset messageBean.addError('Please associate a department.', 'degreeDepartment')>
	</cfif>
	
	<cfif !len(trim(form.degreeName))>
		<cfset messageBean.addError('A degree name is required.', 'degreeName')>
	</cfif>
	
	<cfif !len(trim(form.degreeType))>
		<cfset messageBean.addError('A degree type is required.', 'degreeType')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfset degreeName=canonicalize(trim(form.degreeName), true, true)>
	
	<cfquery name="qEditCheckDegree">
		SELECT id
		FROM DEGREES
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND degree_name = <cfqueryparam value="#degreeName#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif qEditCheckDegree.RecordCount>
		<cfset messageBean.addError('This degree already exists.', 'degreeName')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update degrees --->
	<cfset degreeType=canonicalize(trim(form.degreeType), true, true)>
	
	<cfquery>
		INSERT INTO DEGREES (
			colleges_id, degree_name, departments_id, degree_type, use_catalog
		) VALUES (
			<cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#degreeName#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#form.degreeDepartment#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#degreeType#" cfsqltype="cf_sql_varchar">,
			0
		)
	</cfquery>
	
	<cfset messageBean.addMessage('#degreeName# was successfully added.')>
</cfif>

<!--- Display errors or messages if they exist --->
<cfinclude template="model/editDegree.cfm">
<cfreturn>