<cfoutput>
  <nav class='navbar navbar-expand-lg navbar-light bg-light'>
    <div class='container-fluid'>
      <a class='navbar-brand' href='#router.href()#'>
        <img src='/assets/images/logo.png'  alt='#session.site.title()# Logo' height='48' class='d-inline-block align-text-top'>
      </a>
      <button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='##navbarNavDropdown' aria-controls='navbarNavDropdown' aria-expanded='false' aria-label='Toggle navigation'>
        <span class='navbar-toggler-icon'></span>
      </button>
      <div class='collapse navbar-collapse' id='navbarNavDropdown'>
        <ul class='navbar-nav'>
          <li class='nav-item'>
            <a class='nav-link active' aria-current='page' href='#router.href()#'><span class='navbar-brand'>#session.site.title()#</span></a>
          </li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Members</a>
            <ul class='dropdown-menu'>
              <li><a class='dropdown-item' href='#router.href('member/list')#'>List</a></li>
              <li><a class='dropdown-item' href='#mBlog.page_seo_link('join')#'>Join</a></li>
              <!--- <li><a class='dropdown-item' href='#router.href('member/login')#'>Login</a></li> --->
            </ul>
          </li>
          <li class='nav-item ms-4'>
            <a class='nav-link' href='#mBlog.page_seo_link('Resources')#'>Resources</a>
          </li>
          <li class='nav-item ms-4'>
            <a class='nav-link' href='#mBlog.page_seo_link('about')#'>About</a>
          </li>
          <cfif session.user.loggedIn()>
            <li class='nav-item ms-4 dropdown'>
              <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Profile</a>
              <ul class='dropdown-menu'>
                <li><a class='dropdown-item' href='#router.href('user/home')#'>View</a></li>
                <li><a class='dropdown-item' href='#router.href('user/edit')#'>Edit</a></li>
                <li><a class='dropdown-item' href='#router.href('user/image/list')#'>Images</a></li>
                <li><a class='dropdown-item' href='#router.href('user/link/list')#'>Links</a></li>
              </ul>
            </li>
          </cfif>
        </ul>
        <ul class='navbar-nav ms-auto'>
          <cfif session.user.loggedIn()>
            <cfif session.user.get_admin()>
              <li><a class='dropdown-item' href='#router.href(page: 'home', ref: 'admin')#'>Admin</a></li>
            </cfif>
            <li><a class='dropdown-item' href='#router.href(page: 'login/login')#&logout'>Sign Out</a></li>
          <cfelse>
            <li class='nav-item'>
              <a class='nav-link' href='#mBlog.page_seo_link('join')#'>Join</a>
            </li>
            <li class='nav-item'>
              <a class='nav-link' href='#router.href('login/login')#'>Sign In</a>
            </li>
          </cfif>
        </ul>
      </div>
    </div>
  </nav>
</cfoutput>
