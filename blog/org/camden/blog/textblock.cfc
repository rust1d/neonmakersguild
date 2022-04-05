<!---
  Name         : textblock
  Author       : Raymond Camden
  Created      :
  Last Updated : August 22, 2006
  History      : Updates for Oracle and username/password added by Deanna Schneider (8/22/06)
  Purpose     : Blog CFC
--->
<cfcomponent output="false" displayName="Textblock">

<cfset variables.username = "">
<cfset variables.password = "">
<cfset variables.dsn = "">
<cfset variables.blog = "">

<cffunction name="init" access="public" returnType="textblock" output="false">
  <cfargument name="dsn" type="string" required="true">
  <cfargument name="username" type="string" required="true">
  <cfargument name="password" type="string" required="true">
  <cfargument name="blog" type="string" required="true">

  <cfset variables.dsn = arguments.dsn>
  <cfset variables.username = arguments.username>
  <cfset variables.password = arguments.password>
  <cfset variables.blog = arguments.blog>

  <cfreturn this>
</cffunction>

<cffunction name="deleteTextblock" returnType="void" output="false" access="public">
  <cfargument name="btb_btbid" type="uuid" required="true">

  <cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
  delete from BlogTextBlocks
  where  btb_btbid = <cfqueryparam cfsqltype="varchar" value="#arguments.btb_btbid#" maxlength="35">
  and    btb_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  </cfquery>
</cffunction>

<cffunction name="getTextBlock" access="public" returnType="struct" output="false">
  <cfargument name="label" type="string" required="false">
  <cfargument name="id" type="uuid" required="false">
  <cfset var q = "">
  <cfset var s = structNew()>

  <cfquery name="q" datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
  select    btb_btbid, btb_label, btb_body
  from    BlogTextBlocks
  where    btb_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  <cfif structKeyExists(arguments, "label")>
  and    btb_label = <cfqueryparam cfsqltype="varchar" value="#arguments.label#" maxlength="255">
  </cfif>
  <cfif structKeyExists(arguments, "btb_btbid")>
  and    btb_btbid = <cfqueryparam cfsqltype="varchar" value="#arguments.btb_btbid#" maxlength="35">
  </cfif>
  </cfquery>

  <cfif q.recordCount>
    <cfset s.btb_btbid = q.btb_btbid>
    <cfset s.btb_label = q.btb_label>
    <cfset s.btb_body = q.btb_body>
  </cfif>

  <cfreturn s>
</cffunction>

<cffunction name="getTextBlockContent" access="public" returnType="string" output="false">
  <cfargument name="label" type="string" required="true">
  <cfset var q = "">

  <cfquery name="q" datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
  select    btb_btbid, btb_label, btb_body
  from    BlogTextBlocks
  where    btb_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  and        btb_label = <cfqueryparam cfsqltype="varchar" value="#arguments.label#" maxlength="255">
  </cfquery>

  <cfreturn q.btb_body>
</cffunction>


<cffunction name="getTextBlocks" access="public" returnType="query" output="false">
  <cfset var q = "">

  <cfquery name="q" datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
  select    btb_btbid, btb_label, btb_body
  from    BlogTextBlocks
  where    btb_blog = <cfqueryparam cfsqltype="varchar" value="#variables.blog#" maxlength="50">
  order by   btb_label asc
  </cfquery>

  <cfreturn q>
</cffunction>

<cffunction name="saveTextblock" returnType="void" output="false" access="public">
  <cfargument name="btb_btbid" type="string" required="true">
  <cfargument name="label" type="string" required="true">
  <cfargument name="body" type="string" required="true">

  <cfif arguments.btb_btbid is 0>
    <cfset arguments.btb_btbid = createUUID()>

    <cfquery datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
    insert into BlogTextBlocks(btb_btbid, btb_label, btb_body, btb_blog)
    values(
      <cfqueryparam cfsqltype="varchar" value="#arguments.btb_btbid#" maxlength="35">,
      <cfqueryparam cfsqltype="varchar" value="#arguments.btb_label#" maxlength="255">,
      <cfqueryparam cfsqltype="longvarchar" value="#arguments.btb_body#">,
      <cfqueryparam cfsqltype="varchar" value="#variables.btb_blog#" maxlength="35">
      )
    </cfquery>

  <cfelse>

    <cfquery datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
    update BlogTextBlocks
    set
    btb_label = <cfqueryparam cfsqltype="varchar" value="#arguments.btb_label#" maxlength="255">,
    btb_body = <cfqueryparam cfsqltype="longvarchar" value="#arguments.btb_body#">
    where  btb_btbid = <cfqueryparam cfsqltype="varchar" value="#arguments.btb_btbid#" maxlength="35">
    </cfquery>

  </cfif>

</cffunction>

</cfcomponent>