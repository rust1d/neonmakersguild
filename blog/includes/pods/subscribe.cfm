<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfset formField = "user_register">

<!--- confirmation vars --->
<cfparam name="variables.errorMessage" default="">
<cfparam name="variables.successMessage" default="">
<cfif structKeyExists(form, formField) and len(trim(form[formField]))>
	<cfif caller.isEmail(trim(form[formField]))>
		<cfset token = SESSION.BROG.addSubscriber(trim(form[formField]))>
		<cfif token is not "">
			<cfsavecontent variable="body">
			<cfoutput>
#APPLICATION.BLOG.resourceBundle.getResource("subscribeconfirmation")#
#APPLICATION.PATH.ROOT#/confirmsubscription.cfm?t=#token#
			</cfoutput>
			</cfsavecontent>
			<cfset APPLICATION.BLOG.utils.mail(
				to=form[formField],
				from=SESSION.BROG.getProperty("owneremail"),
				subject="#SESSION.BROG.getProperty("blogtitle")# #APPLICATION.BLOG.resourceBundle.getResource("subscribeconfirm")#",
				type="text",
				body=body
			)>
			<cfset variables.successMessage = "We have received your request.  Please keep an eye on your email; we will send you a link to confirm your subscription.">
		</cfif>
	<cfelse> <!--- bad email syntax --->
		<cfset variables.errorMessage = "Whoops! The email you entered is not valid syntax.">
	</cfif>
</cfif>
<cfmodule template="../../tags/podlayout.cfm" title="#APPLICATION.BLOG.resourceBundle.getResource("subscribe")#">
	<cfset qs = reReplace(CGI.query_string, "<.*?>", "", "all")>
	<cfset qs = reReplace(qs, "[\<\>]", "", "all")>
	<cfset qs = reReplace(qs, "&", "&amp;", "all")>
	<cfoutput>
	<div class="center">
		<form action="#SESSION.BROG.getProperty("blogurl")#?#qs#" method="post" onsubmit="return !isEmpty(this.#formField#)">
			<input type="email" name="#formField#" size="15" placeholder="#APPLICATION.BLOG.resourceBundle.getResource('subscribe')#" required="required" />
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-email" name="search" title="#APPLICATION.BLOG.resourceBundle.getResource('subscribe')#" submit="true" />
		</form>
		<cfif len(variables.successMessage)>
			<span class="blue">#variables.successMessage#</span>
		<cfelseif len(variables.errorMessage)>
			<span class="error">#variables.errorMessage#</span>
		<cfelse>
			<span class="bco_moderated">#APPLICATION.BLOG.resourceBundle.getResource("subscribeblog")#</span>
		</cfif>
	</div>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly="false" />