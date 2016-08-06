<!--- Logout Controller --->
<!--- Thomas Dye, August 2016 --->
<cfset StructClear(session)>
<cflogout>
<cflocation url="..">