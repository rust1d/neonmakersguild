<cfscript>
  mSocials = mBlog.links(bli_type: 'social media').rows;
</cfscript>

<cfoutput>
  <nav class='navbar navbar-expand-lg navbar-light navbar-nmg mb-3'>
    <div class='container d-flex flex-wrap align-items-center justify-content-between'>
      <a class='navbar-brand' href='#router.href()#'>
        <img src='#application.urls.cdn#/assets/images/logo-256.png' alt='#session.site.title()# Logo' class='d-inline-block align-text-top' />
      </a>

      <ul class='navbar-nav flex-row flex-wrap ms-auto'>
        <li class='nav-item dropdown ms-3'>
          <a class='nav-link dropdown-toggle' href='##' data-bs-toggle='dropdown' aria-expanded='false'>
            <span class='d-none d-sm-inline'>Members</span>
            <i class='fa-solid fa-person-dots-from-line d-sm-none'></i>
          </a>
          <ul class='dropdown-menu'>
            <cfif !session.user.loggedIn()>
              <li><a class='dropdown-item' href='/join'>Join</a></li>
            </cfif>
            <li><a class='dropdown-item' href='/stream'>The Wall of Neon</a></li>
            <cfif session.user.loggedIn()>
              <li><a class='dropdown-item' href='#session.user.seo_link()#'>My Page</a></li>
            </cfif>
            <li><a class='dropdown-item' href='/members'>NMG Members</a></li>
            <li><a class='dropdown-item' href='/page/bylaws'>NMG Bylaws</a></li>
          </ul>
        </li>

        <!-- Resources -->
        <li class='nav-item dropdown ms-3'>
          <a class='nav-link dropdown-toggle' href='##' data-bs-toggle='dropdown' aria-expanded='false'>
            <span class='d-none d-sm-inline'>Resources</span>
            <i class='fa-solid fa-book-atlas d-sm-none'></i>
          </a>
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

        <!-- Forums -->
        <li class='nav-item ms-3'>
          <a class='nav-link' href='/forums'>
            <span class='d-none d-sm-inline'>Forums</span>
            <i class='fa-solid fa-comments d-sm-none'></i>
          </a>
        </li>

        <cfif !session.user.loggedIn()>
          <li class='nav-item ms-3'>
            <a class='nav-link' href='/about'>
              <span class='d-none d-sm-inline'>About</span>
              <i class='fa-solid fa-circle-info d-sm-none'></i>
            </a>
          </li>
        </cfif>

        <!-- Profile or Auth -->
        <cfif session.user.loggedIn()>
          <li class='nav-item dropdown ms-3'>
            <a class='nav-link dropdown-toggle' href='##' data-bs-toggle='dropdown' aria-expanded='false'>
              <span class='d-none d-sm-inline'>Profile</span>
              <i class='fa-solid fa-ellipsis d-sm-none'></i>
            </a>
            <ul class='dropdown-menu'>
              <li><a class='dropdown-item' href='#router.href("user/promo")#'>Membership T-Shirts!</a></li>
              <li><a class='dropdown-item' href='#router.href("user/entry/list")#'>Edit Blog Posts</a></li>
              <li><a class='dropdown-item' href='#router.href("user/image/list")#'>Edit Images</a></li>
              <li><a class='dropdown-item' href='#router.href("user/link/list")#'>Edit Links</a></li>
              <li><a class='dropdown-item' href='#router.href("user/edit")#'>Edit Profile</a></li>
              <li><a class='dropdown-item' href='#router.href("user/security")#'>Account Security</a></li>
              <li><a class='dropdown-item' href='/login?logout'>Sign Out</a></li>
            </ul>
          </li>
          <cfif session.user.get_admin()>
            <li class='nav-item ms-3'>
              <a class='nav-link' href='#router.href(page: "", ref: "admin")#'>Admin</a>
            </li>
          </cfif>
        <cfelse>
          <li class='nav-item ms-3'>
            <a class='nav-link' href='/join'>
              <span class='d-none d-sm-inline'>Join</span>
              <i class='fa-solid fa-person-through-window d-sm-none'></i>
            </a>
          </li>
          <li class='nav-item ms-3'>
            <a class='nav-link' href='/login'>
              <span class='d-none d-sm-inline'>Sign In</span>
              <i class='fa-solid fa-user d-sm-none'></i>
            </a>
          </li>
        </cfif>
      </ul>
    </div>
  </nav>
  </cfoutput>
