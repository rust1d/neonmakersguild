
<!---
  articles may be defined if this was included in index file on initial load
--->
<cfif not IsDefined('articles')>
  <cfparam name="URL.page" default="1">
  <cfif not isNumeric(URL.page) or URL.page lte 0 or round(URL.page) neq URL.page>
    <cfset URL.page = 1>
  </cfif>

  <cfset tp = (APPLICATION.BLOG.mobilePageMax *(URL.page-1)) + 1>
  <cfif tp EQ 0>
    <cfset tp = 1>
  </cfif>
  <cfset params.startrow = tp>
  <cfset params.maxEntries = APPLICATION.BLOG.mobilePageMax>


  <cfset articleData = SESSION.BROG.getEntries(params)>
  <cfset articles = articleData.entries>
  <cfset pages = ceiling(articleData.totalEntries/params.maxEntries)>

</cfif>

<cfoutput query="articles">
    <cfset comCnt = SESSION.BROG.getCommentCount(id)>
    <li style="white-space: normal;"><a href="postDetail.cfm?post=#id#" style="white-space: normal;">#title#</a> <span class="ui-li-count">#comCnt#</span></li>
</cfoutput>
