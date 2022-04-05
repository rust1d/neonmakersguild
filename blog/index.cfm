<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
  Name         : Index
  Author       : Raymond Camden
  Created      : February 10, 2003
  Last Updated : May 18, 2007
  History      : Reset history for version 5.0
         : Link for more entries fixed (rkc 6/25/06)
         : Gravatar support (rkc 7/8/06)
         : Cleanup of area shown when no entries exist (rkc 7/15/06)
         : Use of rb(), use of icons, other small mods (rkc 8/20/06)
         : Change how categories are handled (rkc 9/17/06)
         : Big change to cut down on whitespace (rkc 11/30/06)
         : comment mod support (rkc 12/7/06)
         : gravatar fix, thanks Pete F (rkc 12/26/06)
         : use app.maxentries, digg link (rkc 2/28/07)
         : fix bug where 11 items showed up, not 10 (rkc 5/18/07)
  Purpose     : Blog home page
--->

<!--- Handle URL variables to figure out how we will get betting stuff. --->
<cfmodule template="tags/getmode.cfm" r_params="params"/>

<!--- only cache on home page --->
<cfset disabled = false>
<cfif url.mode is not "" or len(cgi.query_string) or not structIsEmpty(form)>
  <cfset disabled = true>
</cfif>

<cfmodule template="tags/scopecache.cfm" cachename="#application.applicationname#" scope="application" disabled="#disabled#" timeout="#application.timeout#">

<!--- Try to get the articles. --->
<cftry>
  <cfset articleData = application.blog.getEntries(params)>
  <cfset articles = articleData.entries>
  <!--- if using alias, switch mode to entry --->
  <cfif url.mode is "alias">
    <cfset url.mode = "entry">
    <cfset url.entry = articles.id>
  </cfif>
  <cfcatch>
    <cfset articleData = structNew()>
    <cfset articleData.totalEntries = 0>
    <cfset articles = queryNew("id")>
  </cfcatch>
</cftry>

<!--- Call layout custom tag. --->
<cfset data = structNew()>
<!---
I already know what I'm doing - I got it from getMode, so let me bypass the work done normally for by Entry, it is the most
popular view
--->
<cfif url.mode is "entry" and articleData.totalEntries is 1>
  <cfset data.title = articles.title[1]>
  <cfset data.entrymode = true>
  <cfset data.entryid = articles.id[1]>
  <cfif not structKeyExists(session.viewedpages, url.entry)>
    <cfset session.viewedpages[url.entry] = 1>
    <cfset application.blog.logView(url.entry)>
  </cfif>
</cfif>

<cfmodule template="tags/layout.cfm" attributecollection="#data#">

  <!--- load up swfobject --->
  <cfoutput>
  <script src="#application.rooturl#/includes/swfobject_modified.js" type="text/javascript"></script>
  </cfoutput>

  <cfset lastDate = "">
  <cfloop query="articles">

    <cfoutput>

            <div class="post">
             <div class="post-header">
              <h3 class="post-title"><a href="#application.blog.makeLink(id)#">#title#</a></h3>

              <p class="post-date">
         <span class="month">#dateFormat(posted, "mmm")#</span>
               <span class="day">#day(posted)#</span>
              </p>
              <p class="post-author">
               <span class="info">posted <cfif len(name)>by <a href="#application.blog.makeUserLink(name)#">#name#</a></cfif> in
           </cfoutput>
           <cfset lastid = listLast(structKeyList(categories))>
        <cfloop item="catid" collection="#categories#">
          <cfoutput><a href="#application.blog.makeCategoryLink(catid)#">#categories[currentRow][catid]#</a><cfif catid is not lastid>, </cfif></cfoutput>
        </cfloop>
          <cfoutput>
          | <a href="#application.blog.makeLink(id)###comments" class="comments"><cfif commentCount neq "">#commentCount#<cfelse>0</cfif> Comments</a>
        <!-- AddThis Button BEGIN -->
        <a href="http://www.addthis.com/bookmark.php?v=250" onmouseover="return addthis_open(this, '', '#URLEncodedFormat(application.blog.makeLink(id))#', '#URLEncodedFormat(application.blog.getProperty('blogTitle'))#')" onmouseout="addthis_close()" onclick="return addthis_sendto()"><img  src="http://s7.addthis.com/static/btn/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0;float:right;"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a20091556eefead"></script>
        <!-- AddThis Button END -->
        </span>
              </p>
             </div>
             <div class="post-content clearfix">
          #application.blog.renderEntry(body,false,ben_enclosure)#

          <!--- STICK IN THE MP3 PLAYER --->
          <cfif ben_enclosure contains "mp3">
            <cfset alternative=replace(getFileFromPath(ben_enclosure),".mp3","") />
            <div class="audioPlayerParent">
              <div id="#alternative#" class="audioPlayer">
              </div>
            </div>
            <script type="text/javascript">
            // <![CDATA[
              var flashvars = {};
              // unique ID
              flashvars.playerID = "#alternative#";
              // load the file
