<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />


<cfif structKeyExists(form, "mark")><!--- handle deletes --->
	<cfloop index="u" list="#form.mark#">
		<cfset SESSION.BROG.removeSubscriber(u)>
	</cfloop>
</cfif>
<cfif structKeyExists(form, "nukeunverified")><!--- handle mass delete --->
	<cfset SESSION.BROG.removeUnverifiedSubscribers()>
</cfif>
<cfif StructKeyExists(URL, "verify")>
	<cfset SESSION.BROG.confirmSubscription(email=URL.verify)>
</cfif>
<cfset subscribers = SESSION.BROG.getSubscribers()>
<cfquery name="verifiedSubscriber" dbtype="query">
	select count(email) as total
	  from subscribers
	 where verified = 1
</cfquery>
<script>
	verify = function(email) {
		window.location = "x.subscribers.cfm?verify=" + email;
	}
</script>
<cfmodule template="../tags/adminlayout.cfm" title="Subscribers">
	<cfoutput>
		<p>Your blog currently has #udfAddSWithCnt("subscriber", subscribers.RecordCount)#.</p>
		<p>Your blog currently has #udfAddSWithCnt("verified subscriber", verifiedSubscriber.total)#.</p>
	</cfoutput>
	<cfmodule template="../tags/datatable.cfm" data="#subscribers#" editlink="" label="Subscribers" linkcol="" linkval="email" showAdd="false" defaultsort="email">
		<cfmodule template="../tags/datacol.cfm" label="<img title='Verify' class='bih-icon bih-icon-checkwhite' src='#APPLICATION.PATH.IMG#/trans.gif'>" data="<button class='ui-button-text-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-corner-all ui-button ui-button-icon-only' onclick='verify(""$email$"")' title='Verify' type='button'><span class='ui-button-icon-primary ui-icon bih-icon bih-icon bih-icon-checkgreen'></span><span class='ui-button-text '>&nbsp;</span></button>" sort="false" width="25"/>
		<cfmodule template="../tags/datacol.cfm" colname="email" label="Email" />
		<cfmodule template="../tags/datacol.cfm" colname="verified" label="Verified" format="yesno"/>
	</cfmodule>
	<hr>
	<p>You may use the button below to delete all non-verified subscribers. You should note that this will delete ALL of them,	even people who just subscribed a second ago. This should be used rarely!</p>
	<form action="x.subscribers.cfm" method="post">
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" name="nukeunverified" class="ui-button-text-tiny" src="bih-icon bih-icon-exclaimation" submit="true" text="Remove ALL Unverified"/>
	</form>
</cfmodule>
<cfsetting enablecfoutputonly="false" />