<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : /client/admin/index.cfm
	Author       : Raymond Camden
	Created      : 04/12/06
	Last Updated : 4/13/06
	History      : Various changes, forgotten keys, new keys (rkc 9/5/06)
				 : Comment moderation support (tr 12/7/06)
				 : support new properties (rkc 12/14/06)
				 : change moderate postings to moderate comments (rkc 4/13/07)
--->

<cfif not APPLICATION.BLOG.settings>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>

<!--- quick utility func to change foo,moo to foo<newline>moo and reverse --->
<cfscript>
function toLines(str) { return replace(str, ",", chr(10), "all"); }
function toList(str) {
	str = replace(str, chr(10), "", "all");
	str = replace(str, chr(13), ",", "all");
	return str;
}
</cfscript>

<cfset settings = SESSION.BROG.getProperties()>

<cfloop item="setting" collection="#settings#">
	<cfparam name="FORM.#setting#" default="#settings[setting]#">
</cfloop>
<!---
we can use all the settings, but username and password may get overwritten
by a login attempt, see this bug report:
http://blogcfc.riaforge.org/index.cfm?event=page.issue&issueid=4CEC3A8A-C919-ED1E-17FD790A1A7DE997
--->
<cfparam name="FORM.dsn_username" default="#settings.username#">
<cfparam name="FORM.dsn_password" default="#settings.password#">