//              flashvars.soundFile= "#application.rooturl#/ben_enclosures/#getFileFromPath(ben_enclosure)#";
                            flashvars.soundFile= "#application.rooturl#/download.cfm/id/#id#/online/1/#urlEncodedFormat(getFileFromPath(ben_enclosure))#";
              // Load width and Height again to fix IE bug
              flashvars.width = "470";
              flashvars.height = "24";
              // Add custom variables
              var params = {};
              params.allowScriptAccess = "sameDomain";
              params.quality = "high";
              params.allowfullscreen = "true";
              params.wmode = "transparent";
              var attributes = false;
              swfobject.embedSWF("#application.rooturl#/includes/audio-player/player.swf", "#alternative#", "470", "24", "8.0.0","/includes/audio-player/expressinstall.swf", flashvars, params, attributes);
            // ]]>
            </script>
          </cfif>
          <cfif len(ben_morebody) and url.mode is not "entry">
          <p align="right">
          <a href="#application.blog.makeLink(id)###more">[#request.rb("more")#]</a>
          </p>
          <cfelseif len(ben_morebody)>
          #application.blog.renderEntry(ben_morebody)#
          </cfif>

          <div class="clear"></div>

          <p class="post-metadata">
          This entry was posted on #dateFormat(posted, "mmmm d, yyyy")# at #timeFormat(posted, "h:mm tt")# and has received #views# views. There are currently <cfif commentCount is "">0<cfelse>#commentCount#</cfif> comments.
          <a href="#application.rooturl#/print.cfm?id=#id#" rel="nofollow">Print this entry.</a>
          <cfif len(ben_enclosure)>
                        <a href="#application.rooturl#/download.cfm/id/#id#/#urlEncodedFormat(getFileFromPath(ben_enclosure))#">Download attachment.</a>
<!---            <a href="#application.rooturl#/ben_enclosures/#urlEncodedFormat(getFileFromPath(ben_enclosure))#">Download attachment.</a>--->
          </cfif>
          </p>


             </div>
            </div>

    </cfoutput>


    <!--- Things to do if showing one entry --->
    <cfif articles.recordCount is 1>

      <cfset qRelatedBlogEntries = application.blog.getRelatedBlogEntries(entryId=id,bDislayFutureLinks=true) />

      <cfif qRelatedBlogEntries.recordCount>
        <cfoutput>
        <div id="relatedentries">
        <p>
        <div class="relatedentriesHeader">#request.rb("relatedblogentries")#</div>
        </p>

          <ul id="relatedEntriesList">
        <cfloop query="qRelatedBlogEntries">
        <li><a href="#application.blog.makeLink(entryId=qRelatedBlogEntries.id)#">#qRelatedBlogEntries.title#</a> (#application.localeUtils.dateLocaleFormat(posted)#)</li>
        </cfloop>
          </ul>
          </div>
          </cfoutput>
      </cfif>

      <cfif application.usetweetbacks>

        <cfoutput>
        <h3 class="commentHeader">TweetBacks</h3>
        <div id="tbContent">
        </cfoutput>

        <cfoutput>
        </div>
        </cfoutput>

      </cfif>


      <cfoutput>
      <h3 class="commentHeader">#request.rb("comments")# <cfif application.commentmoderation>(#request.rb("moderation")#)</cfif></h3>
      </cfoutput>
      <cfset comments = application.blog.getComments(id)>

      <cfif ben_allowcomments>
        <cfoutput>
        <div style="font-size:12px">
        [<a href="javaScript:launchComment('#id#')">#request.rb("addcomment")#</a>]
        [<a href="javaScript:launchCommentSub('#id#')">#request.rb("addsub")#</a>]
        </div>
        </cfoutput>
      </cfif>

      <cfoutput>
      <ul id="comments">

      <cfset entryid = id>
      <cfloop query="comments">
        <cfif currentRow mod 2 is 0>
          <cfset evenodd = "even">
        <cfelse>
          <cfset evenodd = "false">
        </cfif>
        <li class="comment #evenodd# thread-#evenodd# depth-1 with-avatar" id="c#id#">
           <div class="comment-mask regularcomment">
            <div class="comment-main">
             <div class="comment-wrap1">
              <div class="comment-wrap2">
               <div class="comment-head tiptrigger">
            <p><a class="comment-id" href="#application.blog.makeLink(entryid)###c#id#">###currentRow#</a> by <b><cfif len(comments.bco_website)><a href="#comments.bco_website#" rel="nofollow">#name#</a><cfelse>#name#</cfif></b>
            on #application.localeUtils.dateLocaleFormat(posted,"short")# - #application.localeUtils.timeLocaleFormat(posted)#</p>
             </div>
             <div class="comment-body clearfix" id="comment-body-#currentRow#">
            <div class="avatar"><img src="http://www.gravatar.com/avatar/#lcase(hash(lcase(email)))#?s=64&amp;r=pg&amp;d=#application.rooturl#/images/gravatar.gif" title="#name#'s Gravatar" border="0" class="avatar avatar-64 photo" height="64" width="64" /></div>
            <div class="comment-text">
            #application.utils.ParagraphFormat2(application.utils.replaceLinks(comment))#
            </div>
               </div>
              </div>
             </div>
            </div>
           </div>
        </li>

      </cfloop>
      </ul>

      <cfif ben_allowcomments and comments.recordCount gte 5>
        <div style="font-size:12px">
        [<a href="javaScript:launchComment('#id#')">#request.rb("addcomment")#</a>]
        [<a href="javaScript:launchCommentSub('#id#')">#request.rb("addsub")#</a>]
        </div>
      <cfelseif not ben_allowcomments>
        <cfoutput><div>#request.rb("commentsnotallowed")#</div></cfoutput>
      </cfif>

        <div class="clear"></div>
        </cfoutput>

    </cfif>




  </cfloop>

  <cfif articles.recordCount is 0>

    <cfoutput><h3>#request.rb("sorry")#</h3></cfoutput>
    <cfoutput>
    <p>
    <cfif url.mode is "">
      #request.rb("noentries")#
    <cfelse>
      #request.rb("noentriesforcriteria")#
    </cfif>
    </p>
    </cfoutput>

  </cfif>

  <!--- Used for pagination. --->
  <cfif (url.startRow gt 1) or (articleData.totalEntries gte url.startRow + application.maxEntries)>

    <!--- get path if not /index.cfm --->
    <cfset path = rereplace(cgi.path_info, "(.*?)/index.cfm", "")>

    <!--- clean out startrow from query string --->
    <cfset qs = cgi.query_string>
    <!--- handle: http://www.coldfusionjedi.com/forums/messages.cfm?threadid=4DF1ED1F-19B9-E658-9D12DBFBCA680CC6 --->
    <cfset qs = reReplace(qs, "<.*?>", "", "all")>
    <cfset qs = reReplace(qs, "[\<\>]", "", "all")>

    <cfset qs = reReplaceNoCase(qs, "&*startrow=[\-0-9]+", "")>
    <cfif isDefined("form.search") and len(trim(form.search)) and not structKeyExists(url, "search")>
      <cfset qs = qs & "&amp;search=#htmlEditFormat(form.search)#">
    </cfif>

    <cfoutput>
    <p align="right">
    </cfoutput>

    <cfif url.startRow gt 1>

      <cfset prevqs = qs & "&amp;startRow=" & (url.startRow - application.maxEntries)>

      <cfoutput>
      <a href="#application.rooturl#/index.cfm#path#?#prevqs#">#request.rb("preventries")#</a>
      </cfoutput>

    </cfif>

    <cfif (url.startRow gt 1) and (articleData.totalEntries gte url.startRow + application.maxEntries)>
      <cfoutput> / </cfoutput>
    </cfif>

    <cfif articleData.totalEntries gte url.startRow + application.maxEntries>

      <cfset nextqs = qs & "&amp;startRow=" & (url.startRow + application.maxEntries)>

      <cfoutput>
      <a href="#application.rooturl#/index.cfm#path#?#nextqs#">#request.rb("moreentries")#</a>
      </cfoutput>

    </cfif>

    <cfoutput>
    </p>
    </cfoutput>

  </cfif>

</cfmodule>
</cfmodule>

<cfsetting enablecfoutputonly=false>
