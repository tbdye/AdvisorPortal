<!--- Edit College Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor") || !IsDefined("url.college")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetCollege">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
	WHERE id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the college ID is not valid --->
<cfif !qEditGetCollege.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Prepare admission requirements contents --->
<cfquery name="qEditGetAdmissionCourses">
	SELECT a.foreign_course_number, c.id, c.course_number, cat.category
	FROM COLLEGE_ADMISSION_COURSES a, COURSES c, CATEGORIES cat
	WHERE a.courses_id = c.id
	AND a.categories_id = cat.id
	AND a.colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetAdmissionDepartments">
	SELECT a.credit, d.id, d.department_name
	FROM COLLEGE_ADMISSION_DEPARTMENTS a
	JOIN DEPARTMENTS d
	ON a.departments_id = d.id
	WHERE a.colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetAdmissionCodekeys">
	SELECT a.credit, c.id, c.description
	FROM COLLEGE_ADMISSION_CODEKEYS a
	JOIN CODEKEYS c
	ON a.codekeys_id = c.id
	WHERE a.colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetSelectCategories">
	SELECT id, category
	FROM CATEGORIES
</cfquery>

<cfquery name="qEditGetSelectDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	ORDER BY department_name ASC
</cfquery>

<cfquery name="qEditGetSelectCodekeys">
	SELECT id, description
	FROM CODEKEYS
</cfquery>

<cfquery name="qEditGetCollegeNotes">
	SELECT courses_note, departments_note, codekeys_note
	FROM COLLEGE_NOTES
	WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
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
	<cfif isDefined("form.collegeName") && !messageBean.hasErrors()>
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
				<cfset messageBean.addError('A college name is required.', 'collegeName')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for college city --->
	<cfif isDefined("form.collegeCity") && !messageBean.hasErrors()>
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
				<cfset messageBean.addError('A city name is required.', 'collegeCity')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for college website --->
	<cfif isDefined("form.collegeWebsite") && !messageBean.hasErrors()>
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
	<cfif isDefined("form.collegeAvailability") && !messageBean.hasErrors()>
		<cfif (status1 EQ "yes" && form.collegeAvailability NEQ 1) || (status2 EQ "yes" && form.collegeAvailability NEQ 2)>
			<!--- Update availability --->
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
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements course notes "update" button action --->
<cfif isDefined("form.updateCourseReqNoteButton")>
	<cfset courseReqNote=canonicalize(trim(form.courseReqNote), true, true)>
		
	<cfif courseReqNote NEQ qEditGetCollegeNotes.courses_note>
		
		<!--- Update course notes --->
		<cfquery>
			UPDATE COLLEGE_NOTES
			<cfif len(trim(courseReqNote))>
				SET courses_note = <cfqueryparam value="#courseReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET courses_note = NULL
			</cfif>
			WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements courses "remove" button action --->
<cfif isDefined("form.delCourseReq")>
	<cfquery>
		DELETE
		FROM COLLEGE_ADMISSION_COURSES
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#form.coursesId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
</cfif>

