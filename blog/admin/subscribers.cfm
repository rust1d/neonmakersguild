<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
  Name         : C:\projects\blogcfc5\client\admin\subscribers.cfm
  Author       : Raymond Camden
  Created      : 04/07/06
  Last Updated : 7/21/06
  History      : Show how many people are bsu_verified (rkc 7/7/06)
         : Button to let you nuke all the Unverified people at once. (rkc 7/21/06)
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
  <cfloop index="u" list="#form.mark#">
    <cfset application.blog.removeSubscriber(u)>
  </cfloop>
</cfif>

<!--- handle mass delete --->
<cfif structKeyExists(form, "nukeUnverified")>
    <cfset application.blog.removeUnverifiedSubscribers()>
</cfif>

<cfif structKeyExists(url, "verify")>
  <cfset application.blog.confirmSubscription(email=url.verify)>
</cfif>

<cfset subscribers = application.blog.getSubscribers()>

<cfquery name="bsu_verifiedSubscriber" dbtype="query">
select  count(email) as total
from  subscribers
where  bsu_verified = 1
</cfquery>

<cfmodule template="../tags/adminlayout.cfm" title="Subscribers">

  <cfoutput>
  <p>
  Your blog currently has
    <cfif subscribers.recordCount gt 1>
    #subscribers.recordcount# subscribers
    <cfelseif subscribers.recordCount is 1>
    1 subscriber
    <cfelse>
    0 subscribers
    </cfif>. There <cfif bsu_verifiedSubscriber.total is 1>is<cfelse>are</cfif> <cfif bsu_verifiedSubscriber.total neq "">#bsu_verifiedSubscriber.total#<cfelse>no</cfif> <b>bsu_verified</b> subscriber<cfif bsu_verifiedSubscriber.total is not 1>s</cfif>.
  </p>

  <p>
  You may use the button below to delete all non-bsu_verified subscribers. You should note that this will delete ALL of them,
  even people who just subscribed a minute ago. This should be used rarely!
  </p>

  <form action="subscribers.cfm" method="post">
  <input type="submit" name="nukeUnverified" value="Remove Unverified">
  </form>
  </cfoutput>

  <cfmodule template="../tags/datatable.cfm" data="#subscribers#" editlink="" label="Subscribers"
        linkcol="" linkval="email" showAdd="false" defaultsort="email">
    <cfmodule template="../tags/datacol.cfm" colname="email" label="Email" />
    <cfmodule template="../tags/datacol.cfm" colname="bsu_verified" label="bsu_verified" format="yesno"/>
    <cfmodule template="../tags/datacol.cfm" label="Verify" data="<a href=""subscribers.cfm?verify=$email$"">Verify</a>" sort="false"/>

  </cfmodule>

</cfmodule>


<cfsetting enablecfoutputonly=false>