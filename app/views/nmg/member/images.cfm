<cfscript>
  results = mUserBlog.images(utility.paged_term_params(maxrows: 200));
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
  <cfif !results.pagination.one_page>
    <div class='col-12'>
      <div class='row justify-content-end'>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination, placeholder: 'image search...'  })#
      </div>
    </div>
  </cfif>
  <div id='image_list' class='col-12 content-card'>
    <cfif session.user.loggedIn()>
      <div class='d-flex justify-content-between align-items-center mb-2'>
        <div class='fs-5'>Images</div>
        <a class='smaller' href='#router.href('user/image/edit')#'>Upload New Images</a>
      </div>
    </cfif>
    <div class='member-tiles'>
      <cfloop array='#results.rows#' item='mImage'>
        <div class='member-tile position-relative' title='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
          <a href='#mImage.image_src()#' data-toggle='lightbox' data-gallery='#mUser.user()#' data-caption='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
            <img class='lazy-img fade-in-blur img-fluid rounded' data-src='#mImage.thumbnail_src()#' />
          </a>
          <cfif session.user.isUser(mImage.usid())>
            <i class='fa-solid fa-fw fa-pencil btn btn-nmg btn-outline-dark btn-floating btn-floating-br btn-pic' data-uuid='#mImage.encoded_key()#'></i>
          </cfif>
        </div>
      </cfloop>
    </div>
  </div>
  <div class='col-12'>
    <div class='row justify-content-end'>
      #router.include('shared/partials/filter_and_page', { pagination: results.pagination, footer: true })#
    </div>
  </div>
</cfoutput>
