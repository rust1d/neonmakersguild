<cfscript>
  results = mBlog.entries(utility.paged_term_params(ben_released: true, ben_promoted: true, maxrows: 10));
  results.pagination.next_href = '/blog';
  results.pagination.prev_href = '';
  section = 'front';
  // mUsers = new app.models.Users().recently_joining(limit: 5);
</cfscript>

<cfoutput>
  <cfif results.pagination.first && session.user.loggedOut()>
    <cfset mHero = mBlog.textblock_by_label('home-hero') />
    <cfif mHero.persisted()>
      <div class='row mt-3'>
        <div class='col-12'>
          #mHero.body_cdn()#
        </div>
      </div>
    </cfif>
  </cfif>

  <!--- <div class='member-tiles w-50'>
    <cfloop array='#mUsers#' item='mUser'>
      <div class='member-tile'>
        <a href='#mUser.seo_link()#' class='d-block text-decoration-none'>
          <img class='img-fluid' src='#mUser.profile_image().src()#' alt='#mUser.user()#' />
          <div class='text-center fw-semibold'>#mUser.user()#</div>
          <div class='text-center smaller font-montserrat'>#mUser.UserProfile().location()#</div>
        </a>
      </div>
    </cfloop>
  </div> --->

  <div class='row g-2'>
    #router.include('shared/blog/entries', { results: results, section: section })#
  </div>
</cfoutput>
