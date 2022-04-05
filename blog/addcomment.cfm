<cfprocessingdirective pageencoding="utf-8">
<!---
  Name         : addcomment.cfm
  Author       : Raymond Camden
  Created      : February 11, 2003
  Last Updated : October 8, 2007
  History      : Reset history for version 5.0
         : Lengths allowed for name/email were 100, needed to be 50
         : Cancel confirmation (rkc 8/1/06)
         : rb use (rkc 8/20/06)
         : Scott updates the design a bit (ss 8/24/06)
         : Default form.captchaText (rkc 10/21/06)
         : Don't log the getentry (rkc 2/28/07)
         : Don't mail if moderating (rkc 4/13/07)
  Purpose     : Adds comments
--->

<cfif not isDefined("form.addcomment")>
  <cfif isDefined("cookie.blog_name")>
    <cfset form.name = cookie.blog_name>
    <cfset form.rememberMe = true>
  </cfif>
  <cfif isDefined("cookie.blog_email")>
    <cfset form.email = cookie.blog_email>
    <cfset form.rememberMe = true>
  </cfif>
  <!--- RBB 11/02/2005: Added new bco_website check --->
  <cfif isDefined("cookie.blog_website")>
    <cfset form.bco_website = cookie.blog_website>
    <cfset form.rememberMe = true>
  </cfif>
</cfif>

<cfparam name="form.name" default="">
<cfparam name="form.email" default="">
<!--- RBB 11/02/2005: Added new bco_website parameter --->
<cfparam name="form.bco_website" default="http://">
<cfparam name="form.comments" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.captchaText" default="">

<!--- validate boolean --->
<cfif not isBoolean(form.subscribe)>
  <cfset form.subscribe = false />
</cfif>
<cfif not isBoolean(form.rememberme)>
  <cfset form.rememberme = false />
</cfif>

<cfset closeMe = false>
<cfif not isDefined("url.id")>
  <cfset closeMe = true>
<cfelse>
  <cftry>
    <cfset entry = application.blog.getEntry(url.id,true)>
    <cfcatch>
      <cfset closeMe = true>
    </cfcatch>
  </cftry>
</cfif>
<cfif closeMe>
  <cfoutput>
  <script>
  window.close();
  </script>
  </cfoutput>
  <cfabort>
</cfif>

<cfif isDefined("form.addcomment") and entry.ben_allowcomments>
  <cfset form.name = trim(form.name)>
  <cfset form.email = trim(form.email)>
  <!--- RBB 11/02/2005: Added new bco_website option --->
  <cfset form.bco_website = trim(form.bco_website)>
  <cfset form.comments = trim(form.comments)>

  <!--- if bco_website is just http://, remove it --->
  <cfif form.bco_website is "http://">
    <cfset form.bco_website = "">
  </cfif>
  <!---// track the errors //--->
  <cfset aErrors = arrayNew(1) />

  <cfif not len(form.name)>
    <cfset arrayAppend(aErrors, request.rb("mustincludename")) />
  </cfif>
  <cfif not len(form.email) or not application.utils.isEmail(form.email)>
    <cfset arrayAppend(aErrors, request.rb("mustincludeemail")) />
  </cfif>
  <cfif len(form.bco_website) and not application.utils.isURL(form.bco_website)>
    <cfset arrayAppend(aErrors, request.rb("invalidurl")) />
  </cfif>

  <cfif not len(form.comments)>
    <cfset arrayAppend(aErrors, request.rb("mustincludecomments")) />
  </cfif>

  <!--- captcha validation --->
  <cfif application.useCaptcha and not application.utils.isLoggedIn()>
    <cfif not len(form.captchaText)>
      <cfset arrayAppend(aErrors, "Please enter the Captcha text.") />
    <cfelseif NOT application.captcha.validateCaptcha(form.captchaHash,form.captchaText)>
      <cfset arrayAppend(aErrors, "The captcha text you have entered is incorrect.") />
    </cfif>
  </cfif>
  <!--- cfformprotect --->
  <cfif application.usecfp and not application.utils.isLoggedIn()>
    <cfset cffp = createObject("component","cfformprotect.cffpVerify").init() />
    <!--- now we can test the form submission --->
    <cfif not cffp.testSubmission(form)>
      <cfset arrayAppend(aErrors, "Your comment has been flagged as spam.") />
    </cfif>
  </cfif>

  <cfif not arrayLen(aErrors)>
    <!--- RBB 11/02/2005: added bco_website to commentID --->
      <cftry>
      <cfinvoke component="#application.blog#" method="addComment" returnVariable="commentID">
        <cfinvokeargument name="entryid" value="#url.id#">
        <cfinvokeargument name="name" value="#left(form.name, 50)#">
        <cfinvokeargument name="email" value="#left(form.email,50)#">
        <cfinvokeargument name="bco_website" value="#left(form.bco_website, 255)#">
        <cfinvokeargument name="comments" value="#form.comments#">
        <cfinvokeargument name="subscribe" value="#form.subscribe#">
        <cfif application.utils.isLoggedIn()>
          <cfinvokeargument name="overridemoderation" value="true">
        </cfif>
      </cfinvoke>

      <!--- Form a message about the comment --->
      <cfset subject = "Comment posted to " & application.blog.getProperty("blogTitle") & " : " & entry.title>
      <cfset commentTime = dateAdd("h", application.blog.getProperty("offset"), now())>

      <cfsavecontent variable="email">
      <cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Comment Subscription</title>
