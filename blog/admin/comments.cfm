<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />

<cfparam name="FORM.search" default="">
<!--- handle deletes --->
<cfif structKeyExists(FORM, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset SESSION.BROG.deleteComment(u)>
	</cfloop>
</cfif>

<cfif len(trim(FORM.search))>
	<cfset comments = SESSION.BROG.getComments(sortdir="desc",search=FORM.search)>
<cfelse>
	<cfset comments = SESSION.BROG.getComments(sortdir="desc")>
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Comments">
	<cfoutput>
	<p><cfif len(trim(form.search))>Your search returned<cfelse>Your blog currently has</cfif> #udfAddSWithCnt("comment", comments.RecordCount)#.</p>
	<p>
	<form action="x.comments.cfm" method="post">
		Filter By Keyword
		<input type="text" name="search" value="#FORM.search#">
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-filteradd" submit="true" title="Filter By Keyword"/>
	</form>
	</p>
	</cfoutput>
	<cfmodule template="../tags/datatable.cfm" data="#comments#" editlink="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/comment/p.brewer.cfm" label="Comments" linkcol="comment" defaultsort="posted" defaultdir="desc" showAdd="false">
		<cfmodule template="../tags/datacol.cfm" label="<img title='View' class='bih-icon bih-icon-popout' src='#APPLICATION.PATH.IMG#/trans.gif'>" data="<a href=""#APPLICATION.PATH.ROOT#/index.cfm?mode=entry&entry=$entryidfk$##c$id$""><img title='View' class='bih-icon bih-icon-popout' src='#APPLICATION.PATH.IMG#/trans.gif'></a>" sort="false" width="25"/>
		<cfmodule template="../tags/datacol.cfm" colname="name" label="Name" />
		<cfmodule template="../tags/datacol.cfm" colname="entrytitle" label="Entry" left="100" />
		<cfmodule template="../tags/datacol.cfm" colname="posted" label="Posted" format="datetime" />
		<cfmodule template="../tags/datacol.cfm" colname="comment" label="Comment" left="200"/>
	</cfmodule>

</cfmodule>

<cfsetting enablecfoutputonly="false" />