<cfcomponent persistent="true" >
	<cfproperty name="accounts_id" fieldtype="id" generator="foreign" params="{property='ACCOUNTS'}" ormtype="integer" >
	<cfproperty name="ACCOUNTS" fieldtype="one-to-one" cfc="ACCOUNTS" constrained="true" >
	
	<cfproperty name="student_id" ormtype="integer" >
</cfcomponent>