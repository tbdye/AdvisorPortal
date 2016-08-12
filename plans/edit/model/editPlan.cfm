<!--- Edit Plan Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../header.cfm">

<pagetitle="Advisor Services Portal - Edit Plan">

	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>Edit Plan</h1>
			</header>

			<div class="breadcrumb">
				<a href="../../dashboard/">Home</a>
				&raquo; <a href="..">Degree Plans</a>
				&raquo; Edit Plan
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Plan" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
	                	<h2><cfoutput>#qEditGetPlan.plan_name#</cfoutput></h2>
	                	<table>
	                		<cfif messageBean.hasErrors() && isDefined("form.saveButton")>
								<tr>
									<td colspan="2">
										<div id="form-errors">
											<ul>
												<cfloop array="#messageBean.getErrors()#" index="error">
													<cfoutput><li>#error.message#</li></cfoutput>
												</cfloop>
											</ul>
										</div>											
									</td>
								</tr>
							</cfif>
							<cfform>
		                		<tr>
		                			<td><label for="planName">Plan:</label></td>
		                			<td><cfinput type="text" size="#len(qEditGetPlan.plan_name)#" id="planName" name="planName" value="#qEditGetPlan.plan_name#"></td>
		                		</tr>
		                		<tr>
		                			<td>Degree:</td>
		                			<td>
		                				<cfoutput><a href="../degrees/view/?degree=#qEditGetPlan.degrees_id#" title="#qEditGetPlan.degree_name#">#qEditGetPlan.degree_name#</a></cfoutput><br>
		                				<cfoutput>#qEditGetPlan.college_name# - #qEditGetPlan.college_city#</cfoutput><br>
		                				<cfoutput>#qEditGetPlan.degree_type#</cfoutput>
		                			</td>
		                		</tr>
		                		<tr>
		                			<td></td>
		                			<td><cfinput type="submit" name="saveButton" value="Save"></td>
		                		</tr>
	                		</cfform>
	                	</table>
	                	
	                </div>
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