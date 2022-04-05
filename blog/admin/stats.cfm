<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : Stats
	Author       : Raymond Camden
	Created      : November 19, 2004
	Last Updated : April 13, 2007
	History      : reset for 5.0
				 : gettopviews didnt filter by blog. gettotalviews added (rkc 7/17/06)
				 : rb use, and subscriber count wsn't filtering by verified (rkc 8/20/06)
				 : comment mod support (rkc 12/7/06)
				 : top commenters support (rkc 2/28/07)
				 : fix MS Access (rkc 3/2/07)
				 : just formatting (rkc 4/13/07)
	Purpose		 : Stats
--->

<cfmodule template="../tags/adminlayout.cfm" title="Stats">
	<cfset blog = SESSION.BROG.getProperty("name")>
	<!--- get a bunch of crap --->
	<cfquery name="getTotalEntries" datasource="#APPLICATION.DSN.BLOG#">
		select	count(id) as totalentries,
				min(posted) as firstentry,
				max(posted) as lastentry
		from	blogEntries
		where 	ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	</cfquery>

	<cfquery name="getTotalSubscribers" datasource="#APPLICATION.DSN.BLOG#">
		select	count(email) as totalsubscribers
		from	blogSubscribers
		where 	blogSubscribers.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and		verified = 1
	</cfquery>

	<cfquery name="getTotalViews" datasource="#APPLICATION.DSN.BLOG#">
		select		sum(views) as total
		from		blogEntries
		where 	ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	</cfquery>

	<cfquery name="getTopViews" datasource="#APPLICATION.DSN.BLOG#">
		select		 id, title, views
		from		blogEntries
		where 	ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		order by	views desc
		limit 10
	</cfquery>

	<!--- get last 30 --->
	<cfset thirtyDaysAgo = dateAdd("d", -30, now())>
	<cfquery name="last30" datasource="#APPLICATION.DSN.BLOG#">
		select	count(id) as totalentries
		from	blogEntries
		where 	ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and		posted >= <cfqueryparam cfsqltype="cf_sql_date" value="#thirtyDaysAgo#">
	</cfquery>

	<cfquery name="getTotalComments" datasource="#APPLICATION.DSN.BLOG#">
		select	count(blogComments.id) as totalcomments
		from	blogComments, blogEntries
		where	blogComments.entryidfk = blogEntries.id
		and		ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif SESSION.BROG.getProperty("moderate")>
		and		blogComments.bco_moderated = 1
		</cfif>
	</cfquery>

	<!--- gets num of entries per category --->
	<cfquery name="getCategoryCount" datasource="#APPLICATION.DSN.BLOG#">
		select	bca_bcaid, bca_name, count(  bec_bcaid) as total
		from	blogCategories, blogEntriesCategories
		where	blogEntriesCategories.bec_bcaid = blogCategories.bca_bcaid
		and		bca_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		group by blogCategories.bca_bcaid, blogCategories.bca_name
			order by total desc
	</cfquery>

	<!--- gets num of comments per entry, top 10 --->
	<cfquery name="topCommentedEntries" datasource="#APPLICATION.DSN.BLOG#">
		select

		blogEntries.id, blogEntries.title, count(blogComments.id) as commentcount
		from			blogEntries, blogComments
		where			blogComments.entryidfk = blogEntries.id
		and				ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif SESSION.BROG.getProperty("moderate")>
		and				blogComments.bco_moderated = 1
		</cfif>

		group by		blogEntries.id, blogEntries.title
			order by	commentcount desc
		limit 10
	</cfquery>

	<!--- gets num of comments per category, top 10 --->
	<cfquery name="topCommentedCategories" datasource="#APPLICATION.DSN.BLOG#">
		select

						blogCategories.bca_bcaid,
						blogCategories.bca_name,
						count(blogComments.id) as commentcount
		from			blogCategories, blogComments, blogEntriesCategories
		where			blogComments.entryidfk = blogEntriesCategories.entryidfk
		and				blogEntriesCategories.  bec_bcaid = blogCategories.bca_bcaid
		and				bca_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif SESSION.BROG.getProperty("moderate")>
		and				blogComments.bco_moderated = 1
		</cfif>
		group by		blogCategories.bca_bcaid, blogCategories.bca_name
			order by	commentcount desc
		limit 10
	</cfquery>

	<cfquery name="topSearchTerms" datasource="#APPLICATION.DSN.BLOG#">
		select

					searchterm, count(searchterm) as total
		from		blogSearchStats
		where		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
        group by	searchterm
			order by	total desc
		limit 10
	</cfquery>

	<cfquery name="topCommenters" datasource="#APPLICATION.DSN.BLOG#" maxrows="10">
	select	count(blogComments.email) as emailCount, email, blogComments.name
	from	blogComments, blogEntries
	where	blogComments.entryidfk = blogEntries.id
	and 	ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	group by blogComments.email, blogComments.name
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
			<li><a href="##generalstats">#rb("generalstats")#</a></li>
			<li><a href="##topviews">#rb("topviews")#</a></li>
			<li><a href="##categorystats">#rb("categorystats")#</a></li>
			<li><a href="##topentriesbycomments">#rb("topentriesbycomments")#</a></li>
			<li><a href="##topcategoriesbycomments">#rb("topcategoriesbycomments")#</a></li>
			<li><a href="##topsearchterms">#rb("topsearchterms")#</a></li>
			<li><a href="##topcommenters">#rb("topcommenters")#</a></li>
		</ul>

		<div id="generalstats">

			<table class="datagrid" width="100%" cellspacing="0">
				<tr>
					<td class="label" width="250">#rb("totalnumentries")#:</td>
					<td align="right">#numberFormat(getTotalEntries.totalEntries)#</td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("last30")#:</td>
					<td align="right">#numberFormat(last30.totalEntries)#</td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("last30avg")#:</td>
					<td align="right"><cfif last30.totalentries gt 0>#numberFormat(last30.totalEntries/30,"999.99")#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("firstentry")#:</td>
					<td align="right"><cfif len(getTotalEntries.firstEntry)>#dateFormat(getTotalEntries.firstEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("lastentry")#:</td>
					<td align="right"><cfif len(getTotalEntries.lastEntry)>#dateFormat(getTotalEntries.lastEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("bloggingfor")#:</td>
					<td align="right"><cfif structKeyExists(variables, "dur")>#numberFormat(variables.dur)# #rb("days")#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("totalcomments")#:</td>
					<td align="right">#numberFormat(getTotalComments.totalComments)#</td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("avgcommentsperentry")#:</td>
					<td align="right">#numberFormat(averageCommentsPerEntry,"999.99")#</td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("totalviews")#:</td>
					<td align="right">#numberFormat(getTotalViews.total)#</td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("avgviews")#:</td>
					<td align="right">
						<cfif gettotalentries.totalentries gt 0 and gettotalviews.total gt 0>
						#numberFormat(gettotalviews.total/gettotalentries.totalentries,"999.99")#
						<cfelse>
						0
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="label" width="250">#rb("totalsubscribers")#:</td>
					<td align="right">#getTotalSubscribers.totalsubscribers#</td>
				</tr>

			</table>

		</div>

		<div id="topviews">

			<table class="datagrid" width="100%" cellspacing="0">
				<cfloop query="getTopViews">
				<tr>
					<td class="label" width="250"><a href="#SESSION.BROG.makeLink(id)#" rel="nofollow">#title#</a></td>
					<td align="right">#numberFormat(views)#</td>
				</tr>
				</cfloop>
			</table>

		</div>

		<div id="categorystats">
			<table class="datagrid" width="100%" cellspacing="0">
				<cfloop query="getCategoryCount">
				<tr>
					<td class="label" width="250"><a href="#SESSION.BROG.makeCategoryLink(bca_bcaid)#">#bca_name#</a></td>
					<td align="right">#numberFormat(total)#</td>
				</tr>
				</cfloop>
			</table>
		</div>

		<div id="topentriesbycomments">

			<table class="datagrid" width="100%" cellspacing="0">
				<cfloop query="topCommentedEntries">
				<tr>
					<td class="label" width="250"><a href="#SESSION.BROG.makeLink(id)#" rel="nofollow">#title#</a></td>
					<td align="right">#numberFormat(commentCount)#</td>
				</tr>
				</cfloop>
			</table>

		</div>

		<div id="topcategoriesbycomments">

			<table class="datagrid" width="100%" cellspacing="0">
				<cfloop query="topCommentedCategories">
					<!---
						This is ugly code.
						I want to find the avg number of posts
						per entry for this category.
					--->
					<cfquery name="getTotalForThisCat" dbtype="query">
						select	total
						from	getCategoryCount
						where	bca_bcaid = '#bca_bcaid#'
					</cfquery>
					<cfset avg = commentCount / getTotalForThisCat.total>
					<cfset avg = numberFormat(avg,"___.___")>
					<tr>
						<td class="label" width="250"><a href="index.cfm?mode=cat&amp;catid=#bca_bcaid#" rel="nofollow">#bca_name#</a></td>
						<td align="right">#commentCount# (#rb("avgcommentperentry")#: #avg#)</td>
					</tr>
				</cfloop>
			</table>

		</div>

		<div id="topsearchterms">

			<table class="datagrid" width="100%" cellspacing="0">
				<cfloop query="topSearchTerms">
				<tr>
					<td class="label" width="250"><a href="#APPLICATION.PATH.ROOT#/index.cfm?mode=search&amp;search=#urlEncodedFormat(searchterm)#" rel="nofollow">#searchterm#</a></td>
					<td align="right">#numberFormat(total)#</td>
				</tr>
				</cfloop>
			</table>

		</div>

		<div id="topcommenters">

			<table class="datagrid" width="100%" cellspacing="0">
				<cfloop query="topCommenters">
				<tr>
					<td class="label" width="250">#name#</td>
					<td align="right">#numberFormat(emailcount)#</td>
				</tr>
				</cfloop>
			</table>

		</div>

	</div>
	</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false" />