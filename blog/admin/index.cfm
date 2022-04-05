<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!--- As with my stats page, this should most likely be abstracted into the CFC. --->
<cfset blog = SESSION.BROG.getProperty("name")>
<cfset sevendaysago = dateAdd("d", -7, now())>
<cfquery name="topByViews" datasource="#APPLICATION.DSN.BLOG#" maxrows="5">
	select id, title, views, posted
	  from blogEntries
	 where ben_blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and posted > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#sevendaysago#">
	 order by views desc
</cfquery>
<cfmodule template="../tags/adminlayout.cfm" title="Welcome">
	<cfoutput>
	<p>Welcome to BlogCFC Administrator. You are running BlogCFC version #SESSION.BROG.getVersion()#.</p>
	<cfif topByViews.RecordCount>
		<h3>Top Entries</h3>
		<p>Here are the top entries over the past seven days based on the number of views:</p>
		<p><cfloop query="topByViews"><a href="#SESSION.BROG.makeLink(id)#">#title#</a> (#views#)<br/></cfloop></p>
	</cfif>
	<h3>Credits</h3>
	<p>BlogCFC was created by <a href="http://www.coldfusionjedi.com">Raymond Camden</a>. For more information, please visit the BlogCFC site at <a href="http://www.blogcfc.com">http://www.blogcfc.com</a>.</p>
	<p>BlogCFC has had the support and active help of <i>many</i> people. Special thanks to Scott Stroz, Jeff Coughlin, Charlie Griefer, and Paul Hastings.</p>
	<p>BlogCFC makes use of <a href="http://lyla.maestropublishing.com/">Lyla Captcha</a> from Peter Farrell.</p>
	<p>Default spam protection provided by <a href="http://cfformprotect.riaforge.org/">CFFormProtect</a> by Jake Munson.</p>
	<cfif StructKeyExists(URL, "reinit")>
		<div style="margin: 15px 0; padding: 15px; border: 5px solid ##008000; background-color: ##80ff00; color: ##000000; font-weight: bold; text-align: center;">
			Your blog cache has been refreshed.
		</div>
	</cfif>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly="false" />