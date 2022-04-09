<cfoutput>
  <ul>
    <li><a href='#router.href('blog/index')#'>Home</a></li>
    <li><a href='#router.href('blog/entry/edit')#'>Add Entry</a></li>
    <li><a href='#router.href('blog/entry/entries')#'>Entries</a></li>
    <cfif mBlog.isAuthorized('ManageCategories')>
      <li><a href='#router.href('blog/category/list')#'>Categories</a></li>
    </cfif>
    <li><a href='#router.href('blog/comments')#'>Comments</a></li>
    <cfif mBlog.getProperty('moderate')>
      <li><a href='#router.href('blog/moderate')#'>Moderate Comments (#mBlog.unmoderated_count()#)</a></li>
    </cfif>
    <li><a href='#router.href(page: 'blog/index', reinit: 1)#'>Refresh Blog Cache</a></li>
    <cfif mBlog.getProperty("settings")>
      <li><a href='#router.href('blog/settings')#'>Settings</a></li>
    </cfif>
    <li><a href='#router.href('blog/subscribers')#'>Subscribers</a></li>
    <li><a href='#router.href('blog/mailsubscribers')#'>Mail Subscribers</a></li>
    <cfif mBlog.isAuthorized('ManageUsers')>
      <li><a href='#router.href('blog/users')#'>Users</a></li>
    </cfif>
  </ul>
  <cfif mBlog.isAuthorized('PageAdmin')>
    <ul>
      <li><a href='#router.href('blog/pods')#'>Pod Manager</a></li>
      <cfif mBlog.getProperty("filebrowse")>
        <li><a href='#router.href('blog/filemanager')#'>File Manager</a></li>
      </cfif>
      <li><a href='#router.href('blog/pages')#'>Pages</a></li>
      <li><a href='#router.href('blog/slideshows')#'>Slideshows</a></li>
      <li><a href='#router.href('blog/textblocks')#'>Textblocks</a></li>
    </ul>
  </cfif>
  <ul>
    <li><a href='../' target='_new'>Your Blog (New Window)</a></li>
  </ul>
  <ul>
    <li><a href='#router.href('blog/stats')#'>Your Blog Stats</a></li>
    <li><a href='#router.href('blog/stats2')#'>Your Blog Stats 2</a></li>
    <li><a href='#router.href('blog/statsbyyear')#'>Your Blog Stats By Year</a></li>
    <li><a href='#router.href('blog/downloads')#'>Download Reports</a></li>
  </ul>
  <ul>
    <li><a href='#router.href('blog/updatepassword')#'>Update Password</a></li>
  </ul>
</cfoutput>