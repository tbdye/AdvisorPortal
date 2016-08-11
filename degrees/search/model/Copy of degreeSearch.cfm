<!--- Degrees Search Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm">

<pagetitle="Advisor Services Portal - Degree Search">

	<!--- Alter page header depending if in an adivisng session or not. --->
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>Degree Search</h1>
			</header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <a href="..">Degree Plans</a>
				&raquo; Degree Search
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
					<span property="dc:title" content="Degree Search" class="rdf-meta element-hidden"></span>
					
						<!--- Add search degrees textbox form. --->
					<h2>Search for degrees</h2>
					<p>Provide some instructions on how the degree search section works and initial steps to get started using the Advisor Services Portal.</p>
					<cfform>
						<cfinput type="text" id="degreeName" name="degreeName">
						<cfinput type="submit" name="searchButton" value="Search">
					</cfform>
					
					<h2>Filters</h2>
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
					<cfif messageBean.hasErrors()>
						<ul>
							<cfloop array="#messageBean.getErrors()#" index="error">
								<cfoutput><li>Error:  #error.message#</li></cfoutput>
							</cfloop>
						</ul>
					</cfif>
					
	            </div>
	        </div>
	    </article>                   
	</div>

		<aside id="content-sidebar">
		    <div class="region region-sidebar">			
                <div class="content">
                	<p>
                		<strong>About</strong>                		
                	</p>
			    	<p>The Advising Services Portal is an online student-transfer information system... describe some info, helps with visits with faculty advisors.</p>
					<p>More description... explain about intended use.  Private system, info is not shared or sold.</p>
            	</div>
		    </div>
		</aside>

<cfmodule template="../../../footer.cfm">