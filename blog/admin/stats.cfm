<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">

<cfmodule template="../tags/adminlayout.cfm" title="Stats">

  <cfset dsn = application.blog.getProperty("dsn")>
  <cfset dbtype = application.blog.getProperty("blogdbtype")>
  <cfset blog = application.blog.getProperty("name")>
  <cfset username = application.blog.getProperty("username")>
  <cfset password = application.blog.getProperty("password")>

  <!--- get a bunch of crap --->
  <cfquery name="getTotalEntries" datasource="#dsn#">
    select  count(ben_benid) as totalentries,
        min(ben_posted) as firstentry,
        max(ben_posted) as lastentry
    from  BlogEntries
    where   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
  </cfquery>

  <cfquery name="getTotalSubscribers" datasource="#dsn#">
    select  count(bsu_email) as totalsubscribers
    from  BlogSubscribers
    where   BlogSubscribers.bsu_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and    bsu_verified = 1
  </cfquery>

  <cfquery name="getTotalViews" datasource="#dsn#">
    select    sum(ben_views) as total
    from    BlogEntries
    where   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
  </cfquery>

  <cfquery name="getTopViews" datasource="#dsn#">
    select    ben_id, ben_title, ben_views
    from    BlogEntries
    where   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    order by  ben_views desc
    limit 10
  </cfquery>

  <!--- get last 30 --->
  <cfset thirtyDaysAgo = dateAdd("d", -30, now())>
  <cfquery name="last30" datasource="#dsn#">
    select  count(id) as totalentries
    from  BlogEntries
    where   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and    posted >= <cfqueryparam cfsqltype="date" value="#thirtyDaysAgo#">
  </cfquery>

  <cfquery name="getTotalComments" datasource="#dsn#">
    select  count(BlogComments.bco_bcoid) as totalcomments
    from  BlogComments, BlogEntries
    where  BlogComments.bco_benid = BlogEntries.ben_benid
    and    BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    <cfif application.commentmoderation>
    and    BlogComments.bco_moderated = 1
    </cfif>
  </cfquery>

  <!--- gets num of entries per category --->
  <cfquery name="getCategoryCount" datasource="#dsn#">
    select  bca_bcaid, bca_category, count(bec_bcaid) as total
    from  BlogCategories, BlogEntriesCategories
    where  BlogEntriesCategories.bec_bcaid = BlogCategories.bca_bcaid
    and    BlogCategories.bca_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    group by BlogCategories.bca_bcaid, BlogCategories.bca_category
      order by bec_total desc
  </cfquery>

  <!--- gets num of comments per entry, top 10 --->
  <cfquery name="topCommentedEntries" datasource="#dsn#">
    select

    BlogEntries.ben_benid, BlogEntries.ben_title, count(BlogComments.bco_bcoid) as commentcount
    from      BlogEntries, BlogComments
    where      BlogComments.bco_benid = BlogEntries.ben_benid
    and        BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    <cfif application.commentmoderation>
    and        BlogComments.bco_moderated = 1
    </cfif>

    group by    BlogEntries.ben_benid, BlogEntries.ben_title
    <cfif dbtype is not "msaccess">
      order by  commentcount desc
    <cfelse>
      order by   count(BlogComments.bco_bcoid) desc
    </cfif>
    limit 10
  </cfquery>

  <!--- gets num of comments per category, top 10 --->
  <cfquery name="topCommentedCategories" datasource="#dsn#">
    select BlogCategories.bca_bcaid,
            BlogCategories.bca_category,
            count(BlogComments.bco_bcoid) as commentcount
    from      BlogCategories, BlogComments, BlogEntriesCategories
    where      BlogComments.bco_benid = BlogEntriesCategories.bec_benid
    and        BlogEntriesCategories.bec_bcaid = BlogCategories.bca_bcaid
    and        BlogCategories.bca_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    <cfif application.commentmoderation>
    and        BlogComments.bco_moderated = 1
    </cfif>
    group by    BlogCategories.bca_bcaid, BlogCategories.bca_category
    order by  commentcount desc
    limit 10
  </cfquery>

  <cfquery name="topSearchTerms" datasource="#dsn#">
    select bss_term, count(bss_term) as total
    from    BlogSearchStats
    where    bss_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
        group by  bss_term
      order by  total desc
    limit 10
  </cfquery>

  <cfquery name="topCommenters" datasource="#dsn#" maxrows="10">
  select  count(BlogComments.bco_email) as emailCount, email, BlogComments.bco_name
  from  BlogComments, BlogEntries
  where  BlogComments.bco_benid = BlogEntries.ben_benid
  and   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
  group by BlogComments.bco_email, BlogComments.bco_name
  order by emailCount desc
  </cfquery>

  <cfset averageCommentsPerEntry = 0>
  <cfif getTotalEntries.totalEntries>
    <cfset dur = dateDiff("d",getTotalEntries.firstEntry, now())>
    <cfset averageCommentsPerEntry = getTotalComments.totalComments / getTotalEntries.totalEntries>
  </cfif>

  <cfoutput>
  <script type="text/javascript">
  $(document).ready(function() {

    //create tabs
    $("##statstabs").tabs();

  });
  </script>

  <div id="statstabs">

    <ul>
      <li><a href="##generalstats">#request.rb("generalstats")#</a></li>
      <li><a href="##topviews">#request.rb("topviews")#</a></li>
      <li><a href="##categorystats">#request.rb("categorystats")#</a></li>
      <li><a href="##topentriesbycomments">#request.rb("topentriesbycomments")#</a></li>
      <li><a href="##topcategoriesbycomments">#request.rb("topcategoriesbycomments")#</a></li>
      <li><a href="##topsearchterms">#request.rb("topsearchterms")#</a></li>
      <li><a href="##topcommenters">#request.rb("topcommenters")#</a></li>
    </ul>

    <div id="generalstats">

      <table border="1" width="100%">
        <tr>
          <td width="50%">#request.rb("totalnumentries")#:</td>
          <td align="right">#numberFormat(getTotalEntries.totalEntries)#</td>
        </tr>
        <tr>
          <td width="50%">#request.rb("last30")#:</td>
          <td align="right">#numberFormat(last30.totalEntries)#</td>
        </tr>
        <tr>
          <td width="50%">#request.rb("last30avg")#:</td>
          <td align="right"><cfif last30.totalentries gt 0>#numberFormat(last30.totalEntries/30,"999.99")#<cfelse>&nbsp;</cfif></td>
        </tr>
        <tr>
          <td width="50%">#request.rb("firstentry")#:</td>
          <td align="right"><cfif len(getTotalEntries.firstEntry)>#dateFormat(getTotalEntries.firstEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
        </tr>
        <tr>
          <td width="50%">#request.rb("lastentry")#:</td>
          <td align="right"><cfif len(getTotalEntries.lastEntry)>#dateFormat(getTotalEntries.lastEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
        </tr>
        <tr>
          <td width="50%">#request.rb("bloggingfor")#:</td>
          <td align="right"><cfif structKeyExists(variables, "dur")>#numberFormat(variables.dur)# #request.rb("days")#<cfelse>&nbsp;</cfif></td>
        </tr>
        <tr>
          <td width="50%">#request.rb("totalcomments")#:</td>
          <td align="right">#numberFormat(getTotalComments.totalComments)#</td>
        </tr>
        <tr>
          <td width="50%">#request.rb("avgcommentsperentry")#:</td>
          <td align="right">#numberFormat(averageCommentsPerEntry,"999.99")#</td>
        </tr>
        <tr>
          <td width="50%">#request.rb("totalviews")#:</td>
          <td align="right">#numberFormat(getTotalViews.total)#</td>
        </tr>
        <tr>
          <td width="50%">#request.rb("avgviews")#:</td>
          <td align="right">
            <cfif gettotalentries.totalentries gt 0 and gettotalviews.total gt 0>
            #numberFormat(gettotalviews.total/gettotalentries.totalentries,"999.99")#
            <cfelse>
            0
            </cfif>
          </td>
        </tr>
        <tr>
          <td width="50%">#request.rb("totalsubscribers")#:</td>
          <td align="right">#getTotalSubscribers.totalsubscribers#</td>
        </tr>

      </table>

    </div>

    <div id="topviews">

      <table border="1" width="100%">
        <cfloop query="getTopViews">
        <tr>
          <td width="50%"><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></td>
          <td align="right">#numberFormat(views)#</td>
        </tr>
        </cfloop>
      </table>

    </div>

    <div id="categorystats">
      <table border="1" width="100%">
        <cfloop query="getCategoryCount">
        <tr>
          <td width="50%"><a href="#application.blog.makeCategoryLink(bca_bcaid)#">#bca_category#</a></td>
          <td align="right">#numberFormat(total)#</td>
        </tr>
        </cfloop>
      </table>
    </div>

    <div id="topentriesbycomments">

      <table border="1" width="100%">
        <cfloop query="topCommentedEntries">
        <tr>
          <td width="50%"><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></td>
          <td align="right">#numberFormat(commentCount)#</td>
        </tr>
        </cfloop>
      </table>

    </div>

    <div id="topcategoriesbycomments">

      <table border="1" width="100%">
        <cfloop query="topCommentedCategories">
          <!---
            This is ugly code.
            I want to find the avg number of posts
            per entry for this category.
          --->
          <cfquery name="getTotalForThisCat" dbtype="query">
            select  total
            from  getCategoryCount
            where  bca_bcaid = '#bca_bcaid#'
          </cfquery>
          <cfset avg = commentCount / getTotalForThisCat.total>
          <cfset avg = numberFormat(avg,"___.___")>
          <tr>
            <td width="50%"><a href="index.cfm?mode=cat&amp;catid=#bca_bcaid#" rel="nofollow">#bca_category#</a></td>
            <td align="right">#commentCount# (#request.rb("avgcommentperentry")#: #avg#)</td>
          </tr>
        </cfloop>
      </table>

    </div>

    <div id="topsearchterms">

      <table border="1" width="100%">
        <cfloop query="topSearchTerms">
        <tr>
          <td width="50%"><a href="#application.rooturl#/index.cfm?mode=search&amp;search=#urlEncodedFormat(searchterm)#" rel="nofollow">#searchterm#</a></td>
          <td align="right">#numberFormat(total)#</td>
        </tr>
        </cfloop>
      </table>

    </div>

    <div id="topcommenters">

      <table border="1" width="100%">
        <cfloop query="topCommenters">
        <tr>
          <td width="50%">#name#</td>
          <td align="right">#numberFormat(emailcount)#</td>
        </tr>
        </cfloop>
      </table>

    </div>

  </div>
  </cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>