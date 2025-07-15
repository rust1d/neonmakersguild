<cfscript>
  mBEs = new app.models.BlogEntries().stream(utility.paged_term_params(days: 5000, count: 50, maxrows: 15)); // NO LIMITS FOR NOW
  section = 'stream';
  pagination = request.pagination.last;
  mHero = mBlog.textblock_by_label('stream-hero');
  mRecentUsers = new app.models.Users().recently_posting(limit: 10);
</cfscript>

<cfset include_js('assets/js/blog/modals.js') />

<cfoutput>
  <cfif pagination.page lt 2>
    <div id='recent_activity' class='row g-3 mb-3'>
      <cfset mHero = mBlog.textblock_by_label('stream-hero') />
      <cfif mHero.persisted()>
        <div class='col-12 content-card'>
          #mHero.body_cdn()#
        </div>
      </cfif>
      <div class='col-12 content-card font-montserrat p-1'>
        <div class='text-center smaller mb-1'>Recently Active Members</div>
        <div class='row'>
          <div class='col-12'>
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
        </div>
      </div>
    </div>
  </cfif>


  <cfif mBEs.len()>
    <div class='row g-3'>
      <cfloop array='#mBEs#' item='mBE' index='idx'>
        <div class='col-12 content-card p-0'>
          #router.include('shared/blog/summary', { mBE: mBE, section: section, comment_target: 'post' })#
        </div>
      </cfloop>
      <cfif !pagination.one_page>
        <div class='col-4 text-center text-uppercase'>
          <cfif !pagination.first>
            <a href='#utility.page_url_prev(pagination)#'><i class='fa-solid fa-fw fa-xl fa-caret-left'></i> Newer Posts</a>
          </cfif>
        </div>
        <div class='col-4 text-center text-uppercase'>
          Page #pagination.page# of #pagination.pages#
        </div>
        <div class='col-4 text-center text-uppercase'>
          <cfif !pagination.last>
            <a href='#utility.page_url_next(pagination)#'>Older posts <i class='fa-solid fa-fw fa-xl fa-caret-right'></i></a>
          </cfif>
        </div>
      </cfif>
    </div>
  <cfelse>
    <p>There are no recent blog entries by members.</p>
  </cfif>
</cfoutput>
