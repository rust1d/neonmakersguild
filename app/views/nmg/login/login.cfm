<cfscript>
  if (url.keyExists('auth')) {
    new app.services.user.AuthToken().indirect_login(url.auth); // SUCCESS NAVIGATES TO LOGIN'S HOMEPAGE
    router.redirect('login/login'); // GETS auth OUT OF URL
  }

  if (form.keyExists('btnLogin')) {
    new app.services.Login().login(form.username, form.password);
  }

  mBlock = mBlog.textblock_by_label('login');
</cfscript>

<cfoutput>
  <div class='row g-3 justify-content-center'>
    <cfif mBlock.persisted()>
      <div class='col-12'>
        #mBlock.body_cdn()#
      </div>
    </cfif>
    <div class='col-12 col-md-10 col-lg-8'>
      <form method='post'>
        <div class='card'>
          <h5 class='card-header'>Login</h5>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-12'>
                <div class='input-group'>
                  <span class='input-group-text btn-nmg'><i class='fas fa-person-dots-from-line'></i></span>
                  <input type='text' class='form-control' name='username' id='username' maxlength='50' placeholder='username' value='#form.get('username')#' required />
                </div>
              </div>
              <div class='col-12'>
                <div class='input-group'>
                  <span class='input-group-text btn-nmg'><i class='fas fa-key'></i></span>
                  <input type='password' class='form-control' name='password' id='password' placeholder='password' required />
                </div>
              </div>
              <div class='col-12'>
                <div class='text-center'>
                  <button type='submit' name='btnLogin' class='btn btn-nmg'>Login</button>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
    <div class='col-12 text-center links'>
      <a class='text-sm' href='#router.href('login/forgot')#'>Forgot Login?</a>
    </div>
  </div>
</cfoutput>
