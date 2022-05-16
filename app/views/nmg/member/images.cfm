<cfscript>
  results = mUserBlog.images(utility.paged_term_params(maxrows: 30));
</cfscript>

<script>
  $(function() {
    $('[data-toggle="lightbox"]').on('click', function(e) {
      e.preventDefault();
    	new Lightbox(this, { keyboard: true, constrain: true }).show();
    });
  });
</script>

<cfoutput>
  <div class='card-body border-top-0 py-2'>
    <div class='row'>
      #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
    </div>
  </div>
  <div class='card-body pt-0'>
    <div class='row g-3'>
      <cfloop array='#results.rows#' item='mImage' index='idx'>
        <a href='#mImage.image_src()#' class='col-2 text-center' data-toggle='lightbox' data-gallery='#mUser.user()#' data-caption='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
          <img src='#mImage.thumbnail_src()#' class='w-100 img-thumbnail' />
        </a>
      </cfloop>
    </div>
  </div>
  <div class='card-footer bg-nmg-light'>
    <div class='row align-items-center'>
      #router.include('shared/partials/filter_and_page', { pagination: results.pagination, footer: true })#
    </div>
  </div>
</cfoutput>
