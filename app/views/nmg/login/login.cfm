<cfscript>
  mPage = mBlog.page_by_alias('login');

  if (form.keyExists('btnLogin')) {
    new app.services.Login().login(form.username, form.password);
  }
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row justify-content-center'>
      <div class='col-12'>
        #router.include('shared/blog/page', { mPage: mPage })#
      </div>
      <div class='col-md-6'>
        <form role='form' method='post'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>Login</h5>
            <div class='card-body border-left border-right'>
              <div class='input-group mb-3'>
                <span class='input-group-text btn-nmg'><i class='fas fa-at'></i></span>
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
            <div class='card-footer bg-nmg border-top-0'></div>
          </form>
        </div>
      </div>
    </div>
  </section>
</cfoutput>
