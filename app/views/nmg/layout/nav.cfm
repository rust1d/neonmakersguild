<cfoutput>
  <nav class='navbar navbar-expand-lg navbar-light navbar-nmg'>
    <div class='container'>
      <a class='navbar-brand' href='#router.href()#'>
        <img src='/assets/images/logo.png' alt='#session.site.title()# Logo' height='48' class='d-inline-block align-text-top' />
      </a>
      <button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='##navbarNavDropdown' aria-controls='navbarNavDropdown' aria-expanded='false' aria-label='Toggle navigation'>
        <span class='navbar-toggler-icon'></span>
      </button>
      <div class='collapse navbar-collapse' id='navbarNavDropdown'>
        <ul class='navbar-nav'>
          <li class='nav-item'><a class='nav-link' aria-current='page' href='#router.href()#'>#session.site.title()#</a></li>
          <!--- <li class='nav-item ms-4'><a class='nav-link' href='/blog'>Blog</a></li> --->
          <li class='nav-item ms-4'><a class='nav-link' href='/about'>About</a></li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Resources</a>
            <ul class='dropdown-menu'>
              <li><a class='dropdown-item' href='/resources/suppliers'>Suppliers</a></li>
              <li><a class='dropdown-item' href='/resources/classes'>Classes</a></li>
              <li><a class='dropdown-item' href='/resources/other'>Other</a></li>
            </ul>
          </li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Members</a>
            <ul class='dropdown-menu'>
              <li><a class='dropdown-item' href='/join'>Join</a></li>
              <li><a class='dropdown-item' href='/members'>Member List</a></li>
              <li><a class='dropdown-item' href='/forums'>Forums</a></li>
            </ul>
          </li>
          <cfif session.user.loggedIn()>
            <li class='nav-item ms-4 dropdown'>
              <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Profile</a>
              <ul class='dropdown-menu'>
                <li><a class='dropdown-item' href='#session.user.seo_link()#'>Member Page</a></li>
                <!--- <li><a class='dropdown-item' href='#router.href('user/entry/list')#'>Posts</a></li> --->
                <li><a class='dropdown-item' href='#router.href('user/image/list')#'>Images</a></li>
                <li><a class='dropdown-item' href='#router.href('user/link/list')#'>Links</a></li>
                <li><a class='dropdown-item' href='#router.href('user/edit')#'>Edit Profile</a></li>
                <li><a class='dropdown-item' href='#router.href('user/settings')#'>Account</a></li>
              </ul>
            </li>
          </cfif>
        </ul>
        <ul class='navbar-nav ms-auto'>
          <cfif session.user.loggedIn()>
            <cfif session.user.get_admin()>
              <li class='nav-item'><a class='nav-link' href='#router.href(page: '', ref: 'admin')#'>Admin</a></li>
            </cfif>
            <li class='nav-item'><a class='nav-link' href='/login?logout'>Sign Out</a></li>
          <cfelse>
            <li class='nav-item'><a class='nav-link' href='/join'>Join</a></li>
            <li class='nav-item'><a class='nav-link' href='/login'>Sign In</a></li>
          </cfif>
        </ul>
      </div>
    </div>
  </nav>
</cfoutput>
