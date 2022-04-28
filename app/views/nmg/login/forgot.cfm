<cfscript>
  application.paths.templates = '\app\views\templates\';
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
        #mBlock.body()#
      </div>
    </cfif>
    <div class='col-12 col-md-10 col-lg-8'>
      <form method='post'>
        <div class='card'>
          <h5 class='card-header'>Login Recovery</h5>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <div class='input-group'>
                  <span class='input-group-text btn-nmg'><i class='fas fa-person-dots-from-line'></i><i class='fas fa-slash-forward'></i><i class='fa-solid fa-at'></i></span>
                  <input type='text' class='form-control' name='contact' id='contact' maxlength='50' placeholder='username or email' required />
                </div>
              </div>
              <div class='col-12'>
                <div class='text-center'>
                  <button type='submit' name='btnSend' class='btn btn-nmg'>Send Email</button>
                  <a href='/login' class='btn btn-nmg-cancel'>Cancel</a>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</cfoutput>
