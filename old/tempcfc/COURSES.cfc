component persistent="true" table="COURSES"
{
	/* properties */
	
	property name="id" column="id" type="numeric" ormtype="int" fieldtype="id"; 
	property name="course_number" column="course_number" type="string" ormtype="string"; 
	property name="title" column="title" type="string" ormtype="string"; 
	property name="min_credit" column="min_credit" type="numeric" ormtype="double"; 
	property name="max_credit" column="max_credit" type="numeric" ormtype="double"; 
	property name="course_description" column="course_description" type="string" ormtype="string";
	property name="departments_id" fieldtype="many-to-one" cfc="DEPARTMENTS" fkcolumn="id";
	property name="codekeys_id" fieldtype="many-to-many" cfc="CODEKEYS" fkcolumn="id" type="array" singularname="COURSES_CODEKEYS" inversejoincolumn="courses_id" linktable="COURSES_CODEKEYS";         
}
