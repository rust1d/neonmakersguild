<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
  Name         : parseses.cfm
  Author       : Raymond Camden
  Created      : June 23, 2005
  Last Updated : August 31, 2006
  History      : Reset for 5.0 (5/1/06)
         : catch long cats (8/31/06)
  Purpose     : Attempts to find SES info in URL and set URL vars
--->

<cfscript>
/**
 * Parses my SES format. Demands /YYYY/MMMM/TITLE or /YYYY/MMMM/DDDD/TITLE
 * One line from MikeD
 *
 * @author Raymond Camden (ray@camdenfamily.com)
 * @version 1, June 23, 2005
 */
function parseMySES() {
  //line below from Mike D.
  var urlVars=reReplaceNoCase(trim(CGI.path_info), '.+\.cfm/? *', '');
  var r = structNew();
  var theLen = listLen(urlVars,"/");

  if(len(urlVars) is 0 or urlvars is "/" or len(theLen) GT 4) return r;

  //handles categories
  if(theLen is 1) {
      urlVars = replace(urlVars, "/","");
      r.bca_name = urlVars;
      return r;
  }

  //BEGIN BRAUNSTEIN MOD 2/5/2010
  //handles users (aka posters, authors)
  if(theLen is 2 and urlVars contains "postedby") {
      urlVars = replace(urlVars, "/postedby/","");
      r.postedby = urlVars;
      return r;
  }
  //END BRAUNSTEIN MOD 2/5/2010

  r.year = listFirst(urlVars,"/");
  if(theLen gte 2) r.month = listGetAt(urlVars,2,"/");
  if(theLen gte 3) r.day = listGetAt(urlVars,3,"/");
  if(theLen gte 4) r.title = listLast(urlVars, "/");
  return r;
}
</cfscript>
<!--- TRY TO LOAD MY INFO FROM THE URL ... --->
<cfset sesInfo = parseMySES()>
<!--- I DON'T HAVE THE RIGHT INFO, SO WE ARE OUTA HERE! --->
<cfif structIsEmpty(sesInfo)>
  <cfsetting enablecfoutputonly="false" />
  <cfexit method="exitTag">
</cfif>

<cfset params = structNew()>
<cfif structKeyExists(sesInfo, "bca_name")><!--- FIRST SEE IF WE HAVE A CATEGORY --->
  <cfif len(trim(sesInfo.bca_name)) and len(trim(sesInfo.bca_name)) lte 50>
    <cfset bca_bcaid = SESSION.BROG.getCategoryByAlias(sesInfo.bca_name)>
    <cfif len(bca_bcaid)>
      <cfset URL.mode = "cat">
      <cfset URL.catid = bca_bcaid>
    </cfif>
  </cfif>
<cfelseif structKeyExists(sesInfo, "postedby")><!--- ELSE IF WE HAVE A BLOG POSTER/USER/AUTHOR --->
  <cfif len(trim(sesInfo.postedby)) and len(trim(sesInfo.postedby)) lte 50><!--- TRANSLATE BACK - GET USERNAME BASED ON NAME --->
    <!--- <cfset username = SESSION.BROG.getUserByName(sesInfo.postedby)> WE ARE NOT GOING TO USE REAL NAMES HERE, JUST USERNAMES--->
    <cfset username = sesInfo.postedby>
    <cfif len(username)>
      <cfset URL.mode = "postedby">
      <cfset URL.postedby = username>
    </cfif>
  </cfif>
<cfelseif not structKeyExists(sesInfo, "title")><!--- BY MONTH --->
  <cfset URL.month = sesInfo.month>
  <cfset URL.year = sesInfo.year>
  <cfif structKeyExists(sesInfo, "day")>
    <cfset URL.day = sesInfo.day>
    <cfset URL.mode = "day">
  <cfelse>
    <cfset URL.mode = "month">
  </cfif>
<cfelse><!--- THIS IS A FULL ENTRY --->
  <!--- THE BLOG CHECKS, BUT LETS BE EXTRA CAREFUL --->
  <cfif not isNumeric(sesInfo.year) or not isNumeric(sesInfo.month) or not (sesInfo.month gte 1 and sesInfo.month lte 12) or not len(trim(sesInfo.title))>
    <cfsetting enablecfoutputonly="false" />
    <cfexit method="exitTag">
  </cfif>
  <cfset params.byMonth = sesInfo.month>
  <cfset params.byYear = sesInfo.year>
  <cfif structKeyExists(sesInfo,"day")>
    <cfset params.byDay = sesInfo.day>
  </cfif>
  <cfset params.byAlias = sesInfo.title>
  <cfset URL.mode = "alias">
  <cfset URL.alias = params.byAlias>
</cfif>
<!--- Copy to caller --->
<cfset caller.params = params>
<cfsetting enablecfoutputonly="false" />
<cfexit method="exitTag">
