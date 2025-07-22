<cfscript>
  mBEs = new app.models.BlogEntries().stream(utility.paged_term_params(days: 5000, count: 50, maxrows: 15)); // NO LIMITS FOR NOW
  section = 'stream';
  pagination = request.pagination.last;
  mHero = mBlog.textblock_by_label('stream-hero');
  mRecentUsers = new app.models.Users().recently_posting(limit: 10);
</cfscript>

<cfset include_js('assets/js/blog/modals.js') />

<cfoutput>
  <div id='recent_activity' class='row g-3'>
    <cfif pagination.page EQ 1>
      <cfset mHero = mBlog.textblock_by_label('stream-hero') />
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
      <div class='col-12 content-card font-montserrat p-1'>
        <div class='text-center smaller mb-1'>Recently Active Members</div>
        <div id='member-roll' class='d-flex flex-nowrap gap-1 overflow-auto'>
          <cfloop array='#mRecentUsers#' item='mUser'>
            <a href='#mUser.seo_link()#' class='d-block w-100'>
              <img src='#mUser.profile_image().src()#' class='img-thumbnail' />
            </a>
          </cfloop>
          <a href='/members' class='d-block position-relative w-100'>
            <img src='/assets/images/memberlist.jpg' class='img-thumbnail opacity-75' />
          </a>
        </div>
      </div>
    </cfif>

    <cfif mBEs.len()>
      <cfloop array='#mBEs#' item='mBE' index='idx'>
        <div class='col-12 content-card p-0'>
          #router.include('shared/blog/summary', { mBE: mBE, section: section, comment_target: 'post' })#
        </div>
      </cfloop>

      #router.include('shared/blog/_pager', { pagination: pagination })#
    <cfelse>
      <p>There are no recent blog entries by members.</p>
    </cfif>
  </div>

</cfoutput>
