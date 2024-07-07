<cfscript>
  if (form.keyExists('btnSubmit')) {
    mProfile.set(form);
    mProfile.safe_save();
  }
</cfscript>

<script src='/assets/js/image/select.js'></script>

<cfoutput>
  <form method='post'>
    <div class='card'>
      <h5 class='card-header bg-nmg'>Edit User Profile</h5>
      <div class='card-body'>
        <div class='row'>
          <div class='col-md-12'>
            <cfset router.include('user/image/pic') />
          </div>
        </div>
        <h3>Public Info</h3>
        <p class='smaller'>This information is viewable on your public member profile.</p>
        <div class='row g-3'>
          <div class='col-md-6'>
            <label class='form-label' for='up_firstname'>First name</label>
            <input type='text' class='form-control' name='up_firstname' id='up_firstname' value='#encodeForHTML(mProfile.firstname())#' maxlength='50' />
          </div>
          <div class='col-md-6'>
            <label class='form-label' for='up_lastname'>Last name</label>
            <input type='text' class='form-control' name='up_lastname' id='up_lastname' value='#encodeForHTML(mProfile.lastname())#' maxlength='50' />
          </div>
          <div class='col-md-12'>
            <label class='form-label' for='up_location'>Location</label>
            <input type='text' class='form-control' id='up_location' name='up_location' value='#encodeForHTML(mProfile.location())#' maxlength='100' />
          </div>
          <div class='col-12'>
            <label class='form-label' for='imagesearch'>Image Search</label>
            <div class='input-group input-group-sm'>
              <span class='input-group-text btn-nmg'><i class='fa fa-search'></i></span>
              <input type='text' class='form-control' id='imagesearch' name='imagesearch' placeholder='type to search images...' maxlength='20' data-usid='#mUserBlog.encoded_key()#' />
            </div>
            <div id='imageselect' class='row g-1 mt-1'>
              <div class='col-3 col-md-2 col-xl-1'><img class='w-100 img-thumbnail' src='#application.urls.cdn#/assets/images/profile_placeholder.png' /></div>
            </div>
            <small class='text-muted'>Click thumbnail to insert image into bio.</small>
          </div>
          <div class='col-md-12'>
            <label class='form-label' for='up_bio'>Bio</label>
            <textarea class='tiny-mce form-control' rows='15' name='up_bio' id='up_bio'>#encodeForHTML(mProfile.bio())#</textarea>
          </div>
        </div>
        <h3>Private Info</h3>
        <p class='smaller'>This information is only viewable by admins.</p>
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

          <!--- <div class='col-md-6'>
            <label class='form-label' for='up_promo'>T-Shirt Size</label>
            <select name='up_promo' id='up_promo' class='form-control'>
              <option>Not Provided</option>
              <cfloop list='Small (34-36),Medium (38-40),Large (42-44),X-Large (46-48),2X-Large (50-52),3X-Large (54-56)' item='size'>
                <option value='#size#' #ifin(size==mProfile.promo(), 'selected')#>#size#</option>
              </cfloop>
            </select>
            <small class='smaller text-secondary'>US sizing.</small>
          </div> --->
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
