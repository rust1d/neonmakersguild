<cfcache action='servercache' timeSpan='#createTimeSpan(0,6,0,0)#' id='#router.slug()#' usecache='#!application.isDevelopment#'>
  <cfscript>
    roles = [
      { id: 2,  title: 'President' },
      { id: 93, title: 'Vice President' },
      { id: 43, title: 'Treasurer' },
      { id: 14, title: 'Secretary' },
      { id: 3,  title: 'At Large' },
      { id: 7,  title: 'At Large' },
      { id: 94, title: 'At Large' }
    ]

    board_ids = roles.map(role => role.id).toList();
    mdl = new app.models.Users();
    mBoard = mdl.wrap(mdl.get_by_ids(board_ids));
    mFounders = utility.shuffle(mdl.wrap(mdl.get_by_ids('2,3,4,5,6,7')));
    view = session.user.view();
  </cfscript>

  <cfoutput>
    <div class='text-center h4 my-5'>Neon Makers Guild Board Members</div>

    <div class='row g-5 justify-content-center my-5'>
      <cfloop array='#roles#' item='role'>
        <cfset mUser = mBoard.filter(row => row.usid()==role.id).first() />
        <div class='col-4 col-lg-3 text-center'>
          <h5>#role.title#</h5>
          <a href='#mUser.seo_link()#'>
            <img class='img-thumbnail w-100' src='#mUser.profile_image().src()#' />
          </a>
          <a href='#mUser.seo_link()#' class='btn btn-sm btn-nmg w-100 mt-1'>
            #mUser.UserProfile().name()#
          </a>
        </div>
      </cfloop>
    </div>

    <div class='text-center h4 mt-5'>Neon Makers Guild Founding Members</div>

    <div class='row g-3 justify-content-center my-3'>
      <cfloop array='#mFounders#' item='mUser'>
        <div class='col-auto'>
          <!--- <a href='#mUser.seo_link()#'>
            <img class='img-thumbnail w-100' src='#mUser.profile_image().src()#' />
          </a> --->
          <a href='#mUser.seo_link()#' class='btn btn-sm btn-nmg'>
            #mUser.UserProfile().name()#
          </a>
        </div>
      </cfloop>
    </div>
  </cfoutput>
</cfcache>
