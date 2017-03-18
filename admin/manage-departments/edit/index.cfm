<!--- Edit Department Controller --->
<!--- Thomas Dye, March 2017 --->
<cfif !IsUserInRole("editor") >
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Do basic validation --->
<cfif !IsNumeric("#URLDecode(url.department)#")>
	<cflocation url="..">
</cfif>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetDepartment">
	SELECT id, department_name, see_also, dept_intro, abv_title, abv_title2, use_catalog
	FROM DEPARTMENTS
	WHERE id = <cfqueryparam value="#URLDecode(url.department)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the department ID is not valid --->
<cfif !qEditGetDepartment.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Set defaults for form data --->
<cfset status1="no">
<cfset status2="no">
<cfif qEditGetDepartment.use_catalog>
	<cfset status1="yes">
<cfelse>
	<cfset status2="yes">
</cfif>

<cfset checked="no">
<cfif qEditGetDepartment.RecordCount>
	<cfset checked="yes">
</cfif>

<!--- Define "Update department information" button behavior --->
<cfif isDefined("form.updateDepartmentInfoButton")>
	
	<!--- Evaluate update for department name --->
	<cfif isDefined("form.departmentName") && !messageBean.hasErrors()>
		<cfset departmentName=canonicalize(trim(form.departmentName), true, true)>
		
		<cfif departmentName NEQ qEditGetDepartment.department_name>
			
			<!--- Update department name --->
			<cfif len(trim(departmentName))>
				<cfquery>
					UPDATE DEPARTMENTS
					SET department_name = <cfqueryparam value="#departmentName#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfset messageBean.addError('A department name is required.', 'departmentName')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for see also --->
	<cfif isDefined("form.departmentSeeAlso") && !messageBean.hasErrors()>
		<cfset departmentSeeAlso=canonicalize(trim(form.departmentSeeAlso), true, true)>
		
		<cfif departmentSeeAlso NEQ qEditGetDepartment.see_also>
			
			<!--- Update see also --->
			<cfquery>
				UPDATE DEPARTMENTS
				<cfif len(trim(departmentSeeAlso))>
					SET see_also = <cfqueryparam value="#departmentSeeAlso#" cfsqltype="cf_sql_varchar">
				<cfelse>
					SET see_also = NULL
				</cfif>
				WHERE id = <cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for abbreviated title --->
	<cfif isDefined("form.departmentAbvTitle") && !messageBean.hasErrors()>
		<cfset departmentAbvTitle=canonicalize(trim(form.departmentAbvTitle), true, true)>
		
		<cfif departmentAbvTitle NEQ qEditGetDepartment.abv_title>
			
			<!--- Update abbreviated title --->
			<cfquery>
				UPDATE DEPARTMENTS
				<cfif len(trim(departmentAbvTitle))>
					SET abv_title = <cfqueryparam value="#departmentAbvTitle#" cfsqltype="cf_sql_varchar">
				<cfelse>
					SET abv_title = NULL
				</cfif>
				WHERE id = <cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for abbreviated title 2 --->
	<cfif isDefined("form.departmentAbvTitle2") && !messageBean.hasErrors()>
		<cfset departmentAbvTitle2=canonicalize(trim(form.departmentAbvTitle2), true, true)>
		
		<cfif departmentAbvTitle2 NEQ qEditGetDepartment.abv_title2>
			
			<!--- Update abbreviated title 2 --->
			<cfquery>
				UPDATE DEPARTMENTS
				<cfif len(trim(departmentAbvTitle2))>
					SET abv_title2 = <cfqueryparam value="#departmentAbvTitle2#" cfsqltype="cf_sql_varchar">
				<cfelse>
					SET abv_title2 = NULL
				</cfif>
				WHERE id = <cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for availability status --->
	<cfif isDefined("form.departmentAvailability") && !messageBean.hasErrors()>
		<cfif (status1 EQ "yes" && form.departmentAvailability NEQ 1) || (status2 EQ "yes" && form.departmentAvailability NEQ 2)>
			<!--- Update availability --->
			<cfquery>
				UPDATE DEPARTMENTS
				<cfif form.departmentAvailability EQ 1>
					SET use_catalog = 1
				<cfelse>
					SET use_catalog = 0
				</cfif>
				WHERE id = <cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?department=#URLEncodedFormat(qEditGetDepartment.id)#">
	</cfif>
</cfif>

<!--- Define "Update description" button behavior --->
<cfif isDefined("form.updateDepartmentIntroButton")>
	<cfset departmentIntro=canonicalize(trim(form.departmentIntro), true, true)>
		
	<cfif departmentIntro NEQ qEditGetDepartment.dept_intro>
		
		<!--- Update department description notes --->
		<cfquery>
			UPDATE DEPARTMENTS
			<cfif len(trim(departmentIntro))>
				SET dept_intro = <cfqueryparam value="#departmentIntro#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET dept_intro = NULL
			</cfif>
			WHERE id = <cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?department=#URLEncodedFormat(qEditGetDepartment.id)#">
	</cfif>
</cfif>

<!--- Load page --->
<cfinclude template="model/editDepartment.cfm">
<cfreturn>