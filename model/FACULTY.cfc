<cfcomponent persistent="true" >
	<cfproperty name="accounts_id" fieldtype="id" generator="native" >
	<cfproperty name="ACCOUNTS" fieldtype="one-to-one" cfc="ACCOUNTS" fkcolumn="id" >
	
	<cfproperty name="editor" ormtype="boolean" >
	<cfproperty name="administrator" ormtype="boolean" >
</cfcomponent>