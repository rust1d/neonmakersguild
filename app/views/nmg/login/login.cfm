<cfscript>
  if (form.keyExists('btnLogin')) {
    new app.services.Login().login(form.username, form.password);
  }

  mBlock = mBlog.textblock_by_label('login');
</cfscript>

<cfoutput>
  <div class='row justify-content-center'>
    <cfif mBlock.persisted()>
      <div class='col-12'>
        #mBlock.body()#
      </div>
    </cfif>
    <div class='col-12 col-md-10 col-lg-8'>
      <form role='form' method='post'>
        <div class='card'>
          <h5 class='card-header bg-nmg'>Login</h5>
          <div class='card-body'>
            <div class='input-group mb-3'>
              <span class='input-group-text btn-nmg'><i class='fas fa-person-dots-from-line'></i></span>
              <input type='text' class='form-control' name='username' id='username' maxlength='50' placeholder='username' value='#form.get('username')#' required>
            </div>
            <div class='input-group mb-3'>
              <span class='input-group-text btn-nmg'><i class='fas fa-key'></i></span>
              <input type='password' class='form-control' name='password' id='password' placeholder='password' required>
            </div>
            <div class='form-check mb-3'>
              <input id='remember_me' type='checkbox' name='remember_me' value='true' class='form-check-input' #ifin(form.remember_me ?: false, 'checked')#>
              <label for='remember_me' class='form-check-label'>Remember Me</label>
            </div>
            <div class='mb-3 text-center'>
              <button type='submit' name='btnLogin' class='btn btn-nmg'>Login</button>
            </div>
            <div class='row mb-3'>
              <div class='col-6 text-center links'>
                <a class='text-sm' href='#router.href('login/helpUsername')#'>Forgot Username?</a>
              </div>
              <div class='col-6 text-center links'>
                <a class='text-sm' href='#router.href('login/forgotLogin')#'>Forgot Password?</a>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</cfoutput>
