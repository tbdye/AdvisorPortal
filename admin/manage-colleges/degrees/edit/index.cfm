<!--- Edit Degree Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Do basic validation --->
<cfif !IsDefined("url.college") || !IsDefined("url.degree") || !IsNumeric("#URLDecode(url.college)#") || !IsNumeric("#URLDecode(url.degree)#")>
	<cflocation url="..">
</cfif>

<!--- Prepare basic contents of the page --->
<cfquery name="qEditGetCollege">
	SELECT id, college_name, college_city, college_website, use_catalog
	FROM COLLEGES
	WHERE id = <cfqueryparam value="#URLDecode(url.college)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetDegree">
	SELECT id, degree_name, departments_id, degree_type, use_catalog
	FROM DEGREES
	WHERE id = <cfqueryparam value="#URLDecode(url.degree)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Back out if the college or degree ID is not valid --->
<cfif !qEditGetCollege.RecordCount || !qEditGetDegree.RecordCount>
	<cflocation url="..">
</cfif>

<!--- Prepare degree update form contents --->
<cfquery name="qEditGetAllDepartments">
	SELECT id, department_name
	FROM DEPARTMENTS
	<cfif !IsUserInRole("administrator")>
		WHERE use_catalog = 1
	</cfif>
	ORDER BY department_name ASC
</cfquery>

<cfquery name="qEditGetAllCategories">
	SELECT id, category
	FROM CATEGORIES
</cfquery>

<cfquery name="qEditGetAllCodekeys">
	SELECT id, description
	FROM CODEKEYS
</cfquery>

<cfquery name="qEditGetDegreeNotes">
	SELECT
		admission_courses_note, admission_codekeys_note,
		graduation_courses_note, graduation_codekeys_note, general_note
	FROM DEGREE_NOTES
	WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Set defaults for form data --->
<cfset status1="no">
<cfset status2="no">
<cfif qEditGetDegree.use_catalog>
	<cfset status1="yes">
<cfelse>
	<cfset status2="yes">
</cfif>

<!--- Prepare requirements contents --->
<cfquery name="qEditGetAdmissionCourses">
	SELECT a.courses_id, a.foreign_course_number, c.id, c.course_number, cat.category
	FROM DEGREE_ADMISSION_COURSES a, COURSES c, CATEGORIES cat
	WHERE a.courses_id = c.id
	AND a.categories_id = cat.id
	AND a.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetAdmissionCodekeys">
	SELECT a.codekeys_id, a.credit, c.id, c.description
	FROM DEGREE_ADMISSION_CODEKEYS a
	JOIN CODEKEYS c
	ON a.codekeys_id = c.id
	WHERE a.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetGraduationCourses">
	SELECT g.courses_id, g.foreign_course_number, c.id, c.course_number, cat.category
	FROM DEGREE_GRADUATION_COURSES g, COURSES c, CATEGORIES cat
	WHERE g.courses_id = c.id
	AND g.categories_id = cat.id
	AND g.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetGraduationCodekeys">
	SELECT g.codekeys_id, g.credit, c.id, c.description
	FROM DEGREE_GRADUATION_CODEKEYS g
	JOIN CODEKEYS c
	ON g.codekeys_id = c.id
	WHERE g.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Define the "Update degree" button action --->
<cfif isDefined("form.updateDegreeButton")>
	
	<!--- Evaluate update for degree name --->
	<cfif isDefined("form.degreeName") && !messageBean.hasErrors()>
		<cfset degreeName=canonicalize(trim(form.degreeName), true, true)>
			
		<cfif degreeName NEQ qEditGetDegree.degree_name>
			
			<!--- Update degree name --->
			<cfif len(trim(degreeName))>
				<cfquery>
					UPDATE DEGREES
					SET degree_name = <cfqueryparam value="#degreeName#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfset messageBean.addError('A degree name is required.', 'degreeName')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for degree department --->
	<cfif isDefined("form.degreeDepartment") && !messageBean.hasErrors()>>
		<cfif degreeDepartment NEQ qEditGetDegree.departments_id>
			
			<!--- Update degree department --->
			<cfif form.degreeDepartment>
				<cfquery>
					UPDATE DEGREES
					SET departments_id = <cfqueryparam value="#form.degreeDepartment#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfset messageBean.addError('A degree department is required.', 'degreeDepartment')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for degree type --->
	<cfif isDefined("form.degreeType") && !messageBean.hasErrors()>
		<cfset degreeType=canonicalize(trim(form.degreeType), true, true)>
			
		<cfif degreeType NEQ qEditGetDegree.degree_type>
			
			<!--- Update degree name --->
			<cfif len(trim(degreeType))>
				<cfquery>
					UPDATE DEGREES
					SET degree_type = <cfqueryparam value="#degreeType#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfset messageBean.addError('A degree type is required.', 'degreeType')>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Evaluate update for availability status --->
	<cfif isDefined("form.degreeAvailability") && !messageBean.hasErrors()>
		<cfif (status1 EQ "yes" && form.degreeAvailability NEQ 1) || (status2 EQ "yes" && form.degreeAvailability NEQ 2)>
			<!--- Update availability --->
			<cfquery>
				UPDATE DEGREES
				<cfif form.degreeAvailability EQ 1>
					SET use_catalog = 1
				<cfelse>
					SET use_catalog = 0
				</cfif>
				WHERE id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements course notes "update" button action --->
