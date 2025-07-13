<cfscript>
  if (form.keyExists('btnSubmit')) {
    mProfile.set(form);
    mProfile.safe_save();
  }
</cfscript>

<cfset include_js('assets/js/image/select.js') />

<cfoutput>
  <form method='post'>
    <div class='card'>
      <h5 class='card-header bg-nmg'>Edit User Profile</h5>
      <div class='card-body'>
        <div class='row mb-3'>
          <div class='col-sm-auto'>
            <cfset router.include('user/image/pic') />
          </div>
          <div class='col'>
            <div class='fs-3'>
              #mUser.user()#
              <cfif mUser.usid() LT 8><sup><i class='fa-solid fa-fw fa-person-burst text-warning' title='NMG Founder'></i></sup></cfif>
              <cfif mUser.permissions() GT 0><sup><i class='fa-solid fa-fw fa-burst text-warning' title='Site Admin'></i></sup></cfif>
            </div>
            <!--- <div>
              <a class='fs-6' href='#router.href('user/security')#'>
                <i class='fa-solid fa-user-shield me-1'></i>
                Change Password
              </a>
            </div> --->
          </div>
        </div>
        <h4 class='mb-1'>Public Info</h4>
        <p class='smaller text-muted'>This information is viewable on your public member profile.</p>
        <div class='row g-3 mb-3'>
          <div class='col-md-6'>
            <label class='form-label' for='up_firstname'>First name</label>
            <input type='text' class='form-control' name='up_firstname' id='up_firstname' value='#encodeForHTML(mProfile.firstname())#' maxlength='50' />
          </div>
          <div class='col-md-6'>
            <label class='form-label' for='up_lastname'>Last name</label>
            <input type='text' class='form-control' name='up_lastname' id='up_lastname' value='#encodeForHTML(mProfile.lastname())#' maxlength='50' />
          </div>
          <div class='col-12'>
            <label class='form-label' for='up_location'>Location</label>
            <input type='text' class='form-control' id='up_location' name='up_location' value='#encodeForHTML(mProfile.location())#' maxlength='100' />
          </div>
          <div class='col-12'>
            <label class='form-label' for='up_bio'>Bio</label>
            <textarea class='tiny-mce form-control' rows='15' name='up_bio' id='up_bio'>#encodeForHTML(mProfile.bio())#</textarea>
          </div>
          <div class='col-12'>
            <div id='imageselect' class='pb-2'>
              <div class='image-tile'>
                <img class='img-thumbnail w-100' src='#application.urls.cdn#/assets/images/profile_placeholder.png' />
              </div>
            </div>
            <div class='row mt-2'>
              <div class='col-12 col-lg-5 col-xl-4'>
                <div class='input-group input-group-sm'>
                  <label class='input-group-text btn-nmg' for='imagesearch'>Image Search</label>
                  <input type='text' class='form-control' id='imagesearch' name='imagesearch' placeholder='search by filename' maxlength='20' data-usid='#mUserBlog.encoded_key()#' />
                  <span class='input-group-text btn-nmg'><i class='fa fa-search'></i></span>
                </div>
              </div>
              <div class='col text-muted smaller'>
                Click to insert into bio.
              </div>
            </div>
          </div>
          <!--- <div class='col-12'>
            <label class='form-label' for='imagesearch'>Image Search</label>
            <span class='form-text'>Search for an image to insert into your bio.</span>
            <div class='input-group input-group-sm'>
              <span class='input-group-text'>Image Search</span>
              <span class='input-group-text btn-nmg'><i class='fa fa-search'></i></span>
              <input type='text' class='form-control' id='imagesearch' name='imagesearch' placeholder='type to search images...' maxlength='20' data-usid='#mUserBlog.encoded_key()#' />
            </div>
          </div> --->
        </div>
        <h4 class='mb-1'>Private Info</h4>
        <p class='smaller text-muted'>This information is only viewable by admins.</p>
        <div class='row g-3'>
          <div class='col-12 col-md-6'>
            <label class='form-label' for='up_address1'>Address 1</label>
            <input type='text' class='form-control' name='up_address1' id='up_address1' value='#encodeForHTML(mProfile.address1())#' maxlength='50' />
          </div>
          <div class='col-12 col-md-6'>
            <label class='form-label' for='up_address2'>Address 2</label>
            <input type='text' class='form-control' name='up_address2' id='up_address2' value='#encodeForHTML(mProfile.address2())#' maxlength='25' />
          </div>
          <div class='col-12 col-md-6'>
            <label class='form-label' for='up_city'>City</label>
            <input type='text' class='form-control' name='up_city' id='up_city' value='#encodeForHTML(mProfile.city())#' maxlength='25' />
          </div>
          <div class='col-12 col-md-3'>
            <label class='form-label' for='up_region'>State/Region Code</label>
            <input type='text' class='form-control' name='up_region' id='up_region' value='#encodeForHTML(mProfile.region())#' maxlength='25' />
          </div>
          <div class='col-12 col-md-3'>
            <label class='form-label' for='up_postal'>ZIP/Postal Code</label>
            <input type='text' class='form-control' name='up_postal' id='up_postal' value='#mProfile.postal()#' maxlength='12' />
          </div>
          <div class='col-12 col-md-6'>
            <label class='form-label' for='up_country'>Country Code</label>
            <input type='text' class='form-control' name='up_country' id='up_country' value='#mProfile.country()#' maxlength='2' />
          </div>
          <div class='col-12 col-md-6'>
            <label class='form-label' for='up_phone'>Phone</label>
            <input type='tel' class='form-control' name='up_phone' id='up_phone' value='#mProfile.phone()#' maxlength='15' />
          </div>
        </div>

        <div class='row my-3'>
          <div class='col text-center'>
            <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save Profile</button>
            <a href='#session.user.get_home()#' class='btn btn-nmg-cancel'>Cancel</a>
          </div>
        </div>
      </div>
    </div>
  </form>
</cfoutput>
