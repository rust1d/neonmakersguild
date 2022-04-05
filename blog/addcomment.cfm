<cfoutput>
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/popout.css" />
	<style type="text/css">
		@import "#APPLICATION.PATH.ROOT#/blog/css/blog.css";
	</style>
</cfoutput>

<cfif SESSION.LoggedIn>
	<cfset form.usid = SESSION.USER.usid />
	<cfset form.name = SESSION.USER.user />
	<cfset form.email = SESSION.USER.email />
	<cfset form.bco_website = "#APPLICATION.PATH.FULL#/#SESSION.USER.user#/p.brewer.cfm" />
	<cfset form.rememberMe = false />
</cfif>

<cfif NOT isDefined("form.addcomment")>
	<cfif NOT SESSION.LoggedIn>
		<cfif isDefined("cookie.blog_name")>
			<cfset form.name = cookie.blog_name>
			<cfset form.rememberMe = true>
		</cfif>
		<cfif isDefined("cookie.blog_email")>
			<cfset form.email = cookie.blog_email>
			<cfset form.rememberMe = true>
		</cfif>
		<cfif isDefined("cookie.blog_bco_website")>
			<cfset form.bco_website = cookie.blog_bco_website>
			<cfset form.rememberMe = true>
		</cfif>
	</cfif>
</cfif>

<cfparam name="form.usid" default="0">
<cfparam name="form.name" default="">
<cfparam name="form.email" default="">
<cfparam name="form.bco_website" default="http://">
<cfparam name="form.comments" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.captchaText" default="">

<!--- validate boolean --->
<cfif not isBoolean(form.subscribe)><cfset form.subscribe = false /></cfif>
<cfif not isBoolean(form.rememberme)><cfset form.rememberme = false /></cfif>

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
	<cfoutput><script>window.close()</script></cfoutput>
	<cfabort>
</cfif>

<cfif isDefined("form.addcomment") and entry.allowcomments>
	<cfset form.name = trim(form.name)>
	<cfset form.email = trim(form.email)>
	<cfset form.bco_website = trim(form.bco_website)>
	<cfset form.comments = trim(form.comments)>
	<cfif form.bco_website is "http://">
		<cfset form.bco_website = "">
	</cfif>
	<cfset aErrors = arrayNew(1) />
	<cfif not len(form.name)><cfset arrayAppend(aErrors, rb("mustincludename")) /></cfif>
	<cfif not len(form.email) or not isEmail(form.email)><cfset arrayAppend(aErrors, rb("mustincludeemail")) /></cfif>
	<cfif len(form.bco_website) and not isURL(form.bco_website)><cfset arrayAppend(aErrors, rb("invalidurl")) /></cfif>
	<cfif not len(form.comments)><cfset arrayAppend(aErrors, rb("mustincludecomments")) /></cfif>

	<!--- captcha validation --->
	<cfif not SESSION.LoggedIn>
		<cfif not len(form.captchaText)>
			<cfset arrayAppend(aErrors, "Please enter the Captcha text.") />
		<cfelseif NOT APPLICATION.BLOG.captcha.validateCaptcha(form.captchaHash,form.captchaText)>
			<cfset arrayAppend(aErrors, "The captcha text you have entered is incorrect.") />
		</cfif>
	</cfif>
	<!--- cfformprotect --->
	<cfif not SESSION.LoggedIn>
		<cfif not APPLICATION.CFC.Factory.get("CFFP").testSubmission(form)>
			<cfset arrayAppend(aErrors, "Your comment has been flagged as spam.") />
		</cfif>
	</cfif>
	<cfif not arrayLen(aErrors)>
		<cftry>
			<cfinvoke component="#SESSION.BROG#" method="addComment" returnVariable="commentID">
				<cfinvokeargument name="entryid" value="#URL.id#" />
				<cfinvokeargument name="usid" value="#form.usid#" />
				<cfinvokeargument name="name" value="#left(form.name, 50)#" />
				<cfinvokeargument name="email" value="#left(form.email,50)#" />
				<cfinvokeargument name="bco_website" value="#left(form.bco_website, 255)#" />
				<cfinvokeargument name="comments" value="#form.comments#" />
				<cfinvokeargument name="subscribe" value="#form.subscribe#" />
				<cfif SESSION.LoggedIn>
					<cfinvokeargument name="overridemoderation" value="true" />
				</cfif>
			</cfinvoke>
			<cfset subject = "#REQUEST.BLOG#'s blog has a new comment in #entry.title#" />
			<cfset commentTime = dateAdd("h", SESSION.BROG.getProperty("offset"), now())>
			<cfif SESSION.LoggedIn>
				<cfset avSrc = udfAvatarSrc(SESSION.USER.Avatar, SESSION.USER.Gravatar) />
			<cfelse>
				<cfset avSrc = udfAvatarSrc(email=form.email) />
			</cfif>
			<cfsavecontent variable="email">
			<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>BeerInHand Comment Subscription</title>
