component persistent="true" table="PREREQUISITE_PERMISSIONS"
{
	/* properties */
	
	property name="courses_id" fieldtype="many-to-one" cfc="COURSES" fkcolumn="id";
}
