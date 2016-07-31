<!--- Thomas Dye, July 2016 --->
<cfparam name="attributes.pagetitle" default="Advisor Services Portal">
<cfparam name="attributes.includeUserNavBar" default="true"> 
<cfparam name="attributes.includeNavBar" default="true">

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<cfoutput><title>#attributes.pagetitle#</title></cfoutput>
	<link href="../css/pageLocal.css" rel="stylesheet" type="text/css">
</head>
<body>

<div id="header-wrap">
	<!-- HEADER -->
	<header id="header" role="banner">
		<div id="top-brand">
		        <a href="index.cfm"><img class="top-logo" src="../assets/evcclogo.png" alt="EvCC logo" title="Everett Community College" /></a>
		</div>
	
	    <div id="top-quicklinks" role="navigation">
			<cfif attributes.includeUserNavBar>
		    	<ul>
					<li><a href="../login/logout.cfm" title="Log out">Log out</a></li>
					<li><a href="help.cfm" title="Help">Help</a></li>
					<li><a href="account.cfm" title="Account Settings"><cfoutput>Hello, #GetAuthUser()#</cfoutput>!</a></li>
				</ul>
			</cfif>
	    </div>
	</header>
	<!-- //HEADER -->
	
	<!-- TOP NAVIGATION -->		
		<nav role="navigation" >
			<form class="mini-nav" id="mini-nav-form" style="display: none;" action="/#/" method="post">
				<select name="mini-nav-list" id="mini-nav-list">				
					<cfif attributes.includeNavBar>
						<cfif IsUserInRole("advisor")>
							<option value="advisor.cfm">Advise Student</option>
						</cfif>
						
						<cfif IsUserInRole("student") || isDefined("session.studentId")>
							<option value="dashboard.cfm">Student Dashboard</option>
							<option value="courses.cfm">Completed Courses</option>
							<option value="degrees.cfm">Degree Plans</option>
						</cfif>
						
						<cfif IsUserInRole("editor")>
							<option value="editCourses.cfm">Edit Courses</option>
							<option value="editSchools.cfm">Edit Schools</option>
							<option value="editDegrees.cfm">Edit Degrees</option>							
						</cfif>
						
						<cfif IsUserInRole("administrator")>
							<option value="editUsers.cfm">Edit Users</option>
						</cfif>
				    </cfif>					
					
				</select>
			</form>
			<ul id="top-navigation">
				<cfif attributes.includeNavBar>
					<cfif IsUserInRole("advisor")>
						<li><a href="advisor.cfm" title="Advise student">Advise Student</a></li>
					</cfif>
					
					<cfif IsUserInRole("student") || isDefined("session.studentId")>
						<li><a href="dashboard.cfm" title="Dashboard">Student Dashboard</a></li>
						<li><a href="courses.cfm" title="Completed Courses">Completed Courses</a></li>
						<li><a href="degrees.cfm" title="Degree Plans">Degree Plans</a></li>
					</cfif>
					
					<cfif IsUserInRole("editor")>
						<li><a href="editCourses.cfm" title="Edit Courses">Edit Courses</a></li>
						<li><a href="editSchools.cfm" title="Edit Schools">Edit Schools</a></li>
						<li><a href="editDegrees.cfm" title="Edit Degrees">Edit Degrees</a></li>
					</cfif>
					
					<cfif IsUserInRole("administrator")>
						<li><a href="editUsers.cfm" title="Edit Users">Edit Users</a></li>
					</cfif>
			    </cfif>
			</ul>
		</nav>
		
		
	<!-- //TOP NAVIGATION -->
</div>

<main id="content-wrap" role="main">

	<!-- CONTENT -->
    <div id="content-split">


