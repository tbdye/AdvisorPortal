<!--- Degrees Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../header.cfm">
	
	<pagetitle="Advisor Services Portal - Degree Plans">

	<!--- Alter page header depending if in an adivisng session or not. --->
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<cfif IsUserInRole("advisor")>
					<h1>Degree Plans for <cfoutput>#session.studentName#</cfoutput></h1>
				<cfelse>
					<h1>Degree plans</h1>
				</cfif>
	        </header>

			<div class="breadcrumb">
				<a href="../dashboard/">Home</a>
				&raquo; Degree Plans
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
					
					<h2>Add a degree plan</h2>
					<p>Provide some instructions on how the degree plans section works and initial steps to get started using the Advisor Services Portal.</p>
					<a href="search/" title="Search for a degree">Search for a degree</a>
					
					<!--- Display completed courses --->
					<h2>Select a saved degree plan</h2>
					<cfif qDegreesGetStudentPlans.RecordCount>
						<table>
							<tr>
								<th>Plan details</th>
								<th>Created</th>
								<th>Updated</th>
								<th></th>
								<th></th>
							</tr>
							<cfloop query="qCoursesGetStudentCourses">
								<tr>
									<td><cfoutput>#qDegreesGetStudentPlans.plan_name#</cfoutput></td>
									<td><cfoutput>#qDegreesGetStudentPlans.time_created#</cfoutput></td>
									<td><cfoutput>#qDegreesGetStudentPlans.time_updated#</cfoutput></td>
									<td><cfoutput><a href="?delete=#URLEncodedFormat(qDegreesGetStudentPlans.plan_name)#&id=#URLEncodedFormat(qDegreesGetStudentPlans.id)#" title="Delete">Delete</a></cfoutput></td>
									<td><cfoutput><a href="?copy=#URLEncodedFormat(qDegreesGetStudentPlans.plan_name)#&id=#URLEncodedFormat(qDegreesGetStudentPlans.id)#" title="Copy">Copy</a></cfoutput></td>
								</tr>
							</cfloop>
						</table>
					<cfelse>
						<p>No degree plans created yet.</p>
					</cfif>
	                </div>
	            </div>
	        </div>
	    </article>                   

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

<cfmodule template="../../footer.cfm">