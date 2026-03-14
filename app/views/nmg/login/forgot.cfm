<cfscript>
  if (form.keyExists('btnSend')) {
    key = utility.isEmail(form.contact) ? 'us_email' : 'us_user';
    params = { maxrows: 2, '#key#': form.contact }
    mUsers = new app.models.Users().where(params);
    if (mUsers.len()==1) {
      new app.services.email.UserEmailer().SendLoginLink(mUsers.first());
      flash.info('An email was sent with a link to access your account.');
      // router.redirect('login/login');
    } else {
      flash.warning('Your account was not found.');
    }
  }

  mBlock = mBlog.textblock_by_label('forgot-password');
</cfscript>

<cfoutput>
  <div class='row g-3 justify-content-center'>
    <cfif mBlock.persisted()>
      <div class='col-12'>
        #mBlock.body_cdn()#
      </div>
    </cfif>
    <div class='col-12 col-sm-8 col-md-6 col-lg-4'>
      <form method='post'>
        <div class='content-card shadow-sm text-center'>
          <div class='fs-3 text-marker mb-3'>Login Recovery</div>
          <div class='row g-3'>
            <div class='col-12'>
              <div class='input-group'>
                <span class='input-group-text btn-nmg'><i class='fas fa-person-dots-from-line'></i><i class='fas fa-slash-forward'></i><i class='fa-solid fa-fw fa-at'></i></span>
                <input type='text' class='form-control' name='contact' id='contact' maxlength='50' placeholder='username or email' required />
              </div>
            </div>
            <div class='col-12'>
              <button type='submit' name='btnSend' class='btn btn-nmg rounded-pill w-100'>Send Email</button>
            </div>
            <div class='col-12'>
              <a href='/login' class='small text-muted'>Back to Login</a>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