</head>
<body id="blogcommentmail" style="font:10pt Arial,sans-serif;padding: 10px;">
	<table cellspacing="10" width="100%" style="max-width: 800px;">
		<tr id="header">
			<td colspan=2 style="font-size: 14pt; text-transform: capitalize;">#SESSION.BROG.getProperty("name")#'s Blog Comment Notification</td>
		</tr>
		<tr>
			<td colspan=2 style="font-size: 12pt;">A new comment was added to the blog entry <b><a href="#SESSION.BROG.makeLink(URL.id)###c#commentID#" style="color:##7d8524;text-decoration:none;">#entry.title#</a></b>: </td>
		</tr>
		<tr id="content" style="padding: 20px;">
			<td id="comment">
#paragraphformat2(htmlEditFormat(form.comments))#
			</td>
			<td id="commentor" valign=top style="width:120px; height:100%">
				<div id="avatar" style="text-align: center;margin:30px 0 0 0;padding:20px 0 20px 0;width: 100%;height: 100%;">
					<img src="#avSrc#" id="avatar_image" border=0 style="width:80px;height:80px;padding:5px;background:white; border:1px solid ##e4e8af;" />
					<div id="commentorname" style="text-align: center;padding:20 0 20px 0;"><cfif len(form.bco_website)><a href="#form.bco_website#" style="color:##7d8524;text-decoration:none;"></cfif>#form.name#<cfif len(form.bco_website)></a></cfif></div>
				</div>
			</td>
		</tr>
		<tr><td colspan=2 style="height:10px"></td></tr>
		<tr id="footer">
			<td style="border-top:1px solid ##e4e8af;padding:0 10px 0 0;"><a href="http://beerinhand.com/" style="color:##7d8524;text-decoration:none;"><img id="beerme" title="www.beerinhand.com" src="#udfGlassSrc()#" /></a></td>
			<td id="footerlinks" nowrap style="margin:5px;text-align:right;border-top:1px solid ##e4e8af;padding:0 10px 0 0;">
				%unsubscribe%
			</td>
		</tr>
	</table>
