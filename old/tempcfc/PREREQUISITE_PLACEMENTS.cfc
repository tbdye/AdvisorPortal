component persistent="true" table="PREREQUISITE_PLACEMENTS"
{
	/* properties */
	
	property name="courses_id" fieldtype="many-to-one" cfc="COURSES" fkcolumn="id";
	property name="placement" column="placement" type="string" ormtype="string"; 	
}
