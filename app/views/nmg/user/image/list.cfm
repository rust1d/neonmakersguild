<cfscript>
  results = mUserBlog.images(utility.paged_term_params(maxrows: 100));
</cfscript>

<script>
  $(function() {
    $('#image_list i[data-uuid]').on('click', function() {
      alert(this.dataset.uuid);
    });

    $('[data-toggle="lightbox"]').on('click', function(e) {
      e.preventDefault();
    	new Lightbox(this, { keyboard: true, constrain: true }).show();
    });

    let loader = lazy_imager('#image_list');
  });
</script>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center content-card bg-nmg-dark text-white py-4'>
      <div class='fs-2 text-marker'>Image Manager</div>
    </div>
    <div id='image_list' class='col-12 content-card'>
      <div class='row g-2 justify-content-end align-items-center pb-3'>
        <div class='col-auto me-auto'>
          <a href='#router.href('user/image/edit')#' class='btn btn-sm btn-nmg rounded-pill px-3'><i class='fa-solid fa-fw fa-plus'></i> New Image</a>
        </div>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
      </div>
      <div class='member-tiles'>
        <cfloop array='#results.rows#' item='mImage'>
          <div class='member-tile position-relative' title='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
            <a href='#mImage.image_src()#' data-toggle='lightbox' data-gallery='#mUser.user()#' data-caption='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
              <img class='lazy-img fade-in-blur img-fluid rounded' data-src='#mImage.thumbnail_src()#' />
            </a>
            <cfif session.user.isUser(mImage.usid())>
              <i class='fa-solid fa-fw fa-pencil btn btn-sm btn-nmg rounded-circle px-2 btn-floating btn-floating-br btn-pic' data-uuid='#mImage.encoded_key()#'></i>
            </cfif>
          </div>
        </cfloop>
      </div>
    </div>
  </div>
</cfoutput>
