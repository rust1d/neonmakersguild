<cfcomponent displayName="Page" output="false">

<cfset variables.blog = "">

<cffunction name="init" returnType="page" output="false" access="public">
  <cfargument name="blog" type="string" required="true">

  <cfset variables.blog = arguments.blog>

  <cfreturn this>
</cffunction>

<cffunction name="deletePage" returnType="void" output="false" access="public">
  <cfargument name="id" type="uuid" required="true">

  <cfquery datasource="#application.dsn#" >
  delete from BlogPages
  where  bpa_bpaid = <cfqueryparam cfsqltype="varchar" value="#arguments.id#" maxlength="35">
  and    bpa_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  </cfquery>

  <!--- remove all cats --->
  <cfquery datasource="#application.dsn#" >
  delete from BlogPagesCategories
  where bpc_bpaid = <cfqueryparam cfsqltype="varchar" value="#arguments.id#" maxlength="35">
  </cfquery>

</cffunction>

<cffunction name="getCategoriesForPage" returnType="query" output="false" access="public">
  <cfargument name="id" type="uuid" required="true">
  <cfset var q = "">

  <cfquery name="q" datasource="#application.dsn#" >


  select  BlogCategories.bca_bcaid, BlogCategories.bca_category
  from  BlogCategories, BlogPagesCategories
  where  BlogCategories.bca_bcaid = BlogPagesCategories.bpc_bcaid
  and    BlogPagesCategories.bpc_bpaid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
  </cfquery>
  <cfreturn q>
</cffunction>

<cffunction name="getPage" returnType="struct" output="false" access="public">
  <cfargument name="id" type="uuid" required="true">
  <cfset var q = "">
  <cfset var s = structNew()>

  <cfquery name="q" datasource="#application.dsn#" >
  select    bpa_bpaid, bpa_blog, bpa_title, bpa_alias, bpa_body, bpa_showlayout
  from    BlogPages
  where    bpa_bpaid = <cfqueryparam cfsqltype="varchar" value="#arguments.id#" maxlength="35">
  and      bpa_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  </cfquery>

  <cfif q.recordCount>
    <cfset s.bpa_bpaid = q.bpa_bpaid>
    <cfset s.bpa_blog = q.bpa_blog>
    <cfset s.bpa_title = q.bpa_title>
    <cfset s.bpa_alias = q.bpa_alias>
    <cfset s.bpa_body = q.bpa_body>
    <cfset s.bpa_showlayout = q.bpa_showlayout>
    <cfset s.categories = getCategoriesForPage(q.bpa_bpaid)>
  </cfif>

  <cfreturn s>
</cffunction>

<cffunction name="getPageByAlias" returnType="struct" output="false" access="public">
  <cfargument name="alias" type="string" required="true">
  <cfset var q = "">
  <cfset var s = structNew()>

  <cfquery name="q" datasource="#application.dsn#" >
  select    bpa_bpaid, bpa_blog, bpa_title, bpa_alias, bpa_body, bpa_showlayout
  from    BlogPages
  where    bpa_alias = <cfqueryparam cfsqltype="varchar" value="#arguments.alias#" maxlength="100">
  and      bpa_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  </cfquery>

  <cfif q.recordCount>
    <cfset s.bpa_bpaid = q.bpa_bpaid>
    <cfset s.bpa_blog = q.bpa_blog>
    <cfset s.bpa_title = q.bpa_title>
    <cfset s.bpa_alias = q.bpa_alias>
    <cfset s.bpa_body = q.bpa_body>
    <cfset s.bpa_showlayout = q.bpa_showlayout>
  </cfif>

  <cfreturn s>
</cffunction>

<cffunction name="getPages" returnType="query" output="false" access="public">
  <cfset var q = "">

  <cfquery name="q" datasource="#application.dsn#" >
  select    bpa_bpaidid, bpa_blog, bpa_title, bpa_alias, bpa_body, bpa_showlayout
  from    BlogPages
  where    bpa_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  order by   bpa_title asc
  </cfquery>

  <cfreturn q>
</cffunction>

<cffunction name="savePage" returnType="void" output="false" access="public">
  <cfargument name="bpa_bpaid" type="string" required="true">
  <cfargument name="bpa_title" type="string" required="true">
  <cfargument name="bpa_alias" type="string" required="true">
  <cfargument name="bpa_body" type="string" required="true">
  <cfargument name="bpa_showlayout" type="boolean" required="true">
  <cfargument name="categories" type="string" required="true">

  <cfset var c = "">

  <cfif arguments.bpa_bpaid is 0>
    <cfset arguments.bpa_bpaid = createUUID()>
    <cfquery datasource="#application.dsn#" >
    insert into BlogPages(bpa_bpaid, bpa_title, bpa_alias, bpa_body, bpa_blog, bpa_showlayout)
    values(
      <cfqueryparam cfsqltype="varchar" value="#arguments.bpa_bpaid#" maxlength="35">,
      <cfqueryparam cfsqltype="varchar" value="#arguments.bpa_title#" maxlength="255">,
      <cfqueryparam cfsqltype="varchar" value="#arguments.bpa_alias#" maxlength="100">,
      <cfqueryparam cfsqltype="longvarchar" value="#arguments.bpa_body#">,
      <cfqueryparam cfsqltype="varchar" value="#variables.bpa_blog#" maxlength="35">,
      <cfqueryparam cfsqltype="tinyint" value="#arguments.bpa_showlayout#">
      )
    </cfquery>

  <cfelse>

    <cfquery datasource="#application.dsn#" >
    update BlogPages
    set
    bpa_title = <cfqueryparam cfsqltype="varchar" value="#arguments.bpa_title#" maxlength="255">,
    bpa_alias = <cfqueryparam cfsqltype="varchar" value="#arguments.bpa_alias#" maxlength="100">,
    bpa_body = <cfqueryparam cfsqltype="longvarchar" value="#arguments.bpa_body#">,
    bpa_showlayout = <cfqueryparam cfsqltype="tinyint" value="#arguments.bpa_showlayout#">
    where  bpa_bpaid = <cfqueryparam cfsqltype="varchar" value="#arguments.bpa_bpaid#" maxlength="35">
    </cfquery>

  </cfif>

  <!--- remove all cats --->
  <cfquery datasource="#application.dsn#" >
  delete from BlogPagesCategories
  where bpc_bpaid = <cfqueryparam cfsqltype="varchar" value="#arguments.id#" maxlength="35">
  </cfquery>

  <cfloop index="c" list="#arguments.categories#">
    <cfquery datasource="#application.dsn#" >
    insert into BlogPagesCategories(bpc_bpaid,bpc_bcaid)
    values(
      <cfqueryparam cfsqltype="varchar" value="#arguments.id#" maxlength="35">,
      <cfqueryparam cfsqltype="varchar" value="#c#" maxlength="35">
      )
    </cfquery>
  </cfloop>

</cffunction>

</cfcomponent>