</body>
</html>
			</cfoutput>
			</cfsavecontent>
			<cfinvoke component="#SESSION.BROG#" method="notifyEntry">
				<cfinvokeargument name="entryid" value="#entry.id#">
				<cfinvokeargument name="message" value="#trim(email)#">
				<cfinvokeargument name="subject" value="#subject#">
				<cfinvokeargument name="from" value="#form.email#">
				<cfif SESSION.BROG.getProperty("moderate") AND NOT SESSION.LoggedIn>
					<cfinvokeargument name="adminonly" value="true">
				</cfif>
				<cfinvokeargument name="commentid" value="#commentid#">
				<cfinvokeargument name="html" value="true">
			</cfinvoke>
			<cfcatch>
				<cfif cfcatch.message is not "Comment blocked for spam.">
					<cfrethrow>
				<cfelse>
					<cfset arrayAppend(aErrors, "Your comment has been flagged as spam.") />
				</cfif>
			</cfcatch>
			</cftry>
		<cfif not arrayLen(aErrors)>
			<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
			<cfset comments = SESSION.BROG.getComments(URL.id)>
			<cfif form.rememberMe>
				<cfcookie name="blog_name" value="#trim(htmlEditFormat(form.name))#" expires="never">
				<cfcookie name="blog_email" value="#trim(htmlEditFormat(form.email))#" expires="never">
				<cfcookie name="blog_bco_website" value="#trim(htmlEditFormat(form.bco_website))#" expires="never">
			<cfelse>
				<cfcookie name="blog_name" expires="now">
				<cfcookie name="blog_email" expires="now">
				<cfset form.name = "">
				<cfset form.email = "">
				<cfset form.bco_website = "">
			</cfif>
			<cfset form.comments = "">
			<cfoutput>
			<script>
				window.opener.location.reload();
				window.close();
			</script>
			</cfoutput>
			<cfabort>
		</cfif>
	</cfif>
</cfif>

<cfif entry.allowcomments>
	<cfoutput>
	<div id="divBlog">
		<div id="blogAddComment">
		<h2><a name="newpost"></a>#rb("postyourcomments")#</h2>
		<cfif isDefined("aErrors") and arrayLen(aErrors)>
			<div id="CommentError">
				<b>#rb("correctissues")#:</b>
				<ul class="error"><li>#arrayToList(aErrors, "</li><li>")#</li></ul>
			</div>
		</cfif>
			<h3 class="capitalize">#REQUEST.BLOG#'s Blog: #entry.title#</h3>
			<div class="ui-widget-content">
				<form action="#APPLICATION.PATH.ROOT#/b.addcomment.cfm?#CGI.query_string#" method="post">
				<cfinclude template="#APPLICATION.PATH.ROOT#/cfformprotect/cffp.cfm">
				<table class="datagrid noborder" cellspacing="0" width="640">
					<tbody class="bih-grid-form nobevel">
					<cfif SESSION.LoggedIn>
						<tr>
							<td class="label" width="75">#rb("name")#:</td>
							<td><h3>#form.name#</h3></td>
						</tr>
					<cfelse>
						<tr>
							<td class="label required">#rb("name")#:</td>
							<td><input type="text" id="name" name="name" value="#form.name#"<cfif SESSION.LoggedIn> readonly="readonly"</cfif> /></td>
						</tr>
						<tr>
							<td class="label required">#rb("emailaddress")#:</td>
							<td><input type="text" id="email" name="email" value="#form.email#" /></td>
						</tr>
						<tr>
							<td class="label">#rb("bco_website")#:</td>
							<td><input type="text" id="bco_website" name="bco_website" value="#form.bco_website#" /></td>
						</tr>
					</cfif>
						<tr>
							<td class="label required">#rb("comments")#:</td>
							<td><textarea name="comments" id="comments" style="width:100%; height: 275px;">#form.comments#</textarea></td>
						</tr>
					<cfif not SESSION.LoggedIn>
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
					</cfif>
						<tr>
							<td class="label">#rb("subscribe")#:</td>
							<td>
								<input type="checkbox" class="checkBox" id="subscribe" name="subscribe" value="1" <cfif isBoolean(form.subscribe) and form.subscribe>checked="checked"</cfif> />
								#rb("subscribetext")#
							</td>
						</tr>
					</tbody>
				</table>
				<div class="post_buttons ui-widget-content ui-corner-all">
					<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-cancel" name="cancel" text="#rb('cancel')#" onclick="if (confirm('#rb('cancelconfirm')#')) window.close(); else return false;" />
					<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" name="addcomment" text="#rb('post')#" submit="true" />
				</div>
				</form>
			</div>
		</div>
	</div>
	</cfoutput>
</cfif>
