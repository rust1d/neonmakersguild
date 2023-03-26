<cfoutput>
  <nav class='navbar navbar-expand-lg navbar-dark navbar-nmg mb-3'>
    <div class='container'>
      <a class='navbar-brand' href='#router.href()#'>
        <img src='#application.urls.cdn#/assets/images/logo-alt-1600.png'  alt='#session.site.title()# Logo' height='48'>
      </a>
      <button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='##navbarNavDropdown' aria-controls='navbarNavDropdown' aria-expanded='false' aria-label='Toggle navigation'>
        <span class='navbar-toggler-icon'></span>
      </button>
      <div class='collapse navbar-collapse' id='navbarNavDropdown'>
        <ul class='navbar-nav me-auto'>
          <li class='nav-item'>
            <a class='nav-link active' aria-current='page' href='#router.href()#'>#session.site.title()#</a>
          </li>
          <li class='nav-item ms-4'><a class='nav-link' href='#router.href('user/list')#'>Users</a></li>
          <li class='nav-item ms-4'><a class='nav-link' href='#router.href('blog/link/list')#'>Links</a></li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Content</a>
            <ul class='dropdown-menu'>
              <li><a class='dropdown-item' href='#router.href('blog/entry/list')#'>Blog Entries</a></li>
              <li><a class='dropdown-item' href='#router.href('blog/page/list')#'>Site Pages</a></li>
              <li><a class='dropdown-item' href='#router.href('blog/block/list')#'>Content Blocks</a></li>
              <li><a class='dropdown-item' href='#router.href('blog/library/list')#'>Library</a></li>
              <li><a class='dropdown-item' href='#router.href('blog/image/list')#'>Images</a></li>
            </ul>
          </li>
          <li class='nav-item ms-4'><a class='nav-link' href='#router.href('blog/category/list')#'>Categories</a></li>
          <li class='nav-item ms-4'><a class='nav-link' href='#router.href('blog/tag/list')#'>Tags</a></li>
        </ul>
        <ul class='navbar-nav'>
          <li class='nav-item ms-4'>
            <a class='nav-link' href='#router.href(page: '', ref: 'nmg')#'>Website</a>
          </li>
          <li class='nav-item ms-4'>
            <a class='nav-link' href='/login?logout'>Sign Out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</cfoutput>
