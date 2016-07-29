<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../home/courses.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Completed courses">
	
	<cfif IsUserInRole("advisor")>
		<h2>Completed courses for <cfoutput>#session.studentName#</cfoutput></h2>
	<cfelse>
		<h2>Completed courses</h2>
	</cfif>
	<p>Provide some instructions on how the completed courses section works and initial steps to get started using the Advisor Services Portal.</p>

	<h3>Add completed course</h3>
	<cfform>
		<cfinput type="text" id="courseNumber" name="courseNumber">
		<cfinput type="submit" name="addButton" value="Add">
	</cfform>
	
	<a href="https://www.everettcc.edu/catalog/" title="Look up course code" target="_blank">Look up course code</a>
	
	<cfif errorBean.hasErrors() && isDefined("form.addButton")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>
	
	<cfif isDefined("qGetCourse")>
		<table>
			<tr>
				<th>Course Number</th>
				<th>Title</th>
				<th>Credits</th>
				<th></th>
			</tr>
			<cfloop query="qGetCourse">
				<tr>
					<td><cfoutput>#qGetCourse.course_number#</cfoutput></td>
					<td><cfoutput>#qGetCourse.title#</cfoutput></td>
					<cfif !len(qGetCourse.min_credit)>
						<td><cfoutput>#qGetCourse.max_credit#</cfoutput></td>
					<cfelse>
						<td><cfoutput>#qGetCourse.min_credit# - #qGetCourse.max_credit#</cfoutput></td>
					</cfif>
					<td><cfoutput><a href="?course=#URLEncodedFormat(qGetCourse.course_number)#&id=#URLEncodedFormat(qGetCourse.id)#" title="Add">Add</a></cfoutput></td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		<p>No completed courses added yet.</p>
	</cfif>
	
	<cfif errorBean.hasErrors() && isDefined("qCheckCourse")>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>
	
	<cfif isDefined("qCheckCourse") && qCheckCourse.RecordCount>
		<cfif IsNumeric(qCheckCourse.min_credit) || isDefined("qGetPrerequisite") || isDefined("qGetPermission") || isDefined("qGetPlacement")>
			<h3>Verify course eligibility</h3>
			<h4><cfoutput>#qCheckCourse.course_number# - #qCheckCourse.title#</cfoutput></h4>
			
			<cfform>
				<cfif IsNumeric(qCheckCourse.min_credit)>
					<label for="courseCredit">Credits taken <cfoutput>(#qCheckCourse.min_credit# - #qCheckCourse.max_credit#)</cfoutput>:</label>
					<cfinput type="text" id="courseCredit" name="courseCredit">
				</cfif>
				
				<cfif isDefined("qGetPrerequisite") || isDefined("qGetPermission") || isDefined("qGetPlacement")>
					<cfif isDefined("qGetPrerequisite") && q.GetPrerequisite.RecordCount>
						<cfset group="#qGetPrequisite.group#">
						<cfset createLabel="true">
						<cfset firstInGroup="true">
						
						<!--- Build UI for prerequisite radio groups --->
						<cfloop query="qGetPrerequisite">
							<cfif createLabel EQ 'true'>
								<cfinput type="radio" id="prereq#group#" name="prereq#group#">
								<label for="prereq#group#">
							</cfif>
							
							<cfif group EQ qGetPrequisite.group>
								<cfset createLabel="false">
								
								<!--- add from the same group --->
								<cfif firstInGroup EQ 'true'>
									<cfoutput>#qGetPrerequiste.courses_prerequisite_id#</cfoutput>
									<cfset firstInGroup="false">
								<cfelse>
									<cfoutput> and #qGetPrerequiste.courses_prerequisite_id#</cfoutput>
								</cfif>
							<cfelse>
								<!--- the group changed, so end the label --->
								<cfoutput> with a grade of C or higher</cfoutput></label><br>
								
								<cfset group="#qGetPrequisite.group#">
								
								<!--- begin the next radio and label --->
								<cfinput type="radio" id="prereq#group#" name="prereq#group#">
								<label for="prereq#group#"><cfoutput>#qGetPrerequiste.courses_prerequisite_id#</cfoutput>
							</cfif>	
						</cfloop>
						<cfoutput> with a grade of C or higher</cfoutput></label><br>
					</cfif>
					
					<cfif isDefined("qGetPermission") && qGetPermission.RecordCount>
						<cfinput type="radio" id="coursePermission" name="coursePermission">
						<label for="coursePermission">Instructor permission</label><br>
					</cfif>
					
					<cfif isDefined("qGetPlacement") && qGetPlacement.RecordCount>
						<cfinput type="radio" id="coursePlacement" name="coursePlacement">
						<label for="coursePermission">Placement into <cfoutput>#qCheckCourse.course_number#</cfoutput> by assessment.</label><br>
					</cfif>
				</cfif>
				
				<cfinput type="submit" name="addButton" value="Add course">
				<cfinput type="button" name="cancelButton" value="Cancel">
			</cfform>
		</cfif>
	</cfif>
	
<cfmodule template="../includes/footer.cfm">