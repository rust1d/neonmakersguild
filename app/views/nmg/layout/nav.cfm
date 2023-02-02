<cfscript>
  mSocials = mBlog.links(bli_type: 'social media').rows;
</cfscript>

<cfoutput>
  <nav class='navbar navbar-expand-lg navbar-light navbar-nmg mb-3'>
    <div class='container'>
      <a class='navbar-brand' href='#router.href()#'>
        <img src='/assets/images/logo-1600.png' alt='#session.site.title()# Logo' height='48' class='d-inline-block align-text-top' />
      </a>
      <button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='##navbarNavDropdown' aria-controls='navbarNavDropdown' aria-expanded='false' aria-label='Toggle navigation'>
        <span class='navbar-toggler-icon'></span>
      </button>
      <div class='collapse navbar-collapse' id='navbarNavDropdown'>
        <ul class='navbar-nav'>
          <li class='nav-item'><a class='nav-link' aria-current='page' href='#router.href()#'>#session.site.title()#</a></li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Members</a>
            <ul class='dropdown-menu'>
              <cfif !session.user.loggedIn()>
                <li><a class='dropdown-item' href='/join'>Join</a></li>
              <cfelse>
                <li><a class='dropdown-item' href='#session.user.seo_link()#'>My Member Page</a></li>
              </cfif>
              <li><a class='dropdown-item' href='/stream'>Member Stream</a></li>
              <li><a class='dropdown-item' href='/members'>Member List</a></li>
            </ul>
          </li>
          <li class='nav-item ms-4 dropdown'>
            <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Resources</a>
            <ul class='dropdown-menu'>
              <cfloop array='#mSocials#' item='mSocial'>
                <li><a class='dropdown-item' href='#mSocial.url()#' target='_blank'>NMG #utility.capFirst(mSocial.title())#</a></li>
              </cfloop>
              <li><a class='dropdown-item' href='/resources/library'>Library</a></li>
              <li><a class='dropdown-item' href='/resources/suppliers'>Suppliers</a></li>
              <li><a class='dropdown-item' href='/resources/classes'>Classes</a></li>
              <li><a class='dropdown-item' href='/resources/other'>Other</a></li>
            </ul>
          </li>
          <li class='nav-item ms-4'><a class='nav-link' href='/forums'>Forums</a></li>
          <li class='nav-item ms-4'><a class='nav-link' href='/about'>About</a></li>
        </ul>
        <ul class='navbar-nav ms-auto'>
          <cfif session.user.loggedIn()>
            <cfif session.user.get_admin()>
              <li class='nav-item'><a class='nav-link' href='#router.href(page: '', ref: 'admin')#'>Admin</a></li>
            </cfif>
            <li class='nav-item ms-4 dropdown'>
              <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Profile</a>
              <ul class='dropdown-menu'>
                <li><a class='dropdown-item' href='#router.href('user/promo')#'>Membership T-Shirts!</a></li>
                <li><a class='dropdown-item' href='#router.href('user/entry/list')#'>Edit Posts</a></li>
                <li><a class='dropdown-item' href='#router.href('user/image/list')#'>Edit Images</a></li>
                <li><a class='dropdown-item' href='#router.href('user/link/list')#'>Edit Links</a></li>
                <li><a class='dropdown-item' href='#router.href('user/edit')#'>Edit Profile</a></li>
                <li><a class='dropdown-item' href='#router.href('user/security')#'>Account Security</a></li>
                <li><a class='dropdown-item' href='/login?logout'>Sign Out</a></li>
              </ul>
            </li>
          <cfelse>
            <li class='nav-item'><a class='nav-link' href='/join'>Join</a></li>
            <li class='nav-item'><a class='nav-link' href='/login'>Sign In</a></li>
          </cfif>
        </ul>
      </div>
    </div>
  </nav>
</cfoutput>
