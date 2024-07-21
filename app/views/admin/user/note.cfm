<cfscript>
  noid = router.decode('noid');
  mNote = new app.models.Notes();
  if (noid) {
    mNote = mNote.find(noid);
    mUser = mNote.User();
  } else {
    usid = router.decode('usid');
    mUser = new app.models.Users().find(usid);
    mNote = mUser.Notes(build: { no_poster: session.user.user(), no_added: now() });
  }

  if (form.keyExists('btnSubmit')) {
    form.no_note = new app.services.jSoup(form.no_note).text();
    mNote.set(form);
    if (mNote.safe_save()) {
      flash.success('Note saved.');
      router.redirenc(page: 'user/edit&tab=notes', usid: mUser.usid());
    }
  }

  mode = mNote.new_record() ? 'Add' : mNote.system() ? 'View' : 'Edit';
</cfscript>

<cfoutput>
  <div class='row justify-content-center'>
    <div class='col'>
      <form method='post'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row my-3'>
              <div class='col-2'>
                <img class='img-thumbnail w-auto' src='#mUser.profile_image().src()#' />
              </div>
              <div class='col-10'>
                <div class='fs-5'>
                  <div>#mUser.user()#</div>
                  <div>#mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#</div>
                  <div>#mUser.UserProfile().location()#</div>
                </div>
              </div>
            </div>
          </div>
          <div class='card-body bg-nmg'>
            <div class='row tab-content'>
              <div class='col-12 fs-5'>#mode# Note</div>
              <div class='col-12 fs-5'>
                <cfif mNote.new_record()>
                  <label for='no_note'>Note</label>
                <cfelse>
                  <div class='text-small text-muted'>
                    Posted #mNote.added().format('yyyy-mm-dd HH:nn')# by #mNote.poster()#
                  </div>
                </cfif>
              </div>
              <div class='col-12 p-3'>
                <cfif mNote.system()>
                  <div class='p-3 border rounded border-nmg'>
                    #mNote.note()#
                  </div>
                  <br>
                  <marquee class='clipped'>This is a system note and cannot be edited.</marquee>
                <cfelse>
                  <textarea name='no_note' id='no_note' class='form-control' maxlength='2000'>#mNote.note()#</textarea>
                </cfif>
              </div>
            </div>
            <div class='row'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <a href='#router.hrefenc(page: 'user/edit&tab=notes', usid: mUser.usid())#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>