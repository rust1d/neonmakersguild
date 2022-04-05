<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
  Name         : page.cfm
  Author       : Raymond Camden
  Created      : July 8, 2006
  Last Updated : July 15, 2006
  History      : New logic to get path (rkc 7/15/06)
  Purpose     : Page render
--->

<cfset pageAlias = listLast(CGI.path_info, "/")>

<cfif not len(pageAlias)>
  <cflocation url="#APPLICATION.PATH.ROOT#/index.cfm" addToken="false">
</cfif>

<cfset page = APPLICATION.BLOG.page.getPageByAlias(pageAlias)>

<cfif structIsEmpty(page)>
  <cflocation url="#APPLICATION.PATH.ROOT#/index.cfm" addToken="false">
</cfif>

<cfif page.showlayout>

  <cfmodule template="tags/layout.cfm" title="#page.title#">

    <cfoutput>
    <div class="date"><b>#page.title#</b></div>
    <div class="body">
    #SESSION.BROG.renderEntry(page.body)#
    </div>
    </cfoutput>

  </cfmodule>

<cfelse>

  <cfoutput>#SESSION.BROG.renderEntry(page.body)#</cfoutput>

</cfif>