<cfscript>
  arrUsers = utility.preserveNulls(new app.models.Users().search());
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
        <h5>Users</h5>
        <a href='#router.href('user/edit')#' class='btn btn-nmg btn-sm btn-outline-dark'><i class='fal fa-plus'></i> Add New User</a>
      </div>
    </div>
    <div class='row thumbnail-lg'>
      <cfloop array='#arrUsers#' item='row'>
        <cfset mUser = new app.models.Users(row) />
        <div class='col-md-2 col-sm-4'>
          <img class='img-thumbnail' src='#mUser.profile_image().src()#' />
          <div class=''>
            <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#' class='btn btn-nmg btn-sm btn-outline-dark w-100'>
              <i class='fal fa-pencil'></i>
              #mUser.email()#
            </a>
          </div>
        </div>
      </cfloop>
    </div>
  </section>
</cfoutput>
