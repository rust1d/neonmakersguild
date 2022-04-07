<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
  Name         : Stats
  Author       : Raymond Camden
  Created      : November 19, 2004
  Last Updated : December 31, 2008 (by Aaron S. West)
  History      : reset for 5.0
         : gettopviews didnt filter by blog. gettotalviews added (rkc 7/17/06)
         : rb use, and subscriber count wsn't filtering by bsu_verified (rkc 8/20/06)
         : comment mod support (rkc 12/7/06)
  Purpose     : Stats
--->

<cfmodule template="../tags/adminlayout.cfm" title="#request.rb("stats")#">

  <cfset dsn = application.blog.getProperty("dsn")>
  <cfset dbtype = application.blog.getProperty("blogdbtype")>
  <cfset blog = application.blog.getProperty("name")>
  <cfset username = application.blog.getProperty("username")>
  <cfset password = application.blog.getProperty("password")>
  <cfif isDefined("URL.statsYear") AND isNumericDate(URL.statsYear)>
    <cfset statsYear = URL.statsYear>
  <cfelse>
    <cfset statsYear = year(now())>
  </cfif>

  <!--- get a bunch of crap --->
  <cfquery name="getTotalEntries" datasource="#application.dsn#">
    select  count(id) as totalentries,
        min(posted) as firstentry,
        max(posted) as lastentry
    from  BlogEntries
    where   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and    year(posted) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">
  </cfquery>

  <cfquery name="getTotalSubscribers" datasource="#application.dsn#">
    select  count(bsu_email) as totalsubscribers
    from  BlogSubscribers
    where   BlogSubscribers.bsu_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and    bsu_verified = 1
  </cfquery>

  <cfquery name="getTotalViews" datasource="#application.dsn#">
    select    sum(views) as total
    from    BlogEntries
    where   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and    year(posted) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">
  </cfquery>

  <cfquery name="getTopViews" datasource="#application.dsn#">
    select     id, title, views
    from    BlogEntries
    where   BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and    year(posted) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">
    order by  views desc
    limit 10
  </cfquery>

  <cfquery name="getTotalComments" datasource="#application.dsn#">
    select  count(BlogComments.bco_bcoid) as totalcomments
    from  BlogComments, BlogEntries
    where  BlogComments.bco_benid = BlogEntries.ben_benid
    and    BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    <cfif application.blog.getProperty("moderate")>
    and    BlogComments.bco_moderated = 1
    </cfif>
    and    year(  BlogComments.bco_posted) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">
  </cfquery>

  <!--- gets num of entries per category --->
  <cfquery name="getCategoryCount" datasource="#application.dsn#">
    select  bca_bcaid, bca_category, count(fk_bcaid) as total
    from  BlogCategories, BlogEntriesCategories, BlogEntries
    where  BlogEntriesCategories.bec_bcaid = BlogCategories.bca_bcaid
    and    BlogCategories.bca_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and   BlogEntriesCategories.bec_benid = BlogEntries.ben_benid
    and    year(BlogEntries.ben_posted) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">
    group by BlogCategories.bca_bcaid, BlogCategories.bca_category
    order by total desc
  </cfquery>

  <!--- gets num of comments per entry, top 10 --->
  <cfquery name="topCommentedEntries" datasource="#application.dsn#">
    select

    BlogEntries.ben_benid, BlogEntries.ben_title, count(BlogComments.bco_bcoid) as commentcount
    from      BlogEntries, BlogComments
    where      BlogComments.bco_benid = BlogEntries.ben_benid
    and        BlogEntries.ben_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    <cfif application.blog.getProperty("moderate")>
    and        BlogComments.bco_moderated = 1
    </cfif>
    and    year(  BlogComments.bco_posted) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">

    group by    BlogEntries.ben_benid, BlogEntries.ben_title
    <cfif dbtype is not "msaccess">
      order by  commentcount desc
    <cfelse>
      order by   count(BlogComments.bco_bcoid) desc
    </cfif>
    limit 10
  </cfquery>

  <!--- gets num of comments per category, top 10 --->
  <cfquery name="topCommentedCategories" datasource="#application.dsn#">
    select BlogCategories.bca_bcaid,
            BlogCategories.bca_category,
            count(BlogComments.bco_bcoid) as commentcount
    from      BlogCategories, BlogComments, BlogEntriesCategories
    where      BlogComments.bco_benid = BlogEntriesCategories.bec_benid
    and        BlogEntriesCategories.bec_bcaid = BlogCategories.bca_bcaid
    and        BlogCategories.bca_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and        year(  BlogComments.bco_posted) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">
    <cfif application.blog.getProperty("moderate")>
    and        BlogComments.bco_moderated = 1
    </cfif>
    group by    BlogCategories.bca_bcaid, BlogCategories.bca_category
      order by  commentcount desc
    limit 10
  </cfquery>

  <cfquery name="topSearchTerms" datasource="#application.dsn#">
    select bss_term, count(bss_term) as total
    from    BlogSearchStats
    where    bss_blog = <cfqueryparam cfsqltype="varchar" value="#blog#">
    and      year(bss_searched) = <cfqueryparam cfsqltype="numeric" value="#statsYear#">
    group by  bss_term
      order by  total desc
    limit 10
  </cfquery>

  <cfset averageCommentsPerEntry = 0>
  <cfif getTotalEntries.totalEntries>
    <cfset dur = dateDiff("d",getTotalEntries.firstEntry, now())>
    <cfset averageCommentsPerEntry = getTotalComments.totalComments / getTotalEntries.totalEntries>
  </cfif>

  <cfoutput>
  <div class="date"><b>Stats for #statsYear#</b></div>
  <div class="body">
  <Br/>
  To specify a different year add a URL variable: ?statsYear=2016
        <Br/>

  <a href="##generalstats">#request.rb("generalstats")#</a><br>
  <a href="##topviews">#request.rb("topviews")#</a><br>
  <a href="##categorystats">#request.rb("categorystats")#</a><br>
  <a href="##topentriesbycomments">#request.rb("topentriesbycomments")#</a><br>
  <a href="##topcategoriesbycomments">#request.rb("topcategoriesbycomments")#</a><br>
  <a href="##topsearchterms">#request.rb("topsearchterms")#</a><br>
  </div>

  <p />

  <div class="date"><a name="generalstats"></a><b>#request.rb("generalstats")#</b></div>
  <div class="body">
  <table border="1" width="100%">
    <tr>
      <td><b>#request.rb("totalnumentries")#:</b></td>
      <td>#getTotalEntries.totalEntries#</td>
    </tr>
    <tr>
      <td><b>#request.rb("firstentry")#:</b></td>
      <td><cfif len(getTotalEntries.firstEntry)>#dateFormat(getTotalEntries.firstEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
    </tr>
    <tr>
      <td><b>#request.rb("lastentry")#:</b></td>
      <td><cfif len(getTotalEntries.lastEntry)>#dateFormat(getTotalEntries.lastEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
    </tr>
    <tr>
      <td><b>#request.rb("totalcomments")#:</b></td>
      <td>#getTotalComments.totalComments#</td>
    </tr>
    <tr>
      <td><b>#request.rb("avgcommentsperentry")#:</b></td>
      <td>#numberFormat(averageCommentsPerEntry,"999.99")#</td>
    </tr>
    <tr>
      <td><b>#request.rb("totalviews")#:</b></td>
      <td>#getTotalViews.total#</td>
    </tr>
    <tr>
      <td width="50%"><b>Average Views:</b></td>
      <td>
        <cfif gettotalentries.totalentries gt 0 and gettotalviews.total gt 0>
        #numberFormat(gettotalviews.total/gettotalentries.totalentries,"999.99")#
        <cfelse>
        0
        </cfif>
      </td>
    </tr>
    <tr>
      <td><b>#request.rb("totalsubscribers")#:</b></td>
      <td>#getTotalSubscribers.totalsubscribers#</td>
    </tr>

  </table>
  </div>

  <p />

  <div class="date"><a name="topviews"></a><b>#request.rb("topviews")#</b></div>
  <div class="body">
  <table border="1" width="100%">
    <cfloop query="getTopViews">
    <tr>
      <td><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
      <td>#views#</td>
    </tr>
    </cfloop>
  </table>
  </div>

  <p />

  <div class="date"><a name="categorystats"></a><b>#request.rb("categorystats")#</b></div>
  <div class="body">
  <table border="1" width="100%">
    <cfloop query="getCategoryCount">
    <tr>
      <td>#bca_category#</td>
      <td>#total#</td>
    </tr>
    </cfloop>
  </table>
  </div>

  <p />

  <div class="date"><a name="topentriesbycomments"></a><b>#request.rb("topentriesbycomments")#</b></div>
  <div class="body">
  <table border="1" width="100%">
    <cfloop query="topCommentedEntries">
    <tr>
      <td><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
      <td>#commentCount#</td>
    </tr>
    </cfloop>
  </table>
  </div>

  <p />

  <div class="date"><a name="topcategoriesbycomments"></a><b>#request.rb("topcategoriesbycomments")#</b></div>
  <div class="body">
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
      <cftry>
      <cfif getTotalForThisCat.total neq 0 and getTotalForThisCat.total neq "">
        <cfset avg = commentCount / getTotalForThisCat.total>
        <cfset avg = numberFormat(avg,"___.___")>
      <cfelse>
        <cfset avg = 0>
      </cfif>
      <tr>
        <td><b><a href="index.cfm?mode=cat&catid=#bca_bcaid#" rel="nofollow">#bca_category#</a></b></td>
        <td>#commentCount# (#rb("avgcommentperentry")#: #avg#)</td>
      </tr>
      <cfcatch><cfdump var="#getTotalForThisCat#"></cfcatch>
      </cftry>
    </cfloop>
  </table>
  </div>

  <p />

  <div class="date"><a name="topsearchterms"></a><b>#request.rb("topsearchterms")#</b></div>
  <div class="body">
  <table border="1" width="100%">
    <cfloop query="topSearchTerms">
    <tr>
      <td><b><a href="#application.rooturl#/index.cfm?mode=search&search=#urlEncodedFormat(searchterm)#" rel="nofollow">#searchterm#</a></b></td>
      <td>#total#</td>
    </tr>
    </cfloop>
  </table>
  </div>

  </cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>