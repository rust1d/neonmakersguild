<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset APPLICATION.BLOG.page.deletePage(u)>
	</cfloop>
</cfif>
<cfset pages = APPLICATION.BLOG.page.getPages()>
<!--- Kind of a hack, but lets add a new col for our url --->
<cfset queryAddColumn(pages, "url", arrayNew(1))>
<cfloop query="pages">
	<cfset querySetCell(pages, "url", "#APPLICATION.PATH.ROOT#/b.page.cfm/#alias#", currentRow)>
</cfloop>
<cfmodule template="../tags/adminlayout.cfm" title="Pages">
	<cfoutput><p>Your blog currently has #udfAddSWithCnt("page", pages.RecordCount)#.</p></cfoutput>
	<cfmodule template="../tags/datatable.cfm" data="#pages#" editlink="x.page.cfm" label="Pages" linkcol="title" defaultsort="title" defaultdir="asc">
		<cfmodule template="../tags/datacol.cfm" colname="title" label="Title" />
		<cfmodule template="../tags/datacol.cfm" colname="url" label="URL" format="url" />
	</cfmodule>

</cfmodule>

<cfsetting enablecfoutputonly="false" />