<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfmodule template="../../tags/scopecache.cfm" cachename="#SESSION.BROG.getProperty('name')#_tc" scope="APPLICATION" timeout="#APPLICATION.BLOG.timeout#">
	<cfmodule template="../../tags/podlayout.cfm" title="Tags">
		<cfset cats = SESSION.BROG.getCategories()>
		<cfquery dbtype="query" name="tags">
			SELECT entrycount AS tagCount,bca_name AS tag, bca_bcaid
			  FROM cats
			WHERE entrycount >= 10
		</cfquery>
		<cfset tagValueArray = ListToArray(ValueList(tags.tagCount))>
		<cfset max = ArrayMax(tagValueArray)>
		<cfset min = ArrayMin(tagValueArray)>
		<cfset diff = max - min>
		<cfset scaleFactor = 25>
		<cfset distribution = diff / scaleFactor>
		<cfoutput>
			<cfif tags.RecordCount>
				<cfloop query="tags">
					<cfsilent>
						<cfif tags.tagCount EQ min>
							<cfset class="smallestTag">
						<cfelseif tags.tagCount EQ max>
							<cfset class="largestTag">
						<cfelseif tags.tagCount GT (min + (distribution*2))>
							<cfset class="largeTag">
						<cfelseif tags.tagCount GT (min + distribution)>
							<cfset class="mediumTag">
						<cfelse>
							<cfset class="smallTag">
						</cfif>
					</cfsilent>
					<a href="#SESSION.BROG.makeCategoryLink(tags.bca_bcaid)#"><span class="#class#">#lcase(tags.tag)#</span></a>
				</cfloop>
			<cfelse>
				<span class="bco_moderated">not enough tags yet</span>
			</cfif>
		</cfoutput>
	</cfmodule>
</cfmodule>

<cfsetting enablecfoutputonly="false" />