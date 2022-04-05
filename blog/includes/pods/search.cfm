<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfmodule template="../../tags/podlayout.cfm" title="#APPLICATION.BLOG.resourceBundle.getResource("search")#">
	<cfoutput>
	<div class="center">
		<form action="#APPLICATION.PATH.ROOT#/b.search.cfm" method="post" onsubmit="return !isEmpty(this.search)">
			<input type="search" name="search" size="15" placeholder="#APPLICATION.BLOG.resourceBundle.getResource('search')#" required="required" />
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-accessread" title="#APPLICATION.BLOG.resourceBundle.getResource('search')#" onclick="return fieldHintIsEmpty(this.form.search)" />
		</form>
	</div>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly="false" />