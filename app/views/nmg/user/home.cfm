<cfscript>
  if (form.keyExists('btnSubmit')) {
    mProfile.set(form);
    mProfile.safe_save();
  }
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row justify-content-center'>
      <div class='col-md-10'>
        <form role='form' method='post'>
          <div class='card'>
            <div class='card-header bg-nmg'>
            </div>
            <div class='card-body border-left border-right'>
              <div class='row mb-3'>
                <div class='col-auto'>
                  <img class='img-thumbnail' id='profile_image' src='#mUser.profile_image().src()#' />
                </div>
                <div class='col-md-8'>
                  <h5>#mProfile.name()#</h5>
                  <div>#mProfile.location()#</div>
                </div>
              </div>
              <div class='row'>
                <div class='col'>
                  <p>#mProfile.bio()#</p>
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
