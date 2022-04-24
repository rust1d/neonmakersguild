<cfscript>
  boolean function form_valid() {
    if (form.password.len()) {
      if (form.password!=form.passagain) {
        flash.error('Passwords do not match.');
      } else if (form.password.len() < 7) {
        flash.error('Password is not valid.');
      }
    }
    return flash.len()==0;
  }

  if (form.keyExists('btnSave')) {
    if (form_valid()) {
      if (form.password.len()) {
        mUser.password(form.password);
      }
      if (mUser.safe_save()) {
        flash.success('You have successfully updated your password.');
        router.redirect(session.user.get_home());
      }
    }
  }
</cfscript>

<script src='/assets/js/user/password.js'></script>

<cfoutput>
  <div class='row g-3 justify-content-center'>
    <div class='col-12 col-md-10 col-lg-8'>
      <form role='form' method='post'>
        <div class='card'>
          <h5 class='card-header bg-nmg'>Change Password</h5>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <label class='form-label' for='password'>New Password</label>
                <input type='password' class='form-control' name='password' id='password' placeholder='password' required />
              </div>
              <div class='col-12'>
                <input type='password' class='form-control' name='passagain' id='passagain' placeholder='now try to type it again...' required />
              </div>
              <div class='col-12 text-center'>
                <button type='submit' name='btnSave' class='btn btn-nmg'>Update</button>
                <a href='#router.href(session.user.get_home())#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
    <div class='col-12 col-md-10 col-lg-8'>
      <div class='alert-info border rounded p-3'>
        To help protect the security of your account, passwords must be at least 7 characters in length,
        must contain at least one number, one capital letter, one lower case letter, and be created under
        a harvest moon. Special characters such as &ldquo;!,@,$,%,?,*,-,_&rdquo; can also be used to increase
        your password strength and curry favor with the gods.
      </div>
    </div>

  </div>
</cfoutput>
