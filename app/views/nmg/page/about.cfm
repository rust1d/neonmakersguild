<cfscript>
  mdl = new app.models.Users();
  mUsers = utility.shuffle(mdl.wrap(mdl.get_by_ids('2,3,4,5,6,7')));
  view = session.user.view();
</cfscript>

<cfoutput>
  <h5>Neon Makers Guild Founding Members</h5>

  <div class='row g-3'>
    <cfloop array='#mUsers#' item='mUser'>
      <div class='col-4 col-lg-2'>
        <a href='#mUser.seo_link()#'>
          <img class='img-thumbnail w-100' src='#mUser.profile_image().src()#' />
        </a>
        <a href='#mUser.seo_link()#' class='btn btn-sm btn-nmg w-100 mt-1'>
          #mUser.user()#
        </a>
      </div>
    </cfloop>
  </div>

</cfoutput>
