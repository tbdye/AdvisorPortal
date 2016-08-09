<!--- Edit Degree Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit Degree">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit <cfoutput>#qEditGetDegree.degree_name#</cfoutput></h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../..">Home</a>
				&raquo; <a href="../..">Manage Colleges</a>
				&raquo; <a href="../../edit/?college=<cfoutput>#qEditGetCollege.id#</cfoutput>"><cfoutput>#qEditGetCollege.college_name#</cfoutput></a>
				&raquo; <a href="../?college=<cfoutput>#qEditGetCollege.id#</cfoutput>"><cfoutput>Manage Degrees</cfoutput></a>
				&raquo; <cfoutput>#qEditGetDegree.degree_name#</cfoutput>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Degree" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
	                	Empty content
	                	
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
	
<cfmodule template="../../../../../footer.cfm">