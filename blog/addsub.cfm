<cfprocessingdirective pageencoding="utf-8" />

<cfif not isDefined("form.addsub")>
	<cfif isDefined("cookie.blog_email")>
		<cfset form.email = cookie.blog_email>
		<cfset form.rememberMe = true>
	</cfif>
</cfif>

<cfif SESSION.LoggedIn>
	<cfset form.usid = SESSION.USER.usid />
	<cfset form.name = SESSION.USER.user />
	<cfset form.email = SESSION.USER.email />
	<cfset form.rememberMe = false />
	<cfset form.addsub = true />
</cfif>

<cfparam name="form.usid" default="0">
<cfparam name="form.name" default="">
<cfparam name="form.email" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.captchaText" default="">

<cfset closeMe = false>
<cfif not isDefined("URL.id")>
	<cfset closeMe = true>
<cfelse>
	<cftry>
		<cfset REQUEST.blog = APPLICATION.CFC.BLOG.getOwnerByEntry(URL.id) />
		<cfif REQUEST.blog NEQ APPLICATION.BLOG.name>
			<cfset REQUEST.brewer = REQUEST.blog />
		</cfif>
		<cfinclude template="#APPLICATION.PATH.ROOT#/blog/SetContext.cfm" />
		<cfset entry = SESSION.BROG.getEntry(URL.id,true)>
		<cfcatch>
			<cfset closeMe = true>
		</cfcatch>
	</cftry>
</cfif>
<cfif closeMe>
	<cfoutput><script>window.close();</script></cfoutput>
	<cfabort>
</cfif>

<cfif isDefined("form.addsub") and entry.allowcomments>
	<cfset form.email = trim(form.email)>
	<cfset errorStr = "">
	<cfif NOT SESSION.LoggedIn>
		<cfif not len(form.email) or not isEmail(form.email)>
			<cfset errorStr = ListAppend(errorStr, rb("mustincludeemail"), "|") />
		</cfif>
		<!--- CAPTCHA VALIDATION --->
		<cfif not len(form.captchaText)>
			<cfset errorStr = ListAppend(errorStr, "Please enter the Captcha text.", "|") />
		<cfelseif NOT APPLICATION.BLOG.captcha.validateCaptcha(form.captchaHash,form.captchaText)>
			<cfset errorStr = ListAppend(errorStr, "The captcha text is incorrect.", "|") />
		</cfif>
	</cfif>
	<cfif not len(errorStr)>
		<!--- SUBS BASICALLY USE THE COMMENT SYSTEM WITH AN EMPTY COMMENT AND A COMMENTONLY FLAG. --->
		<cfinvoke component="#SESSION.BROG#" method="addComment" returnVariable="commentID">
			<cfinvokeargument name="entryid" value="#URL.id#" />
			<cfinvokeargument name="usid" value="#form.usid#" />
			<cfinvokeargument name="email" value="#left(form.email,50)#" />
			<cfinvokeargument name="subscribe" value="true" />
			<cfinvokeargument name="bco_subscribeonly" value="true" />
			<cfif SESSION.LoggedIn>
				<cfinvokeargument name="overridemoderation" value="true" />
			</cfif>
			<cfinvokeargument name="name" value="" />
			<cfinvokeargument name="bco_website" value="" />
			<cfinvokeargument name="comments" value="" />
		</cfinvoke>
		<!--- clear form data --->
		<cfif form.rememberMe>
			<cfcookie name="blog_email" value="#trim(htmlEditFormat(form.email))#" expires="never">
		<cfelse>
			<cfcookie name="blog_email" expires="now">
			<cfset form.email = "">
		</cfif>
		<cfoutput><script>opener.showStatusWindow("Subscription Added."); window.close();</script></cfoutput>
		<cfabort>
	</cfif>
</cfif>

<cfoutput>
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/popout.css" />
	<style type="text/css">
		@import "#APPLICATION.PATH.ROOT#/blog/css/blog.css";
	</style>
</cfoutput>

<cfif entry.allowcomments>
	<cfoutput>
	<div id="divBlog">
		<div id="blogAddSub">
			<h2>#rb("addsub")#</h2>
			<cfif isDefined("errorStr") and len(errorStr)>
				<div class="errors">
					Please correct the following error(s):
					<div class="pad10">
						<div class="ui-state-default ui-state-error ui-corner-all pad10">
							<ul>
								<cfloop list="#errorStr#" index="err" delimiters="|"><li>#err#</li></cfloop>
							</ul>
						</div>
					</div>
				</div>
			</cfif>
			<h3 class="capitalize">#REQUEST.BLOG#'s Blog: #entry.title#</h3>
			<div class="ui-widget-content">
				<form action="#APPLICATION.PATH.ROOT#/b.addsub.cfm?#CGI.query_string#" method="post">
				<table class="datagrid noborder" cellspacing="0" width="525">
					<tbody class="bih-grid-form nobevel">
						<tr>
							<td class="label required">#rb("emailaddress")#:</td>
							<td><input type="text" id="email" name="email" value="#form.email#" /></td>
						</tr>
						<tr>
							<td class="label required">#rb("captchatext")#:</td>
							<td>
								<cfset variables.captcha = APPLICATION.BLOG.captcha.createHashReference() />
								<input type="hidden" name="captchaHash" value="#variables.captcha.hash#" />
								<input type="text" name="captchaText" id="captchaText" size="6" style="width: 100px" />
								<img src="#APPLICATION.PATH.ROOT#/blog/showCaptcha.cfm?hashReference=#variables.captcha.hash#" alt="Captcha" align="right" vspace="5" />
							</td>
						</tr>
						<tr>
							<td class="label">#rb("remembermyinfo")#:</td>
							<td><input type="checkbox" class="checkBox" id="rememberMe" name="rememberMe" value="1" <cfif isBoolean(form.rememberMe) and form.rememberMe>checked="checked"</cfif> /></td>
						</tr>
					</tbody>
				</table>
				<div class="post_buttons ui-widget-content ui-corner-all">
					<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-cancel" name="cancel" text="#rb('cancel')#" onclick="window.close();" />
					<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-email" name="addsub" text="#rb('post')#" submit="subscribe" />
				</div>
				</form>
			</div>
		</div>
	</div>
	</cfoutput>
<cfelse>
	<cfoutput><p>#rb("subnotallowed")#</p></cfoutput>
</cfif>