</head>
<body id="blogcommentmail" style="font:10pt Arial,sans-serif;padding: 10px;">
  <table cellspacing=0>
    <tr id="header">
      <td colspan=2 style="font-size: 14pt;padding:0 0 6px 0;border-bottom:1px solid ##e4e8af;">Comment Added to <a href="#application.blog.makeLink(url.id)###c#commentID#" style="color:##7d8524;text-decoration:none;">#htmlEditFormat(application.blog.getProperty("blogTitle"))# : #entry.title#</a></td>
    </tr>
    <tr><td colspan=2 style="height:10px"></td></tr>
    <tr id="content" style="padding: 20px;">
      <td id="comment" style="width:75%;">
#application.utils.ParagraphFormat2(htmlEditFormat(form.comments))#
      </td>
      <td id="commentor" valign=top style="width:25%;background-color: ##edf0c9;height:100%">
        <div id="avatar" style="text-align: center;margin:30px 0 0 0;padding:20px 0 20px 0;width: 100%;height: 100%;">
          <img src="http://www.gravatar.com/avatar/#hash(lcase(trim(form.email)))#?s=80&amp;r=pg&amp;d=#application.rooturl#/images/gravatar.gif" id="avatar_image" border=0 title="#form.name#'s Gravatar" style="width:80px;height:80px;padding:5px;background:white; border:1px solid ##e4e8af;" />
          <div id="commentorname" style="text-align: center;padding:20 0 20px 0;"><cfif len(form.bco_website)><a href="#form.bco_website#" style="color:##7d8524;text-decoration:none;"></cfif>#form.name#<cfif len(form.bco_website)></a></cfif></div>
        </div>
      </td>
    </tr>
    <tr><td colspan=2 style="height:10px"></td></tr>
    <tr id="footer">
      <td style="border-top:1px solid ##e4e8af;padding:0 10px 0 0;"><a href="http://blogcfc.com/" style="color:##7d8524;text-decoration:none;"><img src="#application.rooturl#/images/logo.png" border=0/></a></td>
      <td id="footerlinks" nowrap style="margin:5px;text-align:right;border-top:1px solid ##e4e8af;padding:0 10px 0 0;">
        %unsubscribe%
        <div id="createdby" style="font-size:8pt;padding:20px 0 0 0;bottom:0px;text-align:right;">
          Created by <a href="http://www.coldfusionjedi.com" style="color:##7d8524;text-decoration:none;">Raymond Camden</a>
        </div>
      </td>
    </tr>
  </table>
