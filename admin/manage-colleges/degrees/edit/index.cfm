<!--- Edit Degree Controller --->
<!--- Thomas Dye, August 2016 --->
<cfif !IsUserInRole("editor")>
	<cflocation url="..">
</cfif>

<cfset messageBean=createObject('cfcMapping.messageBean').init()>

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
	SELECT id, degrees_id, category
	FROM DEGREE_CATEGORIES
	WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetDegreeNotes">
	SELECT
		admission_courses_note, admission_categories_note,
		graduation_courses_note, graduation_categories_note, general_note
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
	SELECT a.courses_id, a.foreign_course_number, a.degree_categories_id, c.id, c.course_number, d.category
	FROM DEGREE_ADMISSION_COURSES a
	JOIN COURSES c
	ON c.id = a.courses_id
	JOIN DEGREE_CATEGORIES d
	ON d.id = a.degree_categories_id
	WHERE a.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetAdmissionCategories">
	SELECT a.degree_categories_id, a.credit, d.category
	FROM DEGREE_ADMISSION_CATEGORIES a
	JOIN DEGREE_CATEGORIES d
	ON d.id = a.degree_categories_id
	WHERE a.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetGraduationCourses">
	SELECT g.courses_id, g.foreign_course_number, g.degree_categories_id, c.id, c.course_number, d.category
	FROM DEGREE_GRADUATION_COURSES g
	JOIN COURSES c
	ON c.id = g.courses_id
	JOIN DEGREE_CATEGORIES d
	ON d.id = g.degree_categories_id
	WHERE g.degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qEditGetGraduationCategories">
	SELECT g.degree_categories_id, g.credit, d.category
	FROM DEGREE_GRADUATION_CATEGORIES g
	JOIN DEGREE_CATEGORIES d
	ON d.id = g.degree_categories_id
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

<!--- Define the category "remove button action" --->
<cfif isDefined("form.delCategory")>
	
	<!--- Ensure the category is not in use --->
	<cfquery dbtype="query" name="qEditCheckAdmCourseCategory">
		SELECT category
		FROM qEditGetAdmissionCourses
		WHERE degree_categories_id = <cfqueryparam value="#form.categoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery dbtype="query" name="qEditCheckGrdCourseCategory">
		SELECT category
		FROM qEditGetGraduationCourses
		WHERE degree_categories_id = <cfqueryparam value="#form.categoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery dbtype="query" name="qEditCheckAdmDegreeCategory">
		SELECT degree_categories_id
		FROM qEditGetAdmissionCategories
		WHERE degree_categories_id = <cfqueryparam value="#form.categoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery dbtype="query" name="qEditCheckGrdDegreeCategory">
		SELECT degree_categories_id
		FROM qEditGetGraduationCategories
		WHERE degree_categories_id = <cfqueryparam value="#form.categoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="qEditCheckCategorySelectedCourses">
		SELECT id
		FROM PLAN_SELECTEDCOURSES
		WHERE degree_categories_id = <cfqueryparam value="#form.categoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckAdmCourseCategory.RecordCount>
		<cfset messageBean.addError('This degree category is in use by admission courses and cannot be deleted.', 'delCategory')>
	</cfif>
	
	<cfif qEditCheckGrdCourseCategory.RecordCount>
		<cfset messageBean.addError('This degree category is in use by graduation courses and cannot be deleted.', 'delCategory')>
	</cfif>
	
	<cfif qEditCheckAdmDegreeCategory.RecordCount>
		<cfset messageBean.addError('This degree category is in use by admission degree categories and cannot be deleted.', 'delCategory')>
	</cfif>
	
	<cfif qEditCheckGrdDegreeCategory.RecordCount>
		<cfset messageBean.addError('This degree category is in use by graduation degree categories and cannot be deleted.', 'delCategory')>
	</cfif>
	
	<cfif qEditCheckCategorySelectedCourses.RecordCount>
		<cfset messageBean.addError('This degree category is in use by student degree plans and cannot be deleted.', 'delCategory')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so delete the category --->
	<cfquery>
		DELETE
		FROM DEGREE_CATEGORIES
		WHERE id = <cfqueryparam value="#form.categoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
