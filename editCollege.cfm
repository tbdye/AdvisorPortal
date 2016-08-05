<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor") || !IsDefined("url.edit")>
	<cflocation url="manageColleges.cfm">
</cfif>

<cfset errorBean=createObject('cfc.errorBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetCollege">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
	WHERE id = <cfqueryparam value="#URLDecode(url.edit)#" cfsqltype="cf_sql_integer">
	<cfif !IsUserInRole("administrator")>
		AND use_catalog = 1
	</cfif>
</cfquery>

<!--- Back out if the college ID is not valid --->
<cfif !qEditGetCollege.RecordCount>
	<cflocation url="manageColleges.cfm">
</cfif>

<!--- Delete college admission course requirement --->
<cfif isDefined("url.section") && isDefined("url.remove")>
	
	<!--- Perform simple validation on url variables --->
	<cfif URLDecode(url.section) NEQ "courses" || !IsNumeric("#URLDecode(url.remove)#")>
		<cflocation url="manageColleges.cfm">
	</cfif>
	
	<!--- Ensure the supplied course ID is present --->
	<cfquery name="qEditCheckCourse">
		SELECT courses_id
		FROM COLLEGES_ADMISSION_COURSES
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#URLDecode(url.remove)#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Stop here if the course is not valid. --->
	<cfif !qEditCheckCourse.RecordCount>
		<cflocation url="manageColleges.cfm">
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfquery>
		DELETE
		FROM COLLEGES_ADMISSION_COURSES
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#URLDecode(url.remove)#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="editCollege.cfm?edit=#URLEncodedFormat(qEditGetCollege.id)#">
</cfif>

<!--- Prepare admission requirements contents --->
<cfquery name="qEditGetAdmissionCourses">
	SELECT a.foreign_course_number, c.id, c.course_number
	FROM COLLEGES_ADMISSION_COURSES a
	JOIN COURSES c
	ON a.courses_id = c.id
	WHERE a.colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetAdmissionDepartments">
	SELECT a.credit, d.id, d.department_name
	FROM COLLEGE_ADMISSION_DEPARTMENTS a
	JOIN DEPARTMENTS d
	ON a.departments_id = d.id
	WHERE a.colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	ORDER BY department_name ASC
</cfquery>

<cfquery name="qEditGetAdmissionCodekeys">
	SELECT a.credit, c.id, c.description
	FROM COLLEGE_ADMISSION_CODEKEYS a
	JOIN CODEKEYS c
	ON a.codekeys_id = c.id
	WHERE a.colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetCodekeys">
	SELECT id, description
	FROM CODEKEYS
</cfquery>

<!--- Set defaults for form data --->
<cfset status1="no">
<cfset status2="no">
<cfif qEditGetCollege.use_catalog>
	<cfset status1="yes">
<cfelse>
	<cfset status2="yes">
</cfif>

<!--- Define the "update" button action --->
<cfif isDefined("form.updateButton")>
	
	<!--- Evaluate update for college name --->
	<cfif isDefined("form.collegeName") && !errorBean.hasErrors()>
		<cfset collegeName=canonicalize(trim(form.collegeName), true, true)>
		
		<cfif collegeName NEQ qEditGetCollege.college_name>
			
			<!--- Update college name --->
			<cfif len(trim(collegeName))>
				<cfquery>
					UPDATE COLLEGES
					SET college_name = <cfqueryparam value="#collegeName#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfset errorBean.addError('A college name is required.', 'collegeName')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for college city --->
	<cfif isDefined("form.collegeCity") && !errorBean.hasErrors()>
		<cfset collegeCity=canonicalize(trim(form.collegeCity), true, true)>
		
		<cfif collegeCity NEQ qEditGetCollege.college_city>
			
			<!--- Update college city --->
			<cfif len(trim(collegeCity))>
				<cfquery>
					UPDATE COLLEGES
					SET college_city = <cfqueryparam value="#collegeCity#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfset errorBean.addError('A city name is required.', 'collegeCity')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for college website --->
	<cfif isDefined("form.collegeWebsite") && !errorBean.hasErrors()>
		<cfset collegeWebsite=canonicalize(trim(form.collegeWebsite), true, true)>
		
		<cfif collegeWebsite NEQ qEditGetCollege.college_website>
			
			<!--- Update college city --->
			<cfquery>
				UPDATE COLLEGES
				<cfif len(trim(collegeWebsite))>
					SET college_website = <cfqueryparam value="#collegeWebsite#" cfsqltype="cf_sql_varchar">
				<cfelse>
					SET college_website = NULL
				</cfif>
				WHERE id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for availability status --->
	<cfif isDefined("form.collegeAvailability") && !errorBean.hasErrors()>
		<cfif (status1 EQ "yes" && form.collegeAvailability NEQ 1) || (status2 EQ "yes" && form.collegeAvailability NEQ 2)>
			<!--- Update faculty role --->
			<cfquery>
				UPDATE COLLEGES
				<cfif form.collegeAvailability EQ 1>
					SET use_catalog = 1
				<cfelse>
					SET use_catalog = 0
				</cfif>
				WHERE id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>

	<!--- Refresh page if there were no errors --->
	<cfif !errorBean.hasErrors()>
		<cflocation url="editCollege.cfm?edit=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the Requirements by course "add" button action --->
<cfif isDefined("form.addCourseReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.localCourse))>
		<cfset errorBean.addError('An EvCC equivalent course number is required.', 'localCourse')>
	</cfif>
	
	<cfif !len(trim(form.foreignCourse))>
		<cfset errorBean.addError('The university required course must be specified.', 'foreignCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the course, if exists --->
	<cfquery name="qEditGetCourse">
		SELECT id, course_number
		FROM COURSES
		WHERE use_catalog = 1
		AND course_number = <cfqueryparam value="#trim(form.localCourse)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<!--- Handle student ID search results. --->
	<cfif !qEditGetCourse.RecordCount>
		<cfset errorBean.addError('The EvCC course could not be found.', 'localCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfset foreignCourse=canonicalize(trim(form.foreignCourse), true, true)>
	
	<cfquery>
		INSERT INTO COLLEGES_ADMISSION_COURSES (
			colleges_id, courses_id, foreign_course_number
		) VALUES (
			<cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#foreignCourse#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !errorBean.hasErrors()>
		<cflocation url="editCollege.cfm?edit=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the Requirements by department "add" button action --->
<cfif isDefined("form.addDepartmentReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.localDepartment EQ 0>
		<cfset errorBean.addError('Please select a department.', 'localDepartment')>
	</cfif>
	
	<cfif !len(trim(form.departmentCredits))>
		<cfset errorBean.addError('The number of department credits is required.', 'departmentCredits')>
	<cfelseif !IsValid("numeric", trim(form.departmentCredits))>
		<cfset errorBean.addError('Credits must be a decimal number.', 'departmentCredits')>
	<cfelseif !(trim(form.departmentCredits) GT 0)>
		<cfset errorBean.addError('The number of credits must be a positive number.', 'departmentCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfquery>
		INSERT INTO COLLEGE_ADMISSION_DEPARTMENTS (
			colleges_id, departments_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.localDepartment#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.departmentCredits#" cfsqltype="cf_sql_decimal">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !errorBean.hasErrors()>
		<cflocation url="editCollege.cfm?edit=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the Requirements by academic discipline "add" button action --->
<cfif isDefined("form.addCodekeyReq")>
	
		<!--- Perform simple validation on form fields --->
	<cfif form.localCodekey EQ 0>
		<cfset errorBean.addError('Please select a discipline.', 'localCodekey')>
	</cfif>
	
	<cfif !len(trim(form.codekeyCredits))>
		<cfset errorBean.addError('The number of academic credits is required.', 'codekeyCredits')>
	<cfelseif !IsValid("numeric", trim(form.codekeyCredits))>
		<cfset errorBean.addError('Credits must be a decimal number.', 'codekeyCredits')>
	<cfelseif !(trim(form.codekeyCredits) GT 0)>
		<cfset errorBean.addError('The number of credits must be a positive number.', 'codekeyCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif errorBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfquery>
		INSERT INTO COLLEGE_ADMISSION_CODEKEYS (
			colleges_id, codekeys_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.localCodekey#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.codekeyCredits#" cfsqltype="cf_sql_decimal">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !errorBean.hasErrors()>
		<cflocation url="editCollege.cfm?edit=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Display errors if they exist --->
<cfinclude template="model/editCollege.cfm">
<cfreturn>