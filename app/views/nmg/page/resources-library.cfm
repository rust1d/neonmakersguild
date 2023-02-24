<cfscript>
  if (len(form.get('term'))==0 && len(form.get('filter_term'))) form.term = form.filter_term;
  locals.params = utility.paged_term_params();
  if (len(form.get('tag'))) locals.params.tag = form.tag;
  if (len(form.get('bcaid'))) locals.params.bcaid = form.bcaid;
  locals.results = mBlog.documents(locals.params);
  if (len(form.get('tag'))) locals.results.pagination.tag = locals.params.tag;
  if (len(form.get('bcaid'))) locals.results.pagination.bcaid = locals.params.bcaid;
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
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row align-items-center'>
        <div class='col-auto fs-6'>
          Categories
        </div>
        <div class='col-2'>
          <select class='form-control form-control-sm mt-1' name='select_bcaid' id='select_bcaid'>
            <option value=''>-- all --</option>
            <cfloop array='#mBlog.categories()#' item='mCat'>
              <option value='#mCat.bcaid()#' #ifin(form.get('bcaid')==mCat.bcaid(), 'selected')#>#mCat.category()#</option>
            </cfloop>
          </select>
        </div>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
      </div>
    </div>
    <div class='card-body'>
      <div class='row'>
        <cfif session.user.loggedIn()>
          <cfloop array='#locals.results.rows#' item='locals.mDocument'>
            <cfscript>
              locals.tag_links = locals.mDocument.tags().map(tag => '');
            </cfscript>
            <div class='col-12 mb-2'>
              <div class='card'>
                <div class='card-header'>
                  <a class='fs-6' href='#router.hrefenc(page: 'blog/document', docid: locals.mDocument.docid())#' data-link='#locals.mDocument.datadash()#' target='_blank'>#locals.mDocument.filename()#</a>
                  <span class='float-end badge bg-secondary'>#locals.mDocument.type()#</span>
                  <cfif locals.mDocument.recent()><span class='float-end badge bg-warning me-3'>new!</span></cfif>
                </div>
                <cfif len(locals.mDocument.description())>
                  <div class='card-body small'>
                    #locals.mDocument.description()#
                  </div>
                </cfif>
                <div class='card-footer smaller'>
                  <cfif locals.mDocument.blogCategories().len()>
                    <span>
                      Categories:
                      <cfloop array='#locals.mDocument.BlogCategories()#' item='locals.mCat' index='idx'>
                        <a class='show_category' data-tag='#locals.mCat.bcaid()#'>#locals.mCat.category()#</a><cfif idx!=locals.mDocument.BlogCategories().len()>,&nbsp;</cfif>
                      </cfloop>
                    </span>
                    <cfif locals.mDocument.tags().len()> &bull;</cfif>
                  </cfif>
                  <cfif locals.mDocument.tags().len()>
                    <span>
                      Tags:
                      <cfloop array='#locals.mDocument.tags()#' item='locals.mTag' index='idx'>
                        <a class='show_tag' data-tag='#locals.mTag.tag()#'>#locals.mTag.tag()#</a><cfif idx!=locals.mDocument.tags().len()>,&nbsp;</cfif>
                      </cfloop>
                    </span>
                  </cfif>
                  <span class='float-end'>#locals.mDocument.size_mb()#</span>
                  <span class='float-end me-3'>#locals.mDocument.added().format('mm/dd/yyyy')#</span>
                </div>
              </div>
            </div>
          </cfloop>
        <cfelse>
          <div class='col-12'>
            There are currently #locals.results.pagination.total# documents in the library.
            <a href='/login' class='btn btn-sm btn-nmg' title='Login'>
              <i class='fas fa-person-dots-from-line'></i> Login to see them.
            </a>
          </div>
        </cfif>
      </div>
    </div>
    <div class='card-footer bg-nmg'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