</cfif>

<!--- Define the category "Add category" button action --->
<cfif isDefined("form.addDegreeCategory")>
	
	<!--- Perform simple validation on form fields --->
	<cfif !len(trim(form.degreeCategory))>
		<cfset messageBean.addError('The degree category heading name must be supplied.', 'degreeCategory')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfset degreeCategory=canonicalize(trim(form.degreeCategory), true, true)>
	
	<cfquery dbtype="query" name="qEditCheckCategory">
		SELECT category
		FROM qEditGetAllCategories
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND category = <cfqueryparam value="#degreeCategory#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfif qEditCheckCategory.RecordCount>
		<cfset messageBean.addError('This degree category already exists.', 'degreeCategory')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Looks good, so update degree categories --->
	<cfquery>
		INSERT INTO DEGREE_CATEGORIES (
			degrees_id, category
		) VALUES (
			<cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#degreeCategory#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>
	
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
		<cfset messageBean.addError('A CC equivalent course number is required.', 'localAdmCourse')>
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
		<cfset messageBean.addError('The CC course could not be found.', 'localAdmCourse')>
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
		<cfset messageBean.addError('This CC course is already an admission requirement.', 'localAdmCourse')>
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
			degrees_id, courses_id, degree_categories_id, foreign_course_number
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

<!--- Define the admission requirements category notes "update" button action --->
<cfif isDefined("form.updateAdmCategoryReqNoteButton")>
	<cfset admCategoryReqNote=canonicalize(trim(form.admCategoryReqNote), true, true)>
		
	<cfif admCategoryReqNote NEQ qEditGetDegreeNotes.admission_categories_note>
		
		<!--- Update category notes --->
		<cfquery>
			UPDATE DEGREE_NOTES
			<cfif len(trim(admCategoryReqNote))>
				SET admission_categories_note = <cfqueryparam value="#admCategoryReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET admission_categories_note = NULL
			</cfif>
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the admission requirements category "remove" button action --->
<cfif isDefined("form.delAdmCategoryReq")>
	<cfquery>
		DELETE
		FROM DEGREE_ADMISSION_CATEGORIES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND degree_categories_id = <cfqueryparam value="#form.admCategoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
</cfif>

<!--- Define the admission requirements by degree category "add" button action --->
<cfif isDefined("form.addAdmCategoryReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.localAdmCategory EQ 0>
		<cfset messageBean.addError('Please select a category.', 'localAdmCategory')>
	</cfif>
	
	<cfif !len(trim(form.categoryAdmCredits))>
		<cfset messageBean.addError('The number of academic credits is required.', 'categoryAdmCredits')>
	<cfelseif !IsValid("numeric", trim(form.categoryAdmCredits))>
		<cfset messageBean.addError('Credits must be a decimal number.', 'categoryAdmCredits')>
	<cfelseif !(trim(form.categoryAdmCredits) LT 100)>
		<cfset messageBean.addError('The number of requested credits is too high.', 'categoryAdmCredits')>
	<cfelseif !(trim(form.categoryAdmCredits) GT 0)>
		<cfset messageBean.addError('The number of credits must be a positive number.', 'categoryAdmCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCategory">
		SELECT degree_categories_id
		FROM DEGREE_ADMISSION_CATEGORIES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND degree_categories_id = <cfqueryparam value="#trim(form.localAdmCategory)#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCategory.RecordCount>
		<cfset messageBean.addError('This category is already an admission requirement.', 'localAdmCategory')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>

	<!--- Looks good, so update degrees --->
	<cfquery>
		INSERT INTO DEGREE_ADMISSION_CATEGORIES (
			degrees_id, degree_categories_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#trim(form.localAdmCategory)#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.categoryAdmCredits#" scale="2" cfsqltype="cf_sql_decimal">
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
		<cfset messageBean.addError('An CC equivalent course number is required.', 'localGrdCourse')>
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
		<cfset messageBean.addError('The CC course could not be found.', 'localGrdCourse')>
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
			<cfset messageBean.addError('This CC course is already an admission requirement.', 'localGrdCourse')>
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
		<cfset messageBean.addError('This CC course is already an graduation requirement.', 'localGrdCourse')>
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
			degrees_id, courses_id, degree_categories_id, foreign_course_number
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

<!--- Define the graduation requirements category notes "update" button action --->
<cfif isDefined("form.updateGrdCategoryReqNoteButton")>
	<cfset grdCategoryReqNote=canonicalize(trim(form.grdCategoryReqNote), true, true)>
		
	<cfif grdCategoryReqNote NEQ qEditGetDegreeNotes.graduation_categories_note>
		
		<!--- Update category notes --->
		<cfquery>
			UPDATE DEGREE_NOTES
			<cfif len(trim(grdCategoryReqNote))>
				SET graduation_categories_note = <cfqueryparam value="#grdCategoryReqNote#" cfsqltype="cf_sql_varchar">
			<cfelse>
				SET graduation_categories_note = NULL
			</cfif>
			WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	
	<!--- Refresh page if there were no errors --->
	<cfif !messageBean.hasErrors()>
		<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
	</cfif>
</cfif>

<!--- Define the graduation requirements category "remove" button action --->
<cfif isDefined("form.delGrdCategoryReq")>
	<cfquery>
		DELETE
		FROM DEGREE_GRADUATION_CATEGORIES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND degree_categories_id = <cfqueryparam value="#form.grdCategoryId#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<!--- Refresh page --->
	<cflocation url="?college=#URLEncodedFormat(qEditGetCollege.id)#&degree=#URLEncodedFormat(qEditGetDegree.id)#">
</cfif>

<!--- Define the graduation requirements by degree category "add" button action --->
<cfif isDefined("form.addGrdCategoryReq")>
	
	<!--- Perform simple validation on form fields --->
	<cfif form.localGrdCategory EQ 0>
		<cfset messageBean.addError('Please select a category.', 'localGrdCategory')>
	</cfif>
	
	<cfif !len(trim(form.categoryGrdCredits))>
		<cfset messageBean.addError('The number of academic credits is required.', 'categoryGrdCredits')>
	<cfelseif !IsValid("numeric", trim(form.categoryGrdCredits))>
		<cfset messageBean.addError('Credits must be a decimal number.', 'categoryGrdCredits')>
	<cfelseif !(trim(form.categoryGrdCredits) LT 100)>
		<cfset messageBean.addError('The number of requested credits is too high.', 'categoryGrdCredits')>
	<cfelseif !(trim(form.categoryGrdCredits) GT 0)>
		<cfset messageBean.addError('The number of credits must be a positive number.', 'categoryGrdCredits')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure the category is not already an admission requirement --->
	<cfquery name="qEditCheckAdmCategory">
		SELECT degree_categories_id
		FROM DEGREE_ADMISSION_CATEGORIES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND degree_categories_id = <cfqueryparam value="#trim(form.localGrdCategory)#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckAdmCategory.RecordCount>
		<cfset messageBean.addError('This CC category is already an admission requirement.', 'localGrdCategory')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>
	
	<!--- Ensure no duplicates --->
	<cfquery name="qEditCheckCategory">
		SELECT degree_categories_id
		FROM DEGREE_GRADUATION_CATEGORIES
		WHERE degrees_id = <cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">
		AND degree_categories_id = <cfqueryparam value="#trim(form.localGrdCategory)#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif qEditCheckCategory.RecordCount>
		<cfset messageBean.addError('This category is already an graduation requirement.', 'localGrdCategory')>
	</cfif>
	
	<!--- Stop here if errors were detected --->
	<cfif messageBean.hasErrors()>
		<cfinclude template="model/editDegree.cfm">
		<cfreturn>
	</cfif>

	<!--- Looks good, so update degrees --->
	<cfquery>
		INSERT INTO DEGREE_GRADUATION_CATEGORIES (
			degrees_id, degree_categories_id, credit
		) VALUES (
			<cfqueryparam value="#qEditGetDegree.id#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#trim(form.localGrdCategory)#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#form.categoryGrdCredits#" scale="2" cfsqltype="cf_sql_decimal">
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