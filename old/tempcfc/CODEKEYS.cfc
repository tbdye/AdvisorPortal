component persistent="true" table="CODEKEYS"
{
	/* properties */
	
	property name="id" column="id" type="numeric" ormtype="int" fieldtype="id";
	property name="codekey" column="codekey" type="string" ormtype="string";
	property name="courses_id" fieldtype="many-to-many" cfc="COURSES" fkcolumn="id" type="array" singularname="COURSES_CODEKEYS" inversejoincolumn="codekeys_id" linktable="COURSES_CODEKEYS";
}
