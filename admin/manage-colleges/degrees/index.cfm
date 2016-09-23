<!--- Manage Degree Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor") || !IsDefined("url.college")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qManageGetCollege">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
	WHERE id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the college ID is not valid --->
<cfif !qManageGetCollege.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Prepare page contents --->
<cfquery name="qManageGetAllDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	ORDER BY department_name ASC
</cfquery>

<cfquery name="qManageGetSelectDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	WHERE id IN (SELECT departments_id
		FROM DEGREES
		WHERE colleges_id = <cfqueryparam value="#qManageGetCollege.id#" cfsqltype="cf_sql_integer">)
	ORDER BY department_name ASC
</cfquery>

<!--- Define form action for "Add" button. --->
<cfif isDefined("form.addDegreeButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.degreeName))>
		<cfset messageBean.addError('A degree name is required.', 'degreeName')>
	</cfif>
	
	<cfif form.degreeDepartment EQ 0>
		<cfset messageBean.addError('Please associate a department.', 'degreeDepartment')>
	</cfif>
	
	<cfif !len(trim(form.degreeType))>
		<cfset messageBean.addError('A degree type is required.', 'degreeType')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageDegrees.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfset degreeName=canonicalize(trim(form.degreeName), true, true)>
	
	<cfquery name="qManageCheckDegree">
		SELECT id
		FROM DEGREES
		WHERE colleges_id = <cfqueryparam value="#qManageGetCollege.id#" cfsqltype="cf_sql_integer">
		AND degree_name = <cfqueryparam value="#degreeName#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif qManageCheckDegree.RecordCount>
		<cfset messageBean.addError('This degree already exists.', 'degreeName')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageDegrees.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update degrees --->
	<cfset degreeType=canonicalize(trim(form.degreeType), true, true)>
	
	<cfquery>
		INSERT INTO DEGREES (
			colleges_id, degree_name, departments_id, degree_type, use_catalog
		) VALUES (
			<cfqueryparam value="#qManageGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#degreeName#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#form.degreeDepartment#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#degreeType#" cfsqltype="cf_sql_varchar">,
			0
		)
	</cfquery>
	
	<!--- Display success message --->
	<!--- ToDo:  Build interface for this, probably as javascript popup --->
	<!---<cfquery name="qManageVerifyDegree">
		SELECT deg.degree_name, dept.department_name
		FROM DEGREES deg
		JOIN DEPARTMENTS dept
		ON deg.departments_id = dept.id
		WHERE colleges_id = <cfqueryparam value="#qManageGetCollege.id#" cfsqltype="cf_sql_integer">
		AND degree_name = <cfqueryparam value="#degreeName#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfset messageBean.addMessage('#qManageVerifyDegree.degree_name# was successfully added to the #qManageVerifyDegree.department_name# department.')>--->
	
	<!--- Refresh the page --->
	<cflocation url="?college=#URLEncodedFormat(qManageGetCollege.id)#">
</cfif>

<!--- Define form action for "Select" button. --->
<cfif isDefined("form.selectDegreeButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.selectDepartment EQ 0>
		<cfset messageBean.addError('Please select a department.', 'selectDepartment')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageDegrees.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so find degrees --->
	<cfquery name="qManageGetDegrees">
		SELECT
			id, degree_name, degree_type, use_catalog
		FROM DEGREES
		WHERE colleges_id = <cfqueryparam value="#qManageGetCollege.id#" cfsqltype="cf_sql_integer">
		AND departments_id = <cfqueryparam value="#form.selectDepartment#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<!--- Display page without errors --->
<cfinclude template="model/manageDegrees.cfm">
<cfreturn>