</body>
</html>
      </cfoutput>
      </cfsavecontent>

      <cfinvoke component="#application.blog#" method="notifyEntry">
        <cfinvokeargument name="entryid" value="#entry.id#">
        <cfinvokeargument name="message" value="#trim(email)#">
        <cfinvokeargument name="subject" value="#subject#">
        <cfinvokeargument name="from" value="#form.email#">
        <cfif application.commentmoderation>
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
      <cfset comments = application.blog.getComments(url.id)>
      <!--- clear form data --->
      <cfif form.rememberMe>
        <cfcookie name="blog_name" value="#trim(htmlEditFormat(form.name))#" expires="never">
        <cfcookie name="blog_email" value="#trim(htmlEditFormat(form.email))#" expires="never">
            <!--- RBB 11/02/2005: Added new bco_website cookie --->
        <cfcookie name="blog_website" value="#trim(htmlEditFormat(form.bco_website))#" expires="never">
      <cfelse>
        <cfcookie name="blog_name" expires="now">
        <cfcookie name="blog_email" expires="now">
        <!--- RBB 11/02/2005: Added new bco_website form var --->
        <cfset form.name = "">
        <cfset form.email = "">
        <cfset form.bco_website = "">
      </cfif>
      <cfset form.comments = "">

      <!--- reload page and close this up --->
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <cfoutput><title>#application.blog.getProperty("blogTitle")# : #request.rb("addcomments")#</title></cfoutput>
  <link rel="stylesheet" href="includes/style.css" type="text/css" />
  <meta content="text/html; charset=UTF-8" http-equiv="content-type" />
</head>

<body id="popUpFormBody">

<cfoutput>
<div class="date">#request.rb("comments")#: #entry.title#</div>
<div class="body">
</cfoutput>

<cfif entry.ben_allowcomments>


    <cfif isDefined("aErrors") and arrayLen(aErrors)>
      <cfoutput>
        <div id="CommentError">
          <b>#request.rb("correctissues")#:</b>
          <ul class="error"><li>#arrayToList(aErrors, "</li><li>")#</li></ul>
        </div>
      </cfoutput>
    </cfif>
  <cfoutput>
  <form action="#application.rootURL#/addcomment.cfm?#cgi.query_string#" method="post">
  <cfif application.usecfp>
    <cfinclude template="cfformprotect/cffp.cfm">
  </cfif>
  <fieldset id="commentForm">
      <legend>#request.rb("postyourcomments")#</legend>
  <div>
    <label for="name">#request.rb("name")#:</label>
    <input type="text" id="name" name="name" value="#form.name#" />
  </div>
  <div>
    <label for="email">#request.rb("emailaddress")#:</label>
    <input type="text" id="email" name="email" value="#form.email#" />
  </div>
  <div>
    <label for="bco_website">#request.rb("bco_website")#:</label>
    <input type="text" id="bco_website" name="bco_website" value="#form.bco_website#" />
  </div>
  <div>
    <label for="comments">#request.rb("comments")#:</label>
    <textarea name="comments" id="comments" rows="5" cols="45">#form.comments#</textarea>
  </div>
  <cfif application.useCaptcha and not application.utils.isLoggedIn()>
    <div>
    <cfset variables.captcha = application.captcha.createHashReference() />
    <input type="hidden" name="captchaHash" value="#variables.captcha.hash#" />
    <label for="captchaText" class="longLabel">#request.rb("captchatext")#:</label>
    <input type="text" name="captchaText" id="captchaText" size="6" /><br />
    <img src="#application.blog.getRootURL()#showCaptcha.cfm?hashReference=#variables.captcha.hash#" alt="Captcha" align="right" vspace="5" />
  </div>
  </cfif>
  <div>
    <label for="rememberMe" class="longLabel">#request.rb("remembermyinfo")#:</label>
    <input type="checkbox" class="checkBox" id="rememberMe" name="rememberMe" value="1" <cfif isBoolean(form.rememberMe) and form.rememberMe>checked="checked"</cfif> />
  </div>
  <div>
    <label for="subscribe" class="longLabel">#request.rb("subscribe")#:</label>
    <input type="checkbox" class="checkBox" id="subscribe" name="subscribe" value="1" <cfif isBoolean(form.subscribe) and form.subscribe>checked="checked"</cfif> />
  </div>
  <p style="clear:both">#request.rb("subscribetext")#</p>
  <div style="text-align:center">
    <input type="reset" id="reset" value="#request.rb("cancel")#" onclick="if(confirm('#request.rb("cancelconfirm")#')) { window.close(); } else { return false; }" /> <input type="submit" id="submit" name="addcomment" value="#request.rb("post")#" />
    </div>
</fieldset>
  </form>
  </cfoutput>

<cfelse>

  <cfoutput>
  <p>#request.rb("commentsnotallowed")#</p>
  </cfoutput>

</cfif>
</div>

</body>
</html>