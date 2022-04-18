<cfscript>
  if (form.keyExists('btnSubmit')) {
    mProfile.set(form);
    mProfile.safe_save();
  }
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col-12'>
        <form role='form' method='post'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>User Profile</h5>
            <div class='card-body'>
              <div class='row'>
                <div class='col-md-12'>
                  <cfset router.include('user/image/pic') />
                </div>
              </div>
              <div class='row'>
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
                  <textarea class='tiny-mce form-control' name='up_bio' id='up_bio'>#encodeForHTML(mProfile.bio())#</textarea>
                </div>
              </div>
              <div class='row my-3'>
                <div class='col text-center'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save Profile</button>
                  <a href='#router.href(session.user.get_home())#' class='btn btn-nmg-cancel'>Cancel</a>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </section>
</cfoutput>