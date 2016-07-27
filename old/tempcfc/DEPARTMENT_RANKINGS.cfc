component persistent="true" table="DEPARTMENT_RANKINGS"
{
	/* properties */
	
	property name="departments_id" fieldtype="many-to-one" cfc="DEPARTMENTS" fkcolumn="id";
	property name="rank" column="rank" type="numeric" ormtype="int";
}
