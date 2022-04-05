<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfmodule template="../../tags/scopecache.cfm" cachename="pod_pages" scope="application" timeout="#APPLICATION.BLOG.timeout#">
	<cfset pages_qry = APPLICATION.BLOG.page.getPages() />
	<cfmodule template="../../tags/podlayout.cfm" title="Navigation">
		<cfoutput><a href="#APPLICATION.PATH.ROOT#">Home</a><br /></cfoutput>
		<cfloop query="pages_qry">
			<cfoutput><a href="#APPLICATION.PATH.ROOT#/b.page.cfm/#alias#">#title#</a><br /></cfoutput>
		</cfloop>
	</cfmodule>
</cfmodule>
<cfsetting enablecfoutputonly="false" />
