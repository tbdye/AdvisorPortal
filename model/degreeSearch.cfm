<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"
	pagetitle="Advisor Services Portal - Degree search">
	
	<h2>Degree search</h2>
	
	<p>Provide some instructions on how the degree search section works and initial steps to get started using the Advisor Services Portal.</p>
	
	<!--- Add search degrees textbox form. --->
	<h3>Search for degrees</h3>
	<cfform>
		<cfinput type="text" id="degreeName" name="degreeName">
		<cfinput type="submit" name="searchButton" value="Search">
	</cfform>
	
	<h3>Filters</h3>
	<!--- Add filter checkbox forms. --->
	<cfif isDefined("aDepartments") && ArrayLen(aDepartments)>
		<h4>Departments</h4>
		<cfform>
			<cfloop index="i" from=1 to=#ArrayLen(aDepartments)#>
				<cfinput type="checkbox" id="department#i#" name="department" value="#i#">
				<cfoutput><label for="department#i#">#aDepartments[i]#</label></cfoutput><br>
			</cfloop>
			<cfinput type="submit" name="updateDepartmentsButton" value="Update">
		</cfform>
	</cfif>
	<cfif isDefined("aSchools") && ArrayLen(aSchools)>
		<h4>Schools</h4>
		<cfform>
			<cfloop index="i" from=1 to=#ArrayLen(aSchools)#>
				<cfinput type="checkbox" id="school#i#" name="school" value="#i#">
				<cfoutput><label for="school#i#">#aSchools[i]#</label></cfoutput><br>
			</cfloop>
			<cfinput type="submit" name="updateSchoolsButton" value="Update">
		</cfform>
	</cfif>
	
	<!--- Begin main content --->
	<cfif isDefined("qDegreesGetDegrees") && qDegreesGetDegrees.RecordCount>
		<cfloop index="i" from=1 to=#ArrayLen(aDegrees)#>
			<cfform>
				<table>
					<tr>
						<th><cfoutput><a href="viewDegree.cfm?degreeName=#URLEncodedFormat(aDegrees[i].degreeName)#" title="#aDegrees[i].degreeName#" target="_blank">#aDegrees[i].degreeName#</a></cfoutput></th>
						<th><cfinput type="submit" name="selectDegreeButton" value="Select"></th>
					</tr>
					<tr>
						<th><cfoutput>#aDegrees[i].collegeName#, #aDegrees[i].collegeCity#</cfoutput></th>
						<th></th>
					</tr>
					<tr>
						<th><cfoutput>#aDegrees[i].degreeType#</cfoutput></th>
						<th></th>
					</tr>
				</table>
				<cfinput type="hidden" id="degreeId" name="degreeId" value="#aDegrees[i]#">
			</cfform>
		</cfloop>
	</cfif>
	
	<!--- Display an error if the user selection isn't a valid course. --->
	<cfif errorBean.hasErrors()>
		<ul>
			<cfloop array="#errorBean.getErrors()#" index="error">
				<cfoutput><li>Error:  #error.message#</li></cfoutput>
			</cfloop>
		</ul>
	</cfif>

<cfmodule template="../includes/footer.cfm">