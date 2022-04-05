<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
  Name         : /client/tags/adminlayout.cfm
  Author       : Raymond Camden
  Created      : 04/06/06
  Last Updated : 4/13/07
  History      : link to stats (rkc 5/17/06)
         : new links in left menu (rkc 7/7/06 and 7/13/06)
         : Scott P suggested adding blogname (rkc 8/2/06)
         : Re-organized the menu a bit (rkc 9/5/06)
         : htmlEditFormat the blog title (rkc 10/12/06)
         : comment mod link (tr 12/7/06)
         : check filebrowse prop, settings prop (rkc 12/14/06)
         : podmanager add by Scott P (rkc 4/13/07)
--->

<cfparam name="ATTRIBUTES.title" default="">

<cfif thisTag.executionMode is "start">
  <cfoutput>
  <link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/blog/css/blog.css" media="screen" />
  <link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/blog/css/admin.css" media="screen" />
  <script type="text/javascript" src="#APPLICATION.PATH.ROOT#/blog/includes/jquery.selectboxes.js"></script>
  <script type="text/javascript" src="#APPLICATION.PATH.ROOT#/blog/includes/jquery.autogrow.js"></script>
  <div id="divBlog">
    <cfif SESSION.BROG.getProperty("SiteBlog")>
      <div class="subpage_sidebar">
        <ul id="sidebar">
          <li><a href="x.index.cfm">Home</a></li>
          <li><a href="x.entry.cfm?id=0">Add Entry</a></li>
          <li><a href="x.entries.cfm">Entries</a></li>
          <cfif SESSION.BROG.isBlogAuthorized('ManageCategories')><li><a href="x.categories.cfm">Categories</a></li></cfif>
          <li><a href="x.comments.cfm">Comments</a></li>
          <cfif SESSION.BROG.getProperty("moderate")><li><a href="x.moderate.cfm">Moderate Comments (<cfoutput>#SESSION.BROG.getNumberUnbco_moderated()#</cfoutput>)</a></li></cfif>
          <li><a href="x.index.cfm?reinit=1">Refresh Blog Cache</a></li>
          <li><a href="x.stats.cfm">Stats</a></li>
          <cfif APPLICATION.BLOG.settings><li><a href="x.settings.cfm">Settings</a></li></cfif>
          <li><a href="x.subscribers.cfm">Subscribers</a></li>
          <li><a href="x.mailsubscribers.cfm">Mail Subscribers</a></li>
          <cfif SESSION.BROG.isBlogAuthorized('ManageUsers')><li><a href="x.users.cfm">Users</a></li></cfif>
        </ul>
        <cfif SESSION.BROG.isBlogAuthorized('PageAdmin')>
          <ul>
            <li><a href="x.pods.cfm">Pod Manager</a></li>
            <cfif APPLICATION.BLOG.filebrowse><li><a href="x.filemanager.cfm">File Manager</a></li></cfif>
            <li><a href="x.pages.cfm">Pages</a></li>
            <li><a href="x.slideshows.cfm">Slideshows</a></li>
            <li><a href="x.textblocks.cfm">Textblocks</a></li>
          </ul>
        </cfif>
      </div>
    </cfif>
    <div id="content">
      <h2>#ATTRIBUTES.title#</h2>
  </cfoutput>
<cfelse>
  <cfoutput>
    </div>
  </div>
  </cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false" />