<cfcomponent output="false" extends="RootApplication">

  <cffunction name="onApplicationStart" returntype="boolean" output="false">
    <Cfset super.onApplicationStart()>
    <cfreturn true>
  </cffunction>

   <cffunction name="onRequestStart" returntype="boolean" output="false">
    <cfargument name="thePage"type="string"required="true">
    <Cfset super.onApplicationStart()>
    <Cfset super.onRequestStart(thePage)>
    <!--- no idea why this isn't loading in memory --->
    <cfif not isDefined('application.utils.getResource')>
      <cfset onApplicationStart()>
    </cfif>
    <cfset request.rb = application.utils.getResource>

    <cfscript>
      session.user = new app.services.CurrentUser()
      session.user.set_pkid(1);
      session.user.set_class('Users');
      session.user.set_home('user/home');
      session.user.set_admin('true');
      session.user.set('roles', application.blog.getUserBlogRoles(session.user.usid()));
    </cfscript>

    <cfloginuser name="rust1d" password="poop" roles="admin">

    <cfset session.loggedin = true>


    <!--- Security Related --->
    <cfif isDefined("url.logout") and application.utils.isLoggedIn()>
      <cfset structDelete(session,"loggedin")>
      <cflogout>
    </cfif>

    <cfif findNoCase("/admin", cgi.script_name) and not application.utils.isLoggedIn() and not findNoCase("/admin/notify.cfm", cgi.script_name)>
      <cfsetting enablecfoutputonly="false">
      <cfinclude template="login.cfm">
      <cfabort>
    </cfif>

    <cfreturn true>
  </cffunction>

  <cffunction name="onSessionStart" returntype="void" output="false">
    <Cfset super.onSessionStart(onSessionStart)>
  </cffunction>

</cfcomponent>