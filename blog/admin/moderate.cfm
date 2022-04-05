<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : /client/admin/moderate.cfm
	Author       : Trent Richardson
	Created      : 12/7/06
	Last Updated : 5/18/07
	History      : Handle sending email for bco_moderated comments. Note the sucky duplication of the email
	 			   here. I need to fix that in the future. (rkc 4/13/07)
	 			 : Call approveCOmment, and use 'bco_moderated' for ip. I may just hide the whole line (rkc 5/18/07)
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset SESSION.BROG.deleteComment(u)>
	</cfloop>
</cfif>

<cfif StructKeyExists(URL, "approve")>
	<cfset c = SESSION.BROG.getComment(URL.approve)>
	<cfset entry = SESSION.BROG.getEntry(c.entryidfk)>
	<cfset SESSION.BROG.approveComment(URL.approve)>

	<cfif c.usid NEQ 0>
		<cfset qryUser = APPLICATION.CFC.Users.QueryUser(us_usid=c.usid, extend=1) />
		<cfset avSrc = udfAvatarSrc(qryUser.Avatar, qryUser.Gravatar) />
	<cfelse>
		<cfset avSrc = udfAvatarSrc(email=form.email) />
	</cfif>
	<cfset subject = "#REQUEST.BLOG#'s blog has a new comment in #entry.title#" />
	<cfsavecontent variable="email">
	<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Comment Subscription</title>
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
#paragraphformat2(htmlEditFormat(c.comment))#
			</td>
			<td id="commentor" valign=top style="width:120px; height:100%">
				<div id="avatar" style="text-align: center;margin:30px 0 0 0;padding:20px 0 20px 0;width: 100%;height: 100%;">
					<img src="#avSrc#" id="avatar_image" border=0 style="width:80px;height:80px;padding:5px;background:white; border:1px solid ##e4e8af;" />
					<div id="commentorname" style="text-align: center;padding:20 0 20px 0;"><cfif len(c.bco_website)><a href="#c.bco_website#" style="color:##7d8524;text-decoration:none;"></cfif>#c.name#<cfif len(c.bco_website)></a></cfif></div>
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
	<cfset SESSION.BROG.notifyEntry(entryid=c.entryidfk, message=trim(email), subject=subject, from=c.email, noadmin=true, commentid=c.id, html=true)>
</cfif>
<cfset comments = SESSION.BROG.getUnbco_moderatedComments(sortdir="desc")>
<cfmodule template="../tags/adminlayout.cfm" title="Comments">
	<cfoutput>
	<p>Your blog currently has #udfAddSWithCnt("comment", comments.RecordCount)# to moderate.</p>
	</cfoutput>
	<cfmodule template="../tags/datatable.cfm" data="#comments#" editlink="x.comment.cfm" label="Comments" linkcol="comment" defaultsort="posted" defaultdir="desc" showAdd="false">
		<cfmodule template="../tags/datacol.cfm" label="Approve" data="<a href=""#APPLICATION.PATH.ROOT#/blog/admin/x.moderate.cfm?approve=$id$"">Approve</a>" sort="false"/>
		<cfmodule template="../tags/datacol.cfm" colname="name" label="Name" />
		<cfmodule template="../tags/datacol.cfm" colname="entrytitle" label="Entry" left="100" />
		<cfmodule template="../tags/datacol.cfm" colname="posted" label="Posted" format="datetime" width="125" />
		<cfmodule template="../tags/datacol.cfm" colname="comment" label="Comment" left="200"/>
	</cfmodule>
</cfmodule>
<cfsetting enablecfoutputonly="false" />