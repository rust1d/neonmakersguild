<cfcomponent displayName="Blog" output="false" hint="BlogCFC by Raymond Camden">

  <!--- Load utils immidiately. --->
  <cfset variables.utils = createObject("component", "utils")>

  <cfset variables.roles = structNew()>

  <!--- Require 6.1 or higher --->
  <cfset majorVersion = listFirst(server.coldfusion.productversion)>
  <cfset minorVersion = listGetAt(server.coldfusion.productversion,2,".,")>
  <cfset cfversion = majorVersion & "." & minorVersion>
  <cfif (server.coldfusion.productname is "ColdFusion Server" and cfversion lte 6)
      or
      (server.coldfusion.productname is "BlueDragon" and cfversion lte 6.1)>
    <cfset variables.utils.throw("Blog must be run under ColdFusion 6.1, BlueDragon 6.2, or higher.")>
  </cfif>
  <cfset variables.isColdFusionMX8 = server.coldfusion.productname is "ColdFusion Server" and cfversion gte 8>

  <!--- Valid database types --->
  <cfset validDBTypes = "MSACCESS,MYSQL,MSSQL,ORACLE">

  <!--- current version --->
  <cfset version = "5.9.8.012" />

  <!--- cfg file --->
  <cfset variables.cfgFile = "#getDirectoryFromPath(GetCurrentTemplatePath())#/blog.ini.cfm">

  <!--- used for rendering --->
  <cfset variables.renderMethods = structNew()>

  <!--- used for settings --->
  <cfset variables.instance = "">

  <cffunction name="init" access="public" returnType="blog" output="false"
        hint="Initialize the blog engine">

    <cfargument name="name" type="string" required="false" default="default" hint="Blog name, defaults to default in blog.ini">
    <cfargument name="instanceData" type="struct" required="false" hint="Allows you to specify BlogCFC info at runtime.">
    <cfargument name="BlogDBName" type="string" required="false" hint="I am the blog name in the DB.  If I am specified, I will use the name argument to find the config settings, but the blogDBName to find the database data">

    <cfset var renderDir = "">
    <cfset var renderCFCs = "">
    <cfset var cfcName = "">
    <cfset var md = "">

    <cfif isDefined("arguments.instanceData")>
      <cfset instance = duplicate(arguments.instanceData)>
    <cfelse>
      <cfif not listFindNoCase(structKeyList(getProfileSections(variables.cfgFile)),name)>
        <cfset variables.utils.throw("#arguments.name# isn't registered as a valid blog.")>
      </cfif>
      <cfset instance = structNew()>
      <cfset instance.dsn = variables.utils.configParam(variables.cfgFile,arguments.name,"dsn")>
      <cfset instance.username = variables.utils.configParam(variables.cfgFile,arguments.name,"username")>
      <cfset instance.password = variables.utils.configParam(variables.cfgFile,arguments.name,"password")>
      <cfset instance.ownerEmail = variables.utils.configParam(variables.cfgFile, arguments.name, "owneremail")>
      <cfset instance.blogURL = variables.utils.configParam(variables.cfgFile, arguments.name, "blogURL")>
      <cfset instance.blogTitle = variables.utils.configParam(variables.cfgFile, arguments.name, "blogTitle")>
      <cfset instance.blogDescription = variables.utils.configParam(variables.cfgFile, arguments.name, "blogDescription")>
      <cfset instance.blogDBType = variables.utils.configParam(variables.cfgFile, arguments.name, "blogDBType")>
      <cfset instance.locale = variables.utils.configParam(variables.cfgFile, arguments.name, "locale")>
      <cfset instance.commentsFrom = variables.utils.configParam(variables.cfgFile,arguments.name,"commentsFrom")>
      <cfset instance.failTo = variables.utils.configParam(variables.cfgFile,arguments.name,"failTo")>
      <cfset instance.mailServer = variables.utils.configParam(variables.cfgFile,arguments.name,"mailserver")>
      <cfset instance.mailusername = variables.utils.configParam(variables.cfgFile,arguments.name,"mailusername")>
      <cfset instance.mailpassword = variables.utils.configParam(variables.cfgFile,arguments.name,"mailpassword")>
      <cfset instance.pingurls = variables.utils.configParam(variables.cfgFile,arguments.name,"pingurls")>
      <cfset instance.offset = variables.utils.configParam(variables.cfgFile, arguments.name, "offset")>
      <cfset instance.trackbackspamlist = variables.utils.configParam(variables.cfgFile, arguments.name, "trackbackspamlist")>
      <cfset instance.blogkeywords = variables.utils.configParam(variables.cfgFile, arguments.name, "blogkeywords")>
      <cfset instance.ipblocklist = variables.utils.configParam(variables.cfgFile, arguments.name, "ipblocklist")>
      <cfset instance.maxentries = variables.utils.configParam(variables.cfgFile, arguments.name, "maxentries")>
      <cfset instance.maxentriesadmin = variables.utils.configParam(variables.cfgFile, arguments.name, "maxentriesadmin")>
      <cfset instance.moderate = variables.utils.configParam(variables.cfgFile, arguments.name, "moderate")>
      <cfset instance.usecaptcha = variables.utils.configParam(variables.cfgFile, arguments.name, "usecaptcha")>
      <cfset instance.usecfp = variables.utils.configParam(variables.cfgFile, arguments.name, "usecfp")>
      <cfset instance.allowgravatars = variables.utils.configParam(variables.cfgFile, arguments.name, "allowgravatars")>
      <cfset instance.filebrowse = variables.utils.configParam(variables.cfgFile, arguments.name, "filebrowse")>
      <cfset instance.settings = variables.utils.configParam(variables.cfgFile, arguments.name, "settings")>
      <cfset instance.imageroot = variables.utils.configParam(variables.cfgFile, arguments.name, "imageroot")>
      <cfset instance.itunesSubtitle = variables.utils.configParam(variables.cfgFile, arguments.name, "itunesSubtitle")>
      <cfset instance.itunesSummary = variables.utils.configParam(variables.cfgFile, arguments.name, "itunesSummary")>
      <cfset instance.itunesKeywords = variables.utils.configParam(variables.cfgFile, arguments.name, "itunesKeywords")>
      <cfset instance.itunesAuthor = variables.utils.configParam(variables.cfgFile, arguments.name, "itunesAuthor")>
      <cfset instance.itunesImage = variables.utils.configParam(variables.cfgFile, arguments.name, "itunesImage")>
      <cfset instance.itunesExplicit = variables.utils.configParam(variables.cfgFile, arguments.name, "itunesExplicit")>
      <cfset instance.tableprefix = variables.utils.configParam(variables.cfgFile, arguments.name, "tableprefix")>
      <cfset instance.usetweetbacks = variables.utils.configParam(variables.cfgFile, arguments.name, "usetweetbacks")>
      <cfset instance.installed = variables.utils.configParam(variables.cfgFile, arguments.name, "installed")>
      <cfset instance.saltalgorithm = variables.utils.configParam(variables.cfgFile, arguments.name, "saltalgorithm")>
      <cfset instance.saltkeysize = variables.utils.configParam(variables.cfgFile, arguments.name, "saltkeysize")>
      <cfset instance.hashalgorithm = variables.utils.configParam(variables.cfgFile, arguments.name, "hashalgorithm")>
    </cfif>

    <!--- Name the blog --->
    <cfif IsDefined('arguments.BlogDBName')>
      <cfset instance.name = arguments.BlogDBName>
    <cfelse>
      <cfset instance.name = arguments.name>
    </cfif>

    <!--- If FailTo is blank, use Admin email --->
    <cfif instance.failTo is "">
      <cfset instance.failTo = instance.ownerEmail>
    </cfif>

    <cfset variables.ping = createObject("component", "ping8")>

    <!--- get a copy of textblock --->
    <cfset variables.textblock = createObject("component","textblock").init(dsn=instance.dsn, blog=instance.name)>

    <!--- prepare rendering --->
    <cfset renderDir = getDirectoryFromPath(GetCurrentTemplatePath()) & "/render/">
    <!--- get my kids --->
    <cfdirectory action="list" name="renderCFCs" directory="#renderDir#" filter="*.cfc">

    <cfloop query="renderCFCs">
      <cfset cfcName = listDeleteAt(renderCFCs.name, listLen(renderCFCs.name, "."), ".")>

      <cfif cfcName is not "render">
        <!--- store the name --->
        <cfset variables.renderMethods[cfcName] = structNew()>
        <!--- create an instance of the CFC. It better have a render method! --->
        <cfset variables.renderMethods[cfcName].cfc = createObject("component", "render.#cfcName#")>
        <cfset md = getMetaData(variables.renderMethods[cfcName].cfc)>
        <cfif structKeyExists(md, "instructions")>
          <cfset variables.renderMethods[cfcName].instructions = md.instructions>
        </cfif>
      </cfif>

    </cfloop>

    <cfreturn this>

  </cffunction>

  <cffunction name="addCategory" access="remote" returnType="uuid" roles="admin,AddCategory,ManageCategory" output="false"
        hint="Adds a category.">
    <cfargument name="name" type="string" required="true">
    <cfargument name="alias" type="string" required="true">

    <cfset var checkC = "">
    <cfset var id = createUUID()>

    <cflock name="blogcfc.addCategory" type="exclusive" timeout=30>

      <cfif categoryExists(name="#arguments.name#")>
        <cfset variables.utils.throw("#arguments.name# already exists as a category.")>
      </cfif>

      <cfquery datasource="nmg" >
        insert into BlogCategories(bca_bcaid,bca_category,bca_alias,blog)
        values(
          <cfqueryparam value="#id#" cfsqltype="VARCHAR" maxlength="35">,
          <cfqueryparam value="#arguments.name#" cfsqltype="VARCHAR" maxlength="50">,
          <cfqueryparam value="#arguments.alias#" cfsqltype="VARCHAR" maxlength="50">,
          <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">)
      </cfquery>

    </cflock>

    <cfreturn id>
  </cffunction>

  <cffunction name="addComment" access="remote" returnType="uuid" output="false"
        hint="Adds a comment.">
    <cfargument name="bco_benid" type="uuid" required="true">
    <cfargument name="bco_name" type="string" required="true">
    <cfargument name="bco_email" type="string" required="true">
    <!--- RBB 11/02/2005:  Added bco_website argument --->
    <cfargument name="bco_website" type="string" required="true">
    <cfargument name="bco_comments" type="string" required="true">
    <cfargument name="bco_subscribe" type="boolean" required="true">
    <cfargument name="bco_subscribeonly" type="boolean" required="false" default="false">
    <cfargument name="overridemoderation" type="boolean" required="false" default="false">

    <cfset var newID = createUUID()>
    <cfset var entry = "">
    <cfset var spam = "">
    <cfset var kill = createUUID()>

    <cfset arguments.bco_comments = htmleditformat(arguments.bco_comments)>
    <cfset arguments.bco_name = left(htmlEditFormat(arguments.bco_name),50)>
    <cfset arguments.bco_email = left(htmlEditFormat(arguments.bco_email),50)>
    <!--- RBB 11/02/2005:  Added bco_website element --->
    <cfset arguments.bco_website = left(htmlEditFormat(arguments.bco_website),255)>

    <cfif not entryExists(arguments.bco_benid)>
      <cfset variables.utils.throw("#arguments.bco_benid# is not a valid entry.")>
    </cfif>

    <!--- get the entry so we can check for ben_allowcomments --->
    <cfset entry = getEntry(arguments.bco_benid,true)>
    <cfif not entry.ben_allowcomments>
      <cfset variables.utils.throw("#arguments.bco_benid# does not allow for comments.")>
    </cfif>

    <!--- only check spam if not a sub --->
    <cfif not arguments.bco_subscribeonly>
      <!--- check spam and IPs --->
      <cfloop index="spam" list="#instance.trackbackspamlist#">
        <cfif findNoCase(spam, arguments.bco_comments) or
            findNoCase(spam, arguments.bco_name) or
            findNoCase(spam, arguments.bco_website) or
            findNoCase(spam, arguments.bco_email)>
          <cfset variables.utils.throw("Comment blocked for spam.")>
        </cfif>
      </cfloop>
      <cfloop list="#instance.ipblocklist#" index="spam">
        <cfif spam contains "*" and reFindNoCase(replaceNoCase(spam, '.', '\.','all'), cgi.REMOTE_ADDR)>
          <cfset variables.utils.throw("Comment blocked for spam.")>
        <cfelseif spam is cgi.REMOTE_ADDR>
          <cfset variables.utils.throw("Comment blocked for spam.")>
        </cfif>
          </cfloop>
    </cfif>

    <cfquery datasource="nmg" >
    <!--- RBB 11/02/2005:  Added bco_website element --->
    insert into BlogComments(bco_bcoid,bco_benid,bco_name,bco_email,bco_website,bco_comment,bco_posted,bco_subscribe,bco_moderated,bco_kill,bco_subscribeonly)
    values(<cfqueryparam value="#newID#" cfsqltype="VARCHAR" maxlength="35">,
         <cfqueryparam value="#arguments.bco_benid#" cfsqltype="VARCHAR" maxlength="35">,
         <cfqueryparam value="#arguments.bco_name#" maxlength="50">,
         <cfqueryparam value="#arguments.bco_email#" maxlength="50">,
         <cfqueryparam value="#arguments.bco_website#" maxlength="255">,
         <cfqueryparam value="#arguments.bco_comment#" cfsqltype="LONGVARCHAR">,
       <cfqueryparam value="#blogNow()#" cfsqltype="TIMESTAMP">,
                <!--- convert yes/no to 1 or 0 --->
             <cfif arguments.subscribe>
               <cfset arguments.subscribe = 1>
             <cfelse>
               <cfset arguments.subscribe = 0>
             </cfif>
           <cfqueryparam value="#arguments.subscribe#" cfsqltype="TINYINT">,
           <cfif instance.moderate and not arguments.overridemoderation>0<cfelse>1</cfif>,
         <cfqueryparam value="#kill#" cfsqltype="VARCHAR" maxlength="35">,
         <cfqueryparam value="#arguments.bco_subscribeonly#" cfsqltype="TINYINT">
         )
    </cfquery>

    <!--- If subscribe is no, auto set older posts in thread by this author to no --->
    <cfif not arguments.subscribe>
      <cfquery datasource="nmg" >
      update  BlogComments
      set    bco_subscribe = 0
      where  bco_benid = <cfqueryparam value="#arguments.bco_benid#" cfsqltype="VARCHAR" maxlength="35">
      and    bco_email = <cfqueryparam value="#arguments.bco_email#" cfsqltype="varchar" maxlength="100">
      </cfquery>
    </cfif>

    <cfreturn newID>
  </cffunction>

  <cffunction name="addEntry" access="remote" returnType="uuid" roles="admin" output="true"
        hint="Adds an entry.">
    <cfargument name="title" type="string" required="true">
    <cfargument name="body" type="string" required="true">
    <cfargument name="ben_morebody" type="string" required="false" default="">
    <cfargument name="alias" type="string" required="false" default="">
    <cfargument name="posted" type="date" required="false" default="#blogNow()#">
    <cfargument name="ben_allowcomments" type="boolean" required="false" default="true">
    <cfargument name="ben_enclosure" type="string" required="false" default="">
    <cfargument name="ben_filesize" type="numeric" required="false" default="0">
    <cfargument name="ben_mimetype" type="string" required="false" default="">
    <cfargument name="ben_released" type="boolean" required="false" default="true">
    <cfargument name="relatedEntries" type="string" required="false" default="">
    <cfargument name="sendemail" type="boolean" required="false" default="true">
    <cfargument name="duration" type="string" required="false" default="">
    <cfargument name="subtitle" type="string" required="false" default="">
    <cfargument name="summary" type="string" required="false" default="">
    <cfargument name="keywords" type="string" required="false" default="">

    <cfset var id = createUUID()>
    <cfset var theURL = "">

    <cfquery datasource="nmg" >
      insert into BlogEntries(id,title,body,posted
        <cfif len(arguments.ben_morebody)>,ben_morebody</cfif>
        <cfif len(arguments.alias)>,alias</cfif>
        ,username,blog,ben_allowcomments,ben_enclosure,summary,subtitle,keywords,duration,ben_filesize,ben_mimetype,ben_released,views,mailed)
      values(
        <cfqueryparam value="#id#" cfsqltype="VARCHAR" maxlength="35">,
        <cfqueryparam value="#arguments.title#" cfsqltype="VARCHAR" maxlength="100">,
        <cfif instance.blogDBTYPE is "ORACLE">
          <cfqueryparam cfsqltype="clob" value="#arguments.body#">,
        <cfelse>
          <cfqueryparam value="#arguments.body#" cfsqltype="LONGVARCHAR">,
        </cfif>

        <cfqueryparam value="#arguments.posted#" cfsqltype="TIMESTAMP">
        <cfif len(arguments.ben_morebody)>
          <cfif instance.blogDBType is "ORACLE">
            ,<cfqueryparam cfsqltype="clob" value="#arguments.ben_morebody#">
          <cfelse>
            ,<cfqueryparam value="#arguments.ben_morebody#" cfsqltype="LONGVARCHAR">
          </cfif>
        </cfif>
        <cfif len(arguments.alias)>
          ,<cfqueryparam value="#arguments.alias#" cfsqltype="VARCHAR" maxlength="100">
        </cfif>
        ,<cfqueryparam value="#getAuthUser()#" cfsqltype="VARCHAR" maxlength="50">,
        <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">,
          <cfif instance.blogDBType is not "MYSQL" AND instance.blogDBType is not "ORACLE">
          <cfqueryparam value="#arguments.ben_allowcomments#" cfsqltype="BIT">
         <cfelse>
                <!--- convert yes/no to 1 or 0 --->
             <cfif arguments.ben_allowcomments>
               <cfset arguments.ben_allowcomments = 1>
             <cfelse>
               <cfset arguments.ben_allowcomments = 0>
             </cfif>
          <cfqueryparam value="#arguments.ben_allowcomments#" cfsqltype="TINYINT">
         </cfif>
           ,<cfqueryparam value="#arguments.ben_enclosure#" cfsqltype="VARCHAR" maxlength="255">
        ,<cfqueryparam value="#arguments.summary#" cfsqltype="VARCHAR" maxlength="255">
        ,<cfqueryparam value="#arguments.subtitle#" cfsqltype="VARCHAR" maxlength="100">
        ,<cfqueryparam value="#arguments.keywords#" cfsqltype="VARCHAR" maxlength="100">
        ,<cfqueryparam value="#arguments.duration#" cfsqltype="VARCHAR" maxlength="10">
           ,<cfqueryparam value="#arguments.ben_filesize#" cfsqltype="NUMERIC">
           ,<cfqueryparam value="#arguments.ben_mimetype#" cfsqltype="VARCHAR" maxlength="255">
           ,<cfif instance.blogDBType is not "MYSQL" and instance.blogDBType is not "ORACLE">
          <cfqueryparam value="#arguments.ben_released#" cfsqltype="BIT">
         <cfelse>
                <!--- convert yes/no to 1 or 0 --->
             <cfif arguments.ben_released>
               <cfset arguments.ben_released = 1>
             <cfelse>
               <cfset arguments.ben_released = 0>
             </cfif>
          <cfqueryparam value="#arguments.ben_released#" cfsqltype="TINYINT">
         </cfif>
        ,0
        ,<cfif instance.blogDBType is not "MYSQL" AND instance.blogDBType is not "ORACLE">
          <cfqueryparam value="false" cfsqltype="BIT">
         <cfelse>
          <cfqueryparam value="0" cfsqltype="TINYINT">
         </cfif>
        )
    </cfquery>

    <cfif len(trim(arguments.relatedEntries)) GT 0>
      <cfset saveRelatedEntries(id, arguments.relatedEntries) />
    </cfif>

    <!---
        Only mail if released = true, and posted not in the future
    --->
    <cfif arguments.sendEmail and arguments.ben_released and dateCompare(dateAdd("h", instance.offset,arguments.posted), blogNow()) lte 0>

      <cfset mailEntry(id)>

    </cfif>

    <cfif arguments.ben_released>

      <cfif arguments.sendEmail and dateCompare(dateAdd("h", instance.offset,arguments.posted), blogNow()) is 1>
        <!--- Handle delayed posting --->
        <cfset theURL = getRootURL()>
        <cfset theURL = theURL & "admin/notify.cfm?id=#id#">
        <cfschedule action="update" task="BlogCFC Notifier #id#" operation="HTTPRequest"
              startDate="#arguments.posted#" startTime="#arguments.posted#" url="#theURL#" interval="once">
      <cfelse>
        <cfset variables.ping.pingAggregators(instance.pingurls, instance.blogtitle, instance.blogurl)>
      </cfif>

    </cfif>


    <cfreturn id>

  </cffunction>

  <cffunction name="addSubscriber" access="remote" returnType="string" output="false"
        hint="Adds a subscriber to the blog.">
    <cfargument name="bsu_email" type="string" required="true">
    <cfset var bsu_token = createUUID()>
    <cfset var getMe = "">

    <!--- First, lets see if this guy is already subscribed. --->
    <cfquery name="getMe" datasource="nmg" >
    select  bsu_email
    from  BlogSubscribers
    where  bsu_email = <cfqueryparam value="#arguments.bsu_email#" cfsqltype="varchar" maxlength="50">
    and    bsu_blog = <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">
    </cfquery>

    <cfif getMe.recordCount is 0>
      <cfquery datasource="nmg" >
      insert into BlogSubscribers(bsu_email,
      bsu_token,
      bsu_blog,
      bsu_verified)
      values(<cfqueryparam value="#arguments.bsu_email#" cfsqltype="varchar" maxlength="50">,
      <cfqueryparam value="#bsu_token#" cfsqltype="varchar" maxlength="35">,
      <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">,
      0
      )
      </cfquery>

      <cfreturn bsu_token>

    <cfelse>

      <cfreturn "">

    </cfif>

  </cffunction>

  <cffunction name="addUser" access="public" returnType="void" output="false" hint="Adds a user.">
    <cfargument name="username" type="string" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="password" type="string" required="true">
    <cfset var q = "">
    <cfset var salt = generateSalt()>

    <cflock name="blogcfc.adduser" type="exclusive" timeout="60">
      <cfquery name="q" datasource="nmg" >
      select  bus_username
      from  BlogUsers
      where  bus_username = <cfqueryparam cfsqltype="varchar" value="#arguments.username#" maxlength="50">
      and    bus_blog = <cfqueryparam cfsqltype="varchar" value="#instance.name#" maxlength="50">
      </cfquery>

      <cfif q.recordCount>
        <cfset variables.utils.throw("#arguments.name# already exists as a user.")>
      </cfif>

      <cfquery datasource="nmg" >
      insert into BlogUsers(bus_username, bus_name, bus_password, bus_blog, bus_salt)
      values(
      <cfqueryparam cfsqltype="varchar" value="#arguments.bus_username#" maxlength="50">,
      <cfqueryparam cfsqltype="varchar" value="#arguments.bus_name#" maxlength="50">,
      <cfqueryparam cfsqltype="varchar" value="#hash(bus_salt & arguments.bus_password, instance.hashalgorithm)#" maxlength="256">,
      <cfqueryparam cfsqltype="varchar" value="#instance.name#" maxlength="50">,
      <cfqueryparam cfsqltype="varchar" value="#bus_salt#" maxlength="256">
      )
      </cfquery>
    </cflock>

  </cffunction>

  <cffunction name="approveComment" access="public" returnType="void" output="false"
        hint="Approves a comment.">
    <cfargument name="commentid" type="uuid" required="true">

    <cfquery datasource="nmg" >
    update BlogComments
    set     bco_moderated =
      <cfif instance.blogDBType is "MSSQL" or instance.blogDBType is "MSACCESS">
        <cfqueryparam value="true" cfsqltype="BIT">
      <cfelse>
        <cfqueryparam value="1" cfsqltype="TINYINT">
      </cfif>
    where  id = <cfqueryparam value="#arguments.commentid#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>


  <cffunction name="assignCategory" access="remote" returnType="void" roles="admin,ReleaseEntries" output="false"
        hint="Assigns entry ID to category X">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="bca_bcaid" type="uuid" required="true">
    <cfset var checkEC = "">

    <cfquery name="checkEC" datasource="nmg" >
      select  bec_bcaid
      from  BlogEntriesCategories
      where  bec_bcaid = <cfqueryparam value="#arguments.bca_bcaid#" cfsqltype="VARCHAR" maxlength="35">
      and    bec_benid = <cfqueryparam value="#arguments.entryid#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

    <cfif entryExists(arguments.entryid) and categoryExists(id=arguments.bca_bcaid) and not checkEC.recordCount>
      <cfquery datasource="nmg" >
        insert into BlogEntriesCategories(bec_bcaid,bec_benid)
        values(<cfqueryparam value="#arguments.bca_bcaid#" cfsqltype="VARCHAR" maxlength="35">,<cfqueryparam value="#arguments.entryid#" cfsqltype="VARCHAR" maxlength="35">)
      </cfquery>
    </cfif>

  </cffunction>

  <cffunction name="assignCategories" access="remote" returnType="void" roles="admin,ReleaseEntries" output="false"
        hint="Assigns entry ID to multiple categories">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="bca_bcaids" type="string" required="true">

    <cfset var i=0>

    <!--- Loop through categories --->
    <cfloop index="i" from="1" to="#listLen(arguments.bca_bcaids)#">
      <cfset assignCategory(arguments.entryid,listGetAt(bca_bcaids,i))>
    </cfloop>

  </cffunction>

  <cffunction name="authenticate" access="public" returnType="boolean" output="false" hint="Authenticates a user.">
    <cfargument name="username" type="string" required="true">
    <cfargument name="password" type="string" required="true">

    <cfset var q = "">
    <cfset var authenticated = false>

    <cfquery name="q" datasource="nmg" >
      select   bus_username, bus_password, bus_salt
      from  BlogUsers
      where  bus_sername = <cfqueryparam value="#arguments.username#" cfsqltype="VARCHAR" maxlength="50">
      and    bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>

    <cfif (q.recordCount eq 1) AND (q.bus_password is hash(q.bus_salt & arguments.password, instance.hashalgorithm))>
      <cfset authenticated = true>
    </cfif>

    <cfreturn authenticated>
  </cffunction>

  <cffunction name="blogNow" access="public" returntype="date" output="false"
        hint="Returns now() with the offset.">
    <cfreturn dateAdd("h", instance.offset, now())>
  </cffunction>

  <cffunction name="categoryExists" access="private" returnType="boolean" output="false"
        hint="Returns true or false if an entry exists.">
    <cfargument name="id" type="uuid" required="false">
    <cfargument name="name" type="string" required="false">
    <cfset var checkC = "">

    <!--- must pass either ID or name, but not obth --->
    <cfif (not isDefined("arguments.id") and not isDefined("arguments.name")) or (isDefined("arguments.id") and isDefined("arguments.name"))>
      <cfset variables.utils.throw("categoryExists method must be passed id or name, but not both.")>
    </cfif>

    <cfquery name="checkC" datasource="nmg" >
      select  bca_bcaid
      from  BlogCategories
      where
        <cfif isDefined("arguments.id")>
        bca_bcaid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
        </cfif>
        <cfif isDefined("arguments.name")>
        bca_category = <cfqueryparam value="#arguments.name#" cfsqltype="VARCHAR" maxlength="100">
        </cfif>
        and blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">

    </cfquery>

    <cfreturn checkC.recordCount gte 1>

  </cffunction>

  <cffunction name="confirmSubscription" access="public" returnType="void" output="false"
        hint="Confirms a user's subscription to the blog.">
    <cfargument name="bsu_token" type="uuid" required="false">
    <cfargument name="email" type="string" required="false">

    <cfquery datasource="nmg" >
    update  BlogSubscribers
    set    bsu_verified = 1
    <cfif structKeyExists(arguments, "bsu_token")>
    where  bsu_token = <cfqueryparam cfsqltype="varchar" maxlength="35" value="#arguments.bsu_token#">
    <cfelseif structKeyExists(arguments, "bsu_email")>
    where  bsu_email = <cfqueryparam cfsqltype="varchar" maxlength="255" value="#arguments.bsu_email#">
    <cfelse>
      <cfthrow message="Invalid call to confirmSubscription. Must pass bsu_token or bsu_email.">
    </cfif>
    </cfquery>

  </cffunction>

  <cffunction name="deleteCategory" access="public" returnType="void" roles="admin,ManageCategories" output="false"
        hint="Deletes a category.">
    <cfargument name="id" type="uuid" required="true">

    <cfquery datasource="nmg" >
      delete from BlogEntriesCategories
      where bec_bcaid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

    <cfquery datasource="nmg" >
      delete from BlogCategories
      where bca_bcaid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="deleteComment" access="public" returnType="void" roles="admin,ReleaseEntries" output="false"
        hint="Deletes a comment based on the comment's uuid.">
    <cfargument name="id" type="uuid" required="true">

    <cfquery datasource="nmg" >
      delete from BlogComments
      where id = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="deleteEntry" access="remote" returnType="void" roles="admin,ReleaseEntries" output="false"
        hint="Deletes an entry, plus all comments.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var entry = "">
    <cfset var ben_enclosure = "">

    <cfif entryExists(arguments.id)>

      <!--- get the entry. we need it to clean up ben_enclosure --->
      <cfset entry = getEntry(arguments.id)>

      <cfif entry.ben_enclosure neq "">
        <cfif fileExists(entry.ben_enclosure)>
          <cffile action="delete" file="#entry.ben_enclosure#">
        </cfif>
      </cfif>

      <cfquery datasource="nmg" >
        delete from BlogEntries
        where ben_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
        and    ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      </cfquery>

      <cfquery datasource="nmg" >
        delete from BlogEntriesCategories
        where bec_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      </cfquery>

      <cfquery datasource="nmg" >
        delete from BlogComments
        where bco_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      </cfquery>

    </cfif>

  </cffunction>

  <cffunction name="deleteUser" access="public" returnType="void" output="false" hint="Deletes a user.">
    <cfargument name="username" type="string" required="true">

    <cfquery datasource="nmg" >
    delete from BlogUsers
    where  bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    and    bus_username = <cfqueryparam value="#arguments.username#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>

  </cffunction>

  <!--- JH DotComIt modified slightly to allow a "true" result if the item exists but is not available --->
  <cffunction name="entryExists" access="private" returnType="boolean" output="false"
        hint="Returns true or false if an entry exists.">
    <cfargument name="id" type="uuid" required="true">
    <cfargument name="isAvailable" type="Boolean" required="false" default="1">

    <cfset var getIt = "">

    <cfif not structKeyExists(variables, "existsCache")>
      <cfset variables.existsCache = structNew() />
    </cfif>

    <cfif structKeyExists(variables.existsCache, arguments.id)>
      <cfreturn variables.existsCache[arguments.id]>
    </cfif>

    <cfquery name="getIt" datasource="nmg" >
      select    BlogEntries.ben_benid
      from    BlogEntries
      where    BlogEntries.ben_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      and      BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      <cfif (arguments.IsAvailable is 1)>
        <cfif (not isUserInRole("admin"))>
                    and      posted < <cfqueryparam cfsqltype="timestamp" value="#now()#">
                    and      ben_released = 1
        </cfif>
      </cfif>
    </cfquery>

    <cfset variables.existsCache[arguments.id] = getit.recordCount gte 1>
    <cfreturn variables.existsCache[arguments.id]>

  </cffunction>


  <cffunction name="generateRSS" access="remote" returnType="string" output="false"
        hint="Attempts to generate RSS v1 or v2">
    <cfargument name="mode" type="string" required="false" default="short" hint="If mode=short, show EXCERPT chars of entries. Otherwise, show all.">
    <cfargument name="excerpt" type="numeric" required="false" default="250" hint="If mode=short, this how many chars to show.">
    <cfargument name="params" type="struct" required="false" default="#structNew()#" hint="Passed to getEntries. Note, maxEntries can't be bigger than 15.">
    <cfargument name="version" type="numeric" required="false" default="2" hint="RSS verison, Options are 1 or 2">
    <cfargument name="additionalTitle" type="string" required="false" default="" hint="Adds a title to the end of your blog title. Used mainly by the cat view.">

    <cfset var articles = "">
    <cfset var z = getTimeZoneInfo()>
    <cfset var header = "">
    <cfset var channel = "">
    <cfset var items = "">
    <cfset var dateStr = "">
    <cfset var rssStr = "">
    <cfset var utcPrefix = "">
    <cfset var rootURL = "">
    <cfset var cat = "">
    <cfset var lastid = "">
    <cfset var catid = "">
    <cfset var catlist = "">

    <!--- Right now, we force this in. Useful to limit throughput of RSS feed. I may remove this later. --->
    <cfif (structKeyExists(arguments.params,"maxEntries") and arguments.params.maxEntries gt 15) or not structKeyExists(arguments.params,"maxEntries")>
      <cfset arguments.params.maxEntries = 15>
    </cfif>

    <cfset articles = getEntries(arguments.params)>
    <!--- copy over just the actual query --->
    <cfset articles = articles.entries>

    <cfif not find("-", z.utcHourOffset)>
      <cfset utcPrefix = " -">
    <cfelse>
      <cfset z.utcHourOffset = right(z.utcHourOffset, len(z.utcHourOffset) -1 )>
      <cfset utcPrefix = " +">
    </cfif>


    <cfif arguments.version is 1>

      <cfsavecontent variable="header">
      <cfoutput>
      <?xml version="1.0" encoding="utf-8"?>

      <rdf:RDF
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns="http://purl.org/rss/1.0/"
      >
      </cfoutput>
      </cfsavecontent>

      <cfsavecontent variable="channel">
      <cfoutput>
      <channel rdf:about="#xmlFormat(instance.blogURL)#">
      <title>#xmlFormat(instance.blogTitle)##xmlFormat(arguments.additionalTitle)#</title>
      <description>#xmlFormat(instance.blogDescription)#</description>
      <link>#xmlFormat(instance.blogURL)#</link>

      <items>
        <rdf:Seq>
          <cfloop query="articles">
          <rdf:li rdf:resource="#xmlFormat(makeLink(id))#" />
          </cfloop>
        </rdf:Seq>
      </items>

      </channel>
      </cfoutput>
      </cfsavecontent>

      <cfsavecontent variable="items">
      <cfloop query="articles">
      <cfset dateStr = dateFormat(posted,"yyyy-mm-dd")>
      <cfset dateStr = dateStr & "T" & timeFormat(posted,"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & ":00">
      <cfoutput>
        <item rdf:about="#xmlFormat(makeLink(id))#">
      <title>#xmlFormat(title)#</title>
      <description><cfif arguments.mode is "short" and len(REReplaceNoCase(body,"<[^>]*>","","ALL")) gte arguments.excerpt>#xmlFormat(left(REReplaceNoCase(body,"<[^>]*>","","ALL"),arguments.excerpt))#...<cfelse>#xmlFormat(body & ben_morebody)#</cfif></description>
      <link>#xmlFormat(makeLink(id))#</link>
      <dc:date>#dateStr#</dc:date>
      <cfloop item="catid" collection="#categories#">
        <cfset catlist = listAppend(catlist, xmlFormat(categories[currentRow][catid]))>
      </cfloop>
      <dc:subject>#xmlFormat(catlist)#</dc:subject>
      </item>
      </cfoutput>
       </cfloop>
      </cfsavecontent>

      <cfset rssStr = trim(header & channel & items & "</rdf:RDF>")>

    <cfelseif arguments.version eq "2">

      <cfset rootURL = reReplace(instance.blogURL, "(.*)/index.cfm", "\1")>

      <cfsavecontent variable="header">
      <cfoutput>
      <?xml version="1.0" encoding="utf-8"?>

      <rss version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##" xmlns:cc="http://web.resource.org/cc/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:media="http://search.yahoo.com/mrss/">

      <channel>
      <title>#xmlFormat(instance.blogTitle)##xmlFormat(arguments.additionalTitle)#</title>
      <link>#xmlFormat(instance.blogURL)#</link>
      <description>#xmlFormat(instance.blogDescription)#</description>
      <language>#replace(lcase(instance.locale),'_','-','one')#</language>
      <pubDate>#dateFormat(blogNow(),"ddd, dd mmm yyyy") & " " & timeFormat(blogNow(),"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00"#</pubDate>
      <lastBuildDate>{LAST_BUILD_DATE}</lastBuildDate>
      <generator>BlogCFC</generator>
      <docs>http://blogs.law.harvard.edu/tech/rss</docs>
      <!---- JH DotComIt added code to turn e-mails into unitext, removed xmlformat ---->
      <managingEditor>#(variables.utils.EmailAntiSpam(instance.owneremail))#</managingEditor>
      <webMaster>#(variables.utils.EmailAntiSpam(instance.owneremail))#</webMaster>
      <media:copyright>Copyright 2008-#year(now())#, DotComIt LLC</media:copyright>
      <media:thumbnail url="#xmlFormat(instance.itunesImage)#" />
            <media:keywords>#xmlFormat(instance.itunesKeywords)#</media:keywords>
            <media:category scheme="http://www.itunes.com/dtds/podcast-1.0.dtd">Technology/Software How-To</media:category>
            <media:category scheme="http://www.itunes.com/dtds/podcast-1.0.dtd">Technology/Tech News</media:category>
      <itunes:subtitle>#xmlFormat(instance.itunesSubtitle)#</itunes:subtitle>
      <itunes:summary>#xmlFormat(instance.itunesSummary)#</itunes:summary>
      <itunes:category text="Technology" />
      <itunes:category text="Technology">
        <itunes:category text="Software How-To" />
      </itunes:category>
      <itunes:category text="Technology">
        <itunes:category text="Podcasting" />
      </itunes:category>
      <itunes:category text="Technology">
        <itunes:category text="Tech News" />
      </itunes:category>
      <itunes:keywords>#xmlFormat(instance.itunesKeywords)#</itunes:keywords>
      <itunes:author>#xmlFormat(instance.itunesAuthor)#</itunes:author>
      <itunes:owner>
        <itunes:email>#xmlFormat(instance.owneremail)#</itunes:email>
        <itunes:name>#xmlFormat(instance.itunesAuthor)#</itunes:name>
      </itunes:owner>
      <cfif len(instance.itunesImage)>
      <itunes:image href="#xmlFormat(instance.itunesImage)#" />
      <image>
        <url>#xmlFormat(instance.itunesImage)#</url>
        <title>#xmlFormat(instance.blogTitle)#</title>
        <link>#xmlFormat(instance.blogURL)#</link>
      </image>
      </cfif>
      <itunes:explicit>#xmlFormat(instance.itunesExplicit)#</itunes:explicit>
      </cfoutput>
      </cfsavecontent>

      <cfsavecontent variable="items">
      <cfloop query="articles">
      <cfset dateStr = dateFormat(posted,"ddd, dd mmm yyyy") & " " & timeFormat(posted,"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00">
      <cfoutput>
      <item>
        <title>#xmlFormat(title)#</title>
        <link>#xmlFormat(makeLink(id))#</link>
        <description>
        <!--- Regex operation removes HTML code from blog body output --->
        <cfif arguments.mode is "short" and len(REReplaceNoCase(body,"<[^>]*>","","ALL")) gte arguments.excerpt>
        #xmlFormat(left(REReplace(body,"<[^>]*>","","All"),arguments.excerpt))#...
        <cfelse>#xmlFormat(body & ben_morebody)#</cfif>
        </description>
        <cfset lastid = listLast(structKeyList(categories))>
        <cfloop item="catid" collection="#categories#">
        <category>#xmlFormat(categories[currentRow][catid])#</category>
        </cfloop>
        <pubDate>#dateStr#</pubDate>
        <guid>#xmlFormat(makeLink(id))#</guid>
        <!--- JH, DotComIt Adding this back in; no idea why it was commented out --->
                <author>#xmlFormat(instance.owneremail)# (#xmlFormat(instance.itunesAuthor)#)</author>
        <cfif len(ben_enclosure)>
        <ben_enclosure url="#xmlFormat("#rootURL#/ben_enclosures/#getFileFromPath(ben_enclosure)#")#" length="#ben_filesize#" type="#ben_mimetype#"/>
        <cfif ben_mimetype IS "audio/mpeg">
        <itunes:author>#xmlFormat(instance.itunesAuthor)#</itunes:author>
        <itunes:explicit>#xmlFormat(instance.itunesExplicit)#</itunes:explicit>
        <itunes:duration>#xmlFormat(duration)#</itunes:duration>
        <itunes:keywords>#xmlFormat(keywords)#</itunes:keywords>
        <itunes:subtitle>#xmlFormat(subtitle)#</itunes:subtitle>
        <itunes:summary>#xmlFormat(summary)#</itunes:summary>
        <itunes:image href="#xmlFormat(instance.itunesImage)#" />
        </cfif>
        </cfif>
      </item>
      </cfoutput>
       </cfloop>
      </cfsavecontent>

      <cfset header = replace(header,'{LAST_BUILD_DATE}','#dateFormat(articles.posted[1],"ddd, dd mmm yyyy") & " " & timeFormat(articles.posted[1],"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00"#','one')>
      <cfset rssStr = trim(header & items & "</channel></rss>")>

    </cfif>

    <cfreturn rssStr>

  </cffunction>

  <cffunction name="getActiveDays" returnType="string" output="false" hint="Returns a list of days with Entries.">
    <cfargument name="year" type="numeric" required="true">
    <cfargument name="month" type="numeric" required="true">

    <cfset var dtMonth = createDateTime(arguments.year,arguments.month,1,0,0,0)>
    <cfset var dtEndOfMonth = createDateTime(arguments.year,arguments.month,daysInMonth(dtMonth),23,59,59)>
    <cfset var days = "">
    <cfset var posted = "">

    <cfif instance.blogDBType is "MSSQL">
      <cfset posted = "dateAdd(hh, #instance.offset#, BlogEntries.ben_posted)">
    <cfelseif instance.blogDBType is "MSACCESS">
      <cfset posted = "dateAdd('h', #instance.offset#, BlogEntries.ben_posted)">
    <cfelseif instance.blogDBType is "MYSQL">
      <cfset posted = "date_add(posted, interval #instance.offset# hour)">
    <cfelseif instance.blogDBType is "ORACLE">
      <cfset posted = "BlogEntries.ben_posted + (#instance.offset#/24)">
    </cfif>

    <cfquery datasource="nmg" name="days" >
      select distinct
        <cfif instance.blogDBType is "MSSQL">
          datepart(dd, #preserveSingleQuotes(posted)#)
        <cfelseif instance.blogDBType is "MYSQL">
          extract(day from #preserveSingleQuotes(posted)#)
        <cfelseif instance.blogDBType is "MSACCESS">
          datepart('d', #preserveSingleQuotes(posted)#)
        <cfelseif instance.blogDBType is "ORACLE">
          to_char(#preserveSingleQuotes(posted)#, 'dd')
        </cfif> as posted_day
      from BlogEntries
      where
        #preserveSingleQuotes(posted)# >= <cfqueryparam value="#dtMonth#" cfsqltype="TIMESTAMP">
        and
        #preserveSingleQuotes(posted)# <= <cfqueryparam value="#dtEndOfMonth#" cfsqltype="TIMESTAMP">
        and blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
        and  #preserveSingleQuotes(posted)# < <cfqueryparam cfsqltype="timestamp" value="#blogNow()#">
        and  ben_released = 1
    </cfquery>

    <cfreturn valueList(days.posted_day)>

  </cffunction>

  <cffunction name="getArchives" access="public" returnType="query" output="false" hint="I return a query containing all of the past months/years that have entries along with the entry count">
    <cfargument name="archiveYears" type="numeric" required="false" hint="Number of years back to pull archives for. This helps limit the result set that can be returned" default="0">
    <cfset var getMonthlyArchives = "" />
    <cfset var fromYear = year(now()) - arguments.archiveYears />

    <cfquery name="getMonthlyArchives" datasource="nmg" >
      SELECT MONTH(BlogEntries.ben_posted) AS PreviousMonths,
             YEAR(BlogEntries.ben_posted) AS PreviousYears,
           COUNT(BlogEntries.ben_benid) AS entryCount
      FROM BlogEntries
      WHERE BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      <cfif arguments.archiveYears gt 0>
      AND YEAR(BlogEntries.ben_posted) >= #fromYear#
      </cfif>
      GROUP BY YEAR(BlogEntries.ben_posted), MONTH(BlogEntries.ben_posted)
      ORDER BY PreviousYears DESC, PreviousMonths DESC
    </cfquery>

    <cfreturn getMonthlyArchives>
  </cffunction>

  <cffunction name="getBlogRoles" access="public" returnType="query" output="false">
    <cfset var q = "">

    <cfquery name="q" datasource="nmg" >
    select  bro_broid, bro_role, bro_description
    from  BlogRoles
    </cfquery>

    <cfreturn q>
  </cffunction>

  <cffunction name="getCategories" access="remote" returnType="query" output="false" hint="Returns a query containing all of the categories as well as their count for a specified blog.">
    <cfargument name="usecache" type="boolean" required="false" default="true">
    <cfset var getC = "">
    <cfset var getTotal = "">

    <!---
    Update on May 10, 2006
    So I wanted to update the code to handle cats with 0 entries. This proved difficult.
    My friend Tai sent code that he said would work on both mssql and mysql,
    but it only worked on mssql for me.

    So for now I'm going to use the "nice" method for mssql, and the "hack" method
    for the others. The hack method will be slower, but it should not be terrible.
    --->

    <!--- get cats is expensive when not mssql, and really, it doesn't change too often, so I'm adding a cache --->

    <cfif structKeyExists(variables, "categoryCache") and arguments.usecache>
      <cfreturn variables.categoryCache>
    </cfif>

    <cfif instance.blogDBType is "mssql">

      <cfquery name="getC" datasource="nmg" >
        select  BlogCategories.bca_bcaid, BlogCategories.bca_category, BlogCategories.bca_alias, count(BlogEntriesCategories.bec_benid) as entryCount
        from  (BlogCategories
        left outer join
        BlogEntriesCategories ON BlogCategories.bca_bcaid = BlogEntriesCategories.bec_bcaid)
        left join BlogEntries on BlogEntriesCategories.bec_benid = BlogEntries.ben_benid
        where  BlogCategories.bca_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
        <!--- Don't allow future posts unless logged in. --->
        <cfif not isUserInRole("admin")>
            and isNull(BlogEntries.ben_posted, '1/1/1900') < <cfqueryparam cfsqltype="timestamp" value="#blogNow()#">
             and isNull(BlogEntries.ben_released, 1) = 1
        </cfif>
        group by BlogCategories.bca_bcaid, BlogCategories.bca_category, BlogCategories.bca_alias
        order by BlogCategories.bca_category
      </cfquery>

    <cfelse>

      <cfquery name="getC" datasource="nmg" >
      select  BlogCategories.bca_bcaid, BlogCategories.bca_category,
          BlogCategories.bca_alias
      from  BlogCategories
      where  BlogCategories.bca_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      order by BlogCategories.bca_category
      </cfquery>

      <cfset queryAddColumn(getC, "entrycount", arrayNew(1))>

      <cfloop query="getC">
        <cfquery name="getTotal" datasource="nmg" >
        select  count(BlogEntriesCategories.bec_benid) as total
        from  BlogEntriesCategories, BlogEntries
        where  BlogEntriesCategories.bec_bcaid = <cfqueryparam value="#bca_bcaid#" cfsqltype="VARCHAR" maxlength="35">
        and    BlogEntriesCategories.bec_benid = BlogEntries.ben_benid
        and    BlogEntries.ben_released = 1
        </cfquery>
        <cfif getTotal.recordCount>
          <cfset querySetCell(getC, "entrycount", getTotal.total, currentRow)>
        <cfelse>
          <cfset querySetCell(getC, "entrycount", 0, currentRow)>
        </cfif>
      </cfloop>
    </cfif>

    <cfset variables.categoryCache = getC>
    <cfreturn variables.categoryCache>

  </cffunction>

  <cffunction name="getCategoriesForEntry" access="remote" returnType="query" output="false" hint="Returns a query containing all of the categories for a specific blog entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var getC = "">

    <cfif not entryExists(arguments.id)>
      <cfset variables.utils.throw("#arguments.id# does not exist.")>
    </cfif>

    <!--- updated "variables.dsn" to "instance.dsn" (DS 8/22/06) --->
    <cfquery name="getC" datasource="nmg" >
      select  BlogCategories.bca_bcaid, BlogCategories.bca_category
      from  BlogCategories, BlogEntriesCategories
      where  BlogCategories.bca_bcaid = BlogEntriesCategories.bec_bcaid
      and    BlogEntriesCategories.bec_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>
    <cfreturn getC>

  </cffunction>

  <cffunction name="getCategory" access="remote" returnType="query" output="false" hint="Returns a query containing the category name and alias for a specific blog entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var getC = "">

    <cfquery name="getC" datasource="nmg" >
      select  bca_category, bca_alias
      from  BlogCategories
      where  bca_bcaid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      and    bca_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>

    <cfif not getC.recordCount>
      <cfset variables.utils.throw("#arguments.id# is not a valid category.")>
    </cfif>

    <cfreturn getC>

  </cffunction>

  <cffunction name="getCategoryByAlias" access="remote" returnType="string" output="false" hint="Returns the category name for a specific category alias.">
    <cfargument name="alias" type="string" required="true">
    <cfset var getC = "">

    <cfquery name="getC" datasource="nmg" >
      select  bca_bcaid
      from  BlogCategories
      where  bca_alias = <cfqueryparam value="#arguments.alias#" cfsqltype="VARCHAR" maxlength="50">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>

    <cfreturn getC.bca_bcaid>

  </cffunction>

  <!--- This method originally written for parseses, but is not used. Keeping it around though. --->
  <cffunction name="getCategoryByName" access="remote" returnType="string" output="false" hint="Returns the category id for a specific category name.">
    <cfargument name="name" type="string" required="true">
    <cfset var getC = "">

    <cfquery name="getC" datasource="nmg" >
      select  bca_bcaid
      from  BlogCategories
      where  bca_category = <cfqueryparam value="#arguments.name#" cfsqltype="VARCHAR" maxlength="50">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>

    <cfreturn getC.bca_bcaid>

  </cffunction>

  <cffunction name="getComment" access="remote" returnType="query" output="false"
        hint="Gets a specific comment by comment ID.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var getC = "">

    <cfquery name="getC" datasource="nmg" >
      select    id, fk_benid, name, email, bco_website, comment<cfif instance.blogDBTYPE is "ORACLE">s</cfif>, posted, subscribe, bco_moderated, bco_kill
      from    BlogComments
      where    id = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

    <!--- DS 8/22/06: if this is oracle, do a q of q to return the data with column named "comment" --->
    <cfif instance.blogDBType is "ORACLE">
      <cfquery name="getC" dbtype="query">
        select    id, fk_benid, name, email, bco_website, comments AS comment, posted, subscribe, bco_moderated, bco_kill
        from    getC
      </cfquery>
    </cfif>
    <cfreturn getC>

  </cffunction>

  <!--- RBB 8/23/2010: Added a new method to get comment count for an entry --->
  <cffunction name="getCommentCount" access="remote" returnType="numeric"  output="false"
        hint="Gets the total number of comments for a blog entry">
    <cfargument name="id" type="uuid" required="true">

    <cfquery name="getCommentCount" datasource="nmg" >
      select count(id) as commentCount
      from   BlogComments
      where  fk_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">

      <cfif instance.moderate>
        and bco_moderated = 1
      </cfif>
      and (bco_subscribeonly = 0 or bco_subscribeonly is null)
    </cfquery>

    <cfreturn getCommentCount.commentCount>
  </cffunction>

  <cffunction name="getComments" access="remote" returnType="query" output="false"
        hint="Gets all comments for an entry ID.">
    <cfargument name="id" type="uuid" required="false">
    <cfargument name="sortdir" type="string" required="false" default="asc">
    <cfargument name="includesubscribers" type="boolean" required="false" default="false">
    <cfargument name="search" type="string" required="false">

    <cfset var getC = "">
    <cfset var getO = "">

    <cfif structKeyExists(arguments, "id") and not entryExists(arguments.id)>
      <cfset variables.utils.throw("#arguments.id# does not exist.")>
    </cfif>

    <cfif arguments.sortDir is not "asc" and arguments.sortDir is not "desc">
      <cfset arguments.sortDir = "asc">
    </cfif>

    <!--- RBB 11/02/2005: Added bco_website to query --->
    <cfquery name="getC" datasource="nmg" >
      select    BlogComments.bco_bcoid, BlogComments.bco_name, BlogComments.bco_email, BlogComments.bco_website,
            <cfif instance.blogDBTYPE is NOT "ORACLE">BlogComments.comment<cfelse>to_char(BlogComments.comments) as comments</cfif>,   BlogComments.bco_posted, BlogComments.subscribe, BlogEntries.ben_title as entrytitle, BlogComments.bco_benid
      from    BlogComments, BlogEntries
      where    BlogComments.bco_benid = BlogEntries.ben_benid
      <cfif structKeyExists(arguments, "search")>
      and
            (
            <cfif instance.blogDBTYpe is not "ORACLE">
            BlogComments.comment
            <cfelse>
            comments
            </cfif> like <cfqueryparam cfsqltype="varchar" value="%#arguments.search#%">
            or
            BlogComments.bco_name like <cfqueryparam cfsqltype="varchar" value="%#arguments.search#%">
            )
      </cfif>
      <cfif structKeyExists(arguments, "id")>
      and      BlogComments.bco_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      </cfif>
      and      BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      <!--- added 12/5/2006 by Trent Richardson --->
      <cfif instance.moderate>
        and BlogComments.bco_moderated = 1
      </cfif>
      <cfif not arguments.includesubscribers>
      and (bco_subscribeonly = 0 or bco_subscribeonly is null)
      </cfif>
      order by    BlogComments.bco_posted #arguments.sortdir#
    </cfquery>

    <!--- DS 8/22/06: if this is oracle, do a q of q to return the data with column named "comment" --->
    <cfif instance.blogDBType is "ORACLE">
      <cfquery name="getO" dbtype="query">
      select    id, name, email, bco_website,
            comments AS comment, posted, subscribe, entrytitle, fk_benid
      from    getC
      order by  posted #arguments.sortdir#
      </cfquery>

      <cfreturn getO>
    </cfif>

    <cfreturn getC>

  </cffunction>

  <!--- Deprecated --->
  <cffunction name="getEntry" access="remote" returnType="struct" output="false"
        hint="Returns one particular entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfargument name="dontlog" type="boolean" required="false" default="false">
    <cfargument name="IsAvailable" type="boolean" required="false" default="true">

    <cfset var getIt = "">
    <cfset var s = structNew()>
    <cfset var col = "">
    <cfset var getCategories = "">

    <cfif not entryExists(arguments.id,arguments.IsAvailable)>
      <cfset variables.utils.throw("#arguments.id# does not exist.")>
    </cfif>

    <cfquery name="getIt" datasource="nmg" >
      select    BlogEntries.ben_benid, BlogEntries.ben_title,
            <!--- Handle offset --->
            <cfif instance.blogDBType is "MSACCESS">
            dateAdd('h', #instance.offset#, BlogEntries.ben_posted) as posted,
            <cfelseif instance.blogDBType is "MSSQL">
            dateAdd(hh, #instance.offset#, BlogEntries.ben_posted) as posted,
            <cfelseif instance.blogDBType is "ORACLE">
            BlogEntries.ben_posted + (#instance.offset#/24) as posted,
            <cfelse>
            date_add(posted, interval #instance.offset# hour) as posted,
            </cfif>
            BlogEntries.ben_body,
            BlogEntries.ben_morebody, BlogEntries.ben_alias, BlogUsers.bus_name, BlogEntries.ben_allowcomments,
            BlogEntries.ben_enclosure, BlogEntries.ben_filesize, BlogEntries.ben_mimetype, BlogEntries.ben_released, BlogEntries.ben_mailed,
            BlogEntries.ben_summary, BlogEntries.ben_keywords, BlogEntries.ben_subtitle, BlogEntries.ben_duration
      from    BlogEntries, BlogUsers
      where    BlogEntries.ben_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      and      BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      and      BlogEntries.ben_username = BlogUsers.bus_username
    </cfquery>

    <cfquery name="getCategories" datasource="nmg" >
      select  bca_bcaid,bca_category
      from  BlogCategories, BlogEntriesCategories
      where  BlogEntriesCategories.bec_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      and    BlogEntriesCategories.bec_bcaid = BlogCategories.bca_bcaid
    </cfquery>

    <cfloop index="col" list="#getIt.columnList#">
      <cfset s[col] = getIt[col][1]>
    </cfloop>

    <cfset s.categories = structNew()>
    <cfloop query="getCategories">
      <cfset s.categories[bca_bcaid] = bca_category>
    </cfloop>

    <!--- Handle view --->
    <cfif not arguments.dontlog>
      <cfquery datasource="nmg" >
      update  BlogEntries
      set    views = views + 1
      where  id = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      </cfquery>
    </cfif>

    <cfreturn s>

  </cffunction>

  <cffunction name="getEntries" access="remote" returnType="struct" output="false"
        hint="Returns entries. Allows for a params structure to configure what entries are returned.">
    <cfargument name="params" type="struct" required="false" default="#structNew()#">
    <cfset var getEm = "">
    <cfset var getComments = "">
    <cfset var getCategories = "">
    <cfset var getTrackbacks = "">
    <cfset var validOrderBy = "posted,title,views">
    <cfset var validOrderByDir = "asc,desc">
    <cfset var validMode = "short,full">
    <cfset var pos = "">
    <cfset var id = "">
    <cfset var catdata = "">
    <cfset var getIds = "">
    <cfset var idList = "">
    <cfset var pageIdList = "">
    <cfset var x = "">
    <cfset var r = structNew()>

    <!--- By default, order the results by posted col --->
    <cfif not structKeyExists(arguments.params,"orderBy") or not listFindNoCase(validOrderBy,arguments.params.orderBy)>
      <cfset arguments.params.orderBy = "posted">
    </cfif>
    <!--- By default, order the results direction desc --->
    <cfif not structKeyExists(arguments.params,"orderByDir") or not listFindNoCase(validOrderByDir,arguments.params.orderByDir)>
      <cfset arguments.params.orderByDir = "desc">
    </cfif>
    <!--- If lastXDays is passed, verify X is int between 1 and 365 --->
    <cfif structKeyExists(arguments.params,"lastXDays")>
      <cfif not val(arguments.params.lastXDays) or val(arguments.params.lastXDays) lt 1 or val(arguments.params.lastXDays) gt 365>
        <cfset structDelete(arguments.params,"lastXDays")>
      <cfelse>
        <cfset arguments.params.lastXDays = val(arguments.params.lastXDays)>
      </cfif>
    </cfif>
    <!--- If byDay is passed, verify X is int between 1 and 31 --->
    <cfif structKeyExists(arguments.params,"byDay")>
      <cfif not val(arguments.params.byDay) or val(arguments.params.byDay) lt 1 or val(arguments.params.byDay) gt 31>
        <cfset structDelete(arguments.params,"byDay")>
      <cfelse>
        <cfset arguments.params.byDay = val(arguments.params.byDay)>
      </cfif>
    </cfif>
    <!--- If byMonth is passed, verify X is int between 1 and 12 --->
    <cfif structKeyExists(arguments.params,"byMonth")>
      <cfif not val(arguments.params.byMonth) or val(arguments.params.byMonth) lt 1 or val(arguments.params.byMonth) gt 12>
        <cfset structDelete(arguments.params,"byMonth")>
      <cfelse>
        <cfset arguments.params.byMonth = val(arguments.params.byMonth)>
      </cfif>
    </cfif>
    <!--- If byYear is passed, verify X is int  --->
    <cfif structKeyExists(arguments.params,"byYear")>
      <cfif not val(arguments.params.byYear)>
        <cfset structDelete(arguments.params,"byYear")>
      <cfelse>
        <cfset arguments.params.byYear = val(arguments.params.byYear)>
      </cfif>
    </cfif>
    <!--- If byTitle is passed, verify we have a length  --->
    <cfif structKeyExists(arguments.params,"byTitle")>
      <cfif not len(trim(arguments.params.byTitle))>
        <cfset structDelete(arguments.params,"byTitle")>
      <cfelse>
        <cfset arguments.params.byTitle = trim(arguments.params.byTitle)>
      </cfif>
    </cfif>

    <!--- By default, get body, commentCount and categories as well, requires additional lookup --->
    <cfif not structKeyExists(arguments.params,"mode") or not listFindNoCase(validMode,arguments.params.mode)>
      <cfset arguments.params.mode = "full">
    </cfif>
    <!--- handle searching --->
    <cfif structKeyExists(arguments.params,"searchTerms") and not len(trim(arguments.params.searchTerms))>
      <cfset structDelete(arguments.params,"searchTerms")>
    </cfif>
    <!--- Limit number returned. Thanks to Rob Brooks-Bilson --->
    <cfif not structKeyExists(arguments.params,"maxEntries") or (structKeyExists(arguments.params,"maxEntries") and not val(arguments.params.maxEntries))>
      <cfset arguments.params.maxEntries = 10>
    </cfif>

    <cfif not structKeyExists(arguments.params,"startRow") or (structKeyExists(arguments.params,"startRow") and not val(arguments.params.startRow))>
      <cfset arguments.params.startRow = 1>
    </cfif>

    <!--- I get JUST the ids --->
    <cfquery name="getIds" datasource="nmg" >
    select  BlogEntries.ben_benid
    from  BlogEntries, BlogUsers
      <cfif structKeyExists(arguments.params,"byCat")>,BlogEntriesCategories</cfif>
      where    1=1
            and BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
            and BlogEntries.ben_username = BlogUsers.bus_username
            <!--- fix suggested by William Steiner --->
            and  BlogEntries.ben_blog = BlogUsers.bus_blog
      <cfif structKeyExists(arguments.params,"lastXDays")>
        and BlogEntries.ben_posted >= <cfqueryparam value="#dateAdd("d",-1*arguments.params.lastXDays,blogNow())#" cfsqltype="DATE">
      </cfif>
      <cfif structKeyExists(arguments.params,"byDay")>
          and dayOfMonth(date_add(posted, interval #instance.offset# hour)) = <cfqueryparam value="#arguments.params.byDay#" cfsqltype="NUMERIC">
      </cfif>
      <cfif structKeyExists(arguments.params,"byMonth")>
          and month(date_add(posted, interval #instance.offset# hour)) = <cfqueryparam value="#arguments.params.byMonth#" cfsqltype="NUMERIC">
      </cfif>
      <cfif structKeyExists(arguments.params,"byYear")>
          and year(date_add(posted, interval #instance.offset# hour)) = <cfqueryparam value="#arguments.params.byYear#" cfsqltype="NUMERIC">
      </cfif>
      <cfif structKeyExists(arguments.params,"byTitle")>
        and BlogEntries.ben_title = <cfqueryparam value="#arguments.params.byTitle#" cfsqltype="VARCHAR" maxlength="100">
      </cfif>
      <cfif structKeyExists(arguments.params,"byCat")>
        and BlogEntriesCategories.bec_benid = BlogEntries.ben_benid
        and BlogEntriesCategories.bec_bcaid in (<cfqueryparam value="#arguments.params.byCat#" cfsqltype="VARCHAR" maxlength="35" list=true>)
      </cfif>
      <cfif structKeyExists(arguments.params,"byPosted")>
        and BlogEntries.ben_username =  <cfqueryparam value="#arguments.params.byPosted#" cfsqltype="VARCHAR" maxlength="50" list=true>
      </cfif>
      <cfif structKeyExists(arguments.params,"searchTerms")>
        <cfif not structKeyExists(arguments.params, "dontlogsearch")>
          <cfset logSearch(arguments.params.searchTerms)>
        </cfif>
          and (BlogEntries.ben_title like '%#arguments.params.searchTerms#%' OR BlogEntries.ben_body like '%#arguments.params.searchTerms#%' or BlogEntries.ben_morebody like '%#arguments.params.searchTerms#%')
      </cfif>
      <cfif structKeyExists(arguments.params,"byEntry")>
        and BlogEntries.ben_benid = <cfqueryparam value="#arguments.params.byEntry#" cfsqltype="VARCHAR" maxlength="35">
      </cfif>
      <cfif structKeyExists(arguments.params,"byAlias")>
        and BlogEntries.ben_alias = <cfqueryparam value="#arguments.params.byAlias#" cfsqltype="VARCHAR" maxlength="100">
      </cfif>
      <!--- Don't allow future posts unless logged in. --->
      <cfif not isUserInRole("admin") or (structKeyExists(arguments.params, "ben_releasedonly") and arguments.params.ben_releasedonly)>
          and      posted < <cfqueryparam cfsqltype="timestamp" value="#now()#">
        and      ben_released = 1
      </cfif>
      <cfif structKeyExists(arguments.params, "ben_released")>
        and  ben_released = <cfqueryparam cfsqltype="bit" value="#arguments.params.ben_released#">
      </cfif>

      order by   BlogEntries.#arguments.params.orderBy# #arguments.params.orderByDir#
    </cfquery>

    <!--- we now have a query from row 1 to our max, we need to get a 'page' of IDs --->
    <cfset idList = valueList(getIds.id)>
    <cfif idList eq "">
      <!---// the we need the "title" column for the spryproxy.cfm //--->
      <cfset r.entries = queryNew("id, title, posted")>
      <cfset r.totalEntries = 0>
      <cfreturn r>
    </cfif>

    <cfloop index="x" from="#arguments.params.startRow#" to="#min(arguments.params.startRow+arguments.params.maxEntries-1,getIds.recordCount)#">
      <cfset pageIdList = listAppend(pageIdList, listGetAt(idlist,x))>
    </cfloop>

    <!--- I now get the full info --->
    <cfquery name="getEm" datasource="nmg"  maxrows="#arguments.params.maxEntries+arguments.params.startRow-1#">
    <!--- DS 8/22/06: added Oracle pseudo top n code --->
      select
          BlogEntries.ben_benid, BlogEntries.ben_title,
          BlogEntries.ben_alias,
          <!--- Handle offset --->
          <cfif instance.blogDBType is "MSACCESS">
            dateAdd('h', #instance.offset#, BlogEntries.ben_posted) as posted,
          <cfelseif instance.blogDBType is "MSSQL">
            dateAdd(hh, #instance.offset#, BlogEntries.ben_posted) as posted,
          <cfelseif instance.blogDBType is "ORACLE">
            BlogEntries.ben_posted + (#instance.offset#/24) as posted,
          <cfelse>
          date_add(posted, interval #instance.offset# hour) as posted,
          </cfif>
          BlogUsers.bus_name, BlogEntries.ben_allowcomments,
          BlogEntries.ben_enclosure, BlogEntries.ben_filesize, BlogEntries.ben_mimetype, BlogEntries.ben_released, BlogEntries.ben_views,
          BlogEntries.ben_summary, BlogEntries.ben_subtitle, BlogEntries.ben_keywords, BlogEntries.ben_duration
        <cfif arguments.params.mode is "full">, BlogEntries.ben_body, BlogEntries.ben_morebody</cfif>
      from  BlogEntries, BlogUsers
      where
        BlogEntries.ben_benid in (<cfqueryparam cfsqltype="varchar" list="true" value="#pageIdList#">)
            and BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
            and BlogEntries.ben_username = BlogUsers.bus_username
      order by   BlogEntries.#arguments.params.orderBy# #arguments.params.orderByDir#
    </cfquery>

    <cfif arguments.params.mode is "full" and getEm.recordCount>
      <cfset queryAddColumn(getEm,"commentCount",arrayNew(1))>
      <cfquery name="getComments" datasource="nmg" >
        select count(id) as commentCount, fk_benid
        from   BlogComments
        where  fk_benid in (<cfqueryparam value="#valueList(getEm.id)#" cfsqltype="VARCHAR" list="Yes">)
        <!--- added 12/5/2006 by Trent Richardson --->
        <cfif instance.moderate>
          and bco_moderated = 1
        </cfif>
        and (bco_subscribeonly = 0 or bco_subscribeonly is null)
        group by fk_benid
      </cfquery>
      <cfif getComments.recordCount>
        <!--- for each row, need to find in getEm --->
        <cfloop query="getComments">
          <cfset pos = listFindNoCase(valueList(getEm.id),fk_benid)>
          <cfif pos>
            <cfset querySetCell(getEm,"commentCount",commentCount,pos)>
          </cfif>
        </cfloop>
      </cfif>
      <cfset queryAddColumn(getEm,"categories",arrayNew(1))>
      <cfloop query="getEm">
        <cfquery name="getCategories" datasource="nmg" >
          select  bca_bcaid,bca_category
          from  BlogCategories, BlogEntriesCategories
          where  BlogEntriesCategories.bec_benid = <cfqueryparam value="#getEm.id#" cfsqltype="VARCHAR" maxlength="35">
          and    BlogEntriesCategories.bec_bcaid = BlogCategories.bca_bcaid
        </cfquery>

        <cfset catData = structNew()>
        <cfloop query="getCategories">
          <cfset catData[bca_bcaid] = bca_category>
        </cfloop>
        <cfset querySetCell(getEm,"categories",catData,currentRow)>
      </cfloop>

    </cfif>
    <cfset r.entries = getEm>
    <cfset r.totalEntries = getIds.recordCount>

    <cfreturn r>

  </cffunction>

  <!--- RBB 8/24/2010: New method to get the date an entry was posted. Added as
      a method since it's used by several other methods --->
  <cffunction name="getEntryPostedDate" access="public" returnType="date" output="false"
        hint="Returns the date/time an entry was posted">
    <cfargument name="entryId" type="uuid" required="true" hint="UUID of the entry you want to get post date for.">

    <cfset var getPostedDate = "" />

      <cfquery name="getPostedDate" datasource="nmg" >
          select posted
          from BlogEntries
          where id = <cfqueryparam value="#arguments.entryId#" cfsqltype="VARCHAR" maxlength="35" />
      </cfquery>

    <cfreturn getPostedDate.posted>
  </cffunction>

  <cffunction name="getNameForUser" access="public" returnType="string" output="false"
        hint="Returns the full name of a user.">
    <cfargument name="username" type="string" required="true" />
    <cfset var q = "" />

    <cfquery name="q" datasource="nmg" >
    select  bus_name
    from  BlogUsers
    where  bus_username = <cfqueryparam cfsqltype="varchar" value="#arguments.username#" maxlength="50">
    </cfquery>

    <cfreturn q.bus_name>
  </cffunction>

  <cffunction name="getNumberUnbco_moderated" access="public" returntype="numeric" output="false"
        hint="Returns the number of unmodderated comments for a specific blog entry.">
    <cfset var getUnbco_moderated = "" />
    <cfquery name="getUnbco_moderated" datasource="nmg" >
      select count(c.bco_moderated) as unbco_moderated
      from BlogComments c, BlogEntries e
      where c.bco_moderated=0
      and   e.blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      and c.fk_benid = e.id
    </cfquery>

    <cfreturn getUnbco_moderated.unbco_moderated>
  </cffunction>

  <cffunction name="getProperties" access="public" returnType="struct" output="false">
    <cfreturn duplicate(instance)>
  </cffunction>

  <cffunction name="getProperty" access="public" returnType="any" output="false">
    <cfargument name="property" type="string" required="true">

    <cfif not structKeyExists(instance,arguments.property)>
      <cfset variables.utils.throw("#arguments.property# is not a valid property.")>
    </cfif>

    <cfreturn instance[arguments.property]>

  </cffunction>

  <cffunction name="getRecentComments" access="remote" returnType="query" output="false"
                hint="Returns the last N comments for a specific blog.">
        <cfargument name="maxEntries" type="numeric" required="false" default="10">

    <cfset var getRecentComments = "" />
    <cfset var getO = "" />

    <cfquery datasource="nmg" name="getRecentComments" >
    <!--- DS 8/22/06: Added Oracle pseudo "top n" code --->
    <cfif instance.blogDBTYPE is "ORACLE">
    SELECT   * FROM (
    </cfif>

    select <cfif instance.blogDBType is not "MYSQL" AND instance.blogDBType is not "ORACLE">
                    top #arguments.maxEntries#
                </cfif>
    e.id as entryID,
    e.title,
    c.id,
    c.fk_benid,
    c.name,
    c.email, <!--- RBB 8/25/2010: Added email column --->
    <cfif instance.blogDBType is NOT "ORACLE">c.comment<cfelse>to_char(c.comments) as comments</cfif>,
    <!--- Handle offset --->
    <cfif instance.blogDBType is "MSACCESS">
        dateAdd('h', #instance.offset#, c.posted) as posted
    <cfelseif instance.blogDBType is "MSSQL">
        dateAdd(hh, #instance.offset#, c.posted) as posted
    <cfelseif instance.blogDBType is "ORACLE">
      c.posted + (#instance.offset#/24) as posted
    <cfelse>
        date_add(c.posted, interval #instance.offset# hour) as posted
    </cfif>
    from BlogComments c
    inner join BlogEntries e on c.fk_benid = e.id
    where   blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    <!--- added 12/5/2006 by Trent Richardson --->
    <cfif instance.moderate>
      and c.bco_moderated = 1
    </cfif>
    order by c.posted desc
    <cfif instance.blogDBType is "MYSQL">limit #arguments.maxEntries#</cfif>

    <cfif instance.blogDBType is "ORACLE">
    )
    WHERE  rownum <= #arguments.maxEntries#
    </cfif>
    </cfquery>

    <cfif instance.blogDBType is "ORACLE">
      <cfquery name="getO" dbtype="query">
      SELECT   entryID, title, id, fk_benid, name, email, comments AS comment, posted <!--- RBB 8/25/2010: Added email column --->
      FROM  getRecentComments
      ORDER BY posted desc
      </cfquery>

      <cfreturn getO>
    </cfif>


        <cfreturn getRecentComments>

    </cffunction>

  <!--- TODO: Take a look at this, something seems wrong. --->
  <cffunction name="getRelatedBlogEntries" access="remote" returntype="query" output="true"
        hint="returns related entries for a specific blog entry.">
      <cfargument name="entryId" type="uuid" required="true" />
      <cfargument name="bDislayBackwardRelations" type="boolean" hint="Displays related entries that set from another entry" default="true" />
      <cfargument name="bDislayFutureLinks" type="boolean" hint="Displays related entries that occur after the posted date of THIS entry" default="true" />
      <cfargument name="bDisplayForAdmin" type="boolean" hint="If admin, we can show future links not ben_released to public" default="false" />

      <cfset var qEntries = "" />

    <!--- BEGIN : added bca_bcaid to related blog entry query : cjg : 31 december 2005 --->
    <!--- <cfset var qRelatedEntries = queryNew("id,title,posted,alias") />  --->
    <cfset var qRelatedEntries = queryNew("id,title,posted,alias,bca_category") />
    <!--- END : added bca_bcaid to related blog entry query : cjg : 31 december 2005 --->

      <cfset var qThisEntry = "" />
      <cfset var getRelatedIds = "" />
    <cfset var getThisRelatedEntry = "" />
    <!--- RBB 8/23/2010: Refactored to use new method getEntryPostedDate --->
    <cfset var postedDate = "" />

        <cfif bdislayfuturelinks is false>
      <!--- RBB 8/23/2010: Refactored to use new method getEntryPostedDate --->
      <cfset postedDate = application.blog.getEntryPostedDate(entryID=#arguments.entryId#)>
    </cfif>
      <cfquery name="getRelatedIds" datasource="nmg" >
        select distinct bre_relbenid
        from BlogEntriesRelated
        where bre_benid = <cfqueryparam value="#arguments.entryId#" cfsqltype="VARCHAR" maxlength="35" />

        <cfif bDislayBackwardRelations>
        union

        select distinct bre_benid as bre_relbenid
        from BlogEntriesRelated
        where bre_relbenid = <cfqueryparam value="#arguments.entryId#" cfsqltype="VARCHAR" maxlength="35" />
        </cfif>
      </cfquery>
      <cfloop query="getRelatedIds">
      <cfquery name="getThisRelatedEntry" datasource="nmg" >
      select
        BlogEntries.ben_benid,
        BlogEntries.ben_title,
        BlogEntries.ben_posted,
        BlogEntries.ben_alias,
        BlogCategories.bca_category
      from
        (BlogCategories
        inner join BlogEntriesCategories on
          BlogCategories.bca_bcaid = BlogEntriesCategories.bec_bcaid)
        inner join BlogEntries on
          BlogEntriesCategories.bec_benid = BlogEntries.ben_benid
          where BlogEntries.ben_benid = <cfqueryparam value="#getrelatedids.bre_relbenid#" cfsqltype="varchar" maxlength="35" />
          and   BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="255">
          <cfif bdislayfuturelinks is false>
            and BlogEntries.ben_posted <= #createodbcdatetime(postedDate)#
          </cfif>

          <cfif not arguments.bDisplayForAdmin>
            and      ben_posted < <cfqueryparam cfsqltype="timestamp" value="#now()#">
            and      ben_released = 1
          </cfif>
        </cfquery>

        <cfif getThisRelatedEntry.recordCount>
          <cfset queryAddRow(qRelatedEntries, 1) />
          <cfset querySetCell(qRelatedEntries, "ben_benid", getThisRelatedEntry.ben_benid) />
          <cfset querySetCell(qRelatedEntries, "ben_title", getThisRelatedEntry.ben_title) />
          <cfset querySetCell(qRelatedEntries, "ben_posted", getThisRelatedEntry.ben_posted) />
          <cfset querySetCell(qRelatedEntries, "ben_alias", getThisRelatedEntry.ben_alias) />
          <cfset querySetCell(qRelatedEntries, "bca_category", getThisRelatedEntry.bca_category) />
        </cfif>
      </cfloop>
      <cfif qRelatedEntries.recordCount>
        <!--- Order By --->
        <cfquery name="qRelatedEntries" dbtype="query">
          select *
          from qrelatedentries
          order by ben_posted desc
        </cfquery>
      </cfif>

    <cfreturn qRelatedEntries />
  </cffunction>
  <!--- END : get related entries method : cjg  --->

  <!--- RBB 8/23/2010: Added a new method to get related blog entry count for a given entry --->
  <cffunction name="getRelatedBlogEntryCount" access="remote" returnType="numeric"  output="false"
        hint="Gets the total number of related blog entriess for for a specific blog entry">
    <cfargument name="entryId" type="uuid" required="true" hint="UUID of the entry you want to get the count for.">
      <cfargument name="bDislayBackwardRelations" type="boolean" hint="Display related entries that set from another entry" default="true" />
    <cfargument name="bDislayFutureLinks" type="boolean" hint="Display related entries that occur after the posted date of THIS entry. If true, this will return the count for items that have a future publishing date." default="true" />
    <cfargument name="bDisplayForAdmin" type="boolean" hint="If admin, we can show future links not ben_released to public" default="false" />

    <cfset var postedDate = "" />
    <cfset var getRelatedBlogEntryCount = "" />

    <cfif arguments.bDislayFutureLinks is false>
      <cfset postedDate = application.blog.getEntryPostedDate(entryID=#arguments.entryId#)>
    </cfif>

    <cfquery name="getRelatedBlogEntryCount" datasource="nmg" >
      SELECT count(entryId) AS relatedEntryCount
        FROM BlogEntriesRelated, BlogEntries
        WHERE BlogEntriesRelated.entryID = BlogEntries.ben_benid
        AND (BlogEntriesRelated.entryid = <cfqueryparam value="#arguments.entryId#" cfsqltype="VARCHAR" maxlength="35">
      <cfif arguments.bDislayBackwardRelations>
        OR BlogEntriesRelated.bre_relbenid = <cfqueryparam value="#arguments.entryId#" cfsqltype="VARCHAR" maxlength="35" />
      </cfif>
        )
          <cfif bdislayfuturelinks is false>
        <cfif instance.blogDBType is not "ORACLE">
        AND BlogEntries.ben_posted <= #createodbcdatetime(postedDate)#
        <cfelse>
        AND BlogEntries.ben_posted <= <cfqueryparam cfsqltype="timestamp" value="#postedDate#">
        </cfif>
          </cfif>

      <cfif arguments.bDisplayForAdmin is false>
        <cfif instance.blogDBType IS "ORACLE">
           AND  to_char(.posted + (#instance.offset#/24), 'YYYY-MM-DD HH24:MI:SS') <= <cfqueryparam cfsqltype="varchar" value="#dateformat(now(), 'YYYY-MM-DD')# #timeformat(now(), 'HH:mm:ss')#">
        <cfelse>
          AND  BlogEntries.ben_posted < <cfqueryparam cfsqltype="timestamp" value="#now()#">
        </cfif>
      </cfif>
        AND  BlogEntries.ben_released = 1
    </cfquery>

    <cfreturn getRelatedBlogEntryCount.relatedEntryCount>
  </cffunction>

  <cffunction name="getRelatedEntriesSelects" access="remote" returntype="query" output="false"
        hint="Returns a query containing all entries - designed to be used in the admin for
        selecting related entries.">
    <cfset var getRelatedP = "" />

    <cfquery name="getRelatedP" datasource="nmg" >
      select
        BlogCategories.bca_category,
        BlogEntries.ben_benid,
        BlogEntries.ben_title,
        BlogEntries.ben_posted
      from
        BlogEntries inner join
          (BlogCategories inner join BlogEntriesCategories on BlogCategories.bca_bcaid = BlogEntriesCategories.bec_bcaid) on
            BlogEntries.ben_benid = BlogEntriesCategories.bec_benid

      where BlogCategories.bca_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      order by
        BlogCategories.bca_category,
        BlogEntries.ben_posted,
        BlogEntries.ben_title
    </cfquery>

    <cfreturn getRelatedP />
  </cffunction>

  <cffunction name="getRootURL" access="public" returnType="string" output="false"
        hint="Simple helper function to get root url.">

    <cfset var theURL = replace(instance.blogurl, "index.cfm", "")>
    <cfreturn theURL>

  </cffunction>

  <cffunction name="getSubscribers" access="public" returnType="query" output="false"
        hint="Returns all people subscribed to the blog.">
    <cfargument name="bsu_verifiedonly" type="boolean" required="false" default="false">
    <cfset var getPeople = "">

    <cfquery name="getPeople" datasource="nmg" >
    select    bsu_email, bsu_token, bsu_verified
    from    BlogSubscribers
    where    bsu_blog = <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">
    <cfif    arguments.bsu_verifiedonly>
    and      bsu_verified = 1
    </cfif>
    order by  bsu_email asc
    </cfquery>

    <cfreturn getPeople>
  </cffunction>

  <cffunction name="getUnbco_moderatedComments" access="remote" returnType="query" output="false"
        hint="Gets unbco_moderated comments for an entry.">
    <cfargument name="id" type="uuid" required="false">
    <cfargument name="sortdir" type="string" required="false" default="asc">

    <cfset var getC = "">
    <cfset var getO = "">

    <cfif structKeyExists(arguments, "id") and not entryExists(arguments.id)>
      <cfset variables.utils.throw("#arguments.id# does not exist.")>
    </cfif>

    <cfif arguments.sortDir is not "asc" and arguments.sortDir is not "desc">
      <cfset arguments.sortDir = "asc">
    </cfif>

    <!--- RBB 11/02/2005: Added bco_website to query --->
    <cfquery name="getC" datasource="nmg" >
      select    BlogComments.bco_bcoid, BlogComments.bco_name, BlogComments.bco_email, BlogComments.bco_website,
            <cfif instance.blogDBTYPE is NOT "ORACLE">BlogComments.comment<cfelse>to_char(BlogComments.comments) as comments</cfif>,   BlogComments.bco_posted, BlogComments.subscribe, BlogEntries.ben_title as entrytitle, BlogComments.bco_benid
      from    BlogComments, BlogEntries
      where    BlogComments.bco_benid = BlogEntries.ben_benid
      <cfif structKeyExists(arguments, "id")>
      and      BlogComments.bco_benid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      </cfif>
      and      BlogEntries.ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
      <!--- added 12/5/2006 by Trent Richardson --->
      and BlogComments.bco_moderated = 0

      order by    BlogComments.bco_posted #arguments.sortdir#
    </cfquery>

    <!--- DS 8/22/06: if this is oracle, do a q of q to return the data with column named "comment" --->
    <cfif instance.blogDBType is "ORACLE">
      <cfquery name="getO" dbtype="query">
      select    id, name, email, bco_website,
            comments AS comment, posted, subscribe, entrytitle, fk_benid
      from    getC
      order by  posted #arguments.sortdir#
      </cfquery>

      <cfreturn getO>
    </cfif>

    <cfreturn getC>

  </cffunction>

  <cffunction name="getUser" access="public" returnType="struct" output="false" hint="Returns a user for a blog.">
    <cfargument name="username" type="string" required="true">
    <cfset var q = "">
    <cfset var s = structNew()>

    <cfquery name="q" datasource="nmg" >
    select  bus_username, bus_password, bus_name
    from  BlogUsers
    where  bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    and    bus_username = <cfqueryparam value="#arguments.username#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>
    <cfif q.recordCount>
      <cfset s.bus_username = q.bus_username>
      <cfset s.bus_password = q.bus_password>
      <cfset s.bus_name = q.bus_name>
      <cfreturn s>
    <cfelse>
      <cfthrow message="Unknown user #arguments.username# for blog.">
    </cfif>

  </cffunction>

  <cffunction name="getUserByName" access="public" returnType="string" output="false"
        hint="Get username based on encoded name.">
    <cfargument name="name" type="string" required="true">
    <cfset var q = "">

    <cfquery name="q" datasource="nmg" >
    select  bus_username
    from  BlogUsers
    where  bus_name = <cfqueryparam cfsqltype="varchar" value="#replace(arguments.name,"_"," ","all")#" maxlength="50">
    </cfquery>

    <cfreturn q.username>

  </cffunction>

  <cffunction name="getUserBlogRoles" access="public" returnType="string" output="false"
        hint="Returns a list of the roles for a specific user.">
    <cfargument name="username" type="string" required="true">
    <cfset var q = "">

    <!--- MSACCESS fix provided by Andy Florino --->
    <cfquery name="q" datasource="nmg" >
    <cfif instance.blogDBType is "MSACCESS">
    select BlogRoles.bro_broid
    from BlogRoles, BlogUserRoles, BlogUsers
    where (BlogRoles.bro_broid = BlogUserRoles.bur_broid and BlogUserRoles.bus_username = BlogUsers.bus_username)
    and BlogUsers.bus_username = <cfqueryparam cfsqltype="varchar" value="#arguments.username#" maxlength="50">
    and BlogUsers.bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    <cfelse>
    select  BlogRoles.bro_broid
    from  BlogRoles
    left join BlogUserRoles on BlogUserRoles.bur_broid = BlogRoles.bro_broid
    left join BlogUsers on BlogUserRoles.bus_username = BlogUsers.bus_username
    where BlogUsers.bus_username = <cfqueryparam cfsqltype="varchar" value="#arguments.username#" maxlength="50">
    and BlogUsers.bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    </cfif>
    </cfquery>

    <cfreturn valueList(q.bro_broid)>
  </cffunction>

  <cffunction name="getUsers" access="public" returnType="query" output="false" hint="Returns users for a blog.">
    <cfset var q = "">

    <cfquery name="q" datasource="nmg" >
    select  bus_username, bus_name
    from  BlogUsers
    where  bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>

    <cfreturn q>
  </cffunction>

  <cffunction name="getValidDBTypes" access="public" returnType="string" output="false"
        hint="Returns the valid database types.">
    <cfreturn variables.validDBTypes>
  </cffunction>

  <cffunction name="getVersion" access="remote" returnType="string" output="false"
        hint="Returns the version of the blog.">
    <cfreturn variables.version>
  </cffunction>

  <cffunction name="isBlogAuthorized" access="public" returnType="boolean" output="false"
      hint="Simple wrapper to check session roles and see if you are cool to do stuff. Admin role can do all.">
    <cfargument name="role" type="string" required="true">
    <!--- Roles are IDs, but to make code simpler, we allow you to specify a string, so do a cached lookup conversion. --->
    <cfset var q = "">

    <!--- cache admin once --->
    <cfif not structKeyExists(variables.roles, 'admin')>
      <cfquery name="q" datasource="nmg" >
      select  bro_broid
      from  BlogRoles
      where  role = <cfqueryparam cfsqltype="varchar" value="Admin" maxlength="50">
      </cfquery>
      <cfset variables.roles['admin'] = q.bro_broid>
    </cfif>

    <cfif not structKeyExists(variables.roles, arguments.role)>
      <cfquery name="q" datasource="nmg" >
      select  bro_broid
      from  BlogRoles
      where  role = <cfqueryparam cfsqltype="varchar" value="#arguments.role#" maxlength="50">
      </cfquery>
      <cfset variables.roles[arguments.role] = q.bro_broid>
    </cfif>

    <cfreturn (listFindNoCase(session.roles, variables.roles[arguments.role]) or listFindNoCase(session.roles, variables.roles['admin']))>
  </cffunction>

  <cffunction name="isValidDBType" access="private" returnType="boolean" output="false"
        hint="Checks to see if a db type is valid for the blog.">
    <cfargument name="dbtype" type="string" required="true">

    <cfreturn listFindNoCase(getValidDBTypes(), arguments.dbType) gte 1>

  </cffunction>

  <cffunction name="bco_kill" access="public" returnType="void" output="false"
        hint="Deletes a comment based on a separate uuid to identify the comment in email to the blog admin.">
    <cfargument name="kid" type="uuid" required="true">
    <cfset var q = "">

    <!--- delete comment based on kill --->
    <cfquery name="q" datasource="nmg" >
      delete from BlogComments
      where bco_kill = <cfqueryparam cfsqltype="varchar" value="#arguments.kid#" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="logSearch" access="private" returnType="void" output="false"
        hint="Logs the search.">
    <cfargument name="searchterm" type="string" required="true">

    <cfquery datasource="nmg" >
    insert into BlogSearchStats(bss_term, bss_searched, bss_blog)
    values(
      <cfqueryparam value="#arguments.searchterm#" cfsqltype="varchar" maxlength="255">,
      <cfqueryparam value="#blogNow()#" cfsqltype="timestamp">,
      <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">
    )
    </cfquery>

  </cffunction>

  <cffunction name="logView" access="public" returnType="void" output="false"
        hint="Handles adding a view to an entry.">
    <cfargument name="entryid" type="uuid" required="true">

    <cfquery datasource="nmg" >
    update  BlogEntries
    set    views = views + 1
    where  id = <cfqueryparam value="#arguments.entryid#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="mailEntry" access="public" returnType="void" output="false"
        hint="Handles email for the blog.">
    <cfargument name="entryid" type="uuid" required="true">
    <cfset var entry = getEntry(arguments.entryid,true)>
    <cfset var subscribers = getSubscribers(true)>
    <cfset var theMessage = "">
    <cfset var mailBody = "">
    <cfset var renderedText = renderEntry(entry.body,true,entry.ben_enclosure)>
    <cfset var theLink = makeLink(entry.id)>
    <cfset var rootURL = getRootURL()>

    <cfloop query="subscribers">

      <cfsavecontent variable="theMessage">
      <cfoutput>
<h2>#entry.title#</h2>
<b>URL:</b> <a href="#theLink#">#theLink#</a><br />
<b>Author:</b> #entry.name#<br />

#renderedText#<cfif len(entry.ben_morebody)>
<a href="#theLink#">[Continued at Blog]</a></cfif>

<p>
You are receiving this email because you have subscribed to this blog.<br />
To unsubscribe, please go to this URL:
<a href="#rooturl#unsubscribe.cfm?email=#email#&amp;bsu_token=#bsu_token#">#rooturl#unsubscribe.cfm?email=#email#&amp;bsu_token=#bsu_token#</a>
</p>
      </cfoutput>
      </cfsavecontent>
      <cfset utils.mail(to=email,from=instance.owneremail,subject="#variables.utils.htmlToPlainText(htmlEditFormat(instance.blogtitle))# / #variables.utils.htmlToPlainText(entry.title)#",type="html",body=theMessage, failTo=instance.failTo, mailserver=instance.mailserver, mailusername=instance.mailusername, mailpassword=instance.mailpassword)>
    </cfloop>

    <!---
      update the record to mark it mailed.
      note: it is possible that an entry will never be marked mailed if your blog has
      no subscribers. I don't think this is an issue though.
    --->
    <cfquery datasource="nmg" >
    update BlogEntries
    set    mailed =
        <cfif instance.blogDBType is not "MYSQL">
          <cfqueryparam value="true" cfsqltype="BIT">
         <cfelse>
              <cfqueryparam value="1" cfsqltype="TINYINT">
         </cfif>
    where  id = <cfqueryparam value="#arguments.entryid#" cfsqltype="VARCHAR">
    </cfquery>


  </cffunction>

  <cffunction name="makeCategoryLink" access="public" returnType="string" output="false"
        hint="Generates links for a category.">
    <cfargument name="catid" type="uuid" required="true">
    <cfset var q = "">

    <!---// make sure the cache exists //--->
    <cfif not structKeyExists(variables, "catAliasCache")>
      <cfset variables.catAliasCache = structNew() />
    </cfif>

    <cfif structKeyExists(variables.catAliasCache, arguments.catid)>
      <cfreturn variables.catAliasCache[arguments.catid]>
    </cfif>

    <cfquery name="q" datasource="nmg" >
    select  bca_alias
    from  BlogCategories
    where  bca_bcaid = <cfqueryparam cfsqltype="varchar" value="#arguments.catid#" maxlength="35">
    </cfquery>

    <cfif q.bca_alias is not "">
      <cfset variables.catAliasCache[arguments.catid] = "#instance.blogURL#/#q.bca_alias#">
    <cfelse>
      <cfset variables.catAliasCache[arguments.catid] = "#instance.blogURL#?mode=cat&amp;catid=#arguments.catid#">
    </cfif>
    <cfreturn variables.catAliasCache[arguments.catid]>
  </cffunction>

  <cffunction name="makeUserLink" access="public" returnType="string" output="false"
        hint="Generates links for viewing blog posts by user/blog poster.">
    <cfargument name="name" type="string" required="true">

    <cfreturn "#instance.blogURL#/postedby/#replace(arguments.name," ","_","all")#">

  </cffunction>

  <cffunction name="cacheLink" access="public" returnType="struct" output="false"
        hint="Caches a link.">
    <cfargument name="entryid" type="uuid" required="true" />
    <cfargument name="alias" type="string" required="true" />
    <cfargument name="posted" type="date" required="true" />

    <!---// make sure the cache exists //--->
    <cfif not structKeyExists(variables, "lCache")>
      <cfset variables.lCache = structNew() />
    </cfif>

    <cfset variables.lCache[arguments.entryid] = structNew() />
    <cfset variables.lCache[arguments.entryid].alias = arguments.alias />
    <cfset variables.lCache[arguments.entryid].posted = arguments.posted />

    <cfreturn arguments />
  </cffunction>

  <cffunction name="makeLink" access="public" returnType="string" output="false"
        hint="Generates links for an entry.">
    <cfargument name="entryid" type="uuid" required="true" />
    <cfargument name="updateCache" type="boolean" required="false" default="false" />
    <cfset var q = "">
    <cfset var realdate = "">

    <cfif not structKeyExists(variables, "lCache")>
      <cfset variables.lCache = structNew()>
    </cfif>

    <!---// if forcing the cache to be updated, remove the key //--->
    <cfif arguments.updateCache>
      <cfset structDelete(variables.lCache, arguments.entryid, true) />
    </cfif>

    <cfif not structKeyExists(variables.lCache, arguments.entryid)>
      <cflock name="variablesLCache_#instance.name#" timeout="30" type="exclusive">
        <cfif not structKeyExists(variables.lCache, arguments.entryid)>
          <cfquery name="q" datasource="nmg" >
          select  posted, alias
          from  BlogEntries
          where  id = <cfqueryparam cfsqltype="varchar" value="#arguments.entryid#" maxlength="35">
          </cfquery>
          <!---// cache the link //--->
          <cfset realdate = dateAdd("h", instance.offset, q.posted)>
          <cfset cacheLink(entryid=arguments.entryid, alias=q.alias, posted=realdate) />
        <cfelse>
          <cfset q = structNew()>
          <cfset q.alias = variables.lCache[arguments.entryid].alias>
          <cfset q.posted = variables.lCache[arguments.entryid].posted>
        </cfif>
        </cflock>
    <cfelse>
      <cfset q = structNew()>
      <cfset q.alias = variables.lCache[arguments.entryid].alias>
      <cfset q.posted = variables.lCache[arguments.entryid].posted>
    </cfif>

    <cfif q.alias is not "">
      <cfreturn "#instance.blogURL#/#year(q.posted)#/#month(q.posted)#/#day(q.posted)#/#q.alias#">
    <cfelse>
      <cfreturn "#instance.blogURL#?mode=entry&amp;entry=#arguments.entryid#">
    </cfif>
  </cffunction>

  <cffunction name="makeTitle" access="public" returnType="string" output="false"
        hint="Formats the title.">
    <cfargument name="title" type="string" required="true">

    <!--- Remove non alphanumeric but keep spaces. --->
    <!--- Changed to be more strict - Martin Baur noticed foreign chars getting through. THey
    ARE valid alphanumeric chars, but we don't want them. --->
    <!---
    <cfset arguments.title = reReplace(arguments.title,"[^[:alnum:] ]","","all")>
    --->
    <!---// replace the & symbol with the word "and" //--->
    <cfset arguments.title = replace(arguments.title, "&amp;", "and", "all") />
    <!---// remove html entities //--->
    <cfset arguments.title = reReplace(arguments.title, "&[^;]+;", "", "all") />
    <cfset arguments.title = reReplace(arguments.title,"[^0-9a-zA-Z ]","","all")>
    <!--- change spaces to - --->
    <cfset arguments.title = replace(arguments.title," ","-","all")>

    <cfreturn arguments.title>
  </cffunction>

  <cffunction name="notifyEntry" access="public" returnType="void" output="false"
        hint="Sends a message to everyone in an entry.">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="message" type="string" required="true">
    <cfargument name="subject" type="string" required="true">
    <cfargument name="from" type="string" required="true">

    <!--- Both of these are related to comment moderation. --->
    <cfargument name="adminonly" type="boolean" required="false">
    <cfargument name="noadmin" type="boolean" required="false">
    <cfargument name="html" type="boolean" required="false" default="false">

    <!--- used so we can get the kill switch --->
    <cfargument name="commentid" type="string" required="false">

    <cfset var emailAddresses = structNew()>
    <cfset var folks = "">
    <cfset var folk = "">
    <cfset var comments = "">
    <cfset var address = "">
    <cfset var ulink = "">
    <cfset var theMessage = "">
    <cfset var comment = getComment(arguments.commentid)>
    <cfset var fromtouse = arguments.from>
    <cfset var mailType = "text">

    <cfif arguments.html>
      <cfset mailType = "html">
    </cfif>

    <cfif len(instance.commentsFrom)>
      <cfset fromtouse = instance.commentsFrom>
    </cfif>

    <!--- is it a valid entry? --->
    <cfif not entryExists(arguments.entryid)>
      <cfset variables.utils.throw("#entryid# isn't a valid entry.")>
    </cfif>

    <!--- argument allows us to only send to the admin. --->
    <cfif not structKeyExists(arguments, "adminonly") or not arguments.adminonly>

      <!--- First, get everyone in the thread --->
      <cfinvoke method="getComments" returnVariable="comments">
        <cfinvokeargument name="id" value="#arguments.entryid#">
        <cfinvokeargument name="includesubscribers" value="true">
      </cfinvoke>

      <cfloop query="comments">
        <cfif isBoolean(subscribe) and subscribe and not structKeyExists(emailAddresses, email)>
          <!--- We store the id of the comment, this is used in unsub  notices --->
          <cfset emailAddresses[email] = id>
        </cfif>
      </cfloop>


    </cfif>

    <!--- Send email to admin --->
    <cfif not structKeyExists(arguments, "noadmin") or not arguments.noadmin>
      <cfset emailAddresses[instance.ownerEmail] = "">
    </cfif>

    <!--- Don't send email to from --->
    <cfset structDelete(emailAddresses, arguments.from)>

    <cfif not structIsEmpty(emailAddresses)>
      <!---
        Determine if we have a commentsFrom property. If so, it overrides this setting.
      --->
      <cfif getProperty("commentsFrom") neq "">
        <cfset arguments.from = getProperty("commentsFrom")>
      </cfif>

      <cfloop item="address" collection="#emailAddresses#">
        <!--- determine if msg has an unsub bsu_token, if so, prepare the link --->
        <!---
          Note, right now, the email sent to the admin will have a blank
          commentID. Since the admin can't unsub anyway I don't think it
          is a huge deal.

          Btw - I've got some of the HTML design emedded in here. This because web based
          email readers require inline CSS. I could have passed it in as an argument but
          said frack it.
        --->
        <cfif findNoCase("%unsubscribe%", arguments.message)>
          <cfif address is not instance.ownerEmail>
            <cfset ulink = getRootURL() & "unsubscribe.cfm" &
            "?commentID=#emailAddresses[address]#&amp;email=#address#">
            <cfif mailType is "html">
              <cfset ulink = "<a href=""#ulink#"" style=""font-size:8pt;text-decoration:underline;color:##7d8524;text-decoration:none;"">Unsubscribe</a>">
            <cfelse>
              <cfset ulink = "Unsubscribe from Entry: #ulink#">
            </cfif>
          <cfelse>
            <cfset ulink = "">
            <!--- We get a bit fancier now as well as we will be allowing for kill switches --->
            <cfif mailType is "text">
              <cfset ulink = ulink & "#chr(10)#Delete this comment: #getRootURL()#index.cfm?bco_kill=#comment.bco_kill#">
            <cfelse>
              <cfset ulink = ulink & " <a href=""#getRootURL()#index.cfm?bco_kill=#comment.bco_kill#"" style=""font-size:8pt;text-decoration:underline;color:##7d8524;text-decoration:none;"">Delete</a>">
            </cfif>
            <!--- also allow for approving --->
            <cfif instance.moderate>
              <cfif mailType is "text">
                <cfset ulink = ulink & "#chr(10)#Approve this comment: #getRootURL()#index.cfm?approvecomment=#comment.id#">
              <cfelse>
                <cfset ulink = ulink & " <a href=""#getRootURL()#index.cfm?approvecomment=#comment.id#"" style=""font-size:8pt;text-decoration:underline;color:##7d8524;text-decoration:none;"">Approve</a>">
              </cfif>
            </cfif>
          </cfif>
          <cfset theMessage = replaceNoCase(arguments.message, "%unsubscribe%", ulink, "all")>
        <cfelse>
          <cfset theMessage = arguments.message>
        </cfif>

        <cfset utils.mail(to=address,from=fromtouse,subject=variables.utils.htmlToPlainText(arguments.subject),type=mailType,body=theMessage, failTo=instance.failTo, mailserver=instance.mailserver, mailusername=instance.mailusername, mailpassword=instance.mailpassword)>

      </cfloop>
    </cfif>

  </cffunction>

  <cffunction name="removeCategory" access="remote" returnType="void" roles="admin" output="false"
        hint="remove entry ID from category X">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="bca_bcaid" type="uuid" required="true">

    <cfquery datasource="nmg" >
      delete from BlogEntriesCategories
      where bec_bcaid = <cfqueryparam value="#arguments.bca_bcaid#" cfsqltype="VARCHAR" maxlength="35">
      and bec_benid = <cfqueryparam value="#arguments.entryid#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="removeCategories" access="remote" returnType="void" roles="admin" output="false"
        hint="Remove all categories from an entry.">
    <cfargument name="entryid" type="uuid" required="true">

    <cfquery datasource="nmg" >
      delete from BlogEntriesCategories
      where  bec_benid = <cfqueryparam value="#arguments.entryid#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>
  </cffunction>

  <cffunction name="removeSubscriber" access="remote" returnType="boolean" output="false" hint="Removes a subscriber user.">
    <cfargument name="bsu_email" type="string" required="true">
    <cfargument name="bsu_token" type="uuid" required="false">
    <cfset var getMe = "">

    <cfif not isUserInRole("admin") and not structKeyExists(arguments,"bsu_token")>
      <cfset variables.utils.throw("Unauthorized removal.")>
    </cfif>

    <!--- First, lets see if this guy is already subscribed. --->
    <cfquery name="getMe" datasource="nmg" >
    select  bsu_email
    from  BlogSubscribers
    where  bsu_email = <cfqueryparam value="#arguments.bsu_email#" cfsqltype="varchar" maxlength="50">
    <cfif structKeyExists(arguments, "bsu_token")>
    and    bsu_token = <cfqueryparam value="#arguments.bsu_token#" cfsqltype="varchar" maxlength="35">
    </cfif>
    </cfquery>

    <cfif getMe.recordCount is 1>
      <cfquery datasource="nmg" >
      delete  from BlogSubscribers
      where  bsu_email = <cfqueryparam value="#arguments.bsu_email#" cfsqltype="varchar" maxlength="50">
      <cfif structKeyExists(arguments, "bsu_token")>
      and    bsu_token = <cfqueryparam value="#arguments.bsu_token#" cfsqltype="varchar" maxlength="35">
      </cfif>
      and    bsu_blog = <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">
      </cfquery>

      <cfreturn true>
    <cfelse>
      <cfreturn false>
    </cfif>

  </cffunction>

  <cffunction name="removeUnverifiedSubscribers" access="remote" returnType="void" output="false" roles="admin"
        hint="Removes all subscribers who are not bsu_verified.">

    <cfquery datasource="nmg" >
    delete  from BlogSubscribers
    where  bsu_blog = <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">
    and    bsu_verified = 0
    </cfquery>

  </cffunction>

  <cffunction name="renderEntry" access="public" returnType="string" output="false"
        hint="Handles rendering the blog entry.">
    <cfargument name="string" type="string" required="true">
    <cfargument name="printformat" type="boolean" required="false" default="false">
    <cfargument name="ben_enclosure" type="string" required="false" default="">
    <cfargument name="ignoreParagraphFormat" type="boolean" required="false" default="false"/>
    <cfset var counter = "">
    <cfset var codeblock = "">
    <cfset var codeportion = "">
    <cfset var result = "">
    <cfset var newbody = "">
    <cfset var style = "">
    <cfset var imgURL = "">
    <cfset var rootURL = "">
    <cfset var textblock = "">
    <cfset var tbRegex = "">
    <cfset var textblockLabel = "">
    <cfset var textblockTag = "">
    <cfset var newContent = "">

    <cfset var cfc = "">
    <cfset var newstring = "">

    <!---// check to see if we should paragraph format this string //--->
    <cfif not structKeyExists(arguments, "ignoreParagraphFormat")>
      <!---
      <cfset arguments.ignoreParagraphFormat = yesNoFormat(reFindNoCase('<p[^e>]*>', arguments.string, 0, false))>
      --->
    </cfif>

    <!--- Check for code blocks --->
    <cfif findNoCase("<code>",arguments.string) and findNoCase("</code>",arguments.string)>
      <cfset counter = findNoCase("<code>",arguments.string)>
      <cfloop condition="counter gte 1">
                <cfset codeblock = reFindNoCase("(?s)(.*)(<code>)(.*)(</code>)(.*)",arguments.string,1,1)>
        <cfif arrayLen(codeblock.len) gte 6>
                    <cfset codeportion = mid(arguments.string, codeblock.pos[4], codeblock.len[4])>
                    <cfif len(trim(codeportion))>
            <cfif arguments.printformat>
              <cfset result = "<br/><pre class='codePrint'>#trim(htmlEditFormat(codeportion))#</pre><br/>">
            <cfelse>
              <cfset result = variables.codeRenderer.formatString(trim(codeportion))>
              <cfset result = "<div class='code'>#result#</div>">
            </cfif>
          <cfelse>
            <cfset result = "">
          </cfif>
          <cfset newbody = mid(arguments.string, 1, codeblock.len[2]) & result & mid(arguments.string,codeblock.pos[6],codeblock.len[6])>

                    <cfset arguments.string = newbody>
          <cfset counter = findNoCase("<code>",arguments.string,counter)>
        <cfelse>
          <!--- bad crap, maybe <code> and no ender, or maybe </code><code> --->
          <cfset counter = 0>
        </cfif>
      </cfloop>
    </cfif>

    <!--- call our render funcs --->
    <cfloop item="cfc" collection="#variables.renderMethods#">
      <cfinvoke component="#variables.renderMethods[cfc].cfc#" method="renderDisplay" argumentCollection="#arguments#" returnVariable="newstring" />
      <cfset arguments.string = newstring>
    </cfloop>

    <!--- New ben_enclosure support. If enclose if a jpg, png, or gif, put it on top, aligned left. --->
    <cfif len(arguments.ben_enclosure) and listFindNoCase("gif,jpg,png", listLast(arguments.ben_enclosure, "."))>
      <cfset rootURL = replace(instance.blogURL, "index.cfm", "")>
      <cfset imgURL = "#rootURL#ben_enclosures/#urlEncodedFormat(getFileFromPath(ben_enclosure))#">
      <cfset arguments.string = "<div class=""autoImage""><img src=""#imgURL#""></div>" & arguments.string>
    <!--- bmeloche - 06/13/2008 - Adding podcast support. --->
    <cfelseif len(arguments.ben_enclosure) and listFindNoCase("mp3", listLast(arguments.ben_enclosure, "."))>
      <cfset rootURL = replace(instance.blogURL, "index.cfm", "")>
      <cfset imgURL = "#rootURL#ben_enclosures/#urlEncodedFormat(getFileFromPath(ben_enclosure))#">
      <cfset arguments.string = "<div id=""#urlEncodedFormat(getFileFromPath(ben_enclosure))#""></div>" & arguments.string>
    </cfif>

    <!--- textblock support --->
    <cfset tbRegex = "<textblock[[:space:]]+label[[:space:]]*=[[:space:]]*""(.*?)"">">
    <cfif reFindNoCase(tbRegex,arguments.string)>
      <cfset counter = reFindNoCase(tbRegex,arguments.string)>
      <cfloop condition="counter gte 1">
        <cfset textblock = reFindNoCase(tbRegex,arguments.string,1,1)>
        <cfif arrayLen(textblock.pos) is 2>
          <cfset textblockTag = mid(arguments.string, textblock.pos[1], textblock.len[1])>
          <cfset textblockLabel = mid(arguments.string, textblock.pos[2], textblock.len[2])>
          <cfset newContent = variables.textblock.getTextBlockContent(textblockLabel)>
          <cfset arguments.string = replaceNoCase(arguments.string, textblockTag, newContent)>
        </cfif>
        <cfset counter = reFindNoCase(tbRegex,arguments.string, counter)>
      </cfloop>
    </cfif>

    <cfif not arguments.ignoreParagraphFormat>
      <cfset arguments.string = xhtmlParagraphFormat(arguments.string) />
    </cfif>

    <cfreturn arguments.string />
  </cffunction>

  <cffunction name="saveCategory" access="remote" returnType="void" roles="admin" output="false"
        hint="Saves a category.">
    <cfargument name="id" type="uuid" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="alias" type="string" required="true">
    <cfset var oldName = getCategory(arguments.id).bca_category>

    <cflock name="blogcfc.addCategory" type="exclusive" timeout=30>

      <!--- new name? --->
      <cfif oldName neq arguments.name>
        <cfif categoryExists(name="#arguments.name#")>
          <cfset variables.utils.throw("#arguments.name# already exists as a category.")>
        </cfif>
      </cfif>

      <cfquery datasource="nmg" >
      update  BlogCategories
      set    bca_category = <cfqueryparam value="#arguments.name#" cfsqltype="varchar" maxlength="50">,
          bca_alias = <cfqueryparam value="#arguments.alias#" cfsqltype="varchar" maxlength="50">
      where  bca_bcaid = <cfqueryparam value="#arguments.id#" cfsqltype="varchar" maxlength="35">
      </cfquery>

    </cflock>

  </cffunction>

  <cffunction name="saveComment" access="public" returnType="uuid" output="false"
        hint="Saves a comment.">
    <cfargument name="commentid" type="uuid" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="email" type="string" required="true">
    <cfargument name="bco_website" type="string" required="true">
    <cfargument name="comments" type="string" required="true">
    <cfargument name="subscribe" type="boolean" required="true">
    <cfargument name="bco_moderated" type="boolean" required="true">

    <cfset arguments.comments = htmleditformat(arguments.comments)>
    <cfset arguments.name = left(htmlEditFormat(arguments.name),50)>
    <cfset arguments.email = left(htmlEditFormat(arguments.email),50)>
    <cfset arguments.bco_website = left(htmlEditFormat(arguments.bco_website),255)>


    <cfquery datasource="nmg" >
    update BlogComments
    set name = <cfqueryparam value="#arguments.name#" maxlength="50">,
    email = <cfqueryparam value="#arguments.email#" maxlength="50">,
    bco_website = <cfqueryparam value="#arguments.bco_website#" maxlength="255">,
    <cfif instance.blogDBType is not "ORACLE">
    comment = <cfqueryparam value="#arguments.comments#" cfsqltype="LONGVARCHAR">,
    <cfelse>
    comments = <cfqueryparam cfsqltype="clob" value="#arguments.comments#">,
    </cfif>
    subscribe =
         <cfif instance.blogDBType is "MSSQL" or instance.blogDBType is "MSACCESS">
           <cfqueryparam value="#arguments.subscribe#" cfsqltype="BIT">
         <cfelse>
                <!--- convert yes/no to 1 or 0 --->
             <cfif arguments.subscribe>
               <cfset arguments.subscribe = 1>
             <cfelse>
               <cfset arguments.subscribe = 0>
             </cfif>
           <cfqueryparam value="#arguments.subscribe#" cfsqltype="TINYINT">
         </cfif>,
    bco_moderated=
      <cfif instance.blogDBType is "MSSQL" or instance.blogDBType is "MSACCESS">
        <cfqueryparam value="#arguments.bco_moderated#" cfsqltype="BIT">
      <cfelse>
        <cfqueryparam value="#arguments.bco_moderated#" cfsqltype="TINYINT">
      </cfif>
    where  id = <cfqueryparam value="#arguments.commentid#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

    <cfreturn arguments.commentid>
  </cffunction>

  <cffunction name="saveEntry" access="remote" returnType="void" roles="admin" output="false"
        hint="Saves an entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfargument name="title" type="string" required="true">
    <cfargument name="body" type="string" required="true">
    <cfargument name="ben_morebody" type="string" required="false" default="">
    <cfargument name="alias" type="string" required="false" default="">
    <!--- I use "any" so I can default to a blank string --->
    <cfargument name="posted" type="any" required="false" default="">
    <cfargument name="ben_allowcomments" type="boolean" required="false" default="true">
    <cfargument name="ben_enclosure" type="string" required="false" default="">
    <cfargument name="ben_filesize" type="numeric" required="false" default="0">
    <cfargument name="ben_mimetype" type="string" required="false" default="">
    <cfargument name="ben_released" type="boolean" required="false" default="true">
    <cfargument name="relatedPPosts" type="string" required="true" default="">
    <cfargument name="sendemail" type="boolean" required="false" default="true">
    <cfargument name="duration" type="string" required="false" default="">
    <cfargument name="subtitle" type="string" required="false" default="">
    <cfargument name="summary" type="string" required="false" default="">
    <cfargument name="keywords" type="string" required="false" default="">

    <cfset var theURL = "" />
    <cfset var entry = "" />

    <cfif not entryExists(arguments.id)>
      <cfset variables.utils.throw("#arguments.id# does not exist as an entry.")>
    </cfif>

    <cfquery datasource="nmg" >
      update BlogEntries
      set    title = <cfqueryparam value="#arguments.title#" cfsqltype="CHAR" maxlength="100">,
          <cfif instance.blogDBType is not "ORACLE">
          body = <cfqueryparam value="#arguments.body#" cfsqltype="LONGVARCHAR">
          <cfelse>
          body = <cfqueryparam value="#arguments.body#" cfsqltype="CLOB">
          </cfif>
          <cfif len(arguments.ben_morebody)>
            <cfif instance.blogDBType is not "ORACLE">
            ,ben_morebody = <cfqueryparam value="#arguments.ben_morebody#" cfsqltype="LONGVARCHAR">
            <cfelse>
            ,ben_morebody = <cfqueryparam value="#arguments.ben_morebody#" cfsqltype="CLOB">
            </cfif>
          <!--- ME - 04/27/2005 - fix this to overwrite more/ on edit --->
            <cfelse>
            <cfif instance.blogDBType is not "ORACLE">
               ,ben_morebody = <cfqueryparam null="yes" cfsqltype="LONGVARCHAR">
            <cfelse>
            ,ben_morebody = <cfqueryparam null="yes" cfsqltype="CLOB">
            </cfif>
          </cfif>
          <cfif len(arguments.alias)>
            ,alias = <cfqueryparam value="#arguments.alias#" cfsqltype="VARCHAR" maxlength="100">
          </cfif>
          <cfif (len(trim(arguments.posted)) gt 0) and isDate(arguments.posted)>
            ,posted = <cfqueryparam value="#arguments.posted#" cfsqltype="TIMESTAMP">
          </cfif>
            <cfif instance.blogDBType is not "MYSQL" AND instance.blogDBType is not "ORACLE">
          ,ben_allowcomments = <cfqueryparam value="#arguments.ben_allowcomments#" cfsqltype="BIT">
             <cfelse>
               <!--- convert yes/no to 1 or 0 --->
               <cfif arguments.ben_allowcomments>
                 <cfset arguments.ben_allowcomments = 1>
               <cfelse>
                 <cfset arguments.ben_allowcomments = 0>
               </cfif>
            ,ben_allowcomments = <cfqueryparam value="#arguments.ben_allowcomments#" cfsqltype="TINYINT">
             </cfif>
             ,ben_enclosure = <cfqueryparam value="#arguments.ben_enclosure#" cfsqltype="CHAR" maxlength="255">
          ,summary = <cfqueryparam value="#arguments.summary#" cfsqltype="VARCHAR" maxlength="255">
          ,subtitle = <cfqueryparam value="#arguments.subtitle#" cfsqltype="VARCHAR" maxlength="100">
          ,keywords = <cfqueryparam value="#arguments.keywords#" cfsqltype="VARCHAR" maxlength="100">
          ,duration = <cfqueryparam value="#arguments.duration#" cfsqltype="VARCHAR" maxlength="10">
            ,ben_filesize = <cfqueryparam value="#arguments.ben_filesize#" cfsqltype="NUMERIC">
             ,ben_mimetype = <cfqueryparam value="#arguments.ben_mimetype#" cfsqltype="VARCHAR" maxlength="255">
             <cfif instance.blogDBType is not "MYSQL" AND instance.blogDBType is not "ORACLE">
          ,ben_released = <cfqueryparam value="#argumeben_releasedased#" cfsqltype="BIT">
             <cfelse>
               <!--- convert yes/no to 1 or 0 --->
               <cfif arguments.released>
                 <cfset arguments.ben_released = 1>
               <cfelse>
                 <cfset arguments.ben_released = 0>
               </cfif>
            ,ben_released = <cfqueryparam value="#arguments.ben_released#" cfsqltype="TINYINT">
             </cfif>

      where  id = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="VARCHAR" maxlength="50">
    </cfquery>

    <cfset saveRelatedEntries(arguments.ID, arguments.relatedpposts) />

    <!---// get the entry //--->
    <cfset entry = getEntry(arguments.id, true) />

    <!---// update the link cache //--->
    <cfset cacheLink(entryid=arguments.id, alias=entry.alias, posted=entry.posted) />

    <cfif arguments.ben_released>

      <cfif arguments.sendEmail>
        <cfif dateCompare(dateAdd("h", instance.offset, entry.posted), blogNow()) is 1>
          <!--- Handle delayed posting --->
          <cfset theURL = getRootURL()>
          <cfset theURL = theURL & "admin/notify.cfm?id=#id#">
          <cfschedule action="update" task="BlogCFC Notifier #id#" operation="HTTPRequest"
                startDate="#entry.posted#" startTime="#entry.posted#" url="#theURL#" interval="once">
        <cfelse>
          <cfset mailEntry(arguments.id)>
        </cfif>
      </cfif>

      <cfif dateCompare(dateAdd("h", instance.offset, entry.posted), blogNow()) is not 1>
        <cfset variables.ping.pingAggregators(instance.pingurls, instance.blogtitle, instance.blogurl)>
      </cfif>

    </cfif>

  </cffunction>

  <cffunction name="saveRelatedEntries" access="public" returntype="void" roles="admin" output="false"
    hint="I add/update related blog entries">
    <cfargument name="ID" type="UUID" required="true" />
    <cfargument name="relatedpposts" type="string" required="true" />

    <cfset var ppost = "" />

    <cfquery datasource="nmg" >
      delete from
        BlogEntriesRelated
      where
        entryid = <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">
    </cfquery>

    <cfloop list="#arguments.relatedpposts#" index="ppost">
      <cfquery datasource="nmg" >
        insert into
          BlogEntriesRelated(
            bre_benid,
            bre_relbenid
          ) values (
            <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35">,
            <cfqueryparam value="#ppost#" cfsqltype="VARCHAR" maxlength="35">
          )
      </cfquery>
    </cfloop>

  </cffunction>

  <cffunction name="saveUser" access="public" returnType="void" output="false"
        hint="Saves a user.">
    <cfargument name="username" type="string" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="password" type="string" required="false">
    <cfset var salt = generateSalt()>

    <cfquery datasource="nmg" >
    update  BlogUsers
    set    bus_name = <cfqueryparam cfsqltype="varchar" value="#arguments.name#" maxlength="50">
        <!--- RBB 1/17/11: if no password is passed in, we can assume that only the user's name is being updated --->
        <cfif structKeyExists(arguments, "password")>
          <!--- RBB 1/17/11: generate new salt. I like to do this whenever a password is changed --->

          ,bus_password = <cfqueryparam value="#hash(salt & arguments.password, instance.hashalgorithm)#" cfsqltype="varchar" maxlength="256">,
          bus_salt = <cfqueryparam value="#salt#" cfsqltype="varchar" maxlength="256">
        </cfif>
    where  bus_username = <cfqueryparam cfsqltype="varchar" value="#arguments.username#" maxlength="50">
    and    bus_blog = <cfqueryparam cfsqltype="varchar" value="#instance.name#" maxlength="50">
    </cfquery>

  </cffunction>

  <cffunction name="setCodeRenderer" access="public" returnType="void" output="false" hint="Injector for coldfish">
    <cfargument name="renderer" type="any" required="true">
    <cfset variables.coderenderer = arguments.renderer>
  </cffunction>

  <cffunction name="setProperty" access="public" returnType="void" output="false" roles="admin">
    <cfargument name="property" type="string" required="true">
    <cfargument name="value" type="string" required="true">

    <cfset instance[arguments.property] = arguments.value>
    <cfset setProfileString(variables.cfgFile, instance.name, arguments.property, arguments.value)>

  </cffunction>

  <cffunction name="setbco_moderatedComment" access="public" returnType="void" output="false" roles="admin"
        hint="Sets a comment to approved">
    <cfargument name="id" type="string" required="true">

    <cfquery datasource="nmg" >
      update BlogComments set bco_moderated=1 where id=<cfqueryparam value="#arguments.id#" cfsqltype="varchar">
    </cfquery>

  </cffunction>

  <cffunction name="setUserBlogRoles" access="public" returnType="void" output="false" roles="admin"
        hint="Sets a user's blog roles">
    <cfargument name="username" type="string" required="true" />
    <cfargument name="roles" type="string" required="true" />

    <cfset var r = "" />
    <!--- first, nuke old roles --->
    <cfquery datasource="nmg" >
    delete from BlogUserRoles
    where username = <cfqueryparam cfsqltype="varchar" value="#arguments.username#" maxlength="50">
    and blog = <cfqueryparam cfsqltype="varchar" value="#instance.name#" maxlength="50">
    </cfquery>

    <cfloop index="r" list="#arguments.roles#">
      <cfquery datasource="nmg" >
      insert into BlogUserRoles(username, bur_broid, blog)
      values(
      <cfqueryparam cfsqltype="varchar" value="#arguments.username#" maxlength="50">,
      <cfqueryparam cfsqltype="varchar" value="#r#" maxlength="35">,
      <cfqueryparam cfsqltype="varchar" value="#instance.name#" maxlength="50">
      )
      </cfquery>
    </cfloop>

  </cffunction>

  <cffunction name="unsubscribeThread" access="public" returnType="boolean" output="false"
        hint="Removes a user from a thread.">
    <cfargument name="commentID" type="UUID" required="true" />
    <cfargument name="email" type="string" required="true" />

    <cfset var verifySubscribe = "" />

    <!--- First ensure that the commentID equals the email --->
    <cfquery name="verifySubscribe" datasource="nmg" >
      select  fk_benid
      from  BlogComments
      where  id = <cfqueryparam value="#arguments.commentID#" cfsqltype="VARCHAR" maxlength="35">
      and    email = <cfqueryparam value="#arguments.email#" cfsqltype="VARCHAR" maxlength="100">
    </cfquery>

    <!--- If we have a result, then set subscribe=0 for this user for ALL comments in the thread --->
    <cfif verifySubscribe.recordCount>

      <cfquery datasource="nmg" >
        update  BlogComments
        set    subscribe = 0
        where  fk_benid = <cfqueryparam value="#verifySubscribe.fk_benid#"
                  cfsqltype="VARCHAR" maxlength="35">
        and    email = <cfqueryparam value="#arguments.email#" cfsqltype="VARCHAR" maxlength="100">
      </cfquery>

      <cfreturn true />
    </cfif>

    <cfreturn false />
  </cffunction>

  <cffunction name="updatePassword" access="public" returnType="boolean" output="false"
        hint="Updates the current user's password.">
    <cfargument name="oldpassword" type="string" required="true" />
    <cfargument name="newpassword" type="string" required="true" />

    <cfset var checkit = "" />
    <cfset var salt = generateSalt()>

    <cfquery name="checkit" datasource="nmg" >
    select  bus_password, bus_salt
    from  BlogUsers
    where  bus_username = <cfqueryparam value="#getAuthUser()#" cfsqltype="varchar" maxlength="50">
    and    bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">
    </cfquery>

    <cfif checkit.recordCount is 1 AND checkit.password is hash(checkit.salt & arguments.oldpassword, instance.hashalgorithm)>
      <!--- generate a new salt --->

      <cfquery datasource="nmg" >
      update  BlogUsers
      set    bus_password = <cfqueryparam value="#hash(salt & arguments.newpassword, instance.hashalgorithm)#" cfsqltype="varchar" maxlength="256">,
      bus_salt = <cfqueryparam value="#salt#" cfsqltype="varchar" maxlength="256">
      where  bus_username = <cfqueryparam value="#getAuthUser()#" cfsqltype="varchar" maxlength="50">
      and    bus_blog = <cfqueryparam value="#instance.name#" cfsqltype="varchar" maxlength="50">
      </cfquery>
      <cfreturn true />
    <cfelse>
      <cfreturn false />
    </cfif>
  </cffunction>

  <cffunction name="XHTMLParagraphFormat" returntype="string" output="false">
    <cfargument name="strTextBlock" required="true" type="string" />
    <cfreturn REReplace("<p>" & arguments.strTextBlock & "</p>", "\r+\n\r+\n", "</p><p>", "ALL") />
  </cffunction>

  <cffunction name="generateSalt" returnType="string" output="false" access="public" hint="I generate salt for use in hashing user passwords">

    <cfreturn generateSecretKey(instance.saltAlgorithm, instance.saltKeySize)>
  </cffunction>

</cfcomponent>
