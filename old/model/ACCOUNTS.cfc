component persistent="true" table="ACCOUNTS"  schema="dbo" output="false"
{
	/* properties */
	
	property name="id" column="id" type="numeric" ormtype="int" fieldtype="id"; 
	property name="email" column="email" type="string" ormtype="string"; 
	property name="first_name" column="first_name" type="string" ormtype="string"; 
	property name="last_name" column="last_name" type="string" ormtype="string"; 
	property name="password" column="password" type="string" ormtype="string"; 
	property name="salt" column="salt" type="string" ormtype="string"; 
	property name="STUDENTS" fieldtype="one-to-one" cfc="STUDENTS" fkcolumn="accounts_id" mappedby="STUDENTS";
	
	property name="FACULTY" fieldtype="one-to-one" cfc="FACULTY" fkcolumn="accounts_id" mappedby="STUDENTS";
		
}
