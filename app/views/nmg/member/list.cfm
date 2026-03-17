<cfscript>
  setting showdebugoutput='no' requesttimeout=180;

  params = utility.paged_term_params({ isdeleted: 0, maxrows: 400, exclude: 1 });
  cache_key = 'ml-' & utility.hashCC(params.term ?: '');
  cache_results = utility.simple_cache('#cache_key#:300', function() {
    var mdl = new app.models.Users();
    return {
      models: mdl.where(params),
      pagination: mdl.pagination()
    }
  }, true);

  if (!cache_results.models.len() && !len(params.get('term'))) utility.simple_cache_expire(cache_key, true);

  mUsers = cache_results.models;
  pagination = cache_results.pagination;
  view = (url.view ?: '') == 'map' ? 'map' : session.user.view();
</cfscript>

<script>
  $(function() {
    let loader = lazy_imager('#member-list');
  });
</script>

<cfoutput>
  <div id='member-list' class='row'>
    <div class='col-12 content-card'>
      <div class='row pb-3 g-2 justify-content-end align-items-center'>
        <div class='col-12 col-md fs-4 text-marker'>NMG Members Directory</div>
        #router.include('shared/partials/filter_and_page', { pagination: pagination, placeholder: 'member search...' })#
        <div class='col-auto'>
          <form method='post'>
            <div class='btn-group' role='group'>
              <button type='#ifin(view=='grid', 'button', 'submit')#' name='btnView' value='grid' class='btn btn-sm btn-nmg' #ifin(view=='grid', 'disabled')# title='Tiles'><i class='fa-solid fa-fw fa-th'></i></button>
              <button type='#ifin(view=='list', 'button', 'submit')#' name='btnView' value='list' class='btn btn-sm btn-nmg' #ifin(view=='list', 'disabled')# title='Cards'><i class='fa-solid fa-fw fa-list'></i></button>
              <button type='#ifin(view=='map', 'button', 'submit')#' name='btnView' value='map' class='btn btn-sm btn-nmg' #ifin(view=='map', 'disabled')# title='Map'><i class='fa-solid fa-fw fa-map-location-dot'></i></button>
            </div>
          </form>
        </div>
      </div>
      <div class='title-clamp'>
        <cfif view=='list'>
          <div class='member-cards'>
            <cfloop array='#mUsers#' item='mUser'>
              <div class='member-card d-flex align-items-start gap-2 position-relative'>
                <div class='flex-shrink-0'>
                  <img class='lazy-img fade-in-blur' data-src='#mUser.profile_image().src()#' alt='#mUser.user()#' />
                </div>
                <div class='flex-grow-1 ps-2'>
                  <div class='fw-semibold fs-5'>
                    <a href='#mUser.seo_link()#' class='text-decoration-none stretched-link'>#mUser.user()#</a>
                  </div>
                  <div class='small text-dark'>#mUser.UserProfile().name()#</div>
                  <div class='small text-dark'>#mUser.UserProfile().location()#</div>
                </div>
              </div>
            </cfloop>
          </div>
        <cfelseif view=='map'>
          #router.include('member/map')#
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
