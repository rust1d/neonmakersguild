
<!---- expecting a URL Variable w/ the MediaID ---->

<cfif not IsDefined("MediaID")>
  <cfabort />
</cfif>

<cfquery name="getMedia" datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
  select Ad_Media.MediaText,  Ad_MimeTypes.MimeType
  from Ad_Media join Ad_MimeTypes on (Ad_Media.MimeTypeID = Ad_MimeTypes.MimeTypeID)
  where Ad_Media.mediaID = <cfqueryparam value="#MediaID#" cfsqltype="integer">
</cfquery>


<cfquery name="LogDelivery" datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
  insert into AD_MediaLog(DateDisplayed, MediaID )
  values (#createODBCDateTime(now())#, <cfqueryparam value="#MediaID#" cfsqltype="integer">)
</cfquery>

<!--- <Cfdump var="#getMedia#">
<cfdump var="#getMedia.ben_mimetype#"> <br/>
<cfdump var="#expandpath(getMedia.MediaText)#"><br/>
<cfabort /> --->
<cfif getMedia.recordcount NEQ 0>
  <cfcontent type="#getMedia.ben_mimetype#" file="#expandpath(getMedia.MediaText)#">
</cfif>

