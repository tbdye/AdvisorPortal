<!--- Thomas Dye, July 2016 --->
<cfparam name="attributes.pagetitle" default="Advisor Services Portal">
<cfparam name="attributes.includeUserNavBar" default="true"> 
<cfparam name="attributes.includeNavBar" default="true">

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<cfoutput><title>#attributes.pagetitle#</title></cfoutput>
	<link href="https://www.everettcc.edu/common/css/page.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfif attributes.includeUserNavBar>
	<div id="userNavBar">
		<h1>Advisor Services Portal</h1>
		<a href="account.cfm" title="Account Settings"><cfoutput>#GetAuthUser()#</cfoutput></a>
		<a href="help.cfm" title="Help">Help</a>
		<a href="../login/logout.cfm" title="Log out">Log out</a>
    </div>
</cfif>

<div id="main">
    <cfif attributes.includeNavBar>
	    <div id="navBar">
			<cfif IsUserInRole("advisor")>
				<a href="advisor.cfm" title="Advise student">Advise student</a>
			</cfif>
			
			<a href="dashboard.cfm" title="Dashboard">Dashboard</a>
			<a href="courses.cfm" title="Completed courses">Completed courses</a>
			<a href="degrees.cfm" title="Degree plans">Degree plans</a>
			
			<cfif IsUserInRole("editor")>
				<a href="editCourses.cfm" title="Edit courses">Edit courses</a>
				<a href="editSchools.cfm" title="Edit schools">Edit schools</a>
				<a href="editDegrees.cfm" title="Edit degrees">Edit degrees</a>
			</cfif>
			
			<cfif IsUserInRole("administrator")>
				<a href="editUsers.cfm" title="Edit users">Edit users</a>
			</cfif>
	    </div>
    </cfif>
	<div id="content">