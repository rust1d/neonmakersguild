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
  <section class='container'>
    <div class='row justify-content-center'>
      <div class='col-md-6'>
        <form role='form' method='post'>
          <div class='card'>
            <h5 class='card-header btn-nmg'>Change Password</h5>
            <div class='card-body'>
              <p>
                <label class='form-label' for='password'>New Password</label>
                <input type='password' class='form-control' name='password' id='password' placeholder='password' required />
              </p>
              <p>
                <input type='password' class='form-control' name='passagain' id='passagain' placeholder='now try to type it again...' required />
              </p>
              <p class='alert alert-warning'>
                To help protect the security of your account, passwords must be at least 7 characters in length,
                must contain at least one number, one capital letter, one lower case letter, and be created under
                a harvest moon. Special characters such as &ldquo;!,@,$,%,?,*,-,_&rdquo; can also be used to increase
                your password strength and curry favor with the gods.
              </p>
              <div class='mb-3 text-center'>
                <button type='submit' name='btnSave' class='btn btn-nmg'>Update</button>
                <a href='#router.href(session.user.get_home())#' class='btn btn-warning'>Cancel</a>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</cfoutput>
