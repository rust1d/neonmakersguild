<cfscript>
  usid = router.decode('usid');
  mUser = new app.models.User();
  if (usid) mUser = mUser.find(usid);

  if (form.keyExists('btnSubmit')) {
    mUser.set(form);
    if (mUser.safe_save()) {
      flash.success('User data saved.')
      if (form.keyExists('up_firstname')) {
        mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});
        mProfile.set(form);
        mProfile.safe_save();
      }
      if (usid==0) router.redirenc(page: 'user/edit', usid: mUser.usid());
    }
  }

  mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});

  mode = mUser.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row justify-content-center'>
      <div class='col-md-10'>
        <form role='form' method='post'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>#mode# User</h5>
            <div class='card-body border-left border-right'>
              <div class='row'>
                <div class='col-md-6 mb-3'>
                  <label class='form-label required' for='us_email'>Email Address</label>
                  <input type='email' class='form-control' name='us_email' id='us_email' value='#encodeForHTML(mUser.email())#' maxlength='50' required />
                </div>
                <cfif mUser.new_record()>
                  <div class='col-md-6 mb-3'>
                    <label class='form-label required' for='password'>Password</label>
                    <input type='text' class='form-control' name='password' id='password' value='' maxlength='50' required />
                  </div>
                <cfelse>
                  <div class='col-md-6 mb-3'>
                    <label class='form-label' for='password'>Change Password</label>
                    <input type='text' class='form-control' name='password' id='password' value='' maxlength='50' />
                  </div>
                  <div class='col-md-6 mb-3'>
                    <label class='form-label' for='up_firstname'>First name</label>
                    <input type='text' class='form-control' name='up_firstname' id='up_firstname' value='#encodeForHTML(mProfile.firstname())#' maxlength='50' />
                  </div>
                  <div class='col-md-6 mb-3'>
                    <label class='form-label' for='up_lastname'>Last name</label>
                    <input type='text' class='form-control' name='up_lastname' id='up_lastname' value='#encodeForHTML(mProfile.lastname())#' maxlength='50' />
                  </div>
                  <div class='col-md-12 mb-3'>
                    <label class='form-label' for='up_location'>Location</label>
                    <input type='text' class='form-control' id='up_location' name='up_location' value='#encodeForHTML(mProfile.location())#' maxlength='100'>
                  </div>
                  <div class='col-md-12 mb-3'>
                    <label class='form-label' for='up_bio'>Bio</label>
                    <textarea class='form-control' name='up_bio' id='up_bio'>#encodeForHTML(mProfile.bio())#</textarea>
                  </div>
                </cfif>
                <div class='col-md-6 mb-3'>
                  <label class='form-label' for='us_permissions'>Admin Level</label>
                  <select class='form-control' name='us_permissions' id='us_permissions'>
                    <cfloop list='0,None|1,Admin|2,Super Admin' item='val' delimiters='|'>
                      <option value='#val.listFirst()#' #ifin(val.listFirst() eq mUser.permissions(), 'selected')#>#val.listLast()#</option>
                    </cfloop>
                  </select>
                </div>
              </div>
              <div class='row my-3'>
                <div class='col text-center'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                  <a href='#router.href('user/list')#' class='btn btn-nmg'>Cancel</a>
                </div>
              </div>
            </div>
            <div class='card-footer bg-nmg border-top-0'></div>
          </div>
        </form>
      </div>
    </div>
  </section>
</cfoutput>