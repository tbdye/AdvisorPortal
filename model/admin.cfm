<!--- Thomas Dye, July 2016 --->
<cfif !isDefined("errorBean")>
	<cflocation url="../index.cfm">
</cfif>

<cfmodule template="../includes/header.cfm"

	pagetitle="Advisor Services Portal - Administration">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Administration</h1>
	        </header>

			<div class="breadcrumb">
				<a href="index.cfm">Home</a>
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Administration" class="rdf-meta element-hidden"></span>
	
	                <div class="content">
				    	<h2>Manage Portal</h2>
						<a href="manageColleges.cfm" title="Manage Colleges">Manage Colleges</a><br>
						<a href="manageCourses.cfm" title="Manage Courses">Manage Courses</a><br>
						<a href="manageDegrees.cfm" title="Manage Degrees">Manage Degrees</a><br>
						<a href="manageDepartments.cfm" title="Manage Departments">Manage Departments</a><br>
						<a href="manageUsers.cfm" title="Manage Users">Manage Users</a><br>



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
	
<cfmodule template="../includes/footer.cfm">