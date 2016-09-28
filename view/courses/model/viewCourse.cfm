<!--- View Course Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm"

	pagetitle="Advisor Services Portal - View Course">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>View Course - <cfoutput>#qViewGetCourse.course_number#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; View Course - <cfoutput>#qViewGetCourse.course_number#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="View Course" class="rdf-meta element-hidden"></span>
	
	                <div class="content">				    	
						<h2>Basic Details</h2>
				    	<table>
					    	<tr>
					    		<td width="125px">Number:</td>
					    		<td colspan="2"><cfoutput>#qViewGetCourse.course_number#</cfoutput></td>
					    	</tr>
					    	<tr>
					    		<td>Title:</td>
					    		<td colspan="2"><cfoutput>#qViewGetCourse.title#</cfoutput></td>
					    	</tr>
					    	<tr>
					    		<td>Department:</td>
					    		<td colspan="2"><cfoutput>#qViewGetCourse.department_name#</cfoutput></td>
					    	</tr>
					    	<tr>
					    		<td colspan="3"></td>
					    	</tr>
					    	<cfif IsNumeric(qViewGetCourse.min_credit)>
						    	<tr>
						    		<th></th>
						    		<th>Min</th>
						    		<th>Max</th>
						    	</tr>
						    	<tr>
						    		<td>Variable Credit:</td>
						    		<td><cfoutput>#qViewGetCourse.min_credit#</cfoutput></td>
						    		<td><cfoutput>#qViewGetCourse.max_credit#</cfoutput></td>
						    	</tr>
						    <cfelse>
						    	<tr>
						    		<td>Credit:</td>
						    		<td><cfoutput>#qViewGetCourse.max_credit#</cfoutput></td>
						    	</tr>
					    	</cfif>
				    	</table>
				    	
				    	
				    	<h2>Course Description</h2>
				    	<table>
					    	<tr>
					    		<td><cfoutput>#qViewGetCourse.course_description#</cfoutput></td>
					    	</tr>
				    	</table>
						
						<cfif qViewGetPlacement.RecordCount>
							<h3>Placement Scores</h3>
							<table>
								<tr>
									<td><cfoutput>#qViewGetPlacement.placement#</cfoutput></td>
								</tr>
							</table>
						</cfif>
						
						
				    	<h2>Prerequisites</h2>
			    		<table>
			    			<tr>
								<td>
									<cfif qViewGetPrerequisites.RecordCount>
										<ul>
											<cfloop index="i" from=1 to=#ArrayLen(aPrerequisites)#>
												<li><cfoutput>#aPrerequisites[i]#</cfoutput><br></li>
											</cfloop>
										</ul>
									<cfelse>
										This class has open enrollment.
									</cfif>
								</td>
							</tr>
				    	</table>

						<p/>
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
	
<cfmodule template="../../../footer.cfm">