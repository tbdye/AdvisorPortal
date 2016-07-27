<cfset session.userID = '' />
<cfset session.emailAddress = '' />
<cfset sessionInvalidate() />
<cflocation url="../home/index.cfm" addToken="false" />