<!--- Dashboard Model --->
<!--- Thomas Dye, August 2016 --->
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
	
                	<cfif !isDefined("qGetPlan")>
						<h2>Get Started</h2>
						<a href="../courses/" title="Enter your completed courses">Enter your completed courses</a>
						<p>or</p>
						<a href="../degrees/" title="Manage your degree plans">Manage your degree plans</a>
					<cfelse>
						
					</cfif>
					<p/>
                
	        		<cfif isDefined("session.studentId")>
						<p/>
						<p><a href="?advise=end" title="End advising session">Stop advising <cfoutput>#session.studentName#</cfoutput></a></p>
					<cfelse>
						<p/>
					</cfif>
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