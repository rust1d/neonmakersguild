<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfif not isDefined("URL.email")>
  <cflocation url = "#SESSION.BROG.getProperty("blogURL")#">
</cfif>
<cfmodule template="tags/layout.cfm" title="#rb("unsubscribe")#">
<cfif isDefined("URL.commentID")>
  <!--- ATTEMPT TO UNSUB --->
  <cftry>
    <cfset qryUnsub = SESSION.BROG.unsubscribeThread(URL.commentID, URL.email)>
    <cfcatch>
      <cfset qryUnsub = QueryNew("dummy") />
    </cfcatch>
  </cftry>
  <cfoutput>
  <br/>
  <h3>Blog Comment Unsubscribe</h3>
  <cfif qryUnsub.RecordCount>
    <p>You will no longer be notified of new comments on this entry:</p>
    <h4 class="pad10"><a href="#SESSION.BROG.makeLink(qryUnsub.id)#">#qryUnsub.title#</a></h4>
  <cfelse>
    <p>#rb("unsubscribefailure")#</p>
  </cfif>
  <br/>
  <p><a href="#SESSION.BROG.getProperty("blogurl")#">#rb("returntoblog")#</a></p>
  </cfoutput>
<cfelseif isDefined("URL.token")>
  <!--- Attempt to unsub --->
  <cftry>
    <cfset result = SESSION.BROG.removeSubscriber(URL.email, URL.token)>
    <cfcatch>
      <cfset result = false>
    </cfcatch>
  </cftry>
  <cfoutput>
  <br/><br/>
  <h3>Blog Unsubscribe</h3>
  <cfif result>
    <p>#rb("unsubscribeblogsuccess")#</p>
  <cfelse>
    <p>#rb("unsubscribeblogfailure")#</p>
  </cfif>
  <br/><br/>
  <p><a href="#SESSION.BROG.getProperty("blogurl")#">#rb("returntoblog")#</a></p>
  </cfoutput>
</cfif>
<cfoutput></cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly="false" />