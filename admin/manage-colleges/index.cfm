<!--- Manage Colleges Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

<!--- Display the list of available colleges --->
<cfquery name="qManageGetColleges">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
</cfquery>

<cfif isDefined("form.addCollegeButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.collegeName))>
		<cfset messageBean.addError('A college name is required.', 'collegeName')>
	</cfif>
	
	<cfif !len(trim(form.collegeCity))>
		<cfset messageBean.addError('A city name is required.', 'collegeCity')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/manageColleges.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfset collegeName=canonicalize(trim(form.collegeName), true, true)>
	<cfset collegeCity=canonicalize(trim(form.collegeCity), true, true)>
	<cfset collegeWebsite="">
	<cfif isDefined("form.collegeWebsite") && len(trim(form.collegeWebsite))>
		<cfset collegeWebsite=canonicalize(trim(form.collegeWebsite), true, true)>
	</cfif>

	<cfquery>
		INSERT INTO COLLEGES (
			college_name, college_city, college_website, use_catalog)
		VALUES (
			<cfqueryparam value="#collegeName#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#collegeCity#" cfsqltype="cf_sql_varchar">,
			<cfif len(trim(collegeWebsite))>
				<cfqueryparam value="#collegeWebsite#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				NULL,
			</cfif>
			0)
	</cfquery>
	
	<!--- Refresh the page --->
	<cflocation url=".">
</cfif>

<cfinclude template="model/manageColleges.cfm">
<cfreturn>