<!--- Thomas Dye, July 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="index.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<!--- Display the list of available colleges --->
<cfquery name="qManageGetColleges">
	<cfif IsUserInRole("administrator")>
		SELECT id, college_name, college_city, college_website, use_catalog
		FROM COLLEGES
	<cfelse>
		SELECT id, college_name, college_city, college_website
		FROM COLLEGES
		WHERE use_catalog = 1
	</cfif>
</cfquery>

<cfif isDefined("form.addCollegeButton")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.collegeName))>
		<cfset errorBean.addError('Please supply the college name.', 'collegeName')>
	</cfif>
	
	<cfif !len(trim(form.collegeCity))>
		<cfset errorBean.addError('Please supply the college city.', 'collegeCity')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
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
			1)
	</cfquery>
	
	<!--- Refresh the page --->
	<cflocation url="manageColleges.cfm">
</cfif>

<cfinclude template="model/manageColleges.cfm">
<cfreturn>