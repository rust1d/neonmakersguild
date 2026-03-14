<cfscript>
  param form.sort = 'filename';
  if (len(form.get('term'))==0 && len(form.get('filter_term'))) form.term = form.filter_term;
  locals.params = utility.paged_term_params();
  if (len(form.get('tag'))) locals.params.tag = form.tag;
  if (len(form.get('bcaid'))) locals.params.bcaid = form.bcaid;
  if (len(form.get('sort'))) locals.params.sort = form.sort;
  locals.results = mBlog.documents(locals.params);
  if (len(form.get('tag'))) locals.results.pagination.tag = locals.params.tag;
  if (len(form.get('bcaid'))) locals.results.pagination.bcaid = locals.params.bcaid;
  if (len(form.get('sort'))) locals.results.pagination.sort = locals.params.sort;
</cfscript>

<script>
  $(function() {
    $('a.show_tag').on('click', function() {
      var $tag = $('#filter_tag');
      $tag.val(this.dataset.tag);
      $tag[0].form.submit();
    });

    $('#select_bcaid').on('change', function() {
      $('#filter_bcaid').val($(this).val());
      $('#filter_bcaid')[0].form.submit();
    });

    $('#select_sort').on('change', function() {
      $('#filter_sort').val($(this).val());
      $('#filter_sort')[0].form.submit();
    });

    $('#btnClearTag').prop('onclick', null);
    $('#btnClearTerm').prop('onclick', null);

    $('#btnClearTag').on('click', function(event) {
      $('#filter_tag').val('');
      $('#filter_tag')[0].form.submit();
    });

    $('#btnClearTerm').on('click', function(event) {
      $('#filter_term').val('');
      $('#filter_term')[0].form.submit();
    });
  });
</script>

<cfoutput>
  <div class='card border-0 shadow-sm'>
    <div class='card-header bg-white'>
      <div class='row align-items-center'>
        <div class='col-auto small fw-semibold'>Category</div>
        <div class='col-auto'>
          <select class='form-select form-select-sm' name='select_bcaid' id='select_bcaid'>
            <option value=''>-- all --</option>
            <cfloop array='#mBlog.categories()#' item='mCat'>
              <option value='#mCat.bcaid()#' #ifin(form.get('bcaid')==mCat.bcaid(), 'selected')#>#mCat.category()#</option>
            </cfloop>
          </select>
        </div>
        <cfif session.user.loggedIn()>
          <div class='col-auto small fw-semibold'>Sort</div>
          <div class='col-auto'>
            <select class='form-select form-select-sm' name='select_sort' id='select_sort'>
              <option value='filename' #ifin(form.sort EQ 'filename')#>Filename</option>
              <option value='added' #ifin(form.sort EQ 'added')#>Added</option>
              <option value='views' #ifin(form.sort EQ 'views')#>Views</option>
            </select>
          </div>
        </cfif>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
      </div>
    </div>
    <div class='card-body'>
      <cfif session.user.loggedIn()>
        <cfloop array='#locals.results.rows#' item='locals.mDocument'>
          <cfscript>
            locals.tag_links = locals.mDocument.tags().map(tag => '');
          </cfscript>
          <div class='content-card hover-lift mb-2'>
            <div class='d-flex justify-content-between align-items-start'>
              <div>
                <a class='fs-6 fw-semibold' href='#router.hrefenc(page: 'blog/document', docid: locals.mDocument.docid())#' data-link='#locals.mDocument.datadash()#' target='_blank'>
                  #locals.mDocument.filename()# <i class='fa-solid fa-arrow-up-right-from-square smaller ms-1'></i>
                </a>
                <cfif len(locals.mDocument.description())>
                  <div class='small mt-1'>#locals.mDocument.description()#</div>
                </cfif>
              </div>
              <div class='d-flex gap-2'>
                <cfif locals.mDocument.recent()><span class='badge bg-warning'>new!</span></cfif>
                <span class='badge bg-secondary'>#locals.mDocument.type()#</span>
              </div>
            </div>
            <div class='d-flex justify-content-between align-items-center mt-2 smaller text-muted'>
              <div>
                <cfif locals.mDocument.blogCategories().len()>
                  <cfloop array='#locals.mDocument.BlogCategories()#' item='locals.mCat' index='idx'>
                    <a class='show_category' data-tag='#locals.mCat.bcaid()#'>#locals.mCat.category()#</a><cfif idx!=locals.mDocument.BlogCategories().len()>,&nbsp;</cfif>
                  </cfloop>
                  <cfif locals.mDocument.tags().len()> &bull; </cfif>
                </cfif>
                <cfif locals.mDocument.tags().len()>
                  <cfloop array='#locals.mDocument.tags()#' item='locals.mTag' index='idx'>
                    <a class='show_tag' data-tag='#locals.mTag.tag()#'>#locals.mTag.tag()#</a><cfif idx!=locals.mDocument.tags().len()>,&nbsp;</cfif>
                  </cfloop>
                </cfif>
              </div>
              <div>
                #locals.mDocument.added().format('mm/dd/yyyy')# &bull; #locals.mDocument.size_mb()#
              </div>
            </div>
          </div>
        </cfloop>
      <cfelse>
        <div class='text-center py-3'>
          <div class='mb-2'>There are currently #locals.results.pagination.total# documents in the library.</div>
          <a href='/login' class='btn btn-nmg'>
            <i class='fas fa-person-dots-from-line me-1'></i> Login to see them
          </a>
        </div>
      </cfif>
    </div>
    <div class='card-footer bg-nmg-dark'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
