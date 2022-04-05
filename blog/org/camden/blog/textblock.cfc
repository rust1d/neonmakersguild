<cfcomponent output="false" displayName="Textblock">

<cfset variables.dsn = "">
<cfset variables.blog = "">

<cffunction name="init" access="public" returnType="textblock" output="false">
  <cfargument name="dsn" type="string" required="true">
  <cfargument name="blog" type="string" required="true">
  <cfset variables.dsn = arguments.dsn>
  <cfset variables.blog = arguments.blog>
  <cfreturn this>
</cffunction>

<cffunction name="deleteTextblock" returnType="void" output="false" access="public">
  <cfargument name="id" type="uuid" required="true">

  <cfquery datasource="#variables.dsn#">
  delete from blogTextBlocks
  where  id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
  and    blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
  </cfquery>
</cffunction>

<cffunction name="getTextBlock" access="public" returnType="struct" output="false">
  <cfargument name="label" type="string" required="false">
  <cfargument name="id" type="uuid" required="false">
  <cfset var q = "">
  <cfset var s = structNew()>

  <cfquery name="q" datasource="#variables.dsn#" >
  select    id, label, body
  from    blogTextBlocks
  where    blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
  <cfif structKeyExists(arguments, "label")>
  and    label = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.label#" maxlength="255">
  </cfif>
  <cfif structKeyExists(arguments, "id")>
  and    id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
  </cfif>
  </cfquery>

  <cfif q.RecordCount>
    <cfset s.id = q.id>
    <cfset s.label = q.label>
    <cfset s.body = q.body>
  </cfif>

  <cfreturn s>
</cffunction>

<cffunction name="getTextBlockContent" access="public" returnType="string" output="false">
  <cfargument name="label" type="string" required="true">
  <cfset var q = "">

  <cfquery name="q" datasource="#variables.dsn#" >
  select    id, label, body
  from    blogTextBlocks
  where    blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
  and        label = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.label#" maxlength="255">
  </cfquery>

  <cfreturn q.body>
</cffunction>


<cffunction name="getTextBlocks" access="public" returnType="query" output="false">
  <cfset var q = "">

  <cfquery name="q" datasource="#variables.dsn#" >
  select    id, label, body
  from    blogTextBlocks
  where    blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
  order by   label asc
  </cfquery>

  <cfreturn q>
</cffunction>

<cffunction name="saveTextblock" returnType="void" output="false" access="public">
  <cfargument name="id" type="string" required="true">
  <cfargument name="label" type="string" required="true">
  <cfargument name="body" type="string" required="true">

  <cfif arguments.id is 0>
    <cfset arguments.id = createUUID()>

    <cfquery datasource="#variables.dsn#" >
    insert into blogTextBlocks(id, label, body, blog)
    values(
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.label#" maxlength="255">,
      <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="35">
      )
    </cfquery>

  <cfelse>

    <cfquery datasource="#variables.dsn#" >
    update blogTextBlocks
    set
        label = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.label#" maxlength="255">,
        body = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">
    where  id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
    </cfquery>

  </cfif>

</cffunction>

</cfcomponent>