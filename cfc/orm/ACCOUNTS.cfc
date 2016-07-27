component persistent="true"{
	property name="id" column="id" fieldtype="id" generator="native";
	property name="email" ormtype="string";
	property name="first_name" ormtype="string";
	property name="last_name" ormtype="string";
	property name="password" ormtype="string";
	property name="salt" ormtype="string";       
}