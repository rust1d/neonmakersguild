<cfcache action='servercache' timeSpan='#createTimeSpan(0,6,0,0)#' id='#router.slug()#' usecache='#!application.isDevelopment#'>
  <cfscript>
    roles = [
      { id: 75,  title: 'President' },
      { id: 43, title: 'Vice President' },
      { id: 94, title: 'Treasurer' },
      { id: 14, title: 'Secretary' },
      { id: 3,  title: 'At Large' },
      { id: 7,  title: 'At Large' },
      { id: 110, title: 'At Large' }
    ]

    board_ids = roles.map(role => role.id).toList();
    mdl = new app.models.Users();
    mBoard = mdl.wrap(mdl.get_by_ids(board_ids));
    mFounders = utility.shuffle(mdl.wrap(mdl.get_by_ids('2,3,4,5,6,7')));
    view = session.user.view();
  </cfscript>

  <cfoutput>
    <div class='text-center my-5'>
      <div class='fs-3 text-marker'>Board Members</div>
    </div>

    <div class='row g-4 justify-content-center my-3'>
      <cfloop array='#roles#' item='role'>
        <cfset mUser = mBoard.filter(row => row.usid()==role.id).first() />
        <div class='col-6 col-md-4 col-lg-3 text-center'>
          <a href='#mUser.seo_link()#'>
            <img class='avatar-circle' style='width:120px;min-width:120px' src='#mUser.profile_image().src()#' />
          </a>
          <div class='fw-semibold mt-2'>
            <a href='#mUser.seo_link()#' class='text-decoration-none'>#mUser.UserProfile().name()#</a>
          </div>
          <div class='small text-muted font-montserrat'>#role.title#</div>
        </div>
      </cfloop>
    </div>

    <div class='text-center mt-5'>
      <div class='fs-3 text-marker'>Founding Members</div>
    </div>

    <div class='d-flex flex-wrap justify-content-center gap-2 my-3'>
      <cfloop array='#mFounders#' item='mUser'>
        <a href='#mUser.seo_link()#' class='btn btn-sm btn-nmg'>
          #mUser.UserProfile().name()#
        </a>
      </cfloop>
    </div>
  </cfoutput>
</cfcache>
