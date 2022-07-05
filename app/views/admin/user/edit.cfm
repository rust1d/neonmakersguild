<cfscript>
  usid = router.decode('usid');
  mUser = new app.models.Users();
  if (usid) mUser = mUser.find(usid);

  if (form.keyExists('btnSubmit')) {
    form.us_email = form.us_email.lcase();
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
  <div class='row justify-content-center'>
    <div class='col'>
      <form method='post'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# User</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-md-6'>
                <label class='form-label #ifin(mUser.new_record(), 'required')#' for='us_user'>Username</label>
                <input type='text' class='form-control' name='us_user' id='us_user' value='#encodeForHTML(mUser.user())#' maxlength='50' #ifin(mUser.new_record(), 'required', 'readonly')# />
              </div>
              <cfif mUser.new_record()>
                <div class='col-md-6'>
                  <label class='form-label required' for='password'>Password</label>
                  <input type='text' class='form-control' name='password' id='password' value='' maxlength='50' required />
                </div>
              <cfelse>
                <div class='col-md-6'>
                  <label class='form-label' for='password'>Change Password</label>
                  <input type='text' class='form-control' name='password' id='password' value='' maxlength='50' />
                </div>
                <div class='col-md-6'>
                  <label class='form-label required' for='up_firstname'>First name</label>
                  <input type='text' class='form-control' name='up_firstname' id='up_firstname' value='#encodeForHTML(mProfile.firstname())#' maxlength='50' required />
                </div>
                <div class='col-md-6'>
                  <label class='form-label required' for='up_lastname'>Last name</label>
                  <input type='text' class='form-control' name='up_lastname' id='up_lastname' value='#encodeForHTML(mProfile.lastname())#' maxlength='50' required />
                </div>
                <div class='col-md-6'>
                  <label class='form-label required' for='us_email'>Email Address</label>
                  <input type='email' class='form-control' name='us_email' id='us_email' value='#encodeForHTML(mUser.email())#' maxlength='50' required />
                </div>
                <div class='col-md-6'>
                  <label class='form-label' for='up_phone'>Phone</label>
                  <input type='tel' class='form-control' name='up_phone' id='up_phone' value='#mProfile.phone()#' maxlength='15' />
                </div>
                <div class='col-md-6'>
                  <label class='form-label' for='us_permissions'>Admin Level</label>
                  <select class='form-control' name='us_permissions' id='us_permissions'>
                    <cfloop list='0,None|1,Admin|2,Super Admin' item='val' delimiters='|'>
                      <option value='#val.listFirst()#' #ifin(val.listFirst() eq mUser.permissions(), 'selected')#>#val.listLast()#</option>
                    </cfloop>
                  </select>
                </div>
                <div class='col-md-6'>
                  <label class='form-label' for='up_promo'>T-Shirt Size</label>
                  <input type='promo' class='form-control' name='up_promo' id='up_promo' value='#encodeForHTML(mProfile.promo())#' maxlength='50' />
                </div>
                <div class='col-12'>
                  <label class='form-label' for='up_location'>Location</label>
                  <input type='text' class='form-control' id='up_location' name='up_location' value='#encodeForHTML(mProfile.location())#' maxlength='100' />
                </div>
                <div class='col-12'>
                  <label class='form-label' for='up_bio'>Bio</label>
                  <textarea class='tiny-mce form-control' rows='15' name='up_bio' id='up_bio'>#encodeForHTML(mProfile.bio())#</textarea>
                </div>
              </cfif>
            </div>
            <div class='row mt-5'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <a href='#router.href('user/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>