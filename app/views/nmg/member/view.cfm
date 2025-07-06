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
        <div class='col-3'>
          <img class='img-thumbnail' src='#mUser.profile_image().src()#' />
        </div>
        <div class='col-9 position-relative'>
          <div class='fs-3'>#mUser.user()#</div>
          <div>
            <cfif mUser.usid() LT 8><span class='badge bg-secondary'>Founder</span></cfif>
            <cfif mUser.permissions() GT 0><span class='badge bg-secondary'>Admin</span></cfif>
          </div>
          <div>#mUser.UserProfile().name()#</div>
          <div>#mUser.UserProfile().location()#</div>
          <div class='mt-1 small'>Member since #utility.ordinalDate(mUser.added())#</div>
          <div class='mt-1 small'>
            Last seen #utility.ordinalDate(mUser.dll())#
            <cfif mUser.dll().diff('h', now()) LT 24> at #mUser.dll().format('h:nn tt')#</cfif>
          </div>
          <div class='position-absolute bottom-0'>
            <cfloop array='#mUserBlog.owner().profile_links()#' item='mLink'>
              <span class='me-2'>#mLink.icon_link()#</span>
            </cfloop>
          </div>
        </div>
      </div>
    </div>
    <div class='col-12 content-card p-2'>
      <nav class='nav nav-underline nav-fill member-nav'>
        <a class='nav-link #ifin(url.tab=='posts', 'active')# #ifin(counts.post_cnt==0, 'disabled')#' href='#mUser.seo_link()#'>Posts #ifin(url.tab!='posts', "<span class='smaller'>[#counts.post_cnt#]</span>")#</a>
        <a class='nav-link #ifin(url.tab=='about', 'active')#' href='#mUser.seo_link()#/about'>About</a>
        <a class='nav-link #ifin(url.tab=='images', 'active')#' href='#mUser.seo_link()#/images'>Images #ifin(url.tab!='images', "<span class='smaller'>[#counts.image_cnt#]</span>")#</a>
        <a class='nav-link #ifin(url.tab=='links', 'active')#' href='#mUser.seo_link()#/links'>Links #ifin(url.tab!='links', "<span class='smaller'>[#counts.link_cnt#]</span>")#</a>
        <a class='nav-link #ifin(url.tab=='activity', 'active')#' href='#mUser.seo_link()#/activity'>Activity #ifin(url.tab!='activity', "<span class='smaller'>[#counts.activity_cnt#]</span>")#</a>
      </nav>
    </div>
    #router.include('member/#url.tab#')#
  </div>
</cfoutput>
