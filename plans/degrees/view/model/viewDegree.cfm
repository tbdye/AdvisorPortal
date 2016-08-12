<!--- View Degree Model --->
<!--- Thomas Dye, August 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../header.cfm">
	
	<pagetitle="Advisor Services Portal - Explore Degrees">

	<!--- Alter page header depending if in an adivisng session or not. --->
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
				<h1>[Degree Name]</h1>
	        </header>

			<div class="breadcrumb">
				<a href="../../../dashboard/">Home</a>
				&raquo; <a href="../..">Degree Plans</a>
				&raquo; <a href="..">Explore Degrees</a>
				&raquo; [Degree Name]
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	            	empty content
	            	
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

<cfmodule template="../../../../footer.cfm">