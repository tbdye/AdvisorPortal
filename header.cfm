<!--- Header Model --->
<!--- Thomas Dye, July 2016 --->
<cfparam name="attributes.pagetitle" default="Advisor Services Portal">
<cfparam name="attributes.includeUserNavBar" default="true"> 
<cfparam name="attributes.includeNavBar" default="true">

<!--- Find application path to ensure CSS and links work --->
<cfset path=ListToArray(GetCurrentTemplatePath(), "\") />
<cfif ArrayLen(path) LTE 1>
	<cfset path="/">
<cfelse>
	<cfset folderName=path[DecrementValue(ArrayLen(path))] />
	<cfset path="/#folderName#/">
</cfif>

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<cfoutput><title>#attributes.pagetitle#</title></cfoutput>
	<link href="<cfoutput>#path#</cfoutput>pageLocal.css" rel="stylesheet" type="text/css">
</head>
<body>

<div id="header-wrap">
	<!-- HEADER -->
	<header id="header" role="banner">
		<div id="top-brand">
		        <a href="<cfoutput>#path#</cfoutput>"><img class="top-logo" src="<cfoutput>#path#</cfoutput>assets/evcclogo.png" alt="EvCC logo" title="Everett Community College" /></a>
		</div>
	
	    <div id="top-quicklinks" role="navigation">
			<cfif attributes.includeUserNavBar>
		    	<ul>
					<li><a href="<cfoutput>#path#</cfoutput>logout/" title="Log out">Log out</a></li>
					<li><a href="<cfoutput>#path#</cfoutput>help/" title="Help">Help</a></li>
					<li><a href="<cfoutput>#path#</cfoutput>account/" title="Account Settings"><cfoutput>Hello, #session.loginName#!</cfoutput></a></li>
				</ul>
			</cfif>
	    </div>
	</header>
	<!-- //HEADER -->
	
	<!-- TOP NAVIGATION -->		
		<nav role="navigation" >
			<form class="mini-nav" id="mini-nav-form" >
				<select name="mini-nav-list" id="mini-nav-list">				
					<cfif attributes.includeNavBar>
						<cfif IsUserInRole("advisor")>
							<option value="<cfoutput>#path#</cfoutput>faculty/">Advising</option>
						</cfif>
						
						<cfif IsUserInRole("student") || isDefined("session.studentId")>
							<option value="<cfoutput>#path#</cfoutput>dashboard/">Student Dashboard</option>
							<option value="<cfoutput>#path#</cfoutput>courses/">Completed Courses</option>
							<option value="<cfoutput>#path#</cfoutput>plans/">Degree Plans</option>
						</cfif>
						
						<cfif IsUserInRole("editor")>
							<option value="<cfoutput>#path#</cfoutput>admin/">Site Settings</option>
						</cfif>
				    </cfif>					
					
				</select>
			</form>
			<ul id="top-navigation">
				<cfif attributes.includeNavBar>
					<cfif IsUserInRole("advisor")>
						<li><a href="<cfoutput>#path#</cfoutput>faculty/" title="Advising">Advise Student</a></li>
					</cfif>
					
					<cfif IsUserInRole("student") || isDefined("session.studentId")>
						<li><a href="<cfoutput>#path#</cfoutput>dashboard/" title="Dashboard">Student Dashboard</a></li>
						<li><a href="<cfoutput>#path#</cfoutput>courses/" title="Completed Courses">Completed Courses</a></li>
						<li><a href="<cfoutput>#path#</cfoutput>plans/" title="Degree Plans">Degree Plans</a></li>
					</cfif>
					
					<cfif IsUserInRole("editor")>
						<li><a href="<cfoutput>#path#</cfoutput>admin/" title="Administration">Site Settings</a></li>
					</cfif>
			    </cfif>
			</ul>
		</nav>
		
		
	<!-- //TOP NAVIGATION -->
</div>

<main id="content-wrap" role="main">

	<!-- CONTENT -->
    <div id="content-split">


