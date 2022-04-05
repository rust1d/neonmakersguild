<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfset podfile = expandPath("#APPLICATION.PATH.ROOT#/blog/includes/pods/#URL.pod#") />
<cfif fileExists(podfile)>
	<cfoutput>
		<link rel="stylesheet" href="#APPLICATION.PATH.ROOT#/blog/css/layout.css" type="text/css" />
		<link rel="stylesheet" href="#APPLICATION.PATH.ROOT#/blog/css/blog.css" type="text/css" />
	</cfoutput>
	<cfinclude template="#APPLICATION.PATH.ROOT#/blog/includes/pods/#URL.pod#">
</cfif>
<cfsetting enablecfoutputonly="false">