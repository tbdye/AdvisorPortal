<cfcomponent persistent="true" >
	<cfproperty name="id" fieldtype="id" generator="native" >
	<cfproperty name="email" ormtype="string" >
	<cfproperty name="first_name" ormtype="string" >
	<cfproperty name="last_name" ormtype="string" >
	<cfproperty name="password" ormtype="string" >
	<cfproperty name="salt" ormtype="string" >
	
	<cfproperty name="STUDENTS" fieldtype="one-to-one" cfc="STUDENTS" >
	<cfproperty name="FACULTY" fieldtype="one-to-one" cfc="FACULTY" >
</cfcomponent>