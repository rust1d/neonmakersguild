<cfscript>
  arrUsers = utility.preserveNulls(new app.models.Users().search());
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
        <h5>Users</h5>
      </div>
    </div>
    <div class='row'>
      <div class='col-sm-6 col-md-4 col-lg-3'>
        <img class='img-thumbnail w-100 pb-1' src='/assets/images/image_new.png' />
        <a href='#router.href('user/edit')#' class='btn btn-nmg btn-sm btn-outline-dark w-100'>
          <i class='fal fa-plus'></i>
          Add New User
        </a>
      </div>
      <cfloop array='#arrUsers#' item='row'>
        <cfset mUser = new app.models.Users(row) />
        <div class='col-sm-6 col-md-4 col-lg-3'>
          <img class='img-thumbnail w-100 pb-1' src='#mUser.profile_image().src()#' />
          <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#' class='btn btn-nmg btn-sm btn-outline-dark w-100'>
            <i class='fal fa-pencil'></i>
            #mUser.user()#
          </a>
        </div>
      </cfloop>
    </div>
  </section>
</cfoutput>
