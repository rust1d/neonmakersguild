

<cfset params.startrow = 1>
<cfset params.maxEntries = 999>
<cfset params.byCat = SESSION.BROG.getCategoryByAlias(URL.catid)>
<cfset articleData = SESSION.BROG.getEntries(params)>
<cfset articles = articleData.entries>

<cfset catInfo = SESSION.BROG.getCategory(params.byCat)>

<cfoutput>

<div data-role="page"  data-theme="#APPLICATION.BLOG.primaryTheme#">


  <cf_header title="#catInfo.bca_name#" showHome="2" id="blogHeader">

  <div data-role="content" >
    <ul data-role="listview">
      <cfinclude template="posts.cfm">
    </ul>
  </div><!-- /content -->


  <cf_footer />
  <!-- /footer -->


</div><!-- /page -->
</cfoutput>