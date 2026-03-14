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
    <div class='col-12 content-card bg-nmg-dark text-center p-3'>
      <div class='fs-2 text-marker text-white'>Library</div>
    </div>
    <div class='col-12'>
      <nav aria-label='breadcrumb'>
        <ol class='breadcrumb small m-0'>
          <li class='breadcrumb-item'><a href='/resources/library'>Library</a></li>
          <li class='breadcrumb-item active' aria-current='page'><a href='#mDocument.seo_link()#'>#mDocument.filename()#</a></li>
        </ol>
      </nav>
    </div>

    <div class='col-12 content-card'>
      <h3 class='text-marker mb-3'>#mDocument.filename()#</h3>
      <div class='d-flex flex-wrap gap-3 small text-secondary'>
        <span><i class='fa-solid fa-file me-1'></i>#mDocument.type()#</span>
        <span><i class='fa-solid fa-weight-hanging me-1'></i>#mDocument.size_mb()#</span>
        <span><i class='fa-solid fa-eye me-1'></i>#mDocument.views()# views</span>
        <span><i class='fa-solid fa-download me-1'></i>#mDocument.downloads()# downloads</span>
        <span><i class='fa-solid fa-clock me-1'></i>Last accessed #mDocument.dla().format('yyyy-mm-dd')#</span>
        <span><i class='fa-solid fa-calendar-plus me-1'></i>Added #mDocument.added().format('yyyy-mm-dd')#</span>
      </div>
    </div>

    <div class='col-12 content-card'>
      <cfif mDocument.blogCategories().len()>
        <div class='mb-2'>
          <cfloop array='#mDocument.BlogCategories()#' item='mCat' index='idx'>
            <span class='badge border text-dark bg-nmg border-nmg'>#mCat.category()#</span>
          </cfloop>
        </div>
      </cfif>
      <cfif mDocument.tags().len()>
        <div class='mb-2'>
          <cfloop array='#mDocument.tags()#' item='mTag'>
            <span class='badge bg-secondary'>#mTag.tag()#</span>
          </cfloop>
        </div>
      </cfif>
      <cfif mDocument.description().len()>
        <p class='mb-3'>#mDocument.description()#</p>
      </cfif>
      <div class='text-center'>
        <a href='#router.url()#&dln=1' class='btn btn-nmg btn-lg rounded-pill neon-glow'><i class='fa-solid fa-download me-2'></i>Download #mDocument.download_filename()#</a>
      </div>
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