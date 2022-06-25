<cfscript>
  mDocument = mBlog.document_find_or_create(router.decode('docid'));
  if (mDocument.new_record()) router.go('resources/library');

  if (url.keyExists('dln')) {
    mDocument.clicks_inc();
    mDocument.safe_save();
    mDocument.download();
  // } else {
  //   cfheader(value: '2; url=#router.url()#&dln=1', name: 'refresh');
  //   flash.success('Your download will begin automatically...');
  }
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 text-center rounded-pill p-3 bg-nmg-light'>
      <div class='fs-2'>Library</div>
    </div>
    <div class='col-12 text-center'>
      <a href='#router.url()#&dln=1' class='btn btn-lg btn-nmg'>Download #mDocument.download_filename()#</a>
    </div>
    <div class='col-md-9 col-12'>
      <label class='form-label'>Filename</label>
      <h5>#mDocument.filename()#</h5>
    </div>
    <div class='col-md-3 col-12'>
      <label class='form-label'>Type</label>
      <h5>#mDocument.type()#</h5>
    </div>

    <div class='col-12'>
      <label class='form-label'>Tags</label>
      <div class='taglist'>
        <cfloop array='#mDocument.tags()#' item='mTag'>
          <span class='badge border text-dark bg-nmg border-nmg' data-id='#mTag.tagid()#'><input type=hidden name=tagids value='#mTag.tagid()#' />#mTag.tag()#</span>
        </cfloop>
      </div>
    </div>
    <div class='col-3'>
      <label class='form-label'>Size</label>
      <h5>#mDocument.size_mb()#</h5>
    </div>
    <div class='col-3'>
      <label class='form-label'>Views</label>
      <h5>#mDocument.clicks()#</h5>
    </div>
    <div class='col-3'>
      <label class='form-label'>DLA</label>
      <h5>#mDocument.dla().format('yyyy-mm-dd')#</h5>
    </div>
    <div class='col-3'>
      <label class='form-label'>Added</label>
      <h5>#mDocument.added().format('yyyy-mm-dd')#</h5>
    </div>
    <div class='col-12'>
      <label class='form-label'>Description</label>
      <h6>#mDocument.description()#</h6>
    </div>
    <div class='col-12'>
      <embed src='#mDocument.src()#' class='w-100 form-control' style='min-height: 300px' autostart='0' autoplay='false' />
    </div>
  </div>
</cfoutput>