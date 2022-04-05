<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : C:\projects\blogcfc5\client\admin\categories.cfm
	Author       : Raymond Camden
	Created      : 04/07/06
	Last Updated :
	History      :
--->

<cfif not SESSION.BROG.isBlogAuthorized('ManageCategories')>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset SESSION.BROG.deleteCategory(u)>
	</cfloop>
</cfif>


<cfset categories = SESSION.BROG.getCategories(false)>

<cfmodule template="../tags/adminlayout.cfm" title="Categories">

	<cfoutput>
	<p>
	Your blog currently has
		<cfif categories.RecordCount>
		#categories.RecordCount# categories.
		<cfelseif categories.RecordCount is 1>
		1 category.
		<cfelse>
		0 categories.
		</cfif>
	</p>
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#categories#" editlink="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/category/p.brewer.cfm" label="Category"
			  linkcol="bca_name" linkval="bca_bcaid">
		<cfmodule template="../tags/datacol.cfm" colname="bca_name" label="Category" />
		<cfmodule template="../tags/datacol.cfm" colname="entrycount" label="Entries" />
	</cfmodule>

</cfmodule>


<cfsetting enablecfoutputonly="false" />