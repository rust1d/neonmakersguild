<cfscript>
  mUsers = new app.models.Users().where();

  view = 'list'
</cfscript>

<script>
  $(function() {
    $('.view-switch').on('click', function() {
      $('#view-grid').toggleClass('d-none');
      $('#view-list').toggleClass('d-none');
    });
  });
</script>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col-6'>
        <h4>Members</h4>
      </div>
      <div class='col-6 text-end'>
        <div class='btn-group' role='group'>
          <button type='button' class='view-switch btn btn-nmg'><i class='fad fa-th'></i></button>
          <button type='button' class='view-switch btn btn-nmg'><i class='fad fa-list'></i></button>
        </div>
      </div>
    </div>
    <div id='view-grid'>
      <div class='row'>
        <cfloop array='#mUsers#' item='mUser'>
          <div class='col-sm-6 col-md-4 col-lg-3'>
            <img class='img-thumbnail w-100 pb-1' src='#mUser.profile_image().src()#' />
            <a href='#router.hrefenc(page: 'member/view', usid: mUser.usid())#' class='btn btn-nmg btn-sm btn-outline-dark w-100'>
              #mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#
            </a>
          </div>
        </cfloop>
      </div>
    </div>
    <div id='view-list' class='d-none'>
      <cfloop array='#mUsers#' item='mUser'>
        <div class='row p-2 my-2 border'>
          <div class='col-2'>
            <img class='img-thumbnail w-50' src='#mUser.profile_image().src()#' />
          </div>
          <div class='col-2'>
            #mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#
          </div>
          <div class='col-2'>
            #mUser.user()#
          </div>
          <div class='col-2'>
            #mUser.UserProfile().location()#
          </div>
        </div>
      </cfloop>
    </div>
  </section>
</cfoutput>
