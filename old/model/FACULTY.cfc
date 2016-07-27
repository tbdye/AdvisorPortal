component persistent="true" table="FACULTY"  schema="dbo" output="false"
{
	/* properties */
	
	property name="editor" column="editor" type="numeric" ormtype="boolean"; 
	property name="administrator" column="administrator" type="numeric" ormtype="boolean"; 
	property name="ACCOUNTS" fieldtype="one-to-one" cfc="ACCOUNTS" mappedby="FACULTY";
		
}
