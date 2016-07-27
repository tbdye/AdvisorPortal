<!--- Thomas Dye, July 2016 --->
<cfparam name="attributes.pagetitle" default="Advisor Services Portal">
<cfparam name="attributes.includenavbar" default="true"> 

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<cfoutput><title>#attributes.pagetitle#</title></cfoutput>
	<link href="https://www.everettcc.edu/common/css/page.css" rel="stylesheet" type="text/css">
</head>

<body>

<div id="main">
	<div id="header">
    </div>
    <cfif attributes.includenavbar>
	    <div id="navbar">
			<a href="advisor.cfm" title="Advise student">Advise student</a>
			<a href="dashboard.cfm" title="Dashboard">Dashboard</a>
			<a href="courses.cfm" title="Completed courses">Completed courses</a>
			<a href="degrees.cfm" title="Degree plans">Degree plans</a>
			<a href="editCourses.cfm" title="Edit courses">Edit courses</a>
			<a href="editSchools.cfm" title="Edit schools">Edit schools</a>
			<a href="editDegrees.cfm" title="Edit degrees">Edit degrees</a>
			<a href="editUsers.cfm" title="Edit users">Edit users</a>
	    </div>
    </cfif>
	<div id="content">