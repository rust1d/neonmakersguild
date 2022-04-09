<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
    </div>
    <div class='card-body border-left border-right'>
      <div class='row mb-3'>
        <div class='col-auto'>
          <img class='img-thumbnail' id='profile_image' src='#locals.mUser.profile_image().src()#' />
        </div>
        <div class='col-md-8'>
          <h5>#locals.mUser.UserProfile().name()#</h5>
          <div>#locals.mUser.UserProfile().location()#</div>
        </div>
      </div>
      <div class='row'>
        <div class='col'>
          <p>#locals.mUser.UserProfile().bio()#</p>
        </div>
      </div>
    </div>
    <div class='card-footer bg-nmg border-top-0'></div>
  </div>
</cfoutput>
