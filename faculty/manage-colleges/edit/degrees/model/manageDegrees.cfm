<!--- Manage Degree Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../../header.cfm"

	pagetitle="Advisor Services Portal - Manage Degrees">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Manage Degrees</h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../..">Home</a>
				&raquo; <a href="../..">Manage Colleges</a>
				&raquo; <a href="../?edit=<cfoutput>#qEditGetCollege.id#</cfoutput>"><cfoutput>#qEditGetCollege.college_name#</cfoutput></a>
				&raquo; Manage Degrees
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Manage Degrees" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<p>empty add content<p/>
				    	<hr>
				    	<p>empty content<p/>
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
	
<cfmodule template="../../../../../footer.cfm">