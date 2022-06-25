<cfscript>
  locals.params = utility.paged_term_params();
  if (len(form.get('tag'))) locals.params.tag = form.tag;
  locals.results = mBlog.documents(locals.params);
  if (len(form.get('tag'))) locals.results.pagination.tag = locals.params.tag;
</cfscript>

<script>
  $(function() {
    $('a.show_tag').on('click', function() {
      var $tag = $('#filter_tag');
      $tag.val(this.dataset.tag);
      $tag[0].form.submit();
    });
  });

</script>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row align-items-center'>
        <div class='col-auto fs-6'>#locals.mPage.title()#</div>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
      </div>
    </div>
    <div class='card-body'>
      <div class='row'>
        <cfloop array='#locals.results.rows#' item='locals.mDocument'>
          <cfscript>
            locals.tag_links = locals.mDocument.tags().map(tag => '');
          </cfscript>
          <div class='col-12 mb-2'>
            <div class='card'>
              <div class='card-header'>
                <a class='fs-6' href='#router.hrefenc(page: 'blog/document', docid: locals.mDocument.docid())#' data-link='#locals.mDocument.datadash()#' target='_blank'>#locals.mDocument.filename()#</a>
                <span class='float-end badge bg-secondary'>#locals.mDocument.type()#</span>
              </div>
              <cfif len(locals.mDocument.description())>
                <div class='card-body small'>
                  #locals.mDocument.description()#
                </div>
              </cfif>
              <div class='card-footer smaller'>
                <cfif locals.mDocument.tags().len()>
                  Tags:
                  <cfloop array='#locals.mDocument.tags()#' item='locals.mTag' index='idx'>
                    <a class='show_tag' data-tag='#locals.mTag.tag()#'>#locals.mTag.tag()#</a><cfif idx!=locals.mDocument.tags().len()>,&nbsp;</cfif>
                  </cfloop>
                </cfif>
                <span class='float-end'>Size: #locals.mDocument.size_mb()#</span>
              </div>
            </div>
          </div>
        </cfloop>
      </div>
    </div>
    <div class='card-footer bg-nmg'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
