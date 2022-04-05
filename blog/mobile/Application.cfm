
<cfsetting showdebugoutput="false">

<!---prevent load of config file--->
<cfif listlast(CGI.script_name, "/") is "mobile.ini.cfm">
  <cfabort>
</cfif>

<!---include primary application--->
<cfinclude template="../APPLICATION.BLOG.cfm">

<cfif not isDefined('SESSION.BROGMobile') or isDefined('URL.reinit')>
  <cfset SESSION.BROGMobile = createObject("component","components.blogMobile").init(SESSION.BROG.getProperty("name"))>
</cfif>

<cfset APPLICATION.BLOG.primaryTheme = "b"><!---SESSION.BROGMobile.getProperty("theme")--->
<cfset APPLICATION.BLOG.mobilePageMax = 15>
