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
  <div class='col-12 content-card'>
    <cfif !results.pagination.one_page>
      <div class='row border-top-0 pt-2 pb-0'>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination })#
      </div>
    </cfif>

    <div class='row g-3 mb-3'>
      <cfloop array='#results.rows#' item='mImage' index='idx'>
        <a href='#mImage.image_src()#' class='col-2 text-center' data-toggle='lightbox' data-gallery='#mUser.user()#' data-caption='#mImage.filename()# #mImage.dimensions()# &bull; #mImage.size_mb()#'>
          <img src='#mImage.thumbnail_src()#' class='w-100 img-thumbnail' />
        </a>
      </cfloop>
    </div>

    <div class='border-top pt-3'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
