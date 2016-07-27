<cfcomponent >
	<cfset this.name='AdvisorPortal'>
	<cfset this.datasource='advisorPortal'>
	<cfset this.applicationTimeout=CreateTimeSpan(10, 0, 0, 0)>
	<cfset this.sessionManagement=true>
	<cfset this.sessionTimeout=CreateTimeSpan(0, 0, 30, 0)>
	<cfset this.loginStorage='session'>
	<cfset this.ormEnabled=true>
	<cfset this.ormSettings={logsql=true, cfclocation="cfc\orm"}>
	<cfset this.invokeImplicitAccessor=true>
	<cfset this.sessionCookie.httpOnly=true>
	<cfset this.sessionCookie.timeout='10'>
	<cfset this.sessionCookie.disableupdate=true>
	
<!---	<cffunction name="onRequest">
		<cfargument name="templatename" >
		
		<!--- If user session not set, force return to login page. --->
		<cfif !structKeyExists(session,'userID') || !val(session.userID)>
			<cfinclude template="login/login.cfm">
			<cfreturn>
		</cfif>	
		
		<cfinclude template="#arguments.templatename#">	
	</cffunction>--->
	
	
</cfcomponent>