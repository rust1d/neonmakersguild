<cfscript>
  usid = router.decode('usid');
  if (!usid) router.redirect('member/list');

  mUser = mUserBlog.owner();
  counts = mUser.counts();

  param url.tab = 'posts';
  tabs = 'posts,images,activity';
  if (!tabs.listFind(url.tab)) url.tab = 'posts';
  if (url.tab=='posts' && counts.post_cnt==0) url.tab = 'images';
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 content-card bg-nmg-dark text-white p-0 overflow-hidden'>
      <div class='row g-0'>
        <div class='flex-25-250 p-3'>
          <img class='avatar-circle w-100' style='min-width:unset' src='#mUser.profile_image().src()#' />
        </div>
        <div class='col p-3'>
          <div class='fs-3 text-marker'>
            #mUser.user()#
            <cfif mUser.usid() LT 8><sup><i class='fa-solid fa-fw fa-person-burst text-warning' title='NMG Founder'></i></sup></cfif>
            <cfif mUser.permissions() GT 0><sup><i class='fa-solid fa-fw fa-burst text-warning' title='Site Admin'></i></sup></cfif>
          </div>
          <div class='mt-1 fs-5 text-white-50'>#mUser.UserProfile().name()#</div>
          <div class='mt-1 text-white-50'><i class='fa-solid fa-location-dot me-1'></i> #mUser.UserProfile().location()#</div>
          <div class='mt-1 small text-white-50'><i class='fa-regular fa-calendar me-1'></i> Joined #utility.ordinalDate(mUser.added())#</div>
          <div class='mt-1 smaller text-white-50'>Last seen #mUser.dll().format('yyyy-mm-dd')# <cfif mUser.dll().diff('h', now()) LT 24>#mUser.dll().format('h:nn tt')#</cfif></div>
          <div class='mt-2'>
            #router.include('member/_about')#
            <!--- ALL LINKS ON MAIN BAR --->
            #router.include('member/_links')#
            <!--- SOCIAL LINKS ON MAIN BAR --->
            <cfloop array='#mUserBlog.owner().profile_links()#' item='mLink'>
              <span class='me-1'>#mLink.icon_link('fa-lg')#</span>
            </cfloop>
          </div>
        </div>
      </div>
    </div>

    <cfif session.user.isUser(usid)> <!--- PAGE OWNER --->
      <div class='col-12 content-card'>
        <cfset router.include('user/entry/modal') />
      </div>
    </cfif>

    <div class='col-12 content-card p-1'>
      <nav class='nav nav-underline member-nav ps-1'>
        <a class='nav-link #ifin(url.tab=='posts', 'active')# #ifin(counts.post_cnt==0, 'disabled')#' href='#mUser.seo_link()#'>
          Posts
        </a>
        <a class='nav-link #ifin(url.tab=='images', 'active')#' href='#mUser.seo_link()#/images'>
          Images
        </a>
        <a class='nav-link #ifin(url.tab=='activity', 'active')#' href='#mUser.seo_link()#/activity'>
          Activity
        </a>
      </nav>
    </div>
    #router.include('member/#url.tab#')#
  </div>

</cfoutput>
