<cfcomponent displayName="Blog" output="false" hint="BlogCFC by Raymond Camden">
  <!--- Load utils immidiately. --->
  <cfset VARIABLES.utils = createObject("component", "utils")>
  <cfset VARIABLES.roles = structNew()>

  <!--- current version --->
  <cfset version = "5.9.8.012" />

  <!--- cfg file --->
  <cfset VARIABLES.cfgFile = "#getDirectoryFromPath(GetCurrentTemplatePath())#\blog.ini.cfm">

  <!--- used for rendering --->
  <cfset VARIABLES.renderMethods = structNew()>

  <!--- used for settings --->
  <cfset VARIABLES.instance = "">

  <cffunction name="init" access="public" returnType="blog" output="false" hint="Initialize the blog engine">

    <cfargument name="name" type="string" required="false" default="#APPLICATION.SETTING.blog#" hint="Blog name, defaults to default in blog.ini">
    <cfargument name="instanceData" type="struct" required="false" hint="Allows you to specify BlogCFC info at runtime.">

    <cfset var renderDir = "">
    <cfset var renderCFCs = "">
    <cfset var cfcName = "">
    <cfset var md = "">

    <cfif isDefined("ARGUMENTS.instanceData")>
      <cfset instance = duplicate(ARGUMENTS.instanceData)>
    <cfelse>
      <cfif not listFindNoCase(structKeyList(getProfileSections(VARIABLES.cfgFile)),name)>
        <cfset VARIABLES.utils.throw("#ARGUMENTS.name# isn't registered as a valid blog.")>
      </cfif>
      <cfset instance = structNew()>
      <cfset instance.dsn = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"dsn")>
      <cfset instance.username = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"username")>
      <cfset instance.password = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"password")>
      <cfset instance.ownerEmail = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "owneremail")>
      <cfset instance.blogURL = "#APPLICATION.PATH.FULL#/b.index.cfm" />
      <cfset instance.blogTitle = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "blogTitle")>
      <cfset instance.blogDescription = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "blogDescription")>
      <cfset instance.locale = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "locale")>
      <cfset instance.commentsFrom = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"commentsFrom")>
      <cfset instance.failTo = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"failTo")>
      <cfset instance.mailServer = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"mailserver")>
      <cfset instance.mailusername = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"mailusername")>
      <cfset instance.mailpassword = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"mailpassword")>
      <cfset instance.pingurls = VARIABLES.utils.configParam(VARIABLES.cfgFile,ARGUMENTS.name,"pingurls")>
      <cfset instance.offset = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "offset")>
      <cfset instance.trackbackspamlist = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "trackbackspamlist")>
      <cfset instance.blogkeywords = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "blogkeywords")>
      <cfset instance.ipblocklist = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "ipblocklist")>
      <cfset instance.maxentries = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "maxentries")>
      <cfset instance.moderate = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "moderate")>
      <cfset instance.usecaptcha = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "usecaptcha")>
      <cfset instance.usecfp = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "usecfp")>
      <cfset instance.allowgravatars = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "allowgravatars")>
      <cfset instance.filebrowse = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "filebrowse")>
      <cfset instance.settings = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "settings")>
      <cfset instance.itunesSubtitle = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "itunesSubtitle")>
      <cfset instance.itunesSummary = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "itunesSummary")>
      <cfset instance.itunesKeywords = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "itunesKeywords")>
      <cfset instance.itunesAuthor = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "itunesAuthor")>
      <cfset instance.itunesImage = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "itunesImage")>
      <cfset instance.itunesExplicit = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "itunesExplicit")>
      <cfset instance.usetweetbacks = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "usetweetbacks")>
      <cfset instance.installed = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "installed")>
      <cfset instance.saltalgorithm = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "saltalgorithm")>
      <cfset instance.saltkeysize = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "saltkeysize")>
      <cfset instance.hashalgorithm = VARIABLES.utils.configParam(VARIABLES.cfgFile, ARGUMENTS.name, "hashalgorithm")>

    </cfif>

    <!--- Name the blog --->
    <cfset instance.name = ARGUMENTS.name>

    <!--- If FailTo is blank, use Admin email --->
    <cfif instance.failTo is "">
      <cfset instance.failTo = instance.ownerEmail>
    </cfif>

    <!--- get a copy of ping --->
    <cfset VARIABLES.ping = createObject("component", "ping8")>

    <!--- get a copy of textblock --->
    <cfset VARIABLES.textblock = createObject("component","textblock").init(dsn=instance.dsn, username=instance.username, password=instance.password, blog=instance.name)>

    <!--- prepare rendering --->
    <cfset renderDir = getDirectoryFromPath(GetCurrentTemplatePath()) & "/render/">
    <!--- get my kids --->
    <cfdirectory action="list" name="renderCFCs" directory="#renderDir#" filter="*.cfc">

    <cfloop query="renderCFCs">
      <cfset cfcName = listDeleteAt(renderCFCs.name, listLen(renderCFCs.name, "."), ".")>

      <cfif cfcName is not "render">
        <!--- store the name --->
        <cfset VARIABLES.renderMethods[cfcName] = structNew()>
        <!--- create an instance of the CFC. It better have a render method! --->
        <cfset VARIABLES.renderMethods[cfcName].cfc = createObject("component", "render.#cfcName#")>
        <cfset md = getMetaData(VARIABLES.renderMethods[cfcName].cfc)>
        <cfif structKeyExists(md, "instructions")>
          <cfset VARIABLES.renderMethods[cfcName].instructions = md.instructions>
        </cfif>
      </cfif>

    </cfloop>

    <cfreturn this>

  </cffunction>

  <cffunction name="addCategory" access="remote" returnType="uuid" roles="" output="false" hint="Adds a category.">
    <cfargument name="name" type="string" required="true">
    <cfargument name="alias" type="string" required="true">

    <cfset var checkC = "">
    <cfset var id = createUUID()>

    <cflock name="blogcfc.addCategory" type="exclusive" timeout="30">

      <cfif categoryExists(name="#ARGUMENTS.name#")>
        <cfset VARIABLES.utils.throw("#ARGUMENTS.name# already exists as a category.")>
      </cfif>

      <cfquery datasource="#instance.dsn#">
        insert into blogCategories(bca_bcaid,bca_name,bca_alias,blog)
        values(
          <cfqueryparam value="#id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
          <cfqueryparam value="#ARGUMENTS.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
          <cfqueryparam value="#ARGUMENTS.alias#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
          <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
      </cfquery>

    </cflock>

    <cfreturn id>
  </cffunction>

  <cffunction name="addComment" access="remote" returnType="uuid" output="false" hint="Adds a comment.">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="email" type="string" required="true">
    <cfargument name="bco_website" type="string" required="true">
    <cfargument name="comments" type="string" required="true">
    <cfargument name="subscribe" type="boolean" required="true">
    <cfargument name="bco_subscribeonly" type="boolean" required="false" default="false">
    <cfargument name="overridemoderation" type="boolean" required="false" default="false">
    <cfargument name="usid" type="numeric" default="0">

    <cfset var newID = createUUID()>
    <cfset var entry = "">
    <cfset var spam = "">
    <cfset var kill = createUUID()>

    <cfset ARGUMENTS.comments = htmleditformat(ARGUMENTS.comments)>
    <cfset ARGUMENTS.name = left(htmlEditFormat(ARGUMENTS.name),50)>
    <cfset ARGUMENTS.email = left(htmlEditFormat(ARGUMENTS.email),50)>
    <cfset ARGUMENTS.bco_website = left(htmlEditFormat(ARGUMENTS.bco_website),255)>
    <cfif not entryExists(ARGUMENTS.entryid)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.entryid# is not a valid entry.")>
    </cfif>
    <!--- get the entry so we can check for allowcomments --->
    <cfset entry = getEntry(ARGUMENTS.entryid,true)>
    <cfif not entry.allowcomments>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.entryid# does not allow for comments.")>
    </cfif>
    <!--- only check spam if not a sub --->
    <cfif not ARGUMENTS.bco_subscribeonly>
      <!--- check spam and IPs --->
      <cfloop index="spam" list="#instance.trackbackspamlist#">
        <cfif findNoCase(spam, ARGUMENTS.comments) or
            findNoCase(spam, ARGUMENTS.name) or
            findNoCase(spam, ARGUMENTS.bco_website) or
            findNoCase(spam, ARGUMENTS.email)>
          <cfset VARIABLES.utils.throw("Comment blocked for spam.")>
        </cfif>
      </cfloop>
      <cfloop list="#instance.ipblocklist#" index="spam">
        <cfif spam contains "*" and reFindNoCase(replaceNoCase(spam, '.', '\.','all'), CGI.REMOTE_ADDR)>
          <cfset VARIABLES.utils.throw("Comment blocked for spam.")>
        <cfelseif spam is CGI.REMOTE_ADDR>
          <cfset VARIABLES.utils.throw("Comment blocked for spam.")>
        </cfif>
        </cfloop>
    </cfif>
    <cfquery datasource="#instance.dsn#">
      INSERT INTO blogComments(
        id,entryidfk,name,email,bco_website,comment,posted,subscribe,bco_moderated,bco_kill,bco_subscribeonly,usid
      ) VALUES (
        <cfqueryparam value="#newID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
        <cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
        <cfqueryparam value="#ARGUMENTS.name#" maxlength="50">,
        <cfqueryparam value="#ARGUMENTS.email#" maxlength="50">,
        <cfqueryparam value="#ARGUMENTS.bco_website#" maxlength="255">,
        <cfqueryparam value="#ARGUMENTS.comments#" cfsqltype="CF_SQL_LONGVARCHAR">,
        <cfqueryparam value="#blogNow()#" cfsqltype="CF_SQL_TIMESTAMP">,
        <cfqueryparam value="#ARGUMENTS.subscribe#" cfsqltype="CF_SQL_BIT">,
        <cfif instance.moderate and not ARGUMENTS.overridemoderation>0<cfelse>1</cfif>,
        <cfqueryparam value="#kill#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
        <cfqueryparam value="#ARGUMENTS.bco_subscribeonly#" cfsqltype="CF_SQL_TINYINT">,
        <cfqueryparam value="#ARGUMENTS.usid#" cfsqltype="CF_SQL_INTEGER">
      )
    </cfquery>
    <!--- IF SUBSCRIBE IS NO, AUTO SET OLDER POSTS IN THREAD BY THIS AUTHOR TO NO --->
    <cfif not ARGUMENTS.subscribe>
      <cfquery datasource="#instance.dsn#">
        UPDATE blogComments
          SET subscribe = 0
         WHERE entryidfk = <cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
        <cfif ARGUMENTS.usid>
          AND usid = <cfqueryparam value="#ARGUMENTS.usid#" cfsqltype="cf_sql_integer" />
        <cfelse>
          AND email = <cfqueryparam value="#ARGUMENTS.email#" cfsqltype="cf_sql_varchar" maxlength="100" />
        </cfif>
      </cfquery>
    </cfif>
    <cfreturn newID>
  </cffunction>

  <cffunction name="addEntry" access="remote" returnType="uuid" roles="" output="true" hint="Adds an entry.">
    <cfargument name="title" type="string" required="true">
    <cfargument name="body" type="string" required="true">
    <cfargument name="morebody" type="string" required="false" default="">
    <cfargument name="alias" type="string" required="false" default="">
    <cfargument name="posted" type="date" required="false" default="#blogNow()#">
    <cfargument name="allowcomments" type="boolean" required="false" default="true">
    <cfargument name="enclosure" type="string" required="false" default="">
    <cfargument name="filesize" type="numeric" required="false" default="0">
    <cfargument name="mimetype" type="string" required="false" default="">
    <cfargument name="released" type="boolean" required="false" default="true">
    <cfargument name="relatedEntries" type="string" required="false" default="">
    <cfargument name="sendemail" type="boolean" required="false" default="true">
    <cfargument name="duration" type="string" required="false" default="">
    <cfargument name="subtitle" type="string" required="false" default="">
    <cfargument name="summary" type="string" required="false" default="">
    <cfargument name="keywords" type="string" required="false" default="">

    <cfset var id = createUUID()>
    <cfset var theURL = "">
    <cfif ARGUMENTS.allowcomments><cfset ARGUMENTS.allowcomments = 1><cfelse><cfset ARGUMENTS.allowcomments = 0></cfif>
    <cfif ARGUMENTS.released><cfset ARGUMENTS.released = 1><cfelse><cfset ARGUMENTS.released = 0></cfif>
    <cfquery datasource="#instance.dsn#">
      insert into blogEntries(id,title,body,posted,
        <cfif len(ARGUMENTS.morebody)>morebody,</cfif>
        <cfif len(ARGUMENTS.alias)>alias,</cfif>
        username,blog,allowcomments,enclosure,summary,subtitle,keywords,duration,filesize,mimetype,released,views,mailed)
      values(
        <cfqueryparam value="#id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
        <cfqueryparam value="#ARGUMENTS.title#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
        <cfqueryparam value="#ARGUMENTS.body#" cfsqltype="CF_SQL_LONGVARCHAR">,
        <cfqueryparam value="#ARGUMENTS.posted#" cfsqltype="CF_SQL_TIMESTAMP">,
        <cfif len(ARGUMENTS.morebody)>
          <cfqueryparam value="#ARGUMENTS.morebody#" cfsqltype="CF_SQL_LONGVARCHAR">,
        </cfif>
        <cfif len(ARGUMENTS.alias)>
          <cfqueryparam value="#ARGUMENTS.alias#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
        </cfif>
        <cfqueryparam value="#getAuthUser()#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
        <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
        <cfqueryparam value="#ARGUMENTS.allowcomments#" cfsqltype="CF_SQL_TINYINT">,
        <cfqueryparam value="#ARGUMENTS.enclosure#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
        <cfqueryparam value="#ARGUMENTS.summary#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
        <cfqueryparam value="#ARGUMENTS.subtitle#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
        <cfqueryparam value="#ARGUMENTS.keywords#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
        <cfqueryparam value="#ARGUMENTS.duration#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,
        <cfqueryparam value="#ARGUMENTS.filesize#" cfsqltype="CF_SQL_NUMERIC">,
        <cfqueryparam value="#ARGUMENTS.mimetype#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
        <cfqueryparam value="#ARGUMENTS.released#" cfsqltype="CF_SQL_TINYINT">,
        0,
        <cfqueryparam value="0" cfsqltype="CF_SQL_TINYINT">
      )
    </cfquery>
    <cfif len(trim(ARGUMENTS.relatedEntries)) GT 0>
      <cfset saveRelatedEntries(id, ARGUMENTS.relatedEntries) />
    </cfif>
    <!--- Only mail if released = true, and posted not in the future --->
    <cfif ARGUMENTS.sendEmail and ARGUMENTS.released and dateCompare(dateAdd("h", instance.offset,ARGUMENTS.posted), blogNow()) lte 0>
      <cfset mailEntry(id)>
    </cfif>
    <cfif ARGUMENTS.released>
      <cfif ARGUMENTS.sendEmail and dateCompare(dateAdd("h", instance.offset,ARGUMENTS.posted), blogNow()) is 1>
        <!--- Handle delayed posting --->
        <cfset theURL = APPLICATION.PATH.FULL & "/x.notify.cfm?id=#id#">
        <cfschedule action="update" task="BlogCFC Notifier #id#" operation="HTTPRequest" startDate="#ARGUMENTS.posted#" startTime="#ARGUMENTS.posted#" url="#theURL#" interval="once">
      <cfelse>
        <cfset VARIABLES.ping.pingAggregators(instance.pingurls, instance.blogtitle, instance.blogurl)>
      </cfif>
    </cfif>
    <cfreturn id>
  </cffunction>

  <cffunction name="addSubscriber" access="remote" returnType="string" output="false" hint="Adds a subscriber to the blog.">
    <cfargument name="email" type="string" required="true">
    <cfset var token = createUUID()>
    <cfset var getMe = "">

    <!--- First, lets see if this guy is already subscribed. --->
    <cfquery name="getMe" datasource="#instance.dsn#">
    select  email
    from  blogSubscribers
    where  email = <cfqueryparam value="#ARGUMENTS.email#" cfsqltype="cf_sql_varchar" maxlength="50">
    and    blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
    </cfquery>

    <cfif getMe.RecordCount is 0>
      <cfquery datasource="#instance.dsn#">
      insert into blogSubscribers(email,
      token,
      blog,
      verified)
      values(<cfqueryparam value="#ARGUMENTS.email#" cfsqltype="cf_sql_varchar" maxlength="50">,
      <cfqueryparam value="#token#" cfsqltype="cf_sql_varchar" maxlength="35">,
      <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">,
      0
      )
      </cfquery>

      <cfreturn token>

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
      <cfquery name="q" datasource="#instance.dsn#">
      select  username
      from  blogUsers
      where  username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#" maxlength="50">
      and    blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
      </cfquery>

      <cfif q.RecordCount>
        <cfset VARIABLES.utils.throw("#ARGUMENTS.name# already exists as a user.")>
      </cfif>

      <cfquery datasource="#instance.dsn#">
      insert into blogUsers(username, name, password, blog, salt)
      values(
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#" maxlength="50">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.name#" maxlength="50">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(salt & ARGUMENTS.password, instance.hashalgorithm)#" maxlength="256">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#salt#" maxlength="256">
      )
      </cfquery>
    </cflock>

  </cffunction>

  <cffunction name="approveComment" access="public" returnType="void" output="false" hint="Approves a comment.">
    <cfargument name="commentid" type="uuid" required="true">
    <cfquery datasource="#instance.dsn#">
      update blogComments
        set bco_moderated = <cfqueryparam value="1" cfsqltype="CF_SQL_TINYINT">
       where id = <cfqueryparam value="#ARGUMENTS.commentid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>
  </cffunction>

  <cffunction name="assignCategory" access="remote" returnType="void" roles="" output="false" hint="Assigns entry ID to category X">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="bca_bcaid" type="uuid" required="true">
    <cfset var checkEC = "">

    <cfquery name="checkEC" datasource="#instance.dsn#">
      select    bec_bcaid
      from  blogEntriesCategories
      where    bec_bcaid = <cfqueryparam value="#ARGUMENTS.bca_bcaid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      and    entryidfk = <cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>

    <cfif entryExists(ARGUMENTS.entryid) and categoryExists(id=ARGUMENTS.bca_bcaid) and not checkEC.RecordCount>
      <cfquery datasource="#instance.dsn#">
        insert into blogEntriesCategories(  bec_bcaid,entryidfk)
        values(<cfqueryparam value="#ARGUMENTS.bca_bcaid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,<cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">)
      </cfquery>
    </cfif>

  </cffunction>

  <cffunction name="assignCategories" access="remote" returnType="void" roles="" output="false" hint="Assigns entry ID to multiple categories">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="bca_bcaids" type="string" required="true">

    <cfset var i=0>

    <!--- Loop through categories --->
    <cfloop index="i" from="1" to="#listLen(ARGUMENTS.bca_bcaids)#">
      <cfset assignCategory(ARGUMENTS.entryid,listGetAt(bca_bcaids,i))>
    </cfloop>

  </cffunction>

  <cffunction name="authenticate" access="public" returnType="boolean" output="false" hint="Authenticates a user.">
    <cfargument name="username" type="string" required="true">
    <cfargument name="password" type="string" required="true">

    <cfreturn APPLICATION.CFC.Users.Login(ARGUMENTS.username, ARGUMENTS.password).validated />

<!---     <cfset var q = "">
    <cfset var authenticated = false>

    <cfquery name="q" datasource="#instance.dsn#">
      select  username, password, salt
      from  blogUsers
      where  username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>

    <cfif (q.RecordCount eq 1) AND (q.password is hash(q.salt & ARGUMENTS.password, instance.hashalgorithm))>
      <cfset authenticated = true>
    </cfif>

    <cfreturn authenticated> --->

  </cffunction>

  <cffunction name="blogNow" access="public" returntype="date" output="false" hint="Returns now() with the offset.">
    <cfreturn dateAdd("h", instance.offset, now())>
  </cffunction>

  <cffunction name="categoryExists" access="private" returnType="boolean" output="false" hint="Returns true or false if an entry exists.">
    <cfargument name="id" type="uuid" required="false">
    <cfargument name="name" type="string" required="false">
    <cfset var checkC = "">

    <!--- must pass either ID or name, but not obth --->
    <cfif (not isDefined("ARGUMENTS.id") and not isDefined("ARGUMENTS.name")) or (isDefined("ARGUMENTS.id") and isDefined("ARGUMENTS.name"))>
      <cfset VARIABLES.utils.throw("categoryExists method must be passed id or name, but not both.")>
    </cfif>

    <cfquery name="checkC" datasource="#instance.dsn#">
      select  bca_bcaid
      from  blogCategories
      where
        <cfif isDefined("ARGUMENTS.id")>
        bca_bcaid = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
        </cfif>
        <cfif isDefined("ARGUMENTS.name")>
        bca_name = <cfqueryparam value="#ARGUMENTS.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
        </cfif>
        and blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">

    </cfquery>

    <cfreturn checkC.RecordCount gte 1>

  </cffunction>

  <cffunction name="confirmSubscription" access="public" returnType="void" output="false" hint="Confirms a user's subscription to the blog.">
    <cfargument name="token" type="uuid" required="false">
    <cfargument name="email" type="string" required="false">

    <cfquery datasource="#instance.dsn#">
    update  blogSubscribers
    set    verified = 1
    <cfif structKeyExists(arguments, "token")>
    where  token = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.token#">
    <cfelseif structKeyExists(arguments, "email")>
    where  email = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#ARGUMENTS.email#">
    <cfelse>
      <cfthrow message="Invalid call to confirmSubscription. Must pass token or email.">
    </cfif>
    </cfquery>

  </cffunction>

  <cffunction name="deleteCategory" access="public" returnType="void" roles="" output="false" hint="Deletes a category.">
    <cfargument name="id" type="uuid" required="true">

    <cfquery datasource="#instance.dsn#">
      delete from blogEntriesCategories
      where   bec_bcaid = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>

    <cfquery datasource="#instance.dsn#">
      delete from blogCategories
      where bca_bcaid = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="deleteComment" access="public" returnType="void" roles="" output="false" hint="Deletes a comment based on the comment's uuid.">
    <cfargument name="id" type="uuid" required="true">

    <cfquery datasource="#instance.dsn#">
      delete from blogComments
      where id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="deleteEntry" access="remote" returnType="void" roles="" output="false" hint="Deletes an entry, plus all comments.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var entry = "">
    <cfset var enclosure = "">

    <cfif entryExists(ARGUMENTS.id)>

      <!--- get the entry. we need it to clean up enclosure --->
      <cfset entry = getEntry(ARGUMENTS.id)>

      <cfif entry.enclosure neq "">
        <cfif fileExists(entry.enclosure)>
          <cffile action="delete" file="#entry.enclosure#">
        </cfif>
      </cfif>

      <cfquery datasource="#instance.dsn#">
        delete from blogEntries
        where id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
        and    blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      </cfquery>

      <cfquery datasource="#instance.dsn#">
        delete from blogEntriesCategories
        where entryidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      </cfquery>

      <cfquery datasource="#instance.dsn#">
        delete from blogComments
        where entryidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      </cfquery>

    </cfif>

  </cffunction>

  <cffunction name="deleteUser" access="public" returnType="void" output="false" hint="Deletes a user.">
    <cfargument name="username" type="string" required="true">

    <cfquery datasource="#instance.dsn#">
    delete from blogUsers
    where  blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    and    username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>

  </cffunction>

  <cffunction name="entryExists" access="private" returnType="boolean" output="false" hint="Returns true or false if an entry exists.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var getIt = "">

    <cfif not structKeyExists(variables, "existsCache")>
      <cfset VARIABLES.existsCache = structNew() />
    </cfif>

    <cfif structKeyExists(VARIABLES.existsCache, ARGUMENTS.id)>
      <cfreturn VARIABLES.existsCache[ARGUMENTS.id]>
    </cfif>

    <cfquery name="getIt" datasource="#instance.dsn#">
      select    blogEntries.id
      from    blogEntries
      where    blogEntries.id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
<!---       and      ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50"> --->
      <cfif not isBlogAuthorized()>
      and      posted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
      and      released = 1
      </cfif>
    </cfquery>

    <cfset VARIABLES.existsCache[ARGUMENTS.id] = getit.RecordCount gte 1>
    <cfreturn VARIABLES.existsCache[ARGUMENTS.id]>

  </cffunction>


  <cffunction name="generateRSS" access="remote" returnType="string" output="false" hint="Attempts to generate RSS v1 or v2">
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
    <cfset var cat = "">
    <cfset var lastid = "">
    <cfset var catid = "">
    <cfset var catlist = "">

    <!--- Right now, we force this in. Useful to limit throughput of RSS feed. I may remove this later. --->
    <cfif (structKeyExists(ARGUMENTS.params,"maxEntries") and ARGUMENTS.params.maxEntries gt 15) or not structKeyExists(ARGUMENTS.params,"maxEntries")>
      <cfset ARGUMENTS.params.maxEntries = 15>
    </cfif>

    <cfset articles = getEntries(ARGUMENTS.params)>
    <!--- copy over just the actual query --->
    <cfset articles = articles.entries>

    <cfif not find("-", z.utcHourOffset)>
      <cfset utcPrefix = " -">
    <cfelse>
      <cfset z.utcHourOffset = right(z.utcHourOffset, len(z.utcHourOffset) -1 )>
      <cfset utcPrefix = " +">
    </cfif>


    <cfif ARGUMENTS.version is 1>

      <cfsavecontent variable="header">
      <cfoutput>
      <?xml version="1.0" encoding="utf-8"?>

      <rdf:RDF
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
        xmlns:dc="http://pURL.org/dc/elements/1.1/"
        xmlns="http://pURL.org/rss/1.0/"
      >
      </cfoutput>
      </cfsavecontent>

      <cfsavecontent variable="channel">
      <cfoutput>
      <channel rdf:about="#xmlFormat(instance.blogURL)#">
      <title>#xmlFormat(instance.blogTitle)##xmlFormat(ARGUMENTS.additionalTitle)#</title>
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
      <description><cfif ARGUMENTS.mode is "short" and len(REReplaceNoCase(body,"<[^>]*>","","ALL")) gte ARGUMENTS.excerpt>#xmlFormat(left(REReplaceNoCase(body,"<[^>]*>","","ALL"),ARGUMENTS.excerpt))#...<cfelse>#xmlFormat(body & morebody)#</cfif></description>
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

    <cfelseif ARGUMENTS.version eq "2">

      <cfsavecontent variable="header">
      <cfoutput>
      <?xml version="1.0" encoding="utf-8"?>

      <rss version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##" xmlns:cc="http://web.resource.org/cc/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">

      <channel>
      <title>#xmlFormat(instance.blogTitle)##xmlFormat(ARGUMENTS.additionalTitle)#</title>
      <link>#xmlFormat(instance.blogURL)#</link>
      <description>#xmlFormat(instance.blogDescription)#</description>
      <language>#replace(lcase(instance.locale),'_','-','one')#</language>
      <pubDate>#dateFormat(blogNow(),"ddd, dd mmm yyyy") & " " & timeFormat(blogNow(),"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00"#</pubDate>
      <lastBuildDate>{LAST_BUILD_DATE}</lastBuildDate>
      <generator>BlogCFC</generator>
      <docs>http://blogs.law.harvard.edu/tech/rss</docs>
      <managingEditor>#xmlFormat(instance.owneremail)#</managingEditor>
      <webMaster>#xmlFormat(instance.owneremail)#</webMaster>
      <itunes:subtitle>#xmlFormat(instance.itunesSubtitle)#</itunes:subtitle>
      <itunes:summary>#xmlFormat(instance.itunesSummary)#</itunes:summary>
      <itunes:category text="Technology" />
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
        <cfif ARGUMENTS.mode is "short" and len(REReplaceNoCase(body,"<[^>]*>","","ALL")) gte ARGUMENTS.excerpt>
        #xmlFormat(left(REReplace(body,"<[^>]*>","","All"),ARGUMENTS.excerpt))#...
        <cfelse>#xmlFormat(body & morebody)#</cfif>
        </description>
        <cfset lastid = listLast(structKeyList(categories))>
        <cfloop item="catid" collection="#categories#">
        <category>#xmlFormat(categories[currentRow][catid])#</category>
        </cfloop>
        <pubDate>#dateStr#</pubDate>
        <guid>#xmlFormat(makeLink(id))#</guid>
        <!---
        <author>
        <name>#xmlFormat(name)#</name>
        </author>
        --->
        <cfif len(enclosure)>
        <enclosure url="#xmlFormat("#APPLICATION.PATH.ATTACH#/#REQUEST.BLOG#/#getFileFromPath(enclosure)#")#" length="#filesize#" type="#mimetype#"/>
        <cfif mimetype IS "audio/mpeg">
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

    <cfset var dtMonth = createDateTime(ARGUMENTS.year,ARGUMENTS.month,1,0,0,0)>
    <cfset var dtEndOfMonth = createDateTime(ARGUMENTS.year,ARGUMENTS.month,daysInMonth(dtMonth),23,59,59)>
    <cfset var days = "">

    <cfquery datasource="#instance.dsn#" name="days">
      select distinct extract(day from date_add(posted, interval #instance.offset# hour)) as posted_day
        from blogEntries
       where date_add(posted, interval #instance.offset# hour) >= <cfqueryparam value="#dtMonth#" cfsqltype="CF_SQL_TIMESTAMP">
        and date_add(posted, interval #instance.offset# hour) <= <cfqueryparam value="#dtEndOfMonth#" cfsqltype="CF_SQL_TIMESTAMP">
        and blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
        and date_add(posted, interval #instance.offset# hour) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#blogNow()#">
        and released = 1
    </cfquery>
    <cfreturn valueList(days.posted_day)>
  </cffunction>

  <cffunction name="getArchives" access="public" returnType="query" output="false" hint="I return a query containing all of the past months/years that have entries along with the entry count">
    <cfargument name="archiveYears" type="numeric" required="false" hint="Number of years back to pull archives for. This helps limit the result set that can be returned" default="0">
    <cfset var getMonthlyArchives = "" />
    <cfset var fromYear = year(now()) - ARGUMENTS.archiveYears />

    <cfquery name="getMonthlyArchives" datasource="#instance.dsn#">
      SELECT MONTH(blogEntries.posted) AS PreviousMonths,
           YEAR(blogEntries.posted) AS PreviousYears,
          COUNT(blogEntries.id) AS entryCount
      FROM blogEntries
      WHERE ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      <cfif ARGUMENTS.archiveYears gt 0>
      AND YEAR(blogEntries.posted) >= #fromYear#
      </cfif>
      GROUP BY YEAR(blogEntries.posted), MONTH(blogEntries.posted)
      ORDER BY PreviousYears DESC, PreviousMonths DESC
    </cfquery>

    <cfreturn getMonthlyArchives>
  </cffunction>

  <cffunction name="getBlogRoles" access="public" returnType="query" output="false">
    <cfset var q = "">

    <cfquery name="q" datasource="#instance.dsn#">
    select  id, role, description
    from  blogRoles
    </cfquery>

    <cfreturn q>
  </cffunction>

  <cffunction name="getCategories" access="remote" returnType="query" output="false" hint="Returns a query containing all of the categories as well as their count for a specified blog.">
    <cfargument name="usecache" type="boolean" required="false" default="true">
    <cfset var getC = "">
    <cfset var getTotal = "">
    <!--- get cats is expensive when not mssql, and really, it doesn't change too often, so I'm adding a cache --->
    <cfif structKeyExists(variables, "categoryCache") and ARGUMENTS.usecache>
      <cfreturn VARIABLES.categoryCache>
    </cfif>
    <cfquery name="getC" datasource="#instance.dsn#">
      select  blogCategories.bca_bcaid, blogCategories.bca_name, blogCategories.bca_alias
      from  blogCategories
      where  bca_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      order by blogCategories.bca_name
    </cfquery>
    <cfset queryAddColumn(getC, "entrycount", arrayNew(1))>
    <cfloop query="getC">
      <cfquery name="getTotal" datasource="#instance.dsn#">
        select  count(blogEntriesCategories.entryidfk) as total
        from  blogEntriesCategories, blogEntries
        where  blogEntriesCategories.  bec_bcaid = <cfqueryparam value="#bca_bcaid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
        and   blogEntriesCategories.entryidfk = blogEntries.id
        and   blogEntries.released = 1
      </cfquery>
      <cfif getTotal.RecordCount>
        <cfset querySetCell(getC, "entrycount", getTotal.total, currentRow)>
      <cfelse>
        <cfset querySetCell(getC, "entrycount", 0, currentRow)>
      </cfif>
    </cfloop>
    <cfset VARIABLES.categoryCache = getC>
    <cfreturn VARIABLES.categoryCache>
  </cffunction>

  <cffunction name="getCategoriesForEntry" access="remote" returnType="query" output="false" hint="Returns a query containing all of the categories for a specific blog entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var getC = "">

    <cfif not entryExists(ARGUMENTS.id)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.id# does not exist.")>
    </cfif>

    <!--- updated "VARIABLES.dsn" to "instance.dsn" (DS 8/22/06) --->
    <cfquery name="getC" datasource="#instance.dsn#">
      select  blogCategories.bca_bcaid, blogCategories.bca_name
      from  blogCategories, blogEntriesCategories
      where  blogCategories.bca_bcaid = blogEntriesCategories.  bec_bcaid
      and    blogEntriesCategories.entryidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>
    <cfreturn getC>

  </cffunction>

  <cffunction name="getCategory" access="remote" returnType="query" output="false" hint="Returns a query containing the category name and alias for a specific blog entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var getC = "">

    <cfquery name="getC" datasource="#instance.dsn#">
      select  bca_name, bca_alias
      from  blogCategories
      where  bca_bcaid = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>

    <cfif not getC.RecordCount>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.id# is not a valid category.")>
    </cfif>

    <cfreturn getC>

  </cffunction>

  <cffunction name="getCategoryByAlias" access="remote" returnType="string" output="false" hint="Returns the category name for a specific category alias.">
    <cfargument name="alias" type="string" required="true">
    <cfset var getC = "">

    <cfquery name="getC" datasource="#instance.dsn#">
      select  bca_bcaid
      from  blogCategories
      where  bca_alias = <cfqueryparam value="#ARGUMENTS.alias#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>

    <cfreturn getC.bca_bcaid>

  </cffunction>

  <!--- This method originally written for parseses, but is not used. Keeping it around though. --->
  <cffunction name="getCategoryByName" access="remote" returnType="string" output="false" hint="Returns the category id for a specific category name.">
    <cfargument name="name" type="string" required="true">
    <cfset var getC = "">

    <cfquery name="getC" datasource="#instance.dsn#">
      select  bca_bcaid
      from  blogCategories
      where  bca_name = <cfqueryparam value="#ARGUMENTS.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>

    <cfreturn getC.bca_bcaid>

  </cffunction>

  <cffunction name="getComment" access="remote" returnType="query" output="false" hint="Gets a specific comment by comment ID.">
    <cfargument name="id" type="uuid" required="true">
    <cfset var getC = "">
    <cfquery name="getC" datasource="#instance.dsn#">
      select    id, entryidfk, name, email, bco_website, comment, posted, subscribe, bco_moderated, bco_kill, usid
      from    blogComments
      where    id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>
    <cfreturn getC>
  </cffunction>

  <!--- RBB 8/23/2010: Added a new method to get comment count for an entry --->
  <cffunction name="getCommentCount" access="remote" returnType="numeric"  output="false" hint="Gets the total number of comments for a blog entry">
    <cfargument name="id" type="uuid" required="true">

    <cfquery name="getCommentCount" datasource="#instance.dsn#">
      select count(id) as commentCount
      from  blogComments
      where  entryidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">

      <cfif instance.moderate>
        and bco_moderated = 1
      </cfif>
      and (bco_subscribeonly = 0 or bco_subscribeonly is null)
    </cfquery>

    <cfreturn getCommentCount.commentCount>
  </cffunction>

  <cffunction name="getComments" access="remote" returnType="query" output="false" hint="Gets all comments for an entry ID.">
    <cfargument name="id" type="uuid" required="false">
    <cfargument name="sortdir" type="string" required="false" default="asc">
    <cfargument name="includesubscribers" type="boolean" required="false" default="false">
    <cfargument name="search" type="string" required="false">
    <cfset var getC = "">
    <cfif structKeyExists(arguments, "id") and not entryExists(ARGUMENTS.id)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.id# does not exist.")>
    </cfif>
    <cfif ARGUMENTS.sortDir is not "asc" and ARGUMENTS.sortDir is not "desc">
      <cfset ARGUMENTS.sortDir = "asc">
    </cfif>
    <cfquery name="getC" datasource="#instance.dsn#">
      SELECT blogComments.id, blogComments.name, blogComments.email, blogComments.bco_website,
           blogComments.comment, blogComments.posted, blogComments.subscribe, blogEntries.title as entrytitle, blogComments.entryidfk,
           CAST(md5(blogComments.email) AS CHAR) AS gravatar, IF(LENGTH(avatar)=0, 'zombatar.jpg', avatar) AS avatar, blogComments.usid
        FROM blogComments
           INNER JOIN blogEntries ON blogComments.entryidfk = blogEntries.id
           LEFT OUTER JOIN forum_users AS fu ON fu.usid = blogComments.usid
       WHERE 1=1
      <cfif structKeyExists(arguments, "search")>
        AND (
            blogComments.comment LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.search#%">
            OR
            blogComments.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.search#%">
          )
      </cfif>
      <cfif structKeyExists(arguments, "id")>
        AND blogComments.entryidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      </cfif>
        AND ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      <cfif instance.moderate>
        AND blogComments.bco_moderated = 1
      </cfif>
      <cfif not ARGUMENTS.includesubscribers>
        AND (bco_subscribeonly = 0 OR bco_subscribeonly IS NULL)
      </cfif>
      ORDER BY blogComments.posted #ARGUMENTS.sortdir#
    </cfquery>
    <cfreturn getC>
  </cffunction>

  <!--- Deprecated --->
  <cffunction name="getEntry" access="remote" returnType="struct" output="false" hint="Returns one particular entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfargument name="dontlog" type="boolean" required="false" default="false">
    <cfset var getIt = "">
    <cfset var s = structNew()>
    <cfset var col = "">
    <cfset var getCategories = "">

    <cfif not entryExists(ARGUMENTS.id)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.id# does not exist.")>
    </cfif>

    <cfquery name="getIt" datasource="#instance.dsn#">
      select  blogEntries.id, blogEntries.title, date_add(posted, interval #instance.offset# hour) as posted,
            blogEntries.body,
            blogEntries.morebody, blogEntries.alias, blogEntries.allowcomments,
            blogEntries.enclosure, blogEntries.filesize, blogEntries.mimetype, blogEntries.released, blogEntries.mailed,
            blogEntries.summary, blogEntries.keywords, blogEntries.subtitle, blogEntries.duration,
            IF(us_last="", us_user, trim(concat(us_first, " ", us_last))) AS name
      from    blogEntries, bih.users
      where    blogEntries.id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      and      ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      and      blogEntries.username = bih.users.us_user
    </cfquery>

    <cfquery name="getCategories" datasource="#instance.dsn#">
      select  bca_bcaid,bca_name
      from  blogCategories, blogEntriesCategories
      where  blogEntriesCategories.entryidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      and    blogEntriesCategories.  bec_bcaid = blogCategories.bca_bcaid
    </cfquery>

    <cfloop index="col" list="#getIt.columnList#">
      <cfset s[col] = getIt[col][1]>
    </cfloop>

    <cfset s.categories = structNew()>
    <cfloop query="getCategories">
      <cfset s.categories[bca_bcaid] = bca_name>
    </cfloop>

    <!--- Handle view --->
    <cfif not ARGUMENTS.dontlog>
      <cfquery datasource="#instance.dsn#">
      update  blogEntries
      set    views = views + 1
      where  id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      </cfquery>
    </cfif>

    <cfreturn s>

  </cffunction>

  <cffunction name="getEntries" access="remote" returnType="struct" output="false" hint="Returns entries. Allows for a params structure to configure what entries are returned.">
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
    <cfif not structKeyExists(ARGUMENTS.params,"orderBy") or not listFindNoCase(validOrderBy,ARGUMENTS.params.orderBy)>
      <cfset ARGUMENTS.params.orderBy = "posted">
    </cfif>
    <!--- By default, order the results direction desc --->
    <cfif not structKeyExists(ARGUMENTS.params,"orderByDir") or not listFindNoCase(validOrderByDir,ARGUMENTS.params.orderByDir)>
      <cfset ARGUMENTS.params.orderByDir = "desc">
    </cfif>
    <!--- If lastXDays is passed, verify X is int between 1 and 365 --->
    <cfif structKeyExists(ARGUMENTS.params,"lastXDays")>
      <cfif not val(ARGUMENTS.params.lastXDays) or val(ARGUMENTS.params.lastXDays) lt 1 or val(ARGUMENTS.params.lastXDays) gt 365>
        <cfset structDelete(ARGUMENTS.params,"lastXDays")>
      <cfelse>
        <cfset ARGUMENTS.params.lastXDays = val(ARGUMENTS.params.lastXDays)>
      </cfif>
    </cfif>
    <!--- If byDay is passed, verify X is int between 1 and 31 --->
    <cfif structKeyExists(ARGUMENTS.params,"byDay")>
      <cfif not val(ARGUMENTS.params.byDay) or val(ARGUMENTS.params.byDay) lt 1 or val(ARGUMENTS.params.byDay) gt 31>
        <cfset structDelete(ARGUMENTS.params,"byDay")>
      <cfelse>
        <cfset ARGUMENTS.params.byDay = val(ARGUMENTS.params.byDay)>
      </cfif>
    </cfif>
    <!--- If byMonth is passed, verify X is int between 1 and 12 --->
    <cfif structKeyExists(ARGUMENTS.params,"byMonth")>
      <cfif not val(ARGUMENTS.params.byMonth) or val(ARGUMENTS.params.byMonth) lt 1 or val(ARGUMENTS.params.byMonth) gt 12>
        <cfset structDelete(ARGUMENTS.params,"byMonth")>
      <cfelse>
        <cfset ARGUMENTS.params.byMonth = val(ARGUMENTS.params.byMonth)>
      </cfif>
    </cfif>
    <!--- If byYear is passed, verify X is int  --->
    <cfif structKeyExists(ARGUMENTS.params,"byYear")>
      <cfif not val(ARGUMENTS.params.byYear)>
        <cfset structDelete(ARGUMENTS.params,"byYear")>
      <cfelse>
        <cfset ARGUMENTS.params.byYear = val(ARGUMENTS.params.byYear)>
      </cfif>
    </cfif>
    <!--- If byTitle is passed, verify we have a length  --->
    <cfif structKeyExists(ARGUMENTS.params,"byTitle")>
      <cfif not len(trim(ARGUMENTS.params.byTitle))>
        <cfset structDelete(ARGUMENTS.params,"byTitle")>
      <cfelse>
        <cfset ARGUMENTS.params.byTitle = trim(ARGUMENTS.params.byTitle)>
      </cfif>
    </cfif>

    <!--- By default, get body, commentCount and categories as well, requires additional lookup --->
    <cfif not structKeyExists(ARGUMENTS.params,"mode") or not listFindNoCase(validMode,ARGUMENTS.params.mode)>
      <cfset ARGUMENTS.params.mode = "full">
    </cfif>
    <!--- handle searching --->
    <cfif structKeyExists(ARGUMENTS.params,"searchTerms") and not len(trim(ARGUMENTS.params.searchTerms))>
      <cfset structDelete(ARGUMENTS.params,"searchTerms")>
    </cfif>
    <!--- Limit number returned. Thanks to Rob Brooks-Bilson --->
    <cfif not structKeyExists(ARGUMENTS.params,"maxEntries") or (structKeyExists(ARGUMENTS.params,"maxEntries") and not val(ARGUMENTS.params.maxEntries))>
      <cfset ARGUMENTS.params.maxEntries = 10>
    </cfif>

    <cfif not structKeyExists(ARGUMENTS.params,"startRow") or (structKeyExists(ARGUMENTS.params,"startRow") and not val(ARGUMENTS.params.startRow))>
      <cfset ARGUMENTS.params.startRow = 1>
    </cfif>

    <!--- I get JUST the ids --->
    <cfquery name="getIds" datasource="#instance.dsn#">
    select blogEntries.id
    from  blogEntries
      <!--- , blogUsers --->
      <cfif structKeyExists(ARGUMENTS.params,"byCat")>,blogEntriesCategories</cfif>
      where    1=1
            and ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
<!---   and blogEntries.username = blogUsers.username  and  ben_blog = blogUsers.blog --->
      <cfif structKeyExists(ARGUMENTS.params,"lastXDays")>
        and blogEntries.posted >= <cfqueryparam value="#dateAdd("d",-1*ARGUMENTS.params.lastXDays,blogNow())#" cfsqltype="CF_SQL_DATE">
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byDay")>
        and dayOfMonth(date_add(posted, interval #instance.offset# hour)) = <cfqueryparam value="#ARGUMENTS.params.byDay#" cfsqltype="CF_SQL_NUMERIC">
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byMonth")>
        and month(date_add(posted, interval #instance.offset# hour)) = <cfqueryparam value="#ARGUMENTS.params.byMonth#" cfsqltype="CF_SQL_NUMERIC">
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byYear")>
        and year(date_add(posted, interval #instance.offset# hour)) = <cfqueryparam value="#ARGUMENTS.params.byYear#" cfsqltype="CF_SQL_NUMERIC">
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byTitle")>
        and blogEntries.title = <cfqueryparam value="#ARGUMENTS.params.byTitle#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byCat")>
        and blogEntriesCategories.entryidfk = blogEntries.id
        and blogEntriesCategories.  bec_bcaid in (<cfqueryparam value="#ARGUMENTS.params.byCat#" cfsqltype="CF_SQL_VARCHAR" maxlength="35" list=true>)
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byPosted")>
        and blogEntries.username =  <cfqueryparam value="#ARGUMENTS.params.byPosted#" cfsqltype="CF_SQL_VARCHAR" maxlength="50" list=true>
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"searchTerms")>
        <cfif not structKeyExists(ARGUMENTS.params, "dontlogsearch")>
          <cfset logSearch(ARGUMENTS.params.searchTerms)>
        </cfif>
          and (blogEntries.title like '%#ARGUMENTS.params.searchTerms#%' OR blogEntries.body like '%#ARGUMENTS.params.searchTerms#%' or blogEntries.morebody like '%#ARGUMENTS.params.searchTerms#%')
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byEntry")>
        and blogEntries.id = <cfqueryparam value="#ARGUMENTS.params.byEntry#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      </cfif>
      <cfif structKeyExists(ARGUMENTS.params,"byAlias")>
        and blogEntries.alias = <cfqueryparam value="#left(ARGUMENTS.params.byAlias,100)#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
      </cfif>
      <!--- Don't allow future posts unless logged in. --->
      <cfif not isBlogAuthorized() or (structKeyExists(ARGUMENTS.params, "releasedonly") and ARGUMENTS.params.releasedonly)>
          and      posted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        and      released = 1
      </cfif>

      <cfif structKeyExists(ARGUMENTS.params, "released")>
      and  released = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.params.released#">
      </cfif>

      order by  blogEntries.#ARGUMENTS.params.orderBy# #ARGUMENTS.params.orderByDir#
    </cfquery>

    <!--- we now have a query from row 1 to our max, we need to get a 'page' of IDs --->
    <cfset idList = valueList(getIds.id)>
    <cfif idList eq "">
      <!---// the we need the "title" column for the spryproxy.cfm //--->
      <cfset r.entries = queryNew("id, title, posted")>
      <cfset r.totalEntries = 0>
      <cfreturn r>
    </cfif>

    <cfloop index="x" from="#ARGUMENTS.params.startRow#" to="#min(ARGUMENTS.params.startRow+ARGUMENTS.params.maxEntries-1,getIds.RecordCount)#">
      <cfset pageIdList = listAppend(pageIdList, listGetAt(idlist,x))>
    </cfloop>

    <!--- I now get the full info --->
    <cfquery name="getEm" datasource="#instance.dsn#" maxrows="#ARGUMENTS.params.maxEntries+ARGUMENTS.params.startRow-1#">
      select
          blogEntries.id, blogEntries.title,
          blogEntries.alias, date_add(posted, interval #instance.offset# hour) as posted,
          blogEntries.allowcomments,
          blogEntries.enclosure, blogEntries.filesize, blogEntries.mimetype, blogEntries.released, blogEntries.views,
          blogEntries.summary, blogEntries.subtitle, blogEntries.keywords, blogEntries.duration,
          <cfif ARGUMENTS.params.mode is "full"> blogEntries.body, blogEntries.morebody,</cfif>
          IF(us_last="", us_user, trim(concat(us_first, " ", us_last))) AS name
      from blogEntries, bih.users
      where
        blogEntries.id in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#pageIdList#">)
            and ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
            and blogEntries.username = bih.users.us_user
      order by blogEntries.#ARGUMENTS.params.orderBy# #ARGUMENTS.params.orderByDir#
    </cfquery>

    <cfif ARGUMENTS.params.mode is "full" and getEm.RecordCount>
      <cfset queryAddColumn(getEm,"commentCount",arrayNew(1))>
      <cfquery name="getComments" datasource="#instance.dsn#">
        select count(id) as commentCount, entryidfk
        from  blogComments
        where  entryidfk in (<cfqueryparam value="#valueList(getEm.id)#" cfsqltype="CF_SQL_VARCHAR" list="Yes">)
        <!--- added 12/5/2006 by Trent Richardson --->
        <cfif instance.moderate>
          and bco_moderated = 1
        </cfif>
        and (bco_subscribeonly = 0 or bco_subscribeonly is null)
        group by entryidfk
      </cfquery>
      <cfif getComments.RecordCount>
        <!--- for each row, need to find in getEm --->
        <cfloop query="getComments">
          <cfset pos = listFindNoCase(valueList(getEm.id),entryidfk)>
          <cfif pos>
            <cfset querySetCell(getEm,"commentCount",commentCount,pos)>
          </cfif>
        </cfloop>
      </cfif>
      <cfset queryAddColumn(getEm,"categories",arrayNew(1))>
      <cfloop query="getEm">
        <cfquery name="getCategories" datasource="#instance.dsn#">
          select  bca_bcaid,bca_name
          from  blogCategories, blogEntriesCategories
          where  blogEntriesCategories.entryidfk = <cfqueryparam value="#getEm.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
          and    blogEntriesCategories.  bec_bcaid = blogCategories.bca_bcaid
        </cfquery>
        <!---
        <cfset querySetCell(getEm,"bca_bcaids",valueList(getCategories.bca_bcaid),currentRow)>
        <cfset querySetCell(getEm,"bca_names",valueList(getCategories.bca_name),currentRow)>
        --->
        <cfset catData = structNew()>
        <cfloop query="getCategories">
          <cfset catData[bca_bcaid] = bca_name>
        </cfloop>
        <cfset querySetCell(getEm,"categories",catData,currentRow)>
      </cfloop>

    </cfif>
    <cfset r.entries = getEm>
    <cfset r.totalEntries = getIds.RecordCount>

    <cfreturn r>

  </cffunction>

  <!--- RBB 8/24/2010: New method to get the date an entry was posted. Added as
      a method since it's used by several other methods --->
  <cffunction name="getEntryPostedDate" access="public" returnType="date" output="false" hint="Returns the date/time an entry was posted">
    <cfargument name="entryId" type="uuid" required="true" hint="UUID of the entry you want to get post date for.">

    <cfset var getPostedDate = "" />

     <cfquery name="getPostedDate" datasource="#instance.dsn#">
        select posted
        from blogEntries
        where id = <cfqueryparam value="#ARGUMENTS.entryId#" cfsqltype="CF_SQL_VARCHAR" maxlength="35" />
    </cfquery>

    <cfreturn getPostedDate.posted>
  </cffunction>

  <cffunction name="getNameForUser" access="public" returnType="string" output="false" hint="Returns the full name of a user.">
    <cfargument name="username" type="string" required="true" />
    <cfset var q = "" />

    <cfquery name="q" datasource="#APPLICATION.DSN.MAIN#">
      SELECT IF(us_last="", us_user, trim(concat(us_first, " ", us_last))) AS name
        FROM users
       WHERE us_user = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#" maxlength="50">
    </cfquery>

    <cfreturn q.name>
  </cffunction>

  <cffunction name="getNumberUnbco_moderated" access="public" returntype="numeric" output="false" hint="Returns the number of unmodderated comments for a specific blog entry.">
    <cfset var getUnbco_moderated = "" />
    <cfquery name="getUnbco_moderated" datasource="#instance.dsn#">
      select count(c.bco_moderated) as unbco_moderated
      from blogComments c, blogEntries e
      where c.bco_moderated=0
      and   e.blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      and c.entryidfk = e.id
    </cfquery>

    <cfreturn getUnbco_moderated.unbco_moderated>
  </cffunction>

  <cffunction name="getProperties" access="public" returnType="struct" output="false">
    <cfreturn duplicate(instance)>
  </cffunction>

  <cffunction name="getProperty" access="public" returnType="any" output="false">
    <cfargument name="property" type="string" required="true">

    <cfif not structKeyExists(instance,ARGUMENTS.property)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.property# is not a valid property.")>
    </cfif>

    <cfreturn instance[ARGUMENTS.property]>

  </cffunction>

  <cffunction name="getRecentComments" access="remote" returnType="query" output="false" hint="Returns the last N comments for a specific blog.">
    <cfargument name="maxEntries" type="numeric" required="false" default="10">
    <cfset var getRecentComments = "" />
    <cfquery datasource="#instance.dsn#" name="getRecentComments">
      select e.id as entryID, e.title, c.id, c.entryidfk, c.name, c.email, c.comment, date_add(c.posted, interval #instance.offset# hour) as posted
        from blogComments c
           inner join blogEntries e on c.entryidfk = e.id
       where blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      <cfif instance.moderate>
        and c.bco_moderated = 1
      </cfif>
       order by c.posted desc
       limit #ARGUMENTS.maxEntries#
    </cfquery>
    <cfreturn getRecentComments>
   </cffunction>

  <!--- TODO: Take a look at this, something seems wrong. --->
  <cffunction name="getRelatedBlogEntries" access="remote" returntype="query" output="true" hint="returns related entries for a specific blog entry.">
     <cfargument name="entryId" type="uuid" required="true" />
     <cfargument name="bDislayBackwardRelations" type="boolean" hint="Displays related entries that set from another entry" default="true" />
     <cfargument name="bDislayFutureLinks" type="boolean" hint="Displays related entries that occur after the posted date of THIS entry" default="true" />
     <cfargument name="bDisplayForAdmin" type="boolean" hint="If admin, we can show future links not released to public" default="false" />

     <cfset var qEntries = "" />

    <!--- BEGIN : added bca_bcaid to related blog entry query : cjg : 31 december 2005 --->
    <!--- <cfset var qRelatedEntries = queryNew("id,title,posted,alias") />  --->
    <cfset var qRelatedEntries = queryNew("id,title,posted,alias,bca_name") />
    <!--- END : added bca_bcaid to related blog entry query : cjg : 31 december 2005 --->

     <cfset var qThisEntry = "" />
     <cfset var getRelatedIds = "" />
    <cfset var getThisRelatedEntry = "" />
    <!--- RBB 8/23/2010: Refactored to use new method getEntryPostedDate --->
    <cfset var postedDate = "" />

      <cfif bdislayfuturelinks is false>
      <!--- RBB 8/23/2010: Refactored to use new method getEntryPostedDate --->
      <cfset postedDate = SESSION.BROG.getEntryPostedDate(entryID=#ARGUMENTS.entryId#)>
    </cfif>
     <cfquery name="getRelatedIds" datasource="#instance.dsn#">
      select distinct relatedid
      from blogEntriesRelated
      where entryid = <cfqueryparam value="#ARGUMENTS.entryId#" cfsqltype="CF_SQL_VARCHAR" maxlength="35" />

      <cfif bDislayBackwardRelations>
      union

      select distinct entryid as relatedid
      from blogEntriesRelated
      where relatedid = <cfqueryparam value="#ARGUMENTS.entryId#" cfsqltype="CF_SQL_VARCHAR" maxlength="35" />
      </cfif>
     </cfquery>
     <cfloop query="getRelatedIds">
    <cfquery name="getThisRelatedEntry" datasource="#instance.dsn#">
      select blogEntries.id, blogEntries.title, blogEntries.posted, blogEntries.alias, blogCategories.bca_name
        from blogCategories
           inner join blogEntriesCategories on blogCategories.bca_bcaid = blogEntriesCategories.  bec_bcaid
           inner join blogEntries on blogEntriesCategories.entryidfk = blogEntries.id
       where blogEntries.id = <cfqueryparam value="#getrelatedids.relatedid#" cfsqltype="cf_sql_varchar" maxlength="35" />
        and ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="255">
      <cfif bdislayfuturelinks is false>
        and blogEntries.posted <= #createodbcdatetime(postedDate)#
      </cfif>
      <cfif not ARGUMENTS.bDisplayForAdmin>
        and posted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        and released = 1
      </cfif>
    </cfquery>
      <cfif getThisRelatedEntry.RecordCount>
        <cfset queryAddRow(qRelatedEntries, 1) />
        <cfset querySetCell(qRelatedEntries, "id", getThisRelatedEntry.id) />
        <cfset querySetCell(qRelatedEntries, "title", getThisRelatedEntry.title) />
        <cfset querySetCell(qRelatedEntries, "posted", getThisRelatedEntry.posted) />
        <cfset querySetCell(qRelatedEntries, "alias", getThisRelatedEntry.alias) />
        <!--- BEGIN : added bca_name to query : cjg : 31 december 2005 --->
        <cfset querySetCell(qRelatedEntries, "bca_name", getThisRelatedEntry.bca_name) />
        <!--- END : added bca_name to query : cjg : 31 december 2005 --->
      </cfif>
    </cfloop>
    <cfif qRelatedEntries.RecordCount>
      <!--- Order By --->
      <cfquery name="qRelatedEntries" dbtype="query">
        select *
          from qrelatedentries
         order by posted desc
      </cfquery>
     </cfif>

    <cfreturn qRelatedEntries />
  </cffunction>
  <!--- END : get related entries method : cjg  --->

  <!--- RBB 8/23/2010: Added a new method to get related blog entry count for a given entry --->
  <cffunction name="getRelatedBlogEntryCount" access="remote" returnType="numeric"  output="false" hint="Gets the total number of related blog entriess for for a specific blog entry">
    <cfargument name="entryId" type="uuid" required="true" hint="UUID of the entry you want to get the count for.">
     <cfargument name="bDislayBackwardRelations" type="boolean" hint="Display related entries that set from another entry" default="true" />
    <cfargument name="bDislayFutureLinks" type="boolean" hint="Display related entries that occur after the posted date of THIS entry. If true, this will return the count for items that have a future publishing date." default="true" />
    <cfargument name="bDisplayForAdmin" type="boolean" hint="If admin, we can show future links not released to public" default="false" />

    <cfset var postedDate = "" />
    <cfset var getRelatedBlogEntryCount = "" />

    <cfif ARGUMENTS.bDislayFutureLinks is false>
      <cfset postedDate = SESSION.BROG.getEntryPostedDate(entryID=#ARGUMENTS.entryId#)>
    </cfif>

    <cfquery name="getRelatedBlogEntryCount" datasource="#instance.dsn#">
      SELECT count(entryId) AS relatedEntryCount
        FROM blogEntriesRelated, blogEntries
        WHERE blogEntriesRelated.entryID = blogEntries.id
        AND (blogEntriesRelated.entryid = <cfqueryparam value="#ARGUMENTS.entryId#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      <cfif ARGUMENTS.bDislayBackwardRelations>
        OR blogEntriesRelated.relatedid = <cfqueryparam value="#ARGUMENTS.entryId#" cfsqltype="CF_SQL_VARCHAR" maxlength="35" />
      </cfif>
        )
        <cfif bdislayfuturelinks is false>
        AND blogEntries.posted <= #createodbcdatetime(postedDate)#
        </cfif>
      <cfif ARGUMENTS.bDisplayForAdmin is false>
          AND  blogEntries.posted < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
      </cfif>
        AND  blogEntries.released = 1
    </cfquery>

    <cfreturn getRelatedBlogEntryCount.relatedEntryCount>
  </cffunction>

  <cffunction name="getRelatedEntriesSelects" access="remote" returntype="query" output="false" hint="Returns a query containing all entries - designed to be used in the admin for
        selecting related entries.">
    <cfset var getRelatedP = "" />

    <cfquery name="getRelatedP" datasource="#instance.dsn#">
      select
        blogCategories.bca_name,
        blogEntries.id,
        blogEntries.title,
        blogEntries.posted
      from
        blogEntries inner join
          (blogCategories inner join blogEntriesCategories on blogCategories.bca_bcaid = blogEntriesCategories.  bec_bcaid) on
            blogEntries.id = blogEntriesCategories.entryidfk

      where bca_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
      order by
        blogCategories.bca_name,
        blogEntries.posted,
        blogEntries.title
    </cfquery>

    <cfreturn getRelatedP />
  </cffunction>

  <cffunction name="getSubscribers" access="public" returnType="query" output="false" hint="Returns all people subscribed to the blog.">
    <cfargument name="verifiedonly" type="boolean" required="false" default="false">
    <cfset var getPeople = "">

    <cfquery name="getPeople" datasource="#instance.dsn#">
    select    email, token, verified
    from    blogSubscribers
    where    blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
    <cfif    ARGUMENTS.verifiedonly>
    and      verified = 1
    </cfif>
    order by  email asc
    </cfquery>

    <cfreturn getPeople>
  </cffunction>

  <cffunction name="getUnbco_moderatedComments" access="remote" returnType="query" output="false" hint="Gets unbco_moderated comments for an entry.">
    <cfargument name="id" type="uuid" required="false">
    <cfargument name="sortdir" type="string" required="false" default="asc">

    <cfset var getC = "">

    <cfif structKeyExists(arguments, "id") and not entryExists(ARGUMENTS.id)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.id# does not exist.")>
    </cfif>

    <cfif ARGUMENTS.sortDir is not "asc" and ARGUMENTS.sortDir is not "desc">
      <cfset ARGUMENTS.sortDir = "asc">
    </cfif>

    <!--- RBB 11/02/2005: Added bco_website to query --->
    <cfquery name="getC" datasource="#instance.dsn#">
      SELECT blogComments.id, blogComments.name, blogComments.email, blogComments.bco_website, blogComments.comment, blogComments.posted, blogComments.subscribe, blogEntries.title AS entrytitle, blogComments.entryidfk
        FROM blogComments, blogEntries
        WHERE blogComments.entryidfk = blogEntries.id
      <cfif structKeyExists(arguments, "id")>
        AND blogComments.entryidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      </cfif>
        AND ben_blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
        AND blogComments.bco_moderated = 0
       ORDER BY blogComments.posted #ARGUMENTS.sortdir#
    </cfquery>
    <cfreturn getC>

  </cffunction>

  <cffunction name="getUser" access="public" returnType="struct" output="false" hint="Returns a user for a blog.">
    <cfargument name="username" type="string" required="true">
    <cfset var q = "">
    <cfset var s = structNew()>

    <cfquery name="q" datasource="#instance.dsn#">
    select  username, password, name
    from  blogUsers
    where  blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    and    username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>
    <cfif q.RecordCount>
      <cfset s.username = q.username>
      <cfset s.password = q.password>
      <cfset s.name = q.name>
      <cfreturn s>
    <cfelse>
      <cfthrow message="Unknown user #ARGUMENTS.username# for blog.">
    </cfif>

  </cffunction>

  <cffunction name="getUserByName" access="public" returnType="string" output="false" hint="Get username based on encoded name.">
    <cfargument name="name" type="string" required="true">
    <cfset var q = "">

    <cfquery name="q" datasource="#instance.dsn#">
    select  username
    from  blogUsers
    where  name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(ARGUMENTS.name,"_"," ","all")#" maxlength="50">
    </cfquery>

    <cfreturn q.username>

  </cffunction>

  <cffunction name="getUserBlogRoles" access="public" returnType="string" output="false" hint="Returns a list of the roles for a specific user.">
    <cfargument name="username" type="string" required="true">
    <cfset var q = "">
    <cfquery name="q" datasource="#instance.dsn#">
      select  blogRoles.id
      from  blogRoles
      left join blogUserRoles on blogUserRoles.roleidfk = blogRoles.id
      left join blogUsers on blogUserRoles.username = blogUsers.username
      where blogUsers.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#" maxlength="50">
      and blogUsers.blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>
    <cfreturn valueList(q.id)>
  </cffunction>

  <cffunction name="getUsers" access="public" returnType="query" output="false" hint="Returns users for a blog.">
    <cfset var q = "">

    <cfquery name="q" datasource="#instance.dsn#">
    select  username, name
    from  blogUsers
    where  blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>

    <cfreturn q>
  </cffunction>

  <cffunction name="getVersion" access="remote" returnType="string" output="false" hint="Returns the version of the blog.">
    <cfreturn VARIABLES.version>
  </cffunction>

  <cffunction name="isBlogAuthorized" access="public" returnType="boolean" output="false" hint="Simple wrapper to check session roles and see if you are cool to do stuff. Admin role can do all.">
    <cfif NOT SESSION.LoggedIn><cfreturn false /></cfif>
    <cfif isUserInRole("siteadmin")><cfreturn true /></cfif>
    <cfif NOT instance.SiteBlog>
      <cfreturn instance.name EQ SESSION.USER.user />
    </cfif>
    <cfreturn false />
  </cffunction>

  <cffunction name="bco_kill" access="public" returnType="void" output="false" hint="Deletes a comment based on a separate uuid to identify the comment in email to the blog admin.">
    <cfargument name="kid" type="uuid" required="true">
    <cfset var q = "">
    <!--- delete comment based on kill --->
    <cfquery name="q" datasource="#instance.dsn#">
      delete from blogComments
      where bco_kill = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.kid#" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="logSearch" access="private" returnType="void" output="false" hint="Logs the search.">
    <cfargument name="searchterm" type="string" required="true">

    <cfquery datasource="#instance.dsn#">
    insert into blogSearchStats(searchterm, searched, blog)
    values(
      <cfqueryparam value="#ARGUMENTS.searchterm#" cfsqltype="cf_sql_varchar" maxlength="255">,
      <cfqueryparam value="#blogNow()#" cfsqltype="cf_sql_timestamp">,
      <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
    )
    </cfquery>

  </cffunction>

  <cffunction name="logView" access="public" returnType="void" output="false" hint="Handles adding a view to an entry.">
    <cfargument name="entryid" type="uuid" required="true">

    <cfquery datasource="#instance.dsn#">
    update  blogEntries
    set    views = views + 1
    where  id = <cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="mailEntry" access="public" returnType="void" output="false" hint="Handles email for the blog.">
    <cfargument name="entryid" type="uuid" required="true">
    <cfset var entry = getEntry(ARGUMENTS.entryid,true)>
    <cfset var subscribers = getSubscribers(true)>
    <cfset var theMessage = "">
    <cfset var mailBody = "">
    <cfset var renderedText = renderEntry(entry.body,true,entry.enclosure)>
    <cfset var theLink = makeLink(entry.id)>
    <cfloop query="subscribers">
      <cfsavecontent variable="theMessage">
      <cfoutput>
<h2>#entry.title#</h2>
<b>URL:</b> <a href="#theLink#">#theLink#</a><br />
<b>Author:</b> #entry.name#<br />

#renderedText#<cfif len(entry.morebody)>
<a href="#theLink#">[Continued at Blog]</a></cfif>

<p>
You are receiving this email because you have subscribed to this blog.<br />
To unsubscribe, please go to this URL:
<a href="#APPLICATION.PATH.FULL#/b.unsubscribe.cfm?email=#email#&amp;token=#token#">#APPLICATION.PATH.FULL#/b.unsubscribe.cfm?email=#email#&amp;token=#token#</a>
</p>
      </cfoutput>
      </cfsavecontent>
      <cfset utils.mail(to=email,from=instance.owneremail,subject="#VARIABLES.utils.htmlToPlainText(htmlEditFormat(instance.blogtitle))# / #VARIABLES.utils.htmlToPlainText(entry.title)#",type="html",body=theMessage, failTo=instance.failTo, mailserver=instance.mailserver, mailusername=instance.mailusername, mailpassword=instance.mailpassword)>
    </cfloop>

    <!---
      update the record to mark it mailed.
      note: it is possible that an entry will never be marked mailed if your blog has
      no subscribers. I don't think this is an issue though.
    --->
    <cfquery datasource="#instance.dsn#">
    update blogEntries
    set    mailed = <cfqueryparam value="1" cfsqltype="CF_SQL_TINYINT">
    where  id = <cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR">
    </cfquery>


  </cffunction>

  <cffunction name="makeCategoryLink" access="public" returnType="string" output="false" hint="Generates links for a category.">
    <cfargument name="catid" type="uuid" required="true">
    <cfset var q = "">

    <!---// make sure the cache exists //--->
    <cfif not structKeyExists(variables, "catAliasCache")>
      <cfset VARIABLES.catAliasCache = structNew() />
    </cfif>

    <cfif structKeyExists(VARIABLES.catAliasCache, ARGUMENTS.catid)>
      <cfreturn VARIABLES.catAliasCache[ARGUMENTS.catid]>
    </cfif>

    <cfquery name="q" datasource="#instance.dsn#">
    select  bca_alias
    from  blogCategories
    where  bca_bcaid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.catid#" maxlength="35">
    </cfquery>

    <cfif q.bca_alias is not "">
      <cfset VARIABLES.catAliasCache[ARGUMENTS.catid] = "#instance.blogURL#/#q.bca_alias#">
    <cfelse>
      <cfset VARIABLES.catAliasCache[ARGUMENTS.catid] = "#instance.blogURL#?mode=cat&amp;catid=#ARGUMENTS.catid#">
    </cfif>
    <cfreturn VARIABLES.catAliasCache[ARGUMENTS.catid]>
  </cffunction>

  <cffunction name="makeUserLink" access="public" returnType="string" output="false" hint="Generates links for viewing blog posts by user/blog poster.">
    <cfargument name="name" type="string" required="true">
    <!--- <cfreturn "#instance.blogURL#/postedby/#replace(ARGUMENTS.name," ","_","all")#"> --->
    <cfreturn "#instance.blogURL#/postedby/#instance.name#">
  </cffunction>

  <cffunction name="cacheLink" access="public" returnType="struct" output="false" hint="Caches a link.">
    <cfargument name="entryid" type="uuid" required="true" />
    <cfargument name="alias" type="string" required="true" />
    <cfargument name="posted" type="date" required="true" />

    <!---// make sure the cache exists //--->
    <cfif not structKeyExists(variables, "lCache")>
      <cfset VARIABLES.lCache = structNew() />
    </cfif>

    <cfset VARIABLES.lCache[ARGUMENTS.entryid] = structNew() />
    <cfset VARIABLES.lCache[ARGUMENTS.entryid].alias = ARGUMENTS.alias />
    <cfset VARIABLES.lCache[ARGUMENTS.entryid].posted = ARGUMENTS.posted />

    <cfreturn arguments />
  </cffunction>

  <cffunction name="makeLink" access="public" returnType="string" output="false" hint="Generates links for an entry.">
    <cfargument name="entryid" type="uuid" required="true" />
    <cfargument name="updateCache" type="boolean" required="false" default="false" />
    <cfset var q = "">
    <cfset var realdate = "">

    <cfif not structKeyExists(variables, "lCache")>
      <cfset VARIABLES.lCache = structNew()>
    </cfif>

    <!---// if forcing the cache to be updated, remove the key //--->
    <cfif ARGUMENTS.updateCache>
      <cfset structDelete(VARIABLES.lCache, ARGUMENTS.entryid, true) />
    </cfif>

    <cfif not structKeyExists(VARIABLES.lCache, ARGUMENTS.entryid)>
      <cflock name="variablesLCache_#instance.name#" timeout="30" type="exclusive">
        <cfif not structKeyExists(VARIABLES.lCache, ARGUMENTS.entryid)>
          <cfquery name="q" datasource="#instance.dsn#">
          select  posted, alias
          from  blogEntries
          where  id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.entryid#" maxlength="35">
          </cfquery>
          <!---// cache the link //--->
          <cfset realdate = dateAdd("h", instance.offset, q.posted)>
          <cfset cacheLink(entryid=ARGUMENTS.entryid, alias=q.alias, posted=realdate) />
        <cfelse>
          <cfset q = structNew()>
          <cfset q.alias = VARIABLES.lCache[ARGUMENTS.entryid].alias>
          <cfset q.posted = VARIABLES.lCache[ARGUMENTS.entryid].posted>
        </cfif>
        </cflock>
    <cfelse>
      <cfset q = structNew()>
      <cfset q.alias = VARIABLES.lCache[ARGUMENTS.entryid].alias>
      <cfset q.posted = VARIABLES.lCache[ARGUMENTS.entryid].posted>
    </cfif>

    <cfif q.alias is not "">
      <cfreturn "#instance.blogURL#/#year(q.posted)#/#month(q.posted)#/#day(q.posted)#/#q.alias#">
    <cfelse>
      <cfreturn "#instance.blogURL#?mode=entry&amp;entry=#ARGUMENTS.entryid#">
    </cfif>
  </cffunction>

  <cffunction name="makeTitle" access="public" returnType="string" output="false" hint="Formats the title.">
    <cfargument name="title" type="string" required="true">

    <!--- Remove non alphanumeric but keep spaces. --->
    <!--- Changed to be more strict - Martin Baur noticed foreign chars getting through. THey
    ARE valid alphanumeric chars, but we don't want them. --->
    <!---
    <cfset ARGUMENTS.title = reReplace(ARGUMENTS.title,"[^[:alnum:] ]","","all")>
    --->
    <!---// replace the & symbol with the word "and" //--->
    <cfset ARGUMENTS.title = replace(ARGUMENTS.title, "&amp;", "and", "all") />
    <!---// remove html entities //--->
    <cfset ARGUMENTS.title = reReplace(ARGUMENTS.title, "&[^;]+;", "", "all") />
    <cfset ARGUMENTS.title = reReplace(ARGUMENTS.title,"[^0-9a-zA-Z ]","","all")>
    <!--- change spaces to - --->
    <cfset ARGUMENTS.title = replace(ARGUMENTS.title," ","-","all")>

    <cfreturn ARGUMENTS.title>
  </cffunction>

  <cffunction name="notifyEntry" access="public" returnType="void" output="false" hint="Sends a message to everyone in an entry.">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="message" type="string" required="true">
    <cfargument name="subject" type="string" required="true">
    <cfargument name="from" type="string" required="true">

    <!--- Both of these are related to comment moderation. --->
    <cfargument name="adminonly" type="boolean" required="false">
    <cfargument name="approved" type="boolean" required="false">
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
    <cfset var comment = getComment(ARGUMENTS.commentid)>
    <cfset var fromtouse = ARGUMENTS.from>
    <cfset var mailType = "text">

    <cfif ARGUMENTS.html>
      <cfset mailType = "html">
    </cfif>

    <cfif len(instance.commentsFrom)>
      <cfset fromtouse = instance.commentsFrom>
    </cfif>

    <!--- is it a valid entry? --->
    <cfif not entryExists(ARGUMENTS.entryid)>
      <cfset VARIABLES.utils.throw("#entryid# isn't a valid entry.")>
    </cfif>

    <!--- argument allows us to only send to the admin. --->
    <cfif not structKeyExists(arguments, "adminonly") or not ARGUMENTS.adminonly>

      <!--- First, get everyone in the thread --->
      <cfinvoke method="getComments" returnVariable="comments">
        <cfinvokeargument name="id" value="#ARGUMENTS.entryid#">
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
    <cfif not structKeyExists(arguments, "noadmin") or not ARGUMENTS.noadmin>
      <cfset emailAddresses[instance.ownerEmail] = "">
    </cfif>

    <!--- Don't send email to from --->
    <cfset structDelete(emailAddresses, ARGUMENTS.from)>

    <cfif not structIsEmpty(emailAddresses)>
      <!---
        Determine if we have a commentsFrom property. If so, it overrides this setting.
      --->
      <cfif getProperty("commentsFrom") neq "">
        <cfset ARGUMENTS.from = getProperty("commentsFrom")>
      </cfif>

      <cfloop item="address" collection="#emailAddresses#">
        <!--- determine if msg has an unsub token, if so, prepare the link --->
        <!---
          Note, right now, the email sent to the admin will have a blank
          commentID. Since the admin can't unsub anyway I don't think it
          is a huge deal.

          Btw - I've got some of the HTML design emedded in here. This because web based
          email readers require inline CSS. I could have passed it in as an argument but
          said frack it.
        --->
        <cfif findNoCase("%unsubscribe%", ARGUMENTS.message)>
          <cfif address is not instance.ownerEmail>
            <cfif instance.SiteBlog>
              <cfset ulink = "#APPLICATION.PATH.FULL#/b.unsubscribe.cfm?commentID=#emailAddresses[address]#&amp;email=#address#">
            <cfelse>
              <cfset ulink = "#APPLICATION.PATH.FULL#/#REQUEST.brewer#/blog/unsubscribe/p.brewer.cfm?commentID=#emailAddresses[address]#&amp;email=#address#">
            </cfif>
            <cfif mailType is "html">
              <cfset ulink = "<a href=""#ulink#"" style=""font-size:8pt;text-decoration:underline;color:##7d8524;text-decoration:none;"">Unsubscribe</a>">
            <cfelse>
              <cfset ulink = "Unsubscribe from Entry: #ulink#">
            </cfif>
          <cfelse>
            <cfset ulink = "">
            <!--- We get a bit fancier now as well as we will be allowing for kill switches --->
            <cfif mailType is "text">
              <cfset ulink = ulink & "#chr(10)#Delete this comment: #instance.blogURL#?bco_kill=#comment.bco_kill#">
            <cfelse>
              <cfset ulink = ulink & " <a href=""#instance.blogURL#?bco_kill=#comment.bco_kill#"" style=""font-size:8pt;text-decoration:underline;color:##7d8524;text-decoration:none;"">Delete</a>">
            </cfif>
            <!--- also allow for approving --->
            <cfif instance.moderate AND NOT StructKeyExists(ARGUMENTS, "Approved")>
              <cfif mailType is "text">
                <cfset ulink = ulink & "#chr(10)#Approve this comment: #instance.blogURL#?approvecomment=#comment.id#">
              <cfelse>
                <cfset ulink = ulink & " <a href=""#instance.blogURL#?approvecomment=#comment.id#"" style=""font-size:8pt;text-decoration:underline;color:##7d8524;text-decoration:none;"">Approve</a>">
              </cfif>
            </cfif>
          </cfif>
          <cfset theMessage = replaceNoCase(ARGUMENTS.message, "%unsubscribe%", ulink, "all")>
        <cfelse>
          <cfset theMessage = ARGUMENTS.message>
        </cfif>

        <cfset utils.mail(to=address,from=fromtouse,subject=VARIABLES.utils.htmlToPlainText(ARGUMENTS.subject),type=mailType,body=theMessage, failTo=instance.failTo, mailserver=instance.mailserver, mailusername=instance.mailusername, mailpassword=instance.mailpassword)>

      </cfloop>
    </cfif>

  </cffunction>

  <cffunction name="removeCategory" access="remote" returnType="void" roles="" output="false" hint="remove entry ID from category X">
    <cfargument name="entryid" type="uuid" required="true">
    <cfargument name="bca_bcaid" type="uuid" required="true">

    <cfquery datasource="#instance.dsn#">
      delete from blogEntriesCategories
      where   bec_bcaid = <cfqueryparam value="#ARGUMENTS.bca_bcaid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      and entryidfk = <cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>

  </cffunction>

  <cffunction name="removeCategories" access="remote" returnType="void" roles="" output="false" hint="Remove all categories from an entry.">
    <cfargument name="entryid" type="uuid" required="true">

    <cfquery datasource="#instance.dsn#">
      delete from blogEntriesCategories
      where  entryidfk = <cfqueryparam value="#ARGUMENTS.entryid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>
  </cffunction>

  <cffunction name="removeSubscriber" access="remote" returnType="boolean" output="false" hint="Removes a subscriber user.">
    <cfargument name="email" type="string" required="true">
    <cfargument name="token" type="uuid" required="false">
    <cfset var getMe = "">

    <cfif not isBlogAuthorized() and not structKeyExists(arguments,"token")>
      <cfset VARIABLES.utils.throw("Unauthorized removal.")>
    </cfif>

    <!--- First, lets see if this guy is already subscribed. --->
    <cfquery name="getMe" datasource="#instance.dsn#">
    select  email
    from  blogSubscribers
    where  email = <cfqueryparam value="#ARGUMENTS.email#" cfsqltype="cf_sql_varchar" maxlength="50">
    <cfif structKeyExists(arguments, "token")>
    and    token = <cfqueryparam value="#ARGUMENTS.token#" cfsqltype="cf_sql_varchar" maxlength="35">
    </cfif>
    </cfquery>

    <cfif getMe.RecordCount is 1>
      <cfquery datasource="#instance.dsn#">
      delete  from blogSubscribers
      where  email = <cfqueryparam value="#ARGUMENTS.email#" cfsqltype="cf_sql_varchar" maxlength="50">
      <cfif structKeyExists(arguments, "token")>
      and    token = <cfqueryparam value="#ARGUMENTS.token#" cfsqltype="cf_sql_varchar" maxlength="35">
      </cfif>
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
      </cfquery>

      <cfreturn true>
    <cfelse>
      <cfreturn false>
    </cfif>

  </cffunction>

  <cffunction name="removeUnverifiedSubscribers" access="remote" returnType="void" output="false" roles="" hint="Removes all subscribers who are not verified.">

    <cfquery datasource="#instance.dsn#">
    delete  from blogSubscribers
    where  blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
    and    verified = 0
    </cfquery>

  </cffunction>

  <cffunction name="renderEntry" access="public" returnType="string" output="true" hint="Handles rendering the blog entry.">
    <cfargument name="string" type="string" required="true">
    <cfargument name="printformat" type="boolean" required="false" default="false">
    <cfargument name="enclosure" type="string" required="false" default="">
    <cfargument name="ignoreParagraphFormat" type="boolean" required="false" default="false"/>
    <cfset var counter = "">
    <cfset var codeblock = "">
    <cfset var codeportion = "">
    <cfset var result = "">
    <cfset var newbody = "">
    <cfset var style = "">
    <cfset var imgURL = "">
    <cfset var textblock = "">
    <cfset var tbRegex = "">
    <cfset var textblockLabel = "">
    <cfset var textblockTag = "">
    <cfset var newContent = "">

    <cfset var cfc = "">
    <cfset var newstring = "">

    <!--- call our render funcs --->
    <cfloop item="cfc" collection="#VARIABLES.renderMethods#">
      <cfinvoke component="#VARIABLES.renderMethods[cfc].cfc#" method="renderDisplay" argumentCollection="#arguments#" returnVariable="newstring" />
      <cfset ARGUMENTS.string = newstring>
    </cfloop>

    <!--- New enclosure support. If enclose if a jpg, png, or gif, put it on top, aligned left. --->
    <cfif len(ARGUMENTS.enclosure) and listFindNoCase("gif,jpg,png", listLast(ARGUMENTS.enclosure, "."))>
      <cfset imgURL = "#APPLICATION.PATH.BLOGIMG#/#REQUEST.BLOG#/#urlEncodedFormat(getFileFromPath(enclosure))#">
      <cfset ARGUMENTS.string = "<div class=""autoImage""><img src=""#imgURL#""></div>" & ARGUMENTS.string>
    <!--- bmeloche - 06/13/2008 - Adding podcast support. --->
    <cfelseif len(ARGUMENTS.enclosure) and listFindNoCase("mp3", listLast(ARGUMENTS.enclosure, "."))>
      <cfset imgURL = "#APPLICATION.PATH.ATTACH#/#REQUEST.BLOG#/#urlEncodedFormat(getFileFromPath(enclosure))#">
      <cfset ARGUMENTS.string = "<div id=""#urlEncodedFormat(getFileFromPath(enclosure))#""></div>" & ARGUMENTS.string>
    </cfif>

    <!--- textblock support --->
    <cfset tbRegex = "<textblock[[:space:]]+label[[:space:]]*=[[:space:]]*""(.*?)"">">
    <cfif reFindNoCase(tbRegex,ARGUMENTS.string)>
      <cfset counter = reFindNoCase(tbRegex,ARGUMENTS.string)>
      <cfloop condition="counter gte 1">
        <cfset textblock = reFindNoCase(tbRegex,ARGUMENTS.string,1,1)>
        <cfif arrayLen(textblock.pos) is 2>
          <cfset textblockTag = mid(ARGUMENTS.string, textblock.pos[1], textblock.len[1])>
          <cfset textblockLabel = mid(ARGUMENTS.string, textblock.pos[2], textblock.len[2])>
          <cfset newContent = VARIABLES.textblock.getTextBlockContent(textblockLabel)>
          <cfset ARGUMENTS.string = replaceNoCase(ARGUMENTS.string, textblockTag, newContent)>
        </cfif>
        <cfset counter = reFindNoCase(tbRegex,ARGUMENTS.string, counter)>
      </cfloop>
    </cfif>

    <cfif not ARGUMENTS.ignoreParagraphFormat>
      <cfset ARGUMENTS.string = xhtmlParagraphFormat(ARGUMENTS.string) />
    </cfif>

    <cfreturn ARGUMENTS.string />
  </cffunction>

  <cffunction name="saveCategory" access="remote" returnType="void" roles="" output="false" hint="Saves a category.">
    <cfargument name="id" type="uuid" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="alias" type="string" required="true">
    <cfset var oldName = getCategory(ARGUMENTS.id).bca_name>

    <cflock name="blogcfc.addCategory" type="exclusive" timeout="30">

      <!--- new name? --->
      <cfif oldName neq ARGUMENTS.name>
        <cfif categoryExists(name="#ARGUMENTS.name#")>
          <cfset VARIABLES.utils.throw("#ARGUMENTS.name# already exists as a category.")>
        </cfif>
      </cfif>

      <cfquery datasource="#instance.dsn#">
      update  blogCategories
      set    bca_name = <cfqueryparam value="#ARGUMENTS.name#" cfsqltype="cf_sql_varchar" maxlength="50">,
          bca_alias = <cfqueryparam value="#ARGUMENTS.alias#" cfsqltype="cf_sql_varchar" maxlength="50">
      where  bca_bcaid = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar" maxlength="35">
      </cfquery>

    </cflock>

  </cffunction>

  <cffunction name="saveComment" access="public" returnType="uuid" output="false" hint="Saves a comment.">
    <cfargument name="commentid" type="uuid" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="email" type="string" required="true">
    <cfargument name="bco_website" type="string" required="true">
    <cfargument name="comments" type="string" required="true">
    <cfargument name="subscribe" type="boolean" required="true">
    <cfargument name="bco_moderated" type="boolean" required="true">

    <cfset ARGUMENTS.comments = htmleditformat(ARGUMENTS.comments)>
    <cfset ARGUMENTS.name = left(htmlEditFormat(ARGUMENTS.name),50)>
    <cfset ARGUMENTS.email = left(htmlEditFormat(ARGUMENTS.email),50)>
    <cfset ARGUMENTS.bco_website = left(htmlEditFormat(ARGUMENTS.bco_website),255)>
    <cfif ARGUMENTS.subscribe><cfset ARGUMENTS.subscribe = 1><cfelse><cfset ARGUMENTS.subscribe = 0></cfif>
    <cfquery datasource="#instance.dsn#">
      update blogComments
      set name = <cfqueryparam value="#ARGUMENTS.name#" maxlength="50">,
      email = <cfqueryparam value="#ARGUMENTS.email#" maxlength="50">,
      bco_website = <cfqueryparam value="#ARGUMENTS.bco_website#" maxlength="255">,
      comment = <cfqueryparam value="#ARGUMENTS.comments#" cfsqltype="CF_SQL_LONGVARCHAR">,
      subscribe = <cfqueryparam value="#ARGUMENTS.subscribe#" cfsqltype="CF_SQL_TINYINT">,
      bco_moderated= <cfqueryparam value="#ARGUMENTS.bco_moderated#" cfsqltype="CF_SQL_TINYINT">
      where  id = <cfqueryparam value="#ARGUMENTS.commentid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>
    <cfreturn ARGUMENTS.commentid>
  </cffunction>

  <cffunction name="saveEntry" access="remote" returnType="void" roles="" output="false" hint="Saves an entry.">
    <cfargument name="id" type="uuid" required="true">
    <cfargument name="title" type="string" required="true">
    <cfargument name="body" type="string" required="true">
    <cfargument name="morebody" type="string" required="false" default="">
    <cfargument name="alias" type="string" required="false" default="">
    <!--- I use "any" so I can default to a blank string --->
    <cfargument name="posted" type="any" required="false" default="">
    <cfargument name="allowcomments" type="boolean" required="false" default="true">
    <cfargument name="enclosure" type="string" required="false" default="">
    <cfargument name="filesize" type="numeric" required="false" default="0">
    <cfargument name="mimetype" type="string" required="false" default="">
    <cfargument name="released" type="boolean" required="false" default="true">
    <cfargument name="relatedPPosts" type="string" required="true" default="">
    <cfargument name="sendemail" type="boolean" required="false" default="true">
    <cfargument name="duration" type="string" required="false" default="">
    <cfargument name="subtitle" type="string" required="false" default="">
    <cfargument name="summary" type="string" required="false" default="">
    <cfargument name="keywords" type="string" required="false" default="">

    <cfset var theURL = "" />
    <cfset var entry = "" />

    <cfif not entryExists(ARGUMENTS.id)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.id# does not exist as an entry.")>
    </cfif>
    <cfif ARGUMENTS.allowcomments><cfset ARGUMENTS.allowcomments = 1><cfelse><cfset ARGUMENTS.allowcomments = 0></cfif>
    <cfif ARGUMENTS.released><cfset ARGUMENTS.released = 1><cfelse><cfset ARGUMENTS.released = 0></cfif>
    <cfquery datasource="#instance.dsn#">
      update blogEntries
      set    title = <cfqueryparam value="#ARGUMENTS.title#" cfsqltype="CF_SQL_CHAR" maxlength="100">,
          body = <cfqueryparam value="#ARGUMENTS.body#" cfsqltype="CF_SQL_LONGVARCHAR">
          <cfif len(ARGUMENTS.morebody)>
            ,morebody = <cfqueryparam value="#ARGUMENTS.morebody#" cfsqltype="CF_SQL_LONGVARCHAR">
           <cfelse>
            ,morebody = <cfqueryparam null="yes" cfsqltype="CF_SQL_LONGVARCHAR">
          </cfif>
          <cfif len(ARGUMENTS.alias)>
            ,alias = <cfqueryparam value="#ARGUMENTS.alias#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
          </cfif>
          <cfif (len(trim(ARGUMENTS.posted)) gt 0) and isDate(ARGUMENTS.posted)>
            ,posted = <cfqueryparam value="#ARGUMENTS.posted#" cfsqltype="CF_SQL_TIMESTAMP">
          </cfif>
            ,allowcomments = <cfqueryparam value="#ARGUMENTS.allowcomments#" cfsqltype="CF_SQL_TINYINT">
            ,enclosure = <cfqueryparam value="#ARGUMENTS.enclosure#" cfsqltype="CF_SQL_CHAR" maxlength="255">
          ,summary = <cfqueryparam value="#ARGUMENTS.summary#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
          ,subtitle = <cfqueryparam value="#ARGUMENTS.subtitle#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
          ,keywords = <cfqueryparam value="#ARGUMENTS.keywords#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
          ,duration = <cfqueryparam value="#ARGUMENTS.duration#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">
          ,filesize = <cfqueryparam value="#ARGUMENTS.filesize#" cfsqltype="CF_SQL_NUMERIC">
            ,mimetype = <cfqueryparam value="#ARGUMENTS.mimetype#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
            ,released = <cfqueryparam value="#ARGUMENTS.released#" cfsqltype="CF_SQL_TINYINT">
      where  id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
    </cfquery>

    <cfset saveRelatedEntries(ARGUMENTS.ID, ARGUMENTS.relatedpposts) />

    <!---// get the entry //--->
    <cfset entry = getEntry(ARGUMENTS.id, true) />

    <!---// update the link cache //--->
    <cfset cacheLink(entryid=ARGUMENTS.id, alias=entry.alias, posted=entry.posted) />

    <cfif ARGUMENTS.released>

      <cfif ARGUMENTS.sendEmail>
        <cfif dateCompare(dateAdd("h", instance.offset, entry.posted), blogNow()) is 1>
          <!--- Handle delayed posting --->
          <cfset theURL = APPLICATION.PATH.ROOT & "/x.notify.cfm?id=#id#">
          <cfschedule action="update" task="BlogCFC Notifier #id#" operation="HTTPRequest" startDate="#entry.posted#" startTime="#entry.posted#" url="#theURL#" interval="once">
        <cfelse>
          <cfset mailEntry(ARGUMENTS.id)>
        </cfif>
      </cfif>

      <cfif dateCompare(dateAdd("h", instance.offset, entry.posted), blogNow()) is not 1>
        <cfset VARIABLES.ping.pingAggregators(instance.pingurls, instance.blogtitle, instance.blogurl)>
      </cfif>

    </cfif>

  </cffunction>

  <cffunction name="saveRelatedEntries" access="public" returntype="void" roles="" output="false"
    hint="I add/update related blog entries">
    <cfargument name="ID" type="UUID" required="true" />
    <cfargument name="relatedpposts" type="string" required="true" />

    <cfset var ppost = "" />

    <cfquery datasource="#instance.dsn#">
      delete from
        blogEntriesRelated
      where
        entryid = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>

    <cfloop list="#ARGUMENTS.relatedpposts#" index="ppost">
      <cfquery datasource="#instance.dsn#">
        insert into
          blogEntriesRelated(
            entryid,
            relatedid
          ) values (
            <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
            <cfqueryparam value="#ppost#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
          )
      </cfquery>
    </cfloop>

  </cffunction>

  <cffunction name="saveUser" access="public" returnType="void" output="false" hint="Saves a user.">
    <cfargument name="username" type="string" required="true">
    <cfargument name="name" type="string" required="true">
    <cfargument name="password" type="string" required="false">
    <cfset var salt = generateSalt()>

    <cfquery datasource="#instance.dsn#">
    update  blogUsers
    set    name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.name#" maxlength="50">
        <cfif structKeyExists(arguments, "password")>
          ,password = <cfqueryparam value="#hash(salt & ARGUMENTS.password, instance.hashalgorithm)#" cfsqltype="cf_sql_varchar" maxlength="256">,
          salt = <cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar" maxlength="256">
        </cfif>
    where  username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#" maxlength="50">
    and    blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
    </cfquery>

  </cffunction>

  <cffunction name="setProperty" access="public" returnType="void" output="true" roles="">
    <cfargument name="property" type="string" required="true">
    <cfargument name="value" type="string" required="true">
    <cfset instance[ARGUMENTS.property] = ARGUMENTS.value>
    <!--- <cfset setProfileString(VARIABLES.cfgFile, instance.name, ARGUMENTS.property, ARGUMENTS.value)> --->
  </cffunction>

  <cffunction name="setbco_moderatedComment" access="public" returnType="void" output="false" roles="" hint="Sets a comment to approved">
    <cfargument name="id" type="string" required="true">

    <cfquery datasource="#instance.dsn#">
      update blogComments set bco_moderated=1 where id=<cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar">
    </cfquery>

  </cffunction>

  <cffunction name="setUserBlogRoles" access="public" returnType="void" output="false" roles="" hint="Sets a user's blog roles">
    <cfargument name="username" type="string" required="true" />
    <cfargument name="roles" type="string" required="true" />

    <cfset var r = "" />
    <!--- first, nuke old roles --->
    <cfquery datasource="#instance.dsn#">
    delete from blogUserRoles
    where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#" maxlength="50">
    and blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
    </cfquery>

    <cfloop index="r" list="#ARGUMENTS.roles#">
      <cfquery datasource="#instance.dsn#">
      insert into blogUserRoles(username, roleidfk, blog)
      values(
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#" maxlength="50">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#r#" maxlength="35">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
      )
      </cfquery>
    </cfloop>

  </cffunction>

  <cffunction name="unsubscribeThread" access="public" returnType="query" output="false" hint="Removes a user from a thread.">
    <cfargument name="commentID" type="UUID" required="true" />
    <cfargument name="email" type="string" required="true" />

    <cfset var verifySubscribe = "" />

    <!--- First ensure that the commentID equals the email --->
    <cfquery name="verifySubscribe" datasource="#instance.dsn#">
      SELECT entryidfk
        FROM blogComments
       WHERE id = <cfqueryparam value="#ARGUMENTS.commentID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
        AND email = <cfqueryparam value="#ARGUMENTS.email#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
    </cfquery>
    <!--- IF WE HAVE A RESULT, THEN SET SUBSCRIBE=0 FOR THIS USER FOR ALL COMMENTS IN THE THREAD --->
    <cfif verifySubscribe.RecordCount>
      <cfquery datasource="#instance.dsn#">
        UPDATE blogComments
          SET subscribe = 0
         WHERE entryidfk = <cfqueryparam value="#verifySubscribe.entryidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
          AND email = <cfqueryparam value="#ARGUMENTS.email#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
      </cfquery>
      <cfquery name="getTit" datasource="#instance.dsn#">
        SELECT id, title
          FROM blogEntries
         WHERE id = <cfqueryparam value="#verifySubscribe.entryidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
      </cfquery>
      <cfreturn getTit />
    </cfif>
    <cfreturn verifySubscribe />
  </cffunction>

  <cffunction name="updatePassword" access="public" returnType="boolean" output="false" hint="Updates the current user's password.">
    <cfargument name="oldpassword" type="string" required="true" />
    <cfargument name="newpassword" type="string" required="true" />

    <cfset var checkit = "" />
    <cfset var salt = generateSalt()>

    <cfquery name="checkit" datasource="#instance.dsn#">
    select  password, salt
    from  blogUsers
    where  username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar" maxlength="50">
    <!---
    and    password = <cfqueryparam value="#ARGUMENTS.oldpassword#" cfsqltype="cf_sql_varchar" maxlength="255">
    --->
    and    blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
    </cfquery>

    <cfif checkit.RecordCount is 1 AND checkit.password is hash(checkit.salt & ARGUMENTS.oldpassword, instance.hashalgorithm)>
      <!--- generate a new salt --->

      <cfquery datasource="#instance.dsn#">
      update  blogUsers
      set    password = <cfqueryparam value="#hash(salt & ARGUMENTS.newpassword, instance.hashalgorithm)#" cfsqltype="cf_sql_varchar" maxlength="256">,
          salt = <cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar" maxlength="256">
      where  username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar" maxlength="50">
      and    blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
      </cfquery>
      <cfreturn true />
    <cfelse>
      <cfreturn false />
    </cfif>
  </cffunction>

  <cffunction name="XHTMLParagraphFormat" returntype="string" output="false">
    <cfargument name="strTextBlock" required="true" type="string" />
    <cfreturn REReplace("<p>" & ARGUMENTS.strTextBlock & "</p>", "\r+\n\r+\n", "</p><p>", "ALL") />
  </cffunction>

  <cffunction name="generateSalt" returnType="string" output="false" access="public" hint="I generate salt for use in hashing user passwords">

    <cfreturn generateSecretKey(instance.saltAlgorithm, instance.saltKeySize)>
  </cffunction>

  <cffunction name="getOwnerByEntry" access="public" returnType="string" output="false">
    <cfargument name="id" type="uuid" required="true" />
    <cfif not entryExists(ARGUMENTS.id)>
      <cfset VARIABLES.utils.throw("#ARGUMENTS.id# does not exist.")>
    </cfif>
    <cfquery name="getIt" datasource="#instance.dsn#">
      SELECT blog
        FROM blogEntries
       WHERE blogEntries.id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
    </cfquery>
    <cfreturn getIt.blog />
  </cffunction>

</cfcomponent>
