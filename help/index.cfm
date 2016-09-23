<!--- Help Controller --->
<!--- Thomas Dye, August 2016 --->
<cfset messageBean=createObject('#this.mappings['cfcMapping']#.messageBean').init()>

<!--- Load page --->
<cfinclude template="model/help.cfm">
<cfreturn>