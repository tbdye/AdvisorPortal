component persistent="true" table="COURSE_RANKINGS"
{
	/* properties */
	
	property name="courses_id" column="courses_id" type="numeric" ormtype="int" fieldtype="id" cfc="COURSES" fkcolumn="id";
	property name="rank" column="rank" type="numeric" ormtype="int"; 	
}
