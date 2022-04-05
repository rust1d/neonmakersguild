<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset SESSION.BROG.deleteEntry(u)>
	</cfloop>
	<!--- clear cache --->
	<cfmodule template="../tags/scopecache.cfm" scope="application" clearall="true">
</cfif>
<cfparam name="URL.keywords" default="">
<cfparam name="form.keywords" default="#URL.keywords#">
<cfparam name="URL.start" default="1">
<cfparam name="URL.sort" default="posted">
<cfparam name="URL.dir" default="desc">
<cfset params = structNew()>
<cfset params.mode = "short">
<cfif len(trim(form.keywords))>
	<cfset params.searchTerms = form.keywords>
	<cfset params.dontlogsearch = true>
</cfif>
<cfset params.maxEntries = APPLICATION.BLOG.maxEntries>
<cfset params.startRow = URL.start>
<cfif not SESSION.BROG.isBlogAuthorized('ReleaseEntries')>
	<cfset params.released = false>
</cfif>
<cfset params.orderby = URL.sort>
<cfset params.orderbydir = URL.dir>
<cfset entryData = SESSION.BROG.getEntries(params)>
<cfset entries = entryData.entries>
<cfset queryAddColumn(entries,"viewurl",arrayNew(1))>
<cfloop query="entries">
	<cfset vu = SESSION.BROG.makeLink(id)>
	<cfset querySetCell(entries, "viewurl", vu & "?adminview=true", currentRow)>
</cfloop>
<cfmodule template="../tags/adminlayout.cfm" title="Blog Entries">
	<cfoutput>
	<p><cfif len(trim(form.keywords))>Your search returned<cfelse>Your blog currently has</cfif> #udfAddSWithCnt("entry", entryData.totalEntries)#.</p>
	<p>
	<form action="x.entries.cfm" method="post">
		Filter By Keyword
		<input type="text" name="keywords" value="#form.keywords#">
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-filteradd" submit="true" title="Filter By Keyword"/>
	</form>
	</p>
	</cfoutput>
	<cfmodule template="../tags/datatablenew.cfm" data="#entries#" editlink="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/entry/p.brewer.cfm" label="Entry" linkcol="title" defaultsort="posted" defaultdir="desc" queryString="keywords=#urlencodedformat(form.keywords)#" totalRows="#entryData.totalEntries#">
		<cfmodule template="../tags/datacolnew.cfm" label="<img title='View' class='bih-icon bih-icon-popout' src='#APPLICATION.PATH.IMG#/trans.gif'>" data="<a href=""$viewurl$""><img title='View' class='bih-icon bih-icon-popout' src='#APPLICATION.PATH.IMG#/trans.gif'></a>" sort="false" width="25"/>
		<cfmodule template="../tags/datacolnew.cfm" colname="title" label="Title" />
		<cfmodule template="../tags/datacolnew.cfm" colname="released" label="Released" format="yesno"/>
		<cfmodule template="../tags/datacolnew.cfm" colname="posted" label="Posted" format="datetime" />
		<cfmodule template="../tags/datacolnew.cfm" colname="views" label="Views" format="number" />
	</cfmodule>
</cfmodule>
<cfsetting enablecfoutputonly="false" />