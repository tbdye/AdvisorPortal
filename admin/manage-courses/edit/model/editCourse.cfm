<!--- Edit Course Model --->
<!--- Thomas Dye, September 2016 --->
<cfif !isDefined("messageBean")>
	<cflocation url="..">
</cfif>

<cfmodule template="../../../../header.cfm"

	pagetitle="Advisor Services Portal - Edit Course">
	
	<div class="resize-box">
		
	    <article id="content-article" role="article">
	        <header>
	            <h1>Edit #course_number#</h1>
	        </header>

			<div class="breadcrumb">
				<a href="">Home</a>
				&raquo; <a href="">Manage Courses</a>
				&raquo; Edit Course
			</div>	

	        <div id="page-content" class="page-plus-side">
	            <div class="content">
	                <span property="dc:title" content="Edit Course" class="rdf-meta element-hidden"></span>
	
	                <div class="content">

						<h2>Edit Course</h2>
						<h3>Course Information</h3>
				    	Number:
				    	Title:
				    	Department:
				    	Availability:
				    	
				    			Min		Max
				    	Credit: [text] [text]
				    			[Update course]
				    	
				    	<h3>Catalog Description</h3>
				    	[textarea]
				    	[Update]

						<h3>Placement Scores</h3>
						* Information [Remove]
						[textbox] Add]
						
				    	<h3>Prerequisites</h3>
				    	Grouping	Course
				    	#			XXX		  [Remove]
				    	[selector] [textbox]  [Add]

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
	
<cfmodule template="../../../../footer.cfm">