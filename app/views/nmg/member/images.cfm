<cfscript>
  results = mUserBlog.images(utility.paged_term_params(maxrows: 200));
</cfscript>

<script>
  $(function() {
    $('[data-toggle="lightbox"]').on('click', function(e) {
      e.preventDefault();
    	new Lightbox(this, { keyboard: true, constrain: true }).show();
    });

    let loader = lazy_imager('#image-list');
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
  <div id='image-list' class='col-12 content-card'>
    <div class='member-tiles'>
      <cfloop array='#results.rows#' item='mImage'>
        <div class='member-tile' title='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
          <a href='#mImage.image_src()#' data-toggle='lightbox' data-gallery='#mUser.user()#' data-caption='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
            <img class='lazy-img fade-in-blur img-fluid rounded' data-src='#mImage.thumbnail_src()#' />
          </a>
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
