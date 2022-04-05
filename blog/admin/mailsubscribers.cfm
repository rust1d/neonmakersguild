<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />

<cfset vSubscribers = SESSION.BROG.getSubscribers(true)>
<cfparam name="form.subject" default="">
<cfparam name="form.body" default="">
<cfif structKeyExists(form, "send")>
	<cfset errors = arrayNew(1)>
	<cfif not len(trim(form.subject))>
		<cfset arrayAppend(errors, "The subject cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset arrayAppend(errors, "The body cannot be blank.")>
	</cfif>
	<cfif not arrayLen(errors)>
		<cfloop query="vSubscribers">
			<!--- This should maybe be abstracted. It's copied from blog.cfc --->
			<cfsavecontent variable="link">
			<cfoutput>
<p>
You are receiving this email because you have subscribed to this blog.<br />
To unsubscribe, please go to this URL:
<a href="#APPLICATION.PATH.ROOT#/b.unsubscribe.cfm?email=#email#&token=#token#">#APPLICATION.PATH.ROOT#/b.unsubscribe.cfm?email=#email#&token=#token#</a>
</p>
			</cfoutput>
			</cfsavecontent>
			<cfset body = form.body & "<br />" & link>
			<cfset udfEmail(to=email, from=SESSION.USER.email, subject=form.subject, type="html", body=body) />
		</cfloop>
		<cfset success = true>
	</cfif>
</cfif>
<cfmodule template="../tags/adminlayout.cfm" title="Subscribers">
	<cfoutput>
		<p>Your blog currently has #udfAddSWithCnt("verified subscriber", vSubscribers.RecordCount)#.</p>
		<p>The form below will let you email your subscribers. It will automatically add an unsubscribe link to the bottom of the email. HTML is allowed.</p>
	</cfoutput>
	<cfif vSubscribers.RecordCount is 0>
		<cfoutput>
		<p>Since you do not have any verified subscribers, you will not be able to send a message.</p>
		</cfoutput>
	<cfelse>
		<cfif not structKeyExists(variables, "success")>
			<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
				<cfoutput>
				<div class="errors">
					Please correct the following error(s):
					<ul>
					<cfloop index="x" from="1" to="#arrayLen(errors)#"><li>#errors[x]#</li></cfloop>
					</ul>
				</div>
				</cfoutput>
			</cfif>
			<cfoutput>
			<form action="x.mailsubscribers.cfm" method="post">
			<table class="datagrid noborder" cellspacing="0" width="100%">
				<tbody class="bih-grid-form nobevel">
					<tr>
						<td class="label" width="50">Subject:</td>
						<td><input type="text" name="subject" value="#form.subject#" class="txtField" maxlength="255"></td>
					</tr>
				<tr valign="top">
					<td class="label" >Body:</td>
					<td><textarea name="body" class="txtArea">#form.body#</textarea></td>
				</tr>
			</table>
			<p>
			<div class="ui-widget ui-widget-content ui-corner-all right" style="padding: 5px">
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-checkred" submit="true" name="cancel" text="Cancel"/>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-email" submit="true" name="send" text="Send Email"/>
			</div>
			</p>

			</form>
			</cfoutput>

		<cfelse>

			<cfoutput>
			<p>
			Your message has been sent.
			</p>
			</cfoutput>

		</cfif>

	</cfif>

</cfmodule>


<cfsetting enablecfoutputonly="false" />