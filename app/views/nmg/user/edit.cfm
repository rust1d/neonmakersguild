<cfscript>
  if (form.keyExists('btnSubmit')) {
    writedump(request.unclean);
    mProfile.set(request.unclean);
    mProfile.safe_save();
  }
</cfscript>

<script>
  $(function() {
    var froala_defaults = {
      key: 'hWA2C-7G2B6D5D4B2F2vD-8ydzfE-13E-13f1vctdskA2ytqaG3C2A5C4C4E3E3D4F2B2==',
      pluginsEnabled: ['codeView'],
      codeViewKeepActiveButtons: ['selectAll'],
      charCounterMax: 4000,
      heightMin: 200,
      fontSizeSelection: true,
      listAdvancedTypes: true,
      attribution: false
    }
    new FroalaEditor('textarea#up_bio', froala_defaults);
  });
</script>

<cfoutput>
  <section class='container'>
    <div class='row justify-content-center'>
      <div class='col-md-10'>
        <form role='form' method='post'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>User Profile</h5>
            <div class='card-body border-left border-right'>
              <div class='row'>
                <div class='col-md-12'>
                  <cfset router.include('user/images/pic') />
                </div>
              </div>
              <div class='row'>
                <div class='col-md-6 mb-3'>
                  <label class='form-label' for='up_firstname'>First name <sup><i class='text-xsmall text-danger fa fa-asterisk'></i></sup></label>
                  <input type='text' class='form-control' name='up_firstname' id='up_firstname' value='#encodeForHTML(mProfile.firstname())#' maxlength='50' />
                </div>
                <div class='col-md-6 mb-3'>
                  <label class='form-label' for='up_lastname'>Last name <sup><i class='text-xsmall text-danger fa fa-asterisk'></i></sup></label>
                  <input type='text' class='form-control' name='up_lastname' id='up_lastname' value='#encodeForHTML(mProfile.lastname())#' maxlength='50' />
                </div>
                <div class='col-md-12 mb-3'>
                  <label class='form-label' for='up_location'>Location</label>
                  <input type='text' class='form-control' id='up_location' name='up_location' value='#encodeForHTML(mProfile.location())#' maxlength='100'>
                </div>
                <div class='col-md-12 mb-3'>
                  <label class='form-label' for='up_bio'>Bio</label>
                  <textarea class='form-control' name='up_bio' id='up_bio'>#encodeForHTML(mProfile.bio())#</textarea>
                </div>
              </div>
              <small><sup><i class='text-xsmall text-danger fa fa-asterisk'></i></sup> indicates a required field</small>
              <div class='row my-3'>
                <div class='col text-center'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save Profile</button>
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