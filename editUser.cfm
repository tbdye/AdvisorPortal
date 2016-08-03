<!--- Thomas Dye, July 2016 --->
<cfif !IsUserInRole("administrator") || !IsDefined("url.edit")>
	<cflocation url="manageUsers.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<cfquery name="qUserGetAccount">
	SELECT a.id, a.email, a.first_name, a.last_name, a.password, a.salt,
			s.accounts_id AS s_accounts_id, s.student_id,
			f.accounts_id AS f_accounts_id, f.editor, f.administrator
	FROM accounts a
	FULL JOIN students s
	ON a.id = s.accounts_id
	FULL JOIN faculty f
	ON a.id = f.accounts_id
	WHERE a.id = <cfqueryparam value="#URLDecode(url.edit)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfinclude template="model/editUser.cfm">
<cfreturn>