<!--- Define the Requirements by course "add" button action --->
<cfif isDefined("form.addCourseReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.localCourse))>
		<cfset messageBean.addError('An EvCC equivalent course number is required.', 'localCourse')>
	</cfif>
	
	<cfif form.localCourseCategory EQ 0>
		<cfset messageBean.addError('Please select a category.', 'localCourseCategory')>
	</cfif>
	
	<cfif !len(trim(form.foreignCourse))>
		<cfset messageBean.addError('The university required course must be specified.', 'foreignCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the course, if exists --->
	<cfquery name="qEditGetCourse">
		SELECT id
		FROM COURSES
		WHERE course_number = <cfqueryparam value="#trim(form.localCourse)#" cfsqltype="cf_sql_varchar">
		<cfif !IsUserInRole("administrator")>
			AND use_catalog = 1
		</cfif>
	</cfquery>
	
	<cfif !qEditGetCourse.RecordCount>
		<cfset messageBean.addError('The EvCC course could not be found.', 'localCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCourse">
		SELECT courses_id
		FROM COLLEGE_ADMISSION_COURSES
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCourse.RecordCount>
		<cfset messageBean.addError('This EvCC course is already an admission requirement.', 'localCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfset foreignCourse=canonicalize(trim(form.foreignCourse), true, true)>
	
	<cfquery>
		INSERT INTO COLLEGE_ADMISSION_COURSES (
			colleges_id, courses_id, categories_id, foreign_course_number
		) VALUES (
			<cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.localCourseCategory#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#foreignCourse#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements department notes "update" button action --->
<cfif isDefined("form.updateDepartmentReqNoteButton")>
	<cfset departmentReqNote=canonicalize(trim(form.departmentReqNote), true, true)>
		
	<cfif departmentReqNote NEQ qEditGetCollegeNotes.departments_note>
		
		<!--- Update department notes --->
		<cfquery>
			UPDATE COLLEGE_NOTES
			<cfif len(trim(departmentReqNote))>
				SET departments_note = <cfqueryparam value="#departmentReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET departments_note = NULL
			</cfif>
			WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements departments "remove" button action --->
<cfif isDefined("form.delDepartmentReq")>
	<cfquery>
		DELETE
		FROM COLLEGE_ADMISSION_DEPARTMENTS
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND departments_id = <cfqueryparam value="#form.departmentsId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
</cfif>

<!--- Define the Requirements by department "add" button action --->
<cfif isDefined("form.addDepartmentReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.localDepartment EQ 0>
		<cfset messageBean.addError('Please select a department.', 'localDepartment')>
	</cfif>
	
	<cfif !len(trim(form.departmentCredits))>
		<cfset messageBean.addError('The number of department credits is required.', 'departmentCredits')>
	<cfelseif !IsValid("numeric", trim(form.departmentCredits))>
		<cfset messageBean.addError('Credits must be a decimal number.', 'departmentCredits')>
	<cfelseif !(trim(form.departmentCredits) GT 0)>
		<cfset messageBean.addError('The number of credits must be a positive number.', 'departmentCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the department, if exists --->
	<cfquery name="qEditGetDepartment">
		SELECT id
		FROM DEPARTMENTS
		WHERE id = <cfqueryparam value="#trim(form.localDepartment)#" cfsqltype="cf_sql_integer">
		<cfif !IsUserInRole("administrator")>
			AND use_catalog = 1
		</cfif>
	</cfquery>

	<cfif !qEditGetDepartment.RecordCount>
		<cfset messageBean.addError('The EvCC department could not be found.', 'localDepartment')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckDepartment">
		SELECT departments_id
		FROM COLLEGE_ADMISSION_DEPARTMENTS
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND departments_id = <cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckDepartment.RecordCount>
		<cfset messageBean.addError('This EvCC department is already an admission requirement.', 'localDepartment')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfquery>
		INSERT INTO COLLEGE_ADMISSION_DEPARTMENTS (
			colleges_id, departments_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetDepartment.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.departmentCredits#" cfsqltype="cf_sql_decimal">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements academic discipline notes "update" button action --->
<cfif isDefined("form.updateCodekeyReqNoteButton")>
	<cfset codekeyReqNote=canonicalize(trim(form.codekeyReqNote), true, true)>
		
	<cfif codekeyReqNote NEQ qEditGetCollegeNotes.codekeys_note>
		
		<!--- Update codekey notes --->
		<cfquery>
			UPDATE COLLEGE_NOTES
			<cfif len(trim(codekeyReqNote))>
				SET codekeys_note = <cfqueryparam value="#codekeyReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET codekeys_note = NULL
			</cfif>
			WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements academic discipline "remove" button action --->
<cfif isDefined("form.delCodekeyReq")>
	<cfquery>
		DELETE
		FROM COLLEGE_ADMISSION_CODEKEYS
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND codekeys_id = <cfqueryparam value="#form.codekeysId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
</cfif>

<!--- Define the Requirements by academic discipline "add" button action --->
<cfif isDefined("form.addCodekeyReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.localCodekey EQ 0>
		<cfset messageBean.addError('Please select a discipline.', 'localCodekey')>
	</cfif>
	
	<cfif !len(trim(form.codekeyCredits))>
		<cfset messageBean.addError('The number of academic credits is required.', 'codekeyCredits')>
	<cfelseif !IsValid("numeric", trim(form.codekeyCredits))>
		<cfset messageBean.addError('Credits must be a decimal number.', 'codekeyCredits')>
	<cfelseif !(trim(form.codekeyCredits) GT 0)>
		<cfset messageBean.addError('The number of credits must be a positive number.', 'codekeyCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the codekey, if exists --->
	<cfquery name="qEditGetCodekey">
		SELECT id
		FROM CODEKEYS
		WHERE id = <cfqueryparam value="#trim(form.localCodekey)#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif !qEditGetCodekey.RecordCount>
		<cfset messageBean.addError('The EvCC discipline could not be found.', 'localCodekey')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCodekey">
		SELECT codekeys_id
		FROM COLLEGE_ADMISSION_CODEKEYS
		WHERE colleges_id = <cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">
		AND codekeys_id = <cfqueryparam value="#qEditGetCodekey.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCodekey.RecordCount>
		<cfset messageBean.addError('This EvCC discipline is already an admission requirement.', 'localCodekey')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editCollege.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update colleges --->
	<cfquery>
		INSERT INTO COLLEGE_ADMISSION_CODEKEYS (
			colleges_id, codekeys_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetCollege.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCodekey.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.codekeyCredits#" cfsqltype="cf_sql_decimal">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#">
	</cfif>
</cfif>

<!--- Display page without errors --->
<cfinclude template="model/editCollege.cfm">
<cfreturn>