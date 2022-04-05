<cfparam name="URL.id" default="">
<cfif not len(URL.id)>
  <cfabort>
</cfif>

<cfset tweetbacks = APPLICATION.BLOG.sweetTweets.getTweetbacks(SESSION.BROG.makeLink(id), 10)/>

<cfif arrayLen(tweetbacks)>
  <cfloop index="x" from="1" to="#arrayLen(tweetbacks)#">
    <cfset tb = tweetbacks[x]>
    <cfoutput>
    <div class="tweetback">
    <div class="tweetbackBody">
    <img src="#tb.profile_image_url#" title="#tb.from_user#'s Profile" border="0" align="left" />
    #paragraphFormat2(tb.text)#
    </div>
    <div class="tweetbackByLine">
    #rb("postedby")# <a href="http://www.twitter.com/#tb.from_user#">#tb.from_user#</a>
    | #APPLICATION.BLOG.localeUtils.dateLocaleFormat(tb.created_at,"short")# #APPLICATION.BLOG.localeUtils.timeLocaleFormat(tb.created_at)#
    </div>
    <br clear="left">
    </div>
    </cfoutput>
  </cfloop>

<cfelse>
  <cfoutput><p class="tweetbackBody">#APPLICATION.BLOG.resourceBundle.getResource("notweetbacks")#</p></cfoutput>
</cfif>
