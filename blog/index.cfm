<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8"/>
<!--- HANDLE URL VARIABLES TO FIGURE OUT HOW WE WILL GET GETTING STUFF. --->
<cfmodule template="tags/getmode.cfm" r_params="params"/>
<!--- ONLY CACHE ON HOME PAGE --->
<cfset disabled = false>
<cfif URL.mode is not "" or len(CGI.query_string) or not structIsEmpty(form)>
  <cfset disabled = true>
</cfif>

<cfmodule template="tags/scopecache.cfm" cachename="#SESSION.BROG.getProperty('name')#" scope="APPLICATION" disabled="#disabled#" timeout="#APPLICATION.BLOG.timeout#">
  <cftry><!--- TRY TO GET THE ARTICLES. --->
    <cfset articleData = SESSION.BROG.getEntries(params)>
    <cfset articles = articleData.entries>
    <cfif URL.mode is "alias"><!--- IF USING ALIAS, SWITCH MODE TO ENTRY --->
      <cfset URL.mode = "entry">
      <cfset URL.entry = articles.id>
    </cfif>
    <cfcatch>
      <cfset articleData = structNew()>
      <cfset articleData.totalEntries = 0>
      <cfset articles = queryNew("id")>
    </cfcatch>
  </cftry>
  <!--- Call layout custom tag. --->
  <cfset data = structNew()>
  <!--- I already know what I'm doing - I got it from getMode, so let me bypass the work done normally for by Entry, it is the most popular view --->
  <cfif URL.mode is "entry" and articleData.totalEntries is 1>
    <cfset data.title = articles.title[1]>
    <cfset data.entrymode = true>
    <cfset data.entryid = articles.id[1]>
    <cfif not StructKeyExists(SESSION.viewedpages, URL.entry)>
      <cfset SESSION.viewedpages[URL.entry] = 1>
      <cfset SESSION.BROG.logView(URL.entry)>
    </cfif>
  </cfif>
  <cfmodule template="tags/layout.cfm" attributecollection="#data#">
    <cfset lastDate = "">
    <cfloop query="articles">
      <cfoutput>
      <div class="post">
        <div class="post-header">
          <h1 class="post-title"><a href="#SESSION.BROG.makeLink(id)#">#title#</a></h1>
          <div class="metadata">
            #udfUserDateFormat(posted)# <cfif len(name)>by <a href="#SESSION.BROG.makeUserLink(name)#">#name#</a></cfif>|
            <cfloop item="catid" collection="#categories#">
              <a href="#SESSION.BROG.makeCategoryLink(catid)#">#categories[currentRow][catid]#</a>
            </cfloop>
            | <a href="#SESSION.BROG.makeLink(id)###comments" class="comments">#udfAddSWithCnt("Comment", int("0#commentCount#"))#</a>
              <!--- AddThis Button BEGIN --->
              <div class="share">
                <div class="addthis_toolbox addthis_default_style ">
                  <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
                  <a class="addthis_button_tweet"></a>
                  <a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
                </div>
              </div>
              <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##pubid=ra-4f65ee7e36ee027b"></script>
              <!--- AddThis Button END --->
          </div>
        </div>
        <div class="post-content clearfix">
          #SESSION.BROG.renderEntry(body,false,enclosure)#
          <cfif len(morebody) and URL.mode is not "entry">
            <p align="right"><a href="#SESSION.BROG.makeLink(id)###more">[#rb("more")#]</a></p>
          <cfelseif len(morebody)>
            #SESSION.BROG.renderEntry(morebody)#
          </cfif>
          <div class="clear"></div>
          <p class="post-metadata">
            Posted #udfUserDateFormat(posted)# at #timeFormat(posted, "h:mm tt")#
            | #udfAddSWithCnt("View", views)#
            | <a href="#SESSION.BROG.makeLink(id)###comments" class="comments">#udfAddSWithCnt("Comment", int("0#commentCount#"))#</a>
            | <a href="#APPLICATION.PATH.ROOT#/b.print.cfm?id=#id#" rel="nofollow">Print</a>
            <cfif len(enclosure)>| <a href="#APPLICATION.PATH.ATTACH#/#REQUEST.BLOG#/#urlEncodedFormat(getFileFromPath(enclosure))#">Download attachment.</a></cfif>
          </p>
        </div>
      </div>
      </cfoutput>
      <!--- Things to do if showing one entry --->
      <cfif articles.RecordCount is 1>
        <cfset qRelatedBlogEntries = SESSION.BROG.getRelatedBlogEntries(entryId=id,bDislayFutureLinks=true) />
        <cfif qRelatedBlogEntries.RecordCount>
          <cfoutput>
          <div id="relatedentries">
            <p><div class="relatedentriesHeader">#rb("relatedblogentries")#</div></p>
            <ul id="relatedEntriesList">
              <cfloop query="qRelatedBlogEntries">
                <li>
                  <a href="#SESSION.BROG.makeLink(entryId=qRelatedBlogEntries.id)#">#qRelatedBlogEntries.title#</a>
                  (#APPLICATION.BLOG.localeUtils.dateLocaleFormat(posted)#)
                </li>
              </cfloop>
            </ul>
          </div>
          </cfoutput>
        </cfif>
        <cfif SESSION.BROG.getProperty("usetweetbacks")>
          <cfoutput>
          <div class="tweetbacks">
            <h3>TweetBacks</h3>
            <div id="tbContent"></div>
          </div>
          </cfoutput>
        </cfif>
        <cfif allowComments>
          <cfoutput>
          <h3>#rb("comments")#<cfif NOT SESSION.LoggedIn AND SESSION.BROG.getProperty("moderate")><span class="bco_moderated">#rb("moderation")#</span></cfif></h3>
          <div class="post_buttons comment_post_buttons">
            <span class="imgbtn ui-corner-all" onclick="launchComment('#id#')"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-comment" />#rb('addcomment')#</span>
            <span class="imgbtn ui-corner-all" onclick="launchCommentSub('#id#')"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-email" />#rb('addsub')#</span>
          </div>
          </cfoutput>
        </cfif>
        <cfset comments = SESSION.BROG.getComments(id)>
        <cfoutput>
          <ul id="comments">
            <cfset entryid = id>
            <cfloop query="comments">
              <cfif comments.usid NEQ 0>
                <cfset avSrc = udfAvatarSrc(comments.Avatar, comments.Gravatar) />
              <cfelse>
                <cfset avSrc = udfAvatarSrc(email=comments.email) />
              </cfif>
              <li class="comment" id="c#id#">
                <div class="comment-mask regularcomment">
                  <div class="ui-widget-header">
                    <p>
                      <a href="#SESSION.BROG.makeLink(entryid)###c#id#">###currentRow#</a>
                      by
                      <b>
                        <cfif len(comments.bco_website)>
                          <a href="#comments.bco_website#" rel="nofollow">#name#</a>
                        <cfelse>
                          #name#
                        </cfif>
                      </b>
                      on #APPLICATION.BLOG.localeUtils.dateLocaleFormat(posted,"short")# - #APPLICATION.BLOG.localeUtils.timeLocaleFormat(posted)#
                    </p>
                  </div>
                  <div id="comment-body-#currentRow#" class="ui-widget-content comment-body clearfix">
                    <div class="avatar">
                      <cfif len(comments.bco_website)>
                        <a href="#comments.bco_website#" rel="nofollow"><img src="#avSrc#" border="0" class="avatar avatar-64 photo" height="64" width="64" /></a>
                      <cfelse>
                        <img src="#avSrc#" border="0" class="avatar avatar-64 photo" height="64" width="64" />
                      </cfif>
                    </div>
                    <div class="pad10">
                      #paragraphFormat2(replaceLinks(comment))#
                    </div>
                  </div>
                </div>
              </li>
            </cfloop>
          </ul>
          <cfif allowComments and comments.RecordCount gte 5>
            <div class="post_buttons comment_post_buttons">
              <span class="imgbtn ui-corner-all" onclick="launchComment('#id#')"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-comment" />#rb('addcomment')#</span>
              <span class="imgbtn ui-corner-all" onclick="launchCommentSub('#id#')"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-email" />#rb('addsub')#</span>
            </div>
          <cfelseif not allowcomments>
            <cfoutput>
              <div>#rb("commentsnotallowed")#</div>
            </cfoutput>
          </cfif>
          <div class="clear"></div>
        </cfoutput>
      </cfif>
    </cfloop>
    <cfif articles.RecordCount is 0>
      <cfoutput>
        <h3>#rb("sorry")#</h3>
      </cfoutput>
      <cfoutput>
        <p>
          <cfif URL.mode is "">
            #rb("noentries")#
          <cfelse>
            #rb("noentriesforcriteria")#
          </cfif>
        </p>
      </cfoutput>
    </cfif>
    <!--- Used for pagination. --->
    <cfif (URL.startRow gt 1) or (articleData.totalEntries gte URL.startRow + APPLICATION.BLOG.maxEntries)>
      <!--- get path if not /index.cfm --->
      <cfset path = rereplace(CGI.path_info, "(.*?)/index.cfm", "")>
      <!--- clean out startrow from query string --->
      <cfset qs = CGI.query_string>
      <!--- handle: http://www.coldfusionjedi.com/forums/messages.cfm?threadid=4DF1ED1F-19B9-E658-9D12DBFBCA680CC6 --->
      <cfset qs = reReplace(qs, "<.*?>", "", "all")>
      <cfset qs = reReplace(qs, "[\<\>]", "", "all")>
      <cfset qs = reReplaceNoCase(qs, "&*startrow=[\-0-9]+", "")>
      <cfif isDefined("form.search") and len(trim(form.search)) and not StructKeyExists(URL, "search")>
        <cfset qs = qs & "&amp;search=#htmlEditFormat(form.search)#">
      </cfif>
      <cfoutput>
        <p align="right">
      </cfoutput>
      <cfif URL.startRow gt 1> <cfset prevqs = qs & "&amp;startRow=" & (URL.startRow - APPLICATION.BLOG.maxEntries)> <cfoutput> <a href="#APPLICATION.PATH.ROOT#/p.index.cfm#path#?#prevqs#">#rb("preventries")#</a> </cfoutput> </cfif> <cfif (URL.startRow gt 1) and (articleData.totalEntries gte URL.startRow + APPLICATION.BLOG.maxEntries)> <cfoutput> / </cfoutput> </cfif> <cfif articleData.totalEntries gte URL.startRow + APPLICATION.BLOG.maxEntries> <cfset nextqs = qs & "&amp;startRow=" & (URL.startRow + APPLICATION.BLOG.maxEntries)> <cfoutput> <a href="#APPLICATION.PATH.ROOT#/p.index.cfm#path#?#nextqs#">#rb("moreentries")#</a> </cfoutput> </cfif> <cfoutput> </p> </cfoutput>
    </cfif>
  </cfmodule>
</cfmodule>
<cfsetting enablecfoutputonly="false" />
