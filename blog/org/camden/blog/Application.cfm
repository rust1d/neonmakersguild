<!---
	Name         : c:\projects\blog\org\camden\blog\APPLICATION.BLOG.cfm
	Author       : Raymond Camden 
	Created      : 01/22/06
	Last Updated : 
	History      : 
--->

<cfif listlast(CGI.script_name, "/") is "blog.ini.cfm">
	<cfabort>
</cfif>