<cfif isDefined("form.updateAdmCourseReqNoteButton")>
	<cfset admCourseReqNote=canonicalize(trim(form.admCourseReqNote), true, true)>
		
	<cfif admCourseReqNote NEQ qEditGetDegreeNotes.admission_courses_note>
		
		<!--- Update course notes --->
		<cfquery>
			UPDATE DEGREE_NOTES
			<cfif len(trim(admCourseReqNote))>
				SET admission_courses_note = <cfqueryparam value="#admCourseReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET admission_courses_note = NULL
			</cfif>
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements courses "remove" button action --->
<cfif isDefined("form.delAdmCourseReq")>
	<cfquery>
		DELETE
		FROM DEGREE_ADMISSION_COURSES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#form.admCoursesId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
</cfif>

<!--- Define the admission requirements courses "add" button action --->
<cfif isDefined("form.addAdmCourseReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.localAdmCourse))>
		<cfset messageBean.addError('An EvCC equivalent course number is required.', 'localAdmCourse')>
	</cfif>
	
	<cfif form.localAdmCourseCategory EQ 0>
		<cfset messageBean.addError('Please select a category.', 'localAdmCourseCategory')>
	</cfif>
	
	<cfif !len(trim(form.foreignAdmCourse))>
		<cfset messageBean.addError('The university required course must be specified.', 'foreignAdmCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the course, if exists --->
	<cfquery name="qEditGetCourse">
		SELECT id
		FROM COURSES
		WHERE course_number = <cfqueryparam value="#trim(form.localAdmCourse)#" cfsqltype="cf_sql_varchar">
		<cfif !IsUserInRole("administrator")>
			AND use_catalog = 1
		</cfif>
	</cfquery>
	
	<cfif !qEditGetCourse.RecordCount>
		<cfset messageBean.addError('The EvCC course could not be found.', 'localAdmCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCourse">
		SELECT courses_id
		FROM DEGREE_ADMISSION_COURSES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCourse.RecordCount>
		<cfset messageBean.addError('This EvCC course is already an admission requirement.', 'localAdmCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update degrees --->
	<cfset foreignAdmCourse=canonicalize(trim(form.foreignAdmCourse), true, true)>
	
	<cfquery>
		INSERT INTO DEGREE_ADMISSION_COURSES (
			degrees_id, courses_id, categories_id, foreign_course_number
		) VALUES (
			<cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.localAdmCourseCategory#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#foreignAdmCourse#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements codekey notes "update" button action --->
<cfif isDefined("form.updateAdmCodekeyReqNoteButton")>
	<cfset admCodekeyReqNote=canonicalize(trim(form.admCodekeyReqNote), true, true)>
		
	<cfif admCodekeyReqNote NEQ qEditGetDegreeNotes.admission_codekeys_note>
		
		<!--- Update codekey notes --->
		<cfquery>
			UPDATE DEGREE_NOTES
			<cfif len(trim(admCodekeyReqNote))>
				SET admission_codekeys_note = <cfqueryparam value="#admCodekeyReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET admission_codekeys_note = NULL
			</cfif>
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements codekeys "remove" button action --->
<cfif isDefined("form.delAdmCodekeyReq")>
	<cfquery>
		DELETE
		FROM DEGREE_ADMISSION_CODEKEYS
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND codekeys_id = <cfqueryparam value="#form.admCodekeysId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
</cfif>

<!--- Define the admission requirements by academic discipline "add" button action --->
<cfif isDefined("form.addAdmCodekeyReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.localAdmCodekey EQ 0>
		<cfset messageBean.addError('Please select a discipline.', 'localAdmCodekey')>
	</cfif>
	
	<cfif !len(trim(form.codekeyAdmCredits))>
		<cfset messageBean.addError('The number of academic credits is required.', 'codekeyAdmCredits')>
	<cfelseif !IsValid("numeric", trim(form.codekeyAdmCredits))>
		<cfset messageBean.addError('Credits must be a decimal number.', 'codekeyAdmCredits')>
	<cfelseif !(trim(form.codekeyAdmCredits) GT 0)>
		<cfset messageBean.addError('The number of credits must be a positive number.', 'codekeyAdmCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the codekey, if exists --->
	<cfquery name="qEditGetCodekey">
		SELECT id
		FROM CODEKEYS
		WHERE id = <cfqueryparam value="#trim(form.localAdmCodekey)#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif !qEditGetCodekey.RecordCount>
		<cfset messageBean.addError('The EvCC discipline could not be found.', 'localAdmCodekey')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCodekey">
		SELECT codekeys_id
		FROM DEGREE_ADMISSION_CODEKEYS
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND codekeys_id = <cfqueryparam value="#qEditGetCodekey.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCodekey.RecordCount>
		<cfset messageBean.addError('This EvCC discipline is already an admission requirement.', 'localAdmCodekey')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update degrees --->
	<cfquery>
		INSERT INTO DEGREE_ADMISSION_CODEKEYS (
			degrees_id, codekeys_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCodekey.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.codekeyAdmCredits#" cfsqltype="cf_sql_decimal">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the graduation requirements course notes "update" button action --->
<cfif isDefined("form.updateGrdCourseReqNoteButton")>
	<cfset grdCourseReqNote=canonicalize(trim(form.grdCourseReqNote), true, true)>
		
	<cfif grdCourseReqNote NEQ qEditGetDegreeNotes.graduation_courses_note>
		
		<!--- Update course notes --->
		<cfquery>
			UPDATE DEGREE_NOTES
			<cfif len(trim(grdCourseReqNote))>
				SET graduation_courses_note = <cfqueryparam value="#grdCourseReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET graduation_courses_note = NULL
			</cfif>
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the graduation requirements courses "remove" button action --->
<cfif isDefined("form.delGrdCourseReq")>
	<cfquery>
		DELETE
		FROM DEGREE_GRADUATION_COURSES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#form.grdCoursesId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
</cfif>

<!--- Define the graduation requirements courses "add" button action --->
<cfif isDefined("form.addGrdCourseReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.localGrdCourse))>
		<cfset messageBean.addError('An EvCC equivalent course number is required.', 'localGrdCourse')>
	</cfif>
	
	<cfif form.localGrdCourseCategory EQ 0>
		<cfset messageBean.addError('Please select a category.', 'localGrdCourseCategory')>
	</cfif>
	
	<cfif !len(trim(form.foreignGrdCourse))>
		<cfset messageBean.addError('The university required course must be specified.', 'foreignGrdCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the course, if exists --->
	<cfquery name="qEditGetCourse">
		SELECT id
		FROM COURSES
		WHERE course_number = <cfqueryparam value="#trim(form.localGrdCourse)#" cfsqltype="cf_sql_varchar">
		<cfif !IsUserInRole("administrator")>
			AND use_catalog = 1
		</cfif>
	</cfquery>
	
	<cfif !qEditGetCourse.RecordCount>
		<cfset messageBean.addError('The EvCC course could not be found.', 'localGrdCourse')>
	</cfif>
	
	<!--- Ensure the course is not already an admission requirement --->
	<cfif !messageBean.hasErrors()>
		<cfquery name="qEditCheckAdmCourse">
			SELECT courses_id
			FROM DEGREE_ADMISSION_COURSES
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
			AND courses_id = <cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfif qEditCheckAdmCourse.RecordCount>
			<cfset messageBean.addError('This EvCC course is already an admission requirement.', 'localGrdCourse')>
		</cfif>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCourse">
		SELECT courses_id
		FROM DEGREE_GRADUATION_COURSES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND courses_id = <cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCourse.RecordCount>
		<cfset messageBean.addError('This EvCC course is already an graduation requirement.', 'localGrdCourse')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update degrees --->
	<cfset foreignGrdCourse=canonicalize(trim(form.foreignGrdCourse), true, true)>
	
	<cfquery>
		INSERT INTO DEGREE_GRADUATION_COURSES (
			degrees_id, courses_id, categories_id, foreign_course_number
		) VALUES (
			<cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCourse.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.localGrdCourseCategory#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#foreignGrdCourse#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the graduation requirements codekey notes "update" button action --->
<cfif isDefined("form.updateGrdCodekeyReqNoteButton")>
	<cfset grdCodekeyReqNote=canonicalize(trim(form.grdCodekeyReqNote), true, true)>
		
	<cfif grdCodekeyReqNote NEQ qEditGetDegreeNotes.graduation_codekeys_note>
		
		<!--- Update codekey notes --->
		<cfquery>
			UPDATE DEGREE_NOTES
			<cfif len(trim(grdCodekeyReqNote))>
				SET graduation_codekeys_note = <cfqueryparam value="#grdCodekeyReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET graduation_codekeys_note = NULL
			</cfif>
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the graduation requirements codekeys "remove" button action --->
<cfif isDefined("form.delGrdCodekeyReq")>
	<cfquery>
		DELETE
		FROM DEGREE_GRADUATION_CODEKEYS
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND codekeys_id = <cfqueryparam value="#form.grdCodekeysId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
</cfif>

<!--- Define the graduation requirements by academic discipline "add" button action --->
<cfif isDefined("form.addGrdCodekeyReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.localGrdCodekey EQ 0>
		<cfset messageBean.addError('Please select a discipline.', 'localGrdCodekey')>
	</cfif>
	
	<cfif !len(trim(form.codekeyGrdCredits))>
		<cfset messageBean.addError('The number of academic credits is required.', 'codekeyGrdCredits')>
	<cfelseif !IsValid("numeric", trim(form.codekeyGrdCredits))>
		<cfset messageBean.addError('Credits must be a decimal number.', 'codekeyGrdCredits')>
	<cfelseif !(trim(form.codekeyGrdCredits) GT 0)>
		<cfset messageBean.addError('The number of credits must be a positive number.', 'codekeyGrdCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Find the codekey, if exists --->
	<cfquery name="qEditGetCodekey">
		SELECT id
		FROM CODEKEYS
		WHERE id = <cfqueryparam value="#trim(form.localGrdCodekey)#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif !qEditGetCodekey.RecordCount>
		<cfset messageBean.addError('The EvCC discipline could not be found.', 'localGrdCodekey')>
	</cfif>
	
	<!--- Ensure the codekey is not already an admission requirement --->
	<cfif !messageBean.hasErrors()>
		<cfquery name="qEditCheckAdmCodekey">
			SELECT codekeys_id
			FROM DEGREE_ADMISSION_CODEKEYS
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
			AND codekeys_id = <cfqueryparam value="#qEditGetCodekey.id#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfif qEditCheckAdmCodekey.RecordCount>
			<cfset messageBean.addError('This EvCC discipline is already an admission requirement.', 'localGrdCodekey')>
		</cfif>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCodekey">
		SELECT codekeys_id
		FROM DEGREE_GRADUATION_CODEKEYS
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND codekeys_id = <cfqueryparam value="#qEditGetCodekey.id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCodekey.RecordCount>
		<cfset messageBean.addError('This EvCC discipline is already an graduation requirement.', 'localGrdCodekey')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update degrees --->
	<cfquery>
		INSERT INTO DEGREE_GRADUATION_CODEKEYS (
			degrees_id, codekeys_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#qEditGetCodekey.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.codekeyGrdCredits#" cfsqltype="cf_sql_decimal">
		)
	</cfquery>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the degree general notes "update" button action --->
<cfif isDefined("form.updateDegreeGeneralNoteButton")>
	<cfset degreeGeneralNote=canonicalize(trim(form.degreeGeneralNote), true, true)>
		
	<cfif degreeGeneralNote NEQ qEditGetDegreeNotes.general_note>
		
		<!--- Update degree notes --->
		<cfquery>
			UPDATE DEGREE_NOTES
			<cfif len(trim(degreeGeneralNote))>
				SET general_note = <cfqueryparam value="#degreeGeneralNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET general_note = NULL
			</cfif>
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Display page without errors --->
<cfinclude template="model/editDegree.cfm">
<cfreturn>