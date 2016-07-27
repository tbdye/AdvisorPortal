component persistent="true" table="PREREQUISITES"
{
	/* properties */
	
	property name="id" column="id" type="numeric" ormtype="int" fieldtype="id";
	property name="courses_id" fieldtype="many-to-one" cfc="COURSES" fkcolumn="id";
	property name="group" column="group" type="numeric" ormtype="int";
	property name="courses_prerequisite_id" fieldtype="many-to-one" cfc="COURSES" fkcolumn="id";
}
