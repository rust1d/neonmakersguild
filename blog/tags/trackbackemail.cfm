<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
  Name         : trackbackemail.cfm
  Author       : Raymond Camden
  Created      : September 27, 2005
  Last Updated : February 28, 2007
  History      : don't log the getEntry (rkc 2/28/07)
  Purpose     : Handles just the email to notify us about TBs
--->

<!--- id of the TB --->
<cfparam name="ATTRIBUTES.trackback" type="uuid">

<cfset tb = SESSION.BROG.getTrackBack(ATTRIBUTES.trackback)>

<cfif structIsEmpty(tb)>
  <cfsetting enablecfoutputonly="false" />
  <cfexit method="exitTag">
</cfif>

<cftry>
  <cfset blogEntry = SESSION.BROG.getEntry(tb.entryid,false)>
  <cfcatch>
    <cfsetting enablecfoutputonly="false" />
    <cfexit method="exitTag">
  </cfcatch>
</cftry>

<!--- make TB killer link --->
<cfset tbKiller = APPLICATION.PATH.ROOT & "/trackback.cfm?kill=#ATTRIBUTES.trackback#">

<cfset subject = APPLICATION.BLOG.resourceBundle.getResource("trackbackaddedtoentry") & ": " & SESSION.BROG.getProperty("blogTitle") & " / " & APPLICATION.BLOG.resourceBundle.getResource("entry") & ": " & blogEntry.title>
<cfsavecontent variable="email">
<cfoutput>
#APPLICATION.BLOG.resourceBundle.getResource("trackbackaddedtoblogentry")#:  #blogEntry.title#
#APPLICATION.BLOG.resourceBundle.getResource("trackbackadded")#:     #APPLICATION.BLOG.localeUtils.dateLocaleFormat(now())# / #APPLICATION.BLOG.localeUtils.timeLocaleFormat(now())#
#APPLICATION.BLOG.resourceBundle.getResource("blogname")#:       #tb.blogname#
#APPLICATION.BLOG.resourceBundle.getResource("title")#:         #tb.title#
URL:        #tb.posturl#
#APPLICATION.BLOG.resourceBundle.getResource("excerpt")#:
#tb.excerpt#

#APPLICATION.BLOG.resourceBundle.getResource("deletetrackbacklink")#:
#tbKiller#

------------------------------------------------------------
This blog powered by BlogCFC #SESSION.BROG.getVersion()#
Created by Raymond Camden (ray@camdenfamily.com)
</cfoutput>
</cfsavecontent>

<cfset addy = SESSION.BROG.getProperty("owneremail")>
<cfif SESSION.BROG.getProperty("mailserver") is "">
  <cfmail to="#addy#" from="#addy#" subject="#subject#">#email#</cfmail>
<cfelse>
  <cfmail to="#addy#" from="#addy#" subject="#subject#"
    server="#SESSION.BROG.getProperty("mailserver")#" username="#SESSION.BROG.getProperty("mailusername")#" password="#SESSION.BROG.getProperty("mailpassword")#">#email#</cfmail>
</cfif>

<cfsetting enablecfoutputonly="false" />
<cfexit method="exitTag">