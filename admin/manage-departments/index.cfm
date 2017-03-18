<!--- Manage Departments Controller --->
<!--- Karan Kalra, November 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Define form action for "Search" button. --->
<cfif isDefined("form.searchButton")>
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.searchTerm))>
		<cfset messageBean.addError('A department name is required.', 'departmentName')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageDepartments.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the department, if exists --->
	<cfquery name="qDepartmentsGetDepartment">
		SELECT id, department_name, see_also, dept_intro, abv_title, abv_title2, use_catalog
		FROM DEPARTMENTS
		WHERE department_name LIKE <cfqueryparam value="#trim(form.searchTerm)#%" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<!--- Handle student ID search results. --->
	<cfif !qDepartmentsGetDepartment.RecordCount>
		<cfset messageBean.addError('No results.', 'departmentName')>
	</cfif>
</cfif>

<!--- Display page --->
<cfinclude template="model/manageDepartments.cfm">
<cfreturn>