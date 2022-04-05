<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
  Name         : slideshow.cfm
  Author       : Raymond Camden
  Created      : August 18, 2006
  Last Updated : December 14, 2006
  History      : Added metadata support (rkc 9/5/06)
         : Support for getting slide show dir from CFC (rkc 12/14/06)
  Purpose     : Slide Show
--->

<cfset slideshowdir = listLast(CGI.path_info, "/")>

<cfif not len(slideshowdir)>
  <cflocation url="#APPLICATION.PATH.ROOT#/index.cfm" addToken="false">
</cfif>

<cfset directory = udfMakeDirIfNot("#APPLICATION.BLOG.slideshow.getSlideShowDir()#/#slideshowDir#")>

<cfset metadata = APPLICATION.BLOG.slideshow.getInfo(directory)>
<cfset images = APPLICATION.BLOG.slideshow.getImages(directory)>

<cfif not images.RecordCount>
  <cflocation url="#APPLICATION.PATH.ROOT#/index.cfm" addToken="false">
</cfif>

<cfparam name="URL.slide" default="1">

<cfif not isNumeric(URL.slide) or URL.slide lte 0 or URL.slide gt images.RecordCount or round(URL.slide) neq URL.slide>
  <cfset URL.slide = 1>
</cfif>

<cfif len(metadata.formalname)>
  <cfset title = "Slideshow - #metadata.formalname#">
<cfelse>
  <cfset title = "Slideshow">
</cfif>

<cfmodule template="tags/layout.cfm" title="#title#">

  <cfoutput>
  <div class="date"><b>#title# - Picture #URL.slide# of #images.RecordCount#</b></div>
  <div class="body">
  <p align="center">
  <img src="#APPLICATION.PATH.ROOT#/blog/images/slideshows#APPLICATION.DISK.BLOGIMG#\#slideshowdir#/#images.name[URL.slide]#" /><br />
  <cfif structKeyExists(metadata.images, images.name[URL.slide])>
  <b>#metadata.images[images.name[URL.slide]]#</b><br />
  </cfif>
  <cfif URL.slide gt 1>
  <a href="#APPLICATION.PATH.ROOT#/b.slideshow.cfm/#slideshowdir#?slide=#decrementValue(URL.slide)#">Previous</a>
  <cfelse>
  Previous
  </cfif>
  ~
  <cfif URL.slide lt images.RecordCount>
  <a href="#APPLICATION.PATH.ROOT#/b.slideshow.cfm/#slideshowdir#?slide=#incrementValue(URL.slide)#">Next</a>
  <cfelse>
  Next
  </cfif>

  </p>
  </div>
  </cfoutput>

</cfmodule>