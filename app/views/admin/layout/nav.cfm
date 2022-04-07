<cfoutput>
  <nav class='navbar navbar-expand-lg navbar-light bg-light'>
    <div class='container-fluid'>
      <a class='navbar-brand' href='#router.href()#'>
        <img src='/assets/images/logo-alt.png'  alt='#session.site.title()# Logo' height='48' class='d-inline-block align-text-top'>
      </a>
      <button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='##navbarNavDropdown' aria-controls='navbarNavDropdown' aria-expanded='false' aria-label='Toggle navigation'>
        <span class='navbar-toggler-icon'></span>
      </button>
      <div class='collapse navbar-collapse' id='navbarNavDropdown'>
        <ul class='navbar-nav me-auto'>
          <li class='nav-item'>
            <a class='nav-link active' aria-current='page' href='#router.href()#'><span class='navbar-brand'>#session.site.title()# Admin</span></a>
          </li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' href='' id='navbarDropdownMenuLink' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Users</a>
            <ul class='dropdown-menu' aria-labelledby='navbarDropdownMenuLink'>
              <li><a class='dropdown-item' href='#router.href('user/list')#'>List Users</a></li>
              <li><a class='dropdown-item' href='#router.href('user/edit')#'>Add User</a></li>
            </ul>
          </li>

          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' href='' id='navbarDropdownMenuLink' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Blog</a>
            <ul class='dropdown-menu' aria-labelledby='navbarDropdownMenuLink'>
              <li><a class='dropdown-item' href='#router.href('blog/home')#'>Home</a></li>
              <li><a class='dropdown-item' href='#router.href('blog/entry/list')#'>List Entries</a></li>
              <li><a class='dropdown-item' href='#router.href('blog/entry/edit')#'>Add Entry</a></li>
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
          <li class='nav-item'>
            <a class='nav-link' href='?ref=nmg'>Website</a>
          </li>
          <li class='nav-item'>
            <a class='nav-link' href='?logout'>Sign Out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</cfoutput>
