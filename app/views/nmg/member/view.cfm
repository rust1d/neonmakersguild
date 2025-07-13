<cfscript>
  usid = router.decode('usid');
  if (!usid) router.redirect('member/list');

  mUser = mUserBlog.owner();
  counts = mUser.counts();

  param url.tab = 'posts';
  tabs = 'posts,about,images,links,activity';
  if (!tabs.listFind(url.tab)) url.tab = 'posts';
  if (url.tab=='posts' && counts.post_cnt==0) url.tab = 'about';
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 content-card p-2'>
      <div class='row g-3'>
        <div class='col-5 col-sm-auto'>
          <img class='img-thumbnail w-100' src='#mUser.profile_image().src()#' />
        </div>
        <div class='col position-relative'>
          <div class='fs-3'>
            #mUser.user()#
            <cfif mUser.usid() LT 8><sup><i class='fa-solid fa-fw fa-person-burst text-warning' title='NMG Founder'></i></sup></cfif>
            <cfif mUser.permissions() GT 0><sup><i class='fa-solid fa-fw fa-burst text-warning' title='Site Admin'></i></sup></cfif>
          </div>
          <div class='mt-1 fs-5'>#mUser.UserProfile().name()#</div>
          <div class='mt-1'>#mUser.UserProfile().location()#</div>
          <div class='mt-1 small'>Joined #utility.ordinalDate(mUser.added())#</div>
          <div class='mt-1 smaller'>Last seen #mUser.dll().format('yyyy-mm-dd')# <cfif mUser.dll().diff('h', now()) LT 24>#mUser.dll().format('h:nn tt')#</cfif></div>
          <div class='mt-2'>
            <cfloop array='#mUserBlog.owner().profile_links()#' item='mLink'>
              <span class='me-2'>#mLink.icon_link('fa-lg')#</span>
            </cfloop>
          </div>
        </div>
        <div class='col-12'>

        </div>
      </div>
    </div>
    <div class='col-12 content-card p-2'>
      <nav class='nav nav-underline nav-fill member-nav'>
        <a class='nav-link #ifin(url.tab=='posts', 'active')# #ifin(counts.post_cnt==0, 'disabled')#' href='#mUser.seo_link()#'>
          Posts #ifin(url.tab!='posts', "<span class='smaller'>[#counts.post_cnt#]</span>")#
        </a>
        <a class='nav-link #ifin(url.tab=='about', 'active')#' href='#mUser.seo_link()#/about'>
          About
        </a>
        <a class='nav-link #ifin(url.tab=='images', 'active')#' href='#mUser.seo_link()#/images'>
          Images
        </a>
        <a class='nav-link #ifin(url.tab=='links', 'active')#' href='#mUser.seo_link()#/links'>
          Link Tree
        </a>
        <a class='nav-link #ifin(url.tab=='activity', 'active')#' href='#mUser.seo_link()#/activity'>
          Activity
        </a>
      </nav>
    </div>
    #router.include('member/#url.tab#')#
  </div>
</cfoutput>
