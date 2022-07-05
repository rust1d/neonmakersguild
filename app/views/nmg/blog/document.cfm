<cfscript>
  mDocument = mBlog.document_find_or_create(router.decode('docid'));
  if (mDocument.new_record()) router.go('resources/library');

  if (url.keyExists('dln')) {
    mDocument.downloads_inc();
    mDocument.safe_save();
    mDocument.download();
  } else {
    mDocument.views_inc();
    mDocument.safe_save();
  }
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center rounded-pill p-3 bg-nmg-light'>
      <div class='fs-2'>Library</div>
    </div>
    <div class='col-12'>
      <nav aria-label='breadcrumb'>
        <ol class='breadcrumb small m-0'>
          <li class='breadcrumb-item'><a href='/resources/library'>Library</a></li>
          <li class='breadcrumb-item active' aria-current='page'><a href='#mDocument.seo_link()#'>#mDocument.filename()#</a></li>
        </ol>
      </nav>
    </div>

    <div class='col-12'>
      <label class='small'>Filename</label>
      <h3>#mDocument.filename()#</h3>
    </div>
    <div class='col-2'>
      <label class='small'>Type</label>
      <h5>#mDocument.type()#</h5>
    </div>
    <div class='col-2'>
      <label class='small'>Size</label>
      <h5>#mDocument.size_mb()#</h5>
    </div>
    <div class='col-2'>
      <label class='small'>Views</label>
      <h5>#mDocument.views()#</h5>
    </div>
    <div class='col-2'>
      <label class='small'>Downloads</label>
      <h5>#mDocument.downloads()#</h5>
    </div>
    <div class='col-2'>
      <label class='small'>DLA</label>
      <h5>#mDocument.dla().format('yyyy-mm-dd')#</h5>
    </div>
    <div class='col-2'>
      <label class='small'>Added</label>
      <h5>#mDocument.added().format('yyyy-mm-dd')#</h5>
    </div>

    <cfif mDocument.blogCategories().len()>
      <div class='col-12'>
        <label class='small'>Categories</label>
        <div class='catlist'>
          <cfloop array='#mDocument.BlogCategories()#' item='mCat' index='idx'>
            <span class='badge border text-dark bg-nmg border-nmg'>#mCat.category()#</span>
          </cfloop>
        </div>
      </div>
    </cfif>

    <cfif mDocument.tags().len()>
      <div class='col-12'>
        <label class='small'>Tags</label>
        <div class='taglist'>
          <cfloop array='#mDocument.tags()#' item='mTag'>
            <span class='badge border text-dark bg-nmg border-nmg'>#mTag.tag()#</span>
          </cfloop>
        </div>
      </div>
    </cfif>

    <div class='col-12'>
      <label class='small'>Description</label>
      <h6>#mDocument.description()#</h6>
    </div>
    <div class='col-12 text-center'>
      <a href='#router.url()#&dln=1' class='btn btn-sm btn-nmg'>Download #mDocument.download_filename()#</a>
    </div>
    <div class='col-12'>
      <cfif mDocument.type()=='pdf'>
        <embed src='#mDocument.src()#' class='w-100 form-control' style='aspect-ratio: 1' autostart='0' autoplay='false' />
      <cfelse>
        <embed src='#mDocument.src()#' class='w-100 form-control' style='min-height: 500px' autostart='0' autoplay='false' />
      </cfif>
    </div>
  </div>
</cfoutput>