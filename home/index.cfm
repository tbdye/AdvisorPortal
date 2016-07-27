<!---<cfquery name="qPhotographer">
	SELECT * FROM Photographer WHERE featured = 1
</cfquery>
<cfquery name="qPhotos">
	SELECT * FROM Photo WHERE photographerid = #qPhotographer.photographerid#
</cfquery>--->

<!---<cfscript>
	items = entityLoad("Photographer", {featured=1});
	photos = entityLoad("Photo", {photographerid=items[1].getPhotographerid()});
</cfscript>--->

<cfmodule template="../includes/header.cfm"
	pagetitle = "Advisor Services Portal - Home Page">
	
    <h1>Test page</h1>
	<!---<cfoutput><h2>#items[1].getFirstName()# #items[1].getLastName()#</h2></cfoutput>--->

	<!---<cfmodule template="../tags/photodisplay.cfm"
		photos="#photos#">--->
	
<cfmodule template="../includes/footer.cfm">