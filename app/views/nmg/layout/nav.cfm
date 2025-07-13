<cfscript>
  mSocials = mBlog.links(bli_type: 'social media').rows;
</cfscript>

<cfoutput>
  <nav class='navbar sticky-top navbar-expand navbar-light navbar-nmg mb-3 small'>
    <div class='container-lg'>
      <a class='navbar-brand d-flex align-items-center me-1' href='#router.href()#'>
        <img src='#application.urls.cdn#/assets/images/logo-256.png' alt='#session.site.title()# Logo' class='d-inline-block align-text-top' />
        <span class='mx-2 d-none d-md-inline fs-6'>#session.site.title()#</span>
      </a>
      <button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='##navbarNavDropdown' aria-controls='navbarNavDropdown' aria-expanded='false' aria-label='Toggle navigation'>
        <span class='navbar-toggler-icon'></span>
      </button>
      <div class='collapse navbar-collapse' id='navbarNavDropdown'>
        <ul class='navbar-nav justify-content-evenly'>
          <li class='nav-item'><a class='nav-link' href='/stream'>Member Stream</a></li>
          <li class='nav-item'><a class='nav-link' href='/forums'>Forums</a></li>

          <li class='nav-item dropdown drop-right'>
            <a class='nav-link dropdown-toggle' role='button' data-bs-toggle='dropdown' aria-expanded='false'>Learn</a>
            <div class='dropdown-menu nav-dropdown mt-1 py-3 px-1'>
              <cfloop array='#mSocials#' item='mSocial'>
                <a class='dropdown-item round-icon' href='#mSocial.url()#' target='_blank'>#mSocial.icon()# NMG #utility.capFirst(mSocial.title())#</a>
              </cfloop>
              <a class='dropdown-item round-icon' href='/resources/library'><i class='fa-solid fa-book'></i> Library</a>
              <a class='dropdown-item round-icon' href='/resources/suppliers'><i class='fa-solid fa-truck'></i> Suppliers</a>
              <a class='dropdown-item round-icon' href='/resources/classes'><i class='fa-solid fa-people-line'></i> Neon Classes</a>
              <a class='dropdown-item round-icon' href='/resources/other'><i class='fa-solid fa-toolbox'></i> General Resources</a>
              <a class='dropdown-item round-icon' href='/about'><i class='fa-solid fa-circle-info'></i> About NMG</a>
            </div>
          </li>
        </ul>
        <ul class='navbar-nav ms-auto'>
          <cfif session.user.loggedIn()>
            <li class='nav-item dropdown position-relative'>
              <a class='nav-link p-0 d-flex align-items-center' href='##' id='profileDropdown' role='button' data-bs-toggle='dropdown' aria-expanded='false'>
                <div class='profile-button-wrapper'>
                  <img src='#session.user.profile_image().src()#' alt='My profile' class='profile-image' />
                  <span class='profile-caret'>
                    <i class='fa-solid fa-chevron-down'></i>
                  </span>
                </div>
              </a>
              <div class='dropdown-menu dropdown-menu-end nav-dropdown mt-1 py-3 px-1' aria-labelledby='profileDropdown'>
                <a class='dropdown-item round-icon' href='#session.user.seo_link()#'><i class='fa-solid fa-person-dots-from-line'></i> My Page</a>
                <a class='dropdown-item round-icon' href='#router.href('user/entry/list')#'><i class='fa-solid fa-pen-to-square'></i> Post History</a>
                <a class='dropdown-item round-icon' href='#router.href('user/image/list')#'><i class='fa-solid fa-photo-film'></i> My Images</a>
                <a class='dropdown-item round-icon' href='#router.href('user/link/list')#'><i class='fa-solid fa-icons'></i> My Link Tree</a>
                <a class='dropdown-item round-icon' href='#router.href('user/edit')#'><i class='fa-solid fa-user-gear'></i> Edit Profile</a>
                <a class='dropdown-item round-icon' href='#router.href('user/security')#'><i class='fa-solid fa-user-shield'></i> Account Security</a>
                <cfif session.user.get_admin()>
                  <a class='dropdown-item round-icon' href='#router.href(page: '', ref: 'admin')#'><i class='fa-solid fa-screwdriver-wrench'></i> View Admin Site</a>
                </cfif>
                <hr class='dropdown-divider'>
                <a class='dropdown-item round-icon' href='/login?logout'><i class='fa-solid fa-right-from-bracket'></i> Sign Out</a>
              </div>
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
