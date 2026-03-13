<cfscript>
  mBEs = new app.models.BlogEntries().stream(utility.paged_term_params(days: 5000, count: 50, maxrows: 15)); // NO LIMITS FOR NOW
  section = 'stream';
  pagination = request.pagination.last;
  if (pagination.page EQ 1) {
    mHero = mBlog.textblock_by_label('stream-hero');
    mRecentUsers = new app.models.Users().recently_posting(limit: 10);
  }
</cfscript>

<cfset include_js('assets/js/blog/modals.js') />

<cfoutput>
  <div id='recent_activity' class='row g-3'>
    <cfif pagination.page EQ 1>
      <cfif mHero.persisted()>
        <div class='col-12 content-card'>
          #mHero.body_cdn()#
        </div>
      </cfif>
    </cfif>

    <cfif session.user.loggedIn()>
      <div class='col-12 content-card'>
        <cfset router.include('user/entry/modal') />
      </div>
    </cfif>

    <cfif pagination.page EQ 1>
      <div class='col-12 content-card font-montserrat p-2 bg-nmg-dark rounded'>
        <div class='text-center text-light small text-uppercase fw-semibold mb-2 ls-wide'>Recently Active Members</div>
        <div id='member-roll' class='d-flex flex-nowrap gap-2 overflow-visible justify-content-center p-3'>
          <cfloop array='#mRecentUsers#' item='mUser'>
            <a href='#mUser.seo_link()#' class='d-block text-center flex-shrink-0' title='#mUser.UserProfile().name()#'>
              <img src='#mUser.profile_image().src()#' class='avatar-circle' />
            </a>
          </cfloop>
          <a href='/members' class='d-block text-center flex-shrink-0' title='All Members'>
            <img src='/assets/images/memberlist.jpg' class='avatar-circle opacity-75' />
          </a>
        </div>
      </div>
    </cfif>

    <cfif mBEs.len()>
      <cfloop array='#mBEs#' item='mBE' index='idx'>
        <div class='col-12 content-card hover-lift fade-in-up p-0' style='animation-delay: #(idx-1) * 0.05#s'>
          #router.include('shared/blog/summary', { mBE: mBE, section: section, comment_target: 'post' })#
        </div>
      </cfloop>

      #router.include('shared/blog/_pager', { pagination: pagination })#
    <cfelse>
      <p>There are no recent blog entries by members.</p>
    </cfif>
  </div>

</cfoutput>
