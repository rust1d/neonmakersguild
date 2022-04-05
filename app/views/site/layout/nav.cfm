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
        </ul>
        <ul class='navbar-nav'>
          <cfif session.user.loggedIn()>
            <li class='nav-item'>
              <a class='nav-link' href='#router.href()#'>My Account</a>
            </li>
            <li class='nav-item'>
              <a class='nav-link' href='?logout'>Sign Out</a>
            </li>
          <cfelse>
            <li class='nav-item'>
              <a class='nav-link' href='#router.href('home/join')#'>Join</a>
            </li>
            <li class='nav-item'>
              <a class='nav-link' href='#router.href('login/signin')#'>Sign In</a>
            </li>
          </cfif>
        </ul>
      </div>
    </div>
  </nav>
</cfoutput>
