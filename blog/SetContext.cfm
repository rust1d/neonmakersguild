<cfif isDefined("REQUEST.brewer")>
  <cfif NOT isDefined("qryBrewer")>
    <cfset qryBrewer = APPLICATION.CFC.Users.QueryUsers(us_user=REQUEST.brewer) />
  </cfif>
  <cfset REQUEST.BLOG = REQUEST.brewer />
  <cfset SESSION.BROG.setProperty("name", REQUEST.brewer) />
  <cfset SESSION.BROG.setProperty("owneremail", qryBrewer.us_email) />
  <cfset SESSION.BROG.setProperty("offset", qryBrewer.us_offset) />
  <cfset SESSION.BROG.setProperty("moderate", qryBrewer.us_moderate) />
  <cfset SESSION.BROG.setProperty("usetweetbacks", qryBrewer.us_tweetback) />
  <cfset SESSION.BROG.setProperty("blogURL", "#APPLICATION.PATH.FULL#/#REQUEST.brewer#/blog/p.brewer.cfm") />
  <cfset SESSION.BROG.setProperty("SiteBlog", false) />
<cfelse>
  <cfset REQUEST.BLOG = APPLICATION.CFC.BLOG.getProperty("name") />
  <cfset SESSION.BROG.setProperty("name", APPLICATION.CFC.BLOG.getProperty("name")) />
  <cfset SESSION.BROG.setProperty("owneremail", APPLICATION.CFC.BLOG.getProperty("owneremail")) />
  <cfset SESSION.BROG.setProperty("offset", APPLICATION.CFC.BLOG.getProperty("offset")) />
  <cfset SESSION.BROG.setProperty("moderate", APPLICATION.CFC.BLOG.getProperty("moderate")) />
  <cfset SESSION.BROG.setProperty("usetweetbacks", APPLICATION.CFC.BLOG.getProperty("usetweetbacks")) />
  <cfset SESSION.BROG.setProperty("blogURL", APPLICATION.CFC.BLOG.getProperty("blogURL")) />
  <cfset SESSION.BROG.setProperty("SiteBlog", true) />
</cfif>