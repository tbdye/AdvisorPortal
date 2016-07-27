component persistent="true" table="STUDENTS"  schema="dbo" output="false"
{
	/* properties */
	
	property name="student_id" column="student_id" type="numeric" ormtype="int"; 
	property name="ACCOUNTS" fieldtype="one-to-one" cfc="ACCOUNTS" mappedby="STUDENTS";
		
}
