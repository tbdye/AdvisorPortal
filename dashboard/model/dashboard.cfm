<!--- Dashboard Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../header.cfm"

	pagetitle="Advisor Services Portal - Dashboard">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <cfif IsUserInRole("advisor")>
					<h1>Dashboard for <cfoutput>#session.studentName#</cfoutput></h1>
				<cfelse>
					<h1>Dashboard</h1>
				</cfif>
	        </header>

			<div class="breadcrumb">
				<a href="">Home</a> &raquo;			
		            <cfif IsUserInRole("advisor")>
						Dashboard for <cfoutput>#session.studentName#</cfoutput>
					<cfelse>
						Dashboard
					</cfif>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Dashboard" class="rdf-meta element-hidden"></span>
	
                	<cfif qDashboardGetActivePlan.RecordCount>
						<h2><cfoutput>#qDashboardGetActivePlan.plan_name#</cfoutput></h2>
						
						<!---My schedule [<][>]
						[Quarter 1 | Quarter 2 | Quarter 3 | Quarter 4]
						[Edit | Edit | Edit | Edit]
						
						Edit courses for Quarter 1
						Unscheduled courses | Courses in Quarter 1
						[list 1] [>][<] [list 2]
										[Update][Cancel]--->
						
						<h3>Courses remaining for this plan</h3>
						<h4>English Composition</h4>
						<table>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th></th>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
						
						<h4>Writing and Additional Composition</h4>
						<table>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th></th>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
						
						<h4>Quantitative and Symbolic Reasoning</h4>
						<table>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th></th>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
						
						<h4>The Natural World</h4>
						<table>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th></th>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
						
						<h4>Visual, Literary, and Performing Arts</h4>
						<p>(You need X more credits)</p>
						<table>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th></th>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
						
						<h4>Individuals and Societies</h4>
						<p>(You need X more credits)</p>
						<table>
							<tr>
								<th>Code</th>
								<th>Title</th>
								<th>Credits</th>
								<th></th>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
						
					<cfelse>
						<h2>Get Started</h2>
						<a href="../courses/" title="Enter your completed courses">Enter your completed courses</a>
						<p>or</p>
						<a href="../plans/" title="Manage your degree plans">Manage your degree plans</a>
					</cfif>
					<p/>

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