<cfif structKeyExists(form, "cancel")>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>
	<cfif not len(trim(FORM.blogtitle))>
		<cfset arrayAppend(errors, "Your blog must have a title.")>
	</cfif>
	<cfif not len(trim(FORM.blogurl))>
		<cfset arrayAppend(errors, "Your blog url cannot be blank.")>
	<cfelseif right(FORM.blogurl, 9) is not "index.cfm">
		<cfset arrayAppend(errors, "The blogurl setting must end with index.cfm.")>
	</cfif>
	<cfif len(trim(FORM.maxentries)) and not isNumeric(FORM.maxentries)>
		<cfset arrayAppend(errors, "Max entries must be numeric.")>
	</cfif>
	<cfif len(trim(FORM.offset)) and not isNumeric(FORM.offset)>
		<cfset arrayAppend(errors, "Offset must be numeric.")>
	</cfif>
	<cfset FORM.pingurls = toList(FORM.pingurls)>
	<cfset FORM.ipblocklist = toList(FORM.ipblocklist)>
	<cfset FORM.trackbackspamlist = listSort(toList(FORM.trackbackspamlist),"textnocase")>
	<cfif not arrayLen(errors)>
		<!--- copy dsn_* --->
		<cfset FORM.username = FORM.dsn_username>
		<cfset FORM.password = FORM.dsn_password>
		<!--- make a list of the keys we will send. --->
		<cfset keylist = "blogtitle,blogdescription,blogkeywords,blogurl,maxentries,offset,pingurls,moderate,usetweetbacks">
		<cfif settings.Name EQ APPLICATION.SETTING.blog> <!--- ONLY DEFAULT BLOG ADMIN CAN SET THESE --->
			<cfset keylist = ListAppend(KeyList, "ipblocklist,trackbackspamlist,filebrowse,itunessubtitle,itunessummary,ituneskeywords,itunesauthor,itunesimage,itunesexplicit") />
		</cfif>
		<cfloop index="key" list="#keylist#">
			<cfif structKeyExists(form, key)>
				<cfset SESSION.BROG.setProperty(key, trim(form[key]))>
			</cfif>
		</cfloop>
		<cflocation url="x.settings.cfm?reinit=1&settingsupdated=1" addToken="false">
	</cfif>
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Settings">
	<cfif StructKeyExists(URL, "settingsupdated")>
		<cfoutput>
			<div style="margin: 15px 0; padding: 15px; border: 5px solid ##008000; background-color: ##80ff00; color: ##000000; font-weight: bold; text-align: center;">
				Your settings have been updated and your cache refreshed.
			</div>
		</cfoutput>
	</cfif>
	<cfoutput>
	<p>Please edit your settings below.</p>
	</cfoutput>
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
	<form action="x.settings.cfm" method="post" name="settingsForm">
		<h2>Blog Information</h2>
		<table class="datagrid" cellspacing="0" width="660">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td class="label" width="150">Blog Title:</td>
					<td><input type="text" name="blogtitle" value="#htmlEditFormat(FORM.blogtitle)#" class="txtField" maxlength="255"></td>
				</tr>
				<tr>
					<td class="label">Blog Description:</td>
					<td><textarea name="blogdescription" class="txtAreaShort">#htmlEditFormat(FORM.blogdescription)#</textarea></td>
				</tr>
				<tr>
					<td class="label">Blog Keywords:</td>
					<td><input type="text" name="blogkeywords" value="#htmlEditFormat(FORM.blogkeywords)#" class="txtField" maxlength="255"></td>
				</tr>
			</tbody>
		</table>
		<br/>
		<h2>Content Settings</h2>
		<table class="datagrid" cellspacing="0" width="660">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td class="label" width="150">Max Entries:</td>
					<td><input type="text" name="maxentries" value="#FORM.maxentries#" class="txtField" maxlength="255"></td>
				</tr>
				<tr>
					<td class="label">Offset:</td>
					<td><input type="text" name="offset" value="#FORM.offset#" class="txtField" maxlength="255"></td>
				</tr>
				<tr>
					<td class="label">Ping Urls:</td>
					<td><textarea name="pingurls" class="txtAreaShort">#toLines(FORM.pingurls)#</textarea></td>
				</tr>
			</tbody>
		</table>
		<br/>
		<h2>Content Controls / Security</h2>
		<table class="datagrid" cellspacing="0" width="660">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td class="label" width="150">Moderate Comments:</td>
					<td>
						<input type="radio" name="moderate" value="yes" <cfif FORM.moderate>checked</cfif>/> Yes
						<input type="radio" name="moderate" value="no" <cfif not FORM.moderate>checked</cfif>/> No
					</td>
				</tr>
				<tr>
					<td class="label">Use Tweetbacks:</td>
					<td>
						<input type="radio" name="usetweetbacks" value="yes" <cfif FORM.usetweetbacks>checked</cfif>/> Yes
						<input type="radio" name="usetweetbacks" value="no" <cfif not FORM.usetweetbacks>checked</cfif>/> No
					</td>
				</tr>
			<cfif settings.Name EQ APPLICATION.SETTING.blog>
				<tr>
					<td class="label">Spam List:</td>
					<td><textarea name="trackbackspamlist" class="txtAreaShort">#toLines(FORM.trackbackspamlist)#</textarea></td>
				</tr>
				<tr>
					<td class="label" width="150">IP Block List:</td>
					<td><textarea name="ipblocklist" class="txtAreaShort">#toLines(FORM.ipblocklist)#</textarea></td>
				</tr>
				<tr>
					<td class="label">show file manager:</td>
					<td>
						<input type="radio" name="filebrowse" value="yes" <cfif FORM.filebrowse>checked</cfif>/> Yes
						<input type="radio" name="filebrowse" value="no" <cfif not FORM.filebrowse>checked</cfif>/> No
					</td>
				</tr>
			</cfif>
			</tbody>
		</table>
		<cfif settings.Name EQ APPLICATION.SETTING.blog>
			<br/>
			<h2>Podcasting</h2>
			<table class="datagrid" cellspacing="0" width="660">
				<tbody class="bih-grid-form nobevel">
					<tr>
						<td class="label" width="150">iTunes Subtitle:</td>
						<td><input type="text" name="iTunessubtitle" value="#FORM.itunessubtitle#" class="txtField" maxlength="50"></td>
					</tr>
					<tr>
						<td class="label">iTunes Summary:</td>
						<td><input type="text" name="itunessummary" value="#FORM.itunessummary#" class="txtField" maxlength="50"></td>
					</tr>
					<tr>
						<td class="label">iTunes Keywords:</td>
						<td><input type="text" name="ituneskeywords" value="#FORM.ituneskeywords#" class="txtField" maxlength="50"></td>
					</tr>
					<tr>
						<td class="label">iTunes Author:</td>
						<td><input type="text" name="itunesauthor" value="#FORM.itunesauthor#" class="txtField" maxlength="50"></td>
					</tr>
					<tr>
						<td class="label">iTunes Image:</td>
						<td><input type="text" name="itunesimage" value="#FORM.itunesimage#" class="txtField" maxlength="50"></td>
					</tr>
					<tr>
						<td class="label">iTunes Explicit:</td>
						<td>
							<input type="radio" name="itunesexplicit" value="yes" <cfif FORM.itunesexplicit>checked</cfif>/> Yes
							<input type="radio" name="itunesexplicit" value="no" <cfif not FORM.itunesexplicit>checked</cfif>/> No
						</td>
					</tr>
				</tbody>
			</table>
		</cfif>
	<div class="buttonbar">
		<a href="settings.cfm" class="button">Cancel Changes</a> <a href="javascript:document.settingsFORM.submit();" class="button">Save Settings</a>
	</div>
	<input type="hidden" name="save" value="1">
	</form>
	</cfoutput>


</cfmodule>

<cfsetting enablecfoutputonly="false" />