<cfscript>
  params = utility.paged_term_params({ isdeleted: 0, maxrows: 400, exclude: 1 });
  cache_key = 'ml-' & utility.hashCC(params.term ?: '');
  cache_results = utility.simple_cache('#cache_key#:300', function() {
    var mdl = new app.models.Users();
    return {
      models: mdl.where(params),
      pagination: mdl.pagination()
    }
  }, true);
  mUsers = cache_results.models;
  pagination = cache_results.pagination;
  view = session.user.view();
</cfscript>

<script>
  $(function() {
    let loader = lazy_imager('#member-list');
  });
</script>

<cfoutput>
  <div id='member-list' class='row'>
    <div class='col-12 content-card'>
      <div class='row pb-3 g-2 justify-content-end'>
        <div class='col-12 col-md fs-5'>NMG Members Directory</div>
        #router.include('shared/partials/filter_and_page', { pagination: pagination, placeholder: 'member search...' })#
        #router.include('shared/partials/viewer')#
      </div>
      <div class='title-clamp'>
        <cfif view=='list'>
          <div class='member-cards'>
            <cfloop array='#mUsers#' item='mUser'>
              <div class='member-card d-flex align-items-start gap-2'>
                <div class='flex-shrink-0'>
                  <a href='#mUser.seo_link()#'>
                    <img class='lazy-img fade-in-blur' data-src='#mUser.profile_image().src()#' alt='#mUser.user()#' />
                  </a>
                </div>
                <div class='flex-grow-1 ps-2'>
                  <div class='fw-semibold fs-5'>
                    <a href='#mUser.seo_link()#' class='text-decoration-none'>#mUser.user()#</a>
                  </div>
                  <div class='small'>#mUser.UserProfile().name()#</div>
                  <div class='small'>#mUser.UserProfile().location()#</div>
                </div>
              </div>
            </cfloop>
          </div>
        <cfelse>
          <div class='member-tiles'>
            <cfloop array='#mUsers#' item='mUser'>
              <div class='member-tile'>
                <a href='#mUser.seo_link()#' class='d-block text-decoration-none'>
                  <img class='lazy-img fade-in-blur' data-src='#mUser.profile_image().src()#' alt='#mUser.user()#' />
                  <div class='text-center fw-semibold'>#mUser.user()#</div>
                  <div class='text-center smaller font-montserrat'>#mUser.UserProfile().location()#</div>
                </a>
              </div>
            </cfloop>
          </div>
        </cfif>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
