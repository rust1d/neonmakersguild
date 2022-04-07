<cfcomponent>

  <cffunction name="init" access="public" returnType="downloadtracker" output="false">
    <cfreturn this>
  </cffunction>


  <!--- added by Jeffry Houser --->
  <cffunction name="logben_attachmentDownload" access="public" returnType="void" output="false"
        hint="I save download, or view, data based on an ben_attachment">
    <cfargument name="id" type="string" required="true" hint="entry.id">
    <cfargument name="ben_attachment" type="string" required="true" hint="entry.ben_attachment">
    <cfargument name="dir" type="string" required="true" hint="url.dir">
    <cfargument name="online" type="Boolean" required="false" default="0" hint="url.online">


    <cfquery datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
      insert into tblblogben_attachmentdownloads(id,entryid,ipaddress,http_referrer, HTTP_USER_AGENT, downloaddate, downloadtime, ben_attachment,Path, online )
      values(
        <cfqueryparam value="#createuuid()#" cfsqltype="VARCHAR" maxlength="35">,
        <cfif arguments.id is 0>
          null,
        <cfelse>
          <cfqueryparam value="#arguments.id#" cfsqltype="VARCHAR" maxlength="35" >,
        </cfif> <!--- null="#not(YesNoFormat(entry.id))#" --->
        <cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="VARCHAR" maxlength="15">,
        <cfqueryparam value="#cgi.HTTP_REFERER#" cfsqltype="VARCHAR" maxlength="255">,
        <cfqueryparam value="#cgi.HTTP_USER_AGENT#" cfsqltype="VARCHAR" maxlength="255">,
        #createodbcdate(now())#, #createodbctime(now())#,
        <cfqueryparam value="#getFileFromPath(arguments.ben_attachment)#" cfsqltype="VARCHAR" maxlength="255">,
        <cfqueryparam value="#arguments.dir#" cfsqltype="VARCHAR" maxlength="255">,
        <cfqueryparam value="#arguments.online#" cfsqltype="bit">
         )
    </cfquery>


  </cffunction>

  <!--- added by Jeffry Houser --->
  <cffunction name="generateDownloadReport" access="public" returnType="query" output="false"
        hint="I figure out how many episode downloads have happened in the given time frame">
    <cfargument name="StartDate" type="date" required="false" default="#now()#">
    <cfargument name="EndDate" type="date" required="false" default="#now()#">

    <cfset var generateReport = "">

    <cfquery name="generateReport" datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
      SELECT     TOP 100 PERCENT dbo.BlogEntries.ben_benid, dbo.BlogEntries.ben_posted, dbo.BlogEntries.ben_title, COUNT(dbo.tblblogben_attachmentdownloads.entryid) AS TotalDownloads
      FROM         dbo.BlogEntries INNER JOIN
                            dbo.tblblogben_attachmentdownloads ON dbo.BlogEntries.ben_benid = dbo.tblblogben_attachmentdownloads.entryid
      where dbo.tblblogben_attachmentdownloads.downloaddate between #createodbcdate(startdate)#  and #createodbcdate(enddate)#
      GROUP BY dbo.BlogEntries.ben_benid, dbo.BlogEntries.ben_posted, dbo.BlogEntries.ben_title
      ORDER BY dbo.BlogEntries.ben_posted, dbo.BlogEntries.ben_title
    </cfquery>

    <Cfreturn generateReport>

  </cffunction>

  <cffunction name="generateImpressionReport" access="public" returnType="query" output="false"
        hint="I figure out how many impressions different media has had">
    <cfargument name="StartDate" type="date" required="false" default="#now()#">
    <cfargument name="EndDate" type="date" required="false" default="#now()#">

    <cfset var generateReport = "">

    <cfquery name="generateReport" datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
      select count(ad_MediaLog.MediaLogID) as totalviews, ad_Media.MediaText, ad_Media.Description
      from ad_MediaLog, ad_Media
      where ( ad_MediaLog.DateDisplayed between #createodbcdate(startdate)#  and #createodbcdate(enddate)# ) and
          ad_media.mediaID = ad_MediaLog.MediaID
      group by ad_Media.MediaText, ad_Media.Description

    </cfquery>

    <Cfreturn generateReport>

  </cffunction>

</cfcomponent>