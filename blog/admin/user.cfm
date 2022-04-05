<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : user.cfm
	Author       : Raymond Camden
	Created      : 07/15/09
	Last Updated : 01/26/2011
	History      : RBB: Updated to account for hashed passwords.
--->

<cfif not SESSION.BROG.isBlogAuthorized('ManageUsers')>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>

<cfset allroles = SESSION.BROG.getBlogRoles()>

<cftry>
	<cfif URL.id neq 0>
		<cfset user = SESSION.BROG.getUser(URL.id)>
		<cfparam name="form.username" default="#user.username#">
		<cfset roles = SESSION.BROG.getUserBlogRoles(user.username)>
		<cfif not structKeyExists(form, "save")>
			<cfparam name="form.roles" default="#roles#">
		<cfelse>
			<cfparam name="form.roles" default="">
		</cfif>
	<cfelse>
		<cfparam name="form.username" default="">
		<cfparam name="form.roles" default="">
	</cfif>
	<cfcatch>
		<cflocation url="x.users.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="x.users.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>
	<cfif not len(trim(form.username))>
		<cfset arrayAppend(errors, "The username cannot be blank.")>
	</cfif>
	<cfif not arrayLen(errors)>
		<cftry>
		<cfif URL.id eq 0>
			<cfset SESSION.BROG.addUser(left(form.username,50)) />
		</cfif>
		<cfset SESSION.BROG.setUserBlogRoles(form.username, form.roles) />
		<cfcatch>
			<cfif findNoCase("already exists as a user", cfcatch.message)>
				<cfset arrayAppend(errors, "A user with this username already exists.")>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
		</cftry>
		<cfif not arrayLen(errors)>
			<cflocation url="x.users.cfm" addToken="false">
		</cfif>
	</cfif>
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="User Editor">
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
	<p>Use the form below to edit the user roles. Changing roles for a user currently logged in will <b>not</b> change their access until they log in again.</p>
	<form action="x.user.cfm?id=#URL.id#" method="post">
	<table class="datagrid noborder" cellspacing="0" width="100%">
		<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="label required">Username:</td>
			<td><cfif URL.id eq 0><input type="text" name="username" value="#form.username#" class="txtField" maxlength="50" required="required"><cfelse>#form.username#</cfif></td>
		</tr>
		<tr>
			<td class="label">Roles:</td>
			<td>
				<select name="roles" multiple="true" size="5">
					<cfloop query="allroles"><option value="#id#" <cfif listFind(form.roles,id)>selected</cfif>>#role# (#description#)</option></cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="save" value="Save"> <input type="submit" name="cancel" value="Cancel"></td>
		</tr>
	</table>
	</form>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly="false" />
