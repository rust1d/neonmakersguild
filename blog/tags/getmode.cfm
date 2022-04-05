<cfparam name="URL.mode" default="">
<cfparam name="ATTRIBUTES.r_params" type="variableName">
<cfset params = structNew()>
<!---
    SES parsing is abstracted out. This file is getting a bit large so I want to keep things nice and simple.
    Plus if folks don't like this, they can just get rid of it.
    Of course, the Blog makes use of it... but I'll worry about that later.
--->
<cfmodule template="parseses.cfm" />

<!--- starting index --->
<cfparam name="URL.startrow" default="1">
<cfif not isNumeric(URL.startrow) or URL.startrow lte 0 or round(URL.startrow) neq URL.startrow>
  <cfset URL.startrow = 1>
</cfif>
<!--- handle people passing super big #s --->
<cfif not isValid("integer", URL.startrow)>
  <cfset URL.startrow = 1>
</cfif>
<cfset params.startrow = URL.startrow>
<cfset params.maxEntries = APPLICATION.BLOG.maxEntries>

<!--- Handle cleaning of day, month, year --->
<cfif isDefined("URL.day") and (not isNumeric(URL.day) or val(URL.day) is not URL.day)>
  <cfset structDelete(url,"day")>
</cfif>
<cfif isDefined("URL.month") and (not isNumeric(URL.month) or val(URL.month) is not URL.month)>
  <cfset structDelete(url,"month")>
</cfif>
<cfif isDefined("URL.year") and (not isNumeric(URL.year) or val(URL.year) is not URL.year)>
  <cfset structDelete(url,"year")>
</cfif>

<cfif URL.mode is "day" and isDefined("URL.day") and isDefined("URL.month") and URL.month gte 1 and URL.month lte 12 and isDefined("URL.year")>
  <cfset params.byDay = val(URL.day)>
  <cfset params.byMonth = val(URL.month)>
  <cfset params.byYear = val(URL.year)>
  <cfset month = val(URL.month)>
  <cfset year = val(URL.year)>
<cfelseif URL.mode is "month" and isDefined("URL.month") and URL.month gte 1 and URL.month lte 12 and isDefined("URL.year")>
  <cfset params.byMonth = val(URL.month)>
  <cfset params.byYear = val(URL.year)>
  <cfset month = val(URL.month)>
  <cfset year = val(URL.year)>
<cfelseif URL.mode is "cat" and isDefined("URL.catid")>
  <cfset params.byCat = URL.catid>
<!--- BEGIN BRAUNSTEIN MOD 2/5/2010 --->
<cfelseif URL.mode is "postedby" and isDefined("URL.postedby")>
  <cfset params.byPosted = URL.postedby>
<!--- END BRAUNSTEIN MOD 2/5/2010 --->

<cfelseif URL.mode is "search" and (isDefined("form.search") or isDefined("URL.search"))>
  <cfif isDefined("URL.search")>
    <cfset form.search = URL.search>
  </cfif>
  <cfset params.searchTerms = htmlEditFormat(form.search)>
  <!--- dont log pages --->
  <cfif URL.startrow neq 1>
    <cfset params.dontlogsearch = true>
  </cfif>
<cfelseif URL.mode is "entry" and isDefined("URL.entry")>
  <cfset params.byEntry = URL.entry>
<cfelseif URL.mode is "alias" and isDefined("URL.alias") and len(trim(URL.alias))>
  <cfset params.byAlias = URL.alias>
<cfelse>
  <cfset URL.mode = "">
</cfif>

<!---// if user is logged in an has an admin role, then show all entries //--->
<cfif IsUserInRole("admin") and StructKeyExists(URL, "adminview") and URL.adminview>
  <cfset params.releasedonly = false />
<!---// Ensures admins wont see unreleased on main page. //--->
<cfelse>
  <cfset params.releasedonly = true />
</cfif>

<cfset caller[ATTRIBUTES.r_params] = params>

<cfexit method="exitTag">
