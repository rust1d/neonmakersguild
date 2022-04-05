<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfif thisTag.executionMode is "start">
  <cfif isDefined("ATTRIBUTES.title")>
    <cfset additionalTitle = ": " & ATTRIBUTES.title>
  <cfelse>
    <cfset additionalTitle = "">
    <cfif isDefined("URL.mode") and URL.mode is "cat">
      <!--- can be a list --->
      <cfset additionalTitle = "">
      <cfloop index="cat" list="#URL.catid#">
        <cftry>
          <cfset additionalTitle = additionalTitle & " : " & SESSION.BROG.getCategory(cat).bca_name>
          <cfcatch></cfcatch>
        </cftry>
      </cfloop>
    <cfelseif isDefined("URL.mode") and URL.mode is "entry">
      <cftry>
        <!--- Should I add one to views? Only if the user hasn't seen it. --->
        <cfset dontLog = false>
        <cfif StructKeyExists(SESSION.viewedpages, URL.entry)>
          <cfset dontLog = true>
        <cfelse>
          <cfset SESSION.viewedpages[URL.entry] = 1>
        </cfif>
        <cfset entry = SESSION.BROG.getEntry(URL.entry,dontLog)>
        <cfset additionalTitle = ": #entry.title#">
        <cfcatch></cfcatch>
      </cftry>
    </cfif>
  </cfif>
  <cfoutput>
  <link rel="alternate" type="application/rss+xml" title="RSS" href="#APPLICATION.PATH.ROOT#/b.rss.cfm?mode=full" />
  <style type="text/css">
    @import "#APPLICATION.PATH.ROOT#/blog/css/blog.css";
  </style>
  <script type="text/javascript">
    function launchComment(id) {
      cWin = popOut("#APPLICATION.PATH.ROOT#/b.addcomment.cfm?id="+id,"cWin",725,725);
    }
    function launchCommentSub(id) {
      cWin = popOut("#APPLICATION.PATH.ROOT#/b.addsub.cfm?id="+id,"cWin",725,600);
    }
    $(document).ready(function() {
  <cfif isDefined("URL.mode") and URL.mode is "entry" and SESSION.BROG.getProperty("usetweetbacks") and structKeyExists(attributes, "entrymode")>
      $("##tbContent").html("<p class=tweetbackBody><i>Loading Tweetbacks...</i></p>");
      $("##tbContent").load("#APPLICATION.PATH.ROOT#/b.loadtweetbacks.cfm?id=#ATTRIBUTES.entryid#");
  </cfif>
      $("##divFooterCredits").html("<a href='http://www.blogcfc.com' target='_blank'>BlogCFC #SESSION.BROG.getVersion()#</a> <a href='http://www.raymondcamden.com' target='_blank'>by Raymond Camden</a>");
    })
  </script>
  <div id="divBlog">
    <div class="subpage_content">
  </cfoutput>
<cfelse>
  <cfoutput>
    </div>
    <cfif SESSION.BROG.getProperty("SiteBlog")>
      <div class="subpage_sidebar">
        <ul id="sidebar">
          <li class="block">
            <cfinclude template="getpods.cfm">
          </li>
        </ul>
      </div>
    </cfif>
  </div><!-- end divBlog -->
  </cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false" />