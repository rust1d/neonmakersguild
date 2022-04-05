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
        <ul class='navbar-nav me-auto'>
          <li class='nav-item'>
            <a class='nav-link active' aria-current='page' href='#router.href()#'><span class='navbar-brand'>#session.site.title()#</span></a>
          </li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' href='' id='navbarDropdownMenuLink' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Members</a>
            <ul class='dropdown-menu' aria-labelledby='navbarDropdownMenuLink'>
              <li><a class='dropdown-item' href='#router.href()#'>Action</a></li>
              <li><a class='dropdown-item' href='#router.href()#'>Another action</a></li>
              <li><a class='dropdown-item' href='#router.href()#'>Something else here</a></li>
            </ul>
          </li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' href='' id='navbarDropdownMenuLink' role='button' data-bs-toggle='dropdown' aria-expanded='false'>News and Events</a>
            <ul class='dropdown-menu' aria-labelledby='navbarDropdownMenuLink'>
              <li><a class='dropdown-item' href='#router.href('home/news')#'>News</a></li>
              <li><a class='dropdown-item' href='#router.href('home/events')#'>Events</a></li>
            </ul>
          </li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' href='' id='navbarDropdownMenuLink' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Resources</a>
            <ul class='dropdown-menu' aria-labelledby='navbarDropdownMenuLink'>
              <li><a class='dropdown-item' href='#router.href()#'>Action</a></li>
              <li><a class='dropdown-item' href='#router.href()#'>Another action</a></li>
              <li><a class='dropdown-item' href='#router.href()#'>Something else here</a></li>
            </ul>
          </li>
        </ul>
        <ul class='navbar-nav'>
          <cfif session.user.loggedIn()>
            <li class='nav-item ms-4 dropdown'>
              <a class='nav-link dropdown-toggle' id='navbarDropdownMenuLink' role='button' data-bs-toggle='dropdown' aria-expanded='false'>My Profile</a>
              <ul class='dropdown-menu' aria-labelledby='navbarDropdownMenuLink'>
                <li><a class='dropdown-item' href='#router.href('user/home')#'>View</a></li>
                <li><a class='dropdown-item' href='#router.href('user/edit')#'>Edit</a></li>
                <li><a class='dropdown-item' href='#router.href('user/images')#'>My Images</a></li>
                <li><a class='dropdown-item' href='#router.href('user/links')#'>My Links</a></li>
                <cfif session.user.get_admin()>
                  <li><a class='dropdown-item' href='?ref=admin'>Website Admin</a></li>
                </cfif>
                <li><a class='dropdown-item' href='#router.href('?logout')#'>Sign Out</a></li>
              </ul>
            </li>
          <cfelse>
            <li class='nav-item'>
              <a class='nav-link' href='#router.href('home/join')#'>Join</a>
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