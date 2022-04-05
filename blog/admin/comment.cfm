<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cftry>
	<cfset comment = SESSION.BROG.getComment(URL.id)>
	<cfif comment.RecordCount is 0>
		<cflocation url="x.comments.cfm" addToken="false">
	</cfif>
	<cfcatch>
		<cflocation url="x.comments.cfm" addToken="false">
	</cfcatch>
</cftry>
<cfif structKeyExists(form, "cancel")>
	<cflocation url="x.comments.cfm" addToken="false">
</cfif>
<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>
	<cfif not len(trim(form.name))>
		<cfset arrayAppend(errors, "The name cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.email)) or not isEmail(form.email)>
		<cfset arrayAppend(errors, "The email cannot be blank and must be a valid email address.")>
	</cfif>
	<cfif len(form.bco_website) and not isURL(form.bco_website)>
		<cfset arrayAppend(errors, "bco_website must be a valid URL.")>
	</cfif>
	<cfif not len(trim(form.comment))>
		<cfset arrayAppend(errors, "The comment cannot be blank.")>
	</cfif>
	<cfif not arrayLen(errors)>
		<cfset SESSION.BROG.saveComment(URL.id, left(form.name,50), left(form.email,50), left(form.bco_website,255), form.comment, form.subscribe, form.bco_moderated)>
		<cflocation url="x.comments.cfm" addToken="false">
	</cfif>
</cfif>

<cfparam name="form.name" default="#comment.name#">
<cfparam name="form.email" default="#comment.email#">
<cfparam name="form.bco_website" default="#comment.bco_website#">
<cfparam name="form.comment" default="#comment.comment#">
<cfparam name="form.subscribe" default="#comment.subscribe#">
<cfparam name="form.bco_moderated" default="#comment.bco_moderated#">

<cfmodule template="../tags/adminlayout.cfm" title="Comment Editor">
	<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
		<cfoutput>
		<div class="errors">
		Please correct the following error(s):
		<ul>
		<cfloop index="x" from="1" to="#arrayLen(errors)#">
		<li>#errors[x]#</li>
		</cfloop>
		</ul>
		</div>
		</cfoutput>
	</cfif>
	<cfoutput>
		<div class="ui-widget-content">
		<form action="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/comment/p.brewer.cfm?id=#comment.id#" method="post">
		<table class="datagrid noborder" cellspacing="0" width="640">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td class="label">posted:</td>
					<td><h5>#APPLICATION.BLOG.localeUtils.dateLocaleFormat(comment.posted)# #APPLICATION.BLOG.localeUtils.timeLocaleFormat(comment.posted)#</h5></td>
				</tr>
				<tr>
					<td class="label">name:</td>
					<td><input type="text" name="name" value="#form.name#" class="txtField" maxlength="50"></td>
				</tr>
				<tr>
					<td class="label">email:</td>
					<td><input type="text" name="email" value="#form.email#" class="txtField" maxlength="50"></td>
				</tr>
				<tr>
					<td class="label">bco_website:</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="url" maxlen="150" value="#form.bco_website#" name="bco_website" class="txtField" /></td>
				</tr>
				<tr valign="top">
					<td class="label">comment:</td>
					<td><textarea name="comment" class="txtArea">#form.comment#</textarea></td>
				</tr>
				<tr>
					<td class="label">subscribed:</td>
					<td>
					<select name="subscribe">
					<option value="yes" <cfif form.subscribe>selected</cfif>>Yes</option>
					<option value="no" <cfif not form.subscribe>selected</cfif>>No</option>
					</select>
					</td>
				</tr>
				<tr>
					<td class="label">bco_moderated:</td>
					<td>
					<select name="bco_moderated">
					<option value="yes" <cfif form.bco_moderated>selected</cfif>>Yes</option>
					<option value="no" <cfif not form.bco_moderated>selected</cfif>>No</option>
					</select>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><input type="submit" name="cancel" value="Cancel">
					 <input type="submit" name="save" value="Save">
					  <input type="button" name="approve" value="Approve" onclick="location.href='#APPLICATION.PATH.ROOT#/blog/admin/x.moderate.cfm?approve=#comment.id#'" /></td>
				</tr>
			</tbody>
		</table>
		<div class="post_buttons ui-widget-content ui-corner-all">
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-cancel" name="cancel" text="Cancel" onclick="if (confirm('#rb('cancelconfirm')#')) window.close(); else return false;" />
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-disk" name="save" text="Save" submit="true" />
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-checkgreen" name="approve" text="Approve" onclick="location.href='#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/moderate/p.brewer.cfm?approve=#comment.id#'" />
		</div>
	</div>
	</form>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly="false" />
