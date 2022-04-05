<cfcomponent displayName="Page" output="false">

<cfset variables.dsn = "">
<cfset variables.blog = "">

<cffunction name="init" returnType="page" output="false" access="public">
	<cfargument name="dsn" type="string" required="true">
	<cfargument name="blog" type="string" required="true">
	<cfset variables.dsn = arguments.dsn>
	<cfset variables.blog = arguments.blog>
	<cfreturn this>
</cffunction>

<cffunction name="deletePage" returnType="void" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">

	<cfquery datasource="#variables.dsn#">
	delete from blogPages
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	and		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	</cfquery>

	<!--- remove all cats --->
	<cfquery datasource="#variables.dsn#">
	delete from blogPagescategories
	where pageidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	</cfquery>

</cffunction>

<cffunction name="getCategoriesForPage" returnType="query" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">
	<cfset var q = "">

	<cfquery name="q" datasource="#variables.dsn#">


	select	blogCategories.bca_bcaid, blogCategories.bca_name
	from	blogCategories, blogPagescategories
	where	blogCategories.bca_bcaid = blogPagescategories.  bec_bcaid
	and		blogPagescategories.pageidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
	</cfquery>
	<cfreturn q>
</cffunction>

<cffunction name="getPage" returnType="struct" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">
	<cfset var q = "">
	<cfset var s = structNew()>

	<cfquery name="q" datasource="#variables.dsn#">
	select		id, blog, title, alias, body, showlayout
	from		blogPages
	where		id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	and			blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	</cfquery>

	<cfif q.RecordCount>
		<cfset s.id = q.id>
		<cfset s.blog = q.blog>
		<cfset s.title = q.title>
		<cfset s.alias = q.alias>
		<cfset s.body = q.body>
		<cfset s.showlayout = q.showlayout>
		<cfset s.categories = getCategoriesForPage(q.id)>
	</cfif>

	<cfreturn s>
</cffunction>

<cffunction name="getPageByAlias" returnType="struct" output="false" access="public">
	<cfargument name="alias" type="string" required="true">
	<cfset var q = "">
	<cfset var s = structNew()>

	<cfquery name="q" datasource="#variables.dsn#">
	select		id, blog, title, alias, body, showlayout
	from		blogPages
	where		alias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">
	and			blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	</cfquery>

	<cfif q.RecordCount>
		<cfset s.id = q.id>
		<cfset s.blog = q.blog>
		<cfset s.title = q.title>
		<cfset s.alias = q.alias>
		<cfset s.body = q.body>
		<cfset s.showlayout = q.showlayout>
	</cfif>

	<cfreturn s>
</cffunction>

<cffunction name="getPages" returnType="query" output="false" access="public">
	<cfset var q = "">

	<cfquery name="q" datasource="#variables.dsn#">
	select		id, blog, title, alias, body, showlayout
	from		blogPages
	where		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	order by 	title asc
	</cfquery>

	<cfreturn q>
</cffunction>

<cffunction name="savePage" returnType="void" output="false" access="public">
	<cfargument name="id" type="string" required="true">
	<cfargument name="title" type="string" required="true">
	<cfargument name="alias" type="string" required="true">
	<cfargument name="body" type="string" required="true">
	<cfargument name="showlayout" type="boolean" required="true">
	<cfargument name="categories" type="string" required="true">

	<cfset var c = "">

	<cfif arguments.id is 0>
		<cfset arguments.id = createUUID()>

		<cfquery datasource="#variables.dsn#">
		insert into blogPages(id, title, alias, body, blog, showlayout)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="255">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.showlayout#">
			)
		</cfquery>

	<cfelse>

		<cfquery datasource="#variables.dsn#">
		update blogPages
		set
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="255">,
				alias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">,
				body = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">,
				showlayout = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.showlayout#">
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

	</cfif>

	<!--- remove all cats --->
	<cfquery datasource="#variables.dsn#">
	delete from blogPagescategories
	where pageidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	</cfquery>

	<cfloop index="c" list="#arguments.categories#">
		<cfquery datasource="#variables.dsn#">
		insert into blogPagescategories(pageidfk,  bec_bcaid)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#c#" maxlength="35">
			)
		</cfquery>
	</cfloop>

</cffunction>

</cfcomponent>