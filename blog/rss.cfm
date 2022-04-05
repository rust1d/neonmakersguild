<cfsetting enablecfoutputonly=true showdebugoutput=false>
<cfprocessingdirective pageencoding="utf-8" />
<!---
  Name         : RSS
  Author       : Raymond Camden
  Created      : March 12, 2003
  Last Updated : May 18, 2007
  History      : Reset history for version 5.0
         : Note that I'm not doing RSS feeds by day or month anymore, so that code is marked for removal (maybe)
         : Added additionalTitle support for cats
         : Cache for main RSS (rkc 7/10/06)
         : Rob Wilkerson added code to handle noting/returning headers for aggregators (rkc 4/19/07)
         http://musetracks.instantspot.com/blog/index.cfm/2007/4/19/BlogCFC-Enhancement
         : Fix bug where no entries - also support N categories (rkc 5/18/07)
         : DanS fix for unreleased entries, cap URL.byentry to 35 (rkc 11/17/07)
  Purpose     : Blog RSS feed.
--->

<cfif isDefined("URL.mode") and URL.mode is "full">
  <cfset mode = "full">
<cfelse>
  <cfset mode = "short">
</cfif>

<!--- only allow 1 or 2 --->
<cfif isDefined("URL.version") and URL.version is 1>
  <cfset version = 1>
<cfelse>
  <cfset version = 2>
</cfif>

<cfset params = structNew()>
<!---// dgs: only get released items //--->
<cfset params.releasedonly = true />

<cfset additionalTitle = "">

<cfif isDefined("URL.mode2")>
  <cfif URL.mode2 is "day" and isDefined("URL.day") and isDefined("URL.month") and isDefined("URL.year")>
    <cfset params.byDay = val(URL.day)>
    <cfset params.byMonth = val(URL.month)>
    <cfset params.byYear = val(URL.year)>
  <cfelseif URL.mode2 is "month" and isDefined("URL.month") and isDefined("URL.year")>
    <cfset params.byMonth = val(URL.month)>
    <cfset params.byYear = val(URL.year)>
  <cfelseif URL.mode2 is "cat" and isDefined("URL.catid")>
    <!--- can be a list --->
    <cfset additionalTitle = "">
    <cfset params.byCat = "">
    <cfloop index="x" from="1" to="#listLen(URL.catid)#">
      <cfset cat = listGetAt(URL.catid, x)>
      <!--- set to 35 --->
      <cfset cat = left(cat, 35)>
      <cfset params.byCat = listAppend(params.byCat, cat)>
      <cftry>
        <cfset additionalTitle = additionalTitle & " - " & SESSION.BROG.getCategory(cat).bca_name>
        <cfcatch></cfcatch>
      </cftry>
    </cfloop>
  <cfelseif URL.mode2 is "entry">
    <cfset params.byEntry = left(URL.entry,35)>
  </cfif>
</cfif>

<!--- Only cache if not isdefined mode 2 --->
<!--- In other words, cache just the main view --->
<!--- Therefore, our cache name needs to just care about mode and version --->
<cfset cachename = SESSION.BROG.getProperty('name') & "_rss_" & mode & version>
<cfif StructKeyExists(URL, "mode2")>
  <cfset disabled = true>
<cfelse>
  <cfset disabled = false>
</cfif>

<cfsavecontent variable="variables.feedXML">
<cfmodule template="tags/scopecache.cfm" cachename="#cachename#" scope="APPLICATION" timeout="#APPLICATION.BLOG.timeout#" disabled="#disabled#">
  <cfoutput>#SESSION.BROG.generateRSS(mode=mode,params=params,version=version,additionalTitle=additionalTitle)#</cfoutput>
</cfmodule>
</cfsavecontent>

<cfset variables.lastModified = XMLSearch ( XMLParse ( variables.feedXML ), '//item[1]/pubDate' ) />
<cfif arrayLen(variables.lastModified) is 0>
  <cfset variables.lastModified = "">
<cfelse>
  <cfset variables.lastModified = variables.lastModified[1].XMLText />
</cfif>
<cfset variables.ETag         = hash ( variables.lastModified ) />

<cfset variables.request      = getHTTPRequestData() />
<cfset variables.headers      = variables.REQUEST.headers />

<cfif structKeyExists ( variables.headers, 'If-Modified-Since' ) and variables.headers['If-Modified-Since'] eq variables.lastModified>
  <cfif structKeyExists ( variables.headers, 'If-None-Match' ) and variables.headers['If-None-Match'] eq variables.ETag>
    <cfheader statuscode="304" statustext="Not Modified" />
    <cfexit />
  </cfif>
</cfif>

<cftry>
  <cfheader name="Last-Modified" value="#variables.lastModified#" />
  <cfheader name="ETag" value="#variables.ETag#" />

  <cfcontent type="text/xml; charset=utf-8"><cfoutput>#variables.feedXML#</cfoutput>
  <cfcatch>
    <!--- Logic is - if they filtered incorrectly, revert to default, if not, abort --->
    <cfif CGI.query_string neq "">
      <cflocation url="rss.cfm">
    <cfelse>
      <cfabort>
    </cfif>
  </cfcatch>
</cftry>
