<cfscript>
  mrid = router.decode('mrid');
  mMR = new app.models.MemberRequests();
  if (mrid) mMR = mMR.find(mrid);

  if (form.keyExists('btnSubmit')) {
    mMR.set(form);
    if (mMR.safe_save()) {
      flash.success('Member Request data saved.')
      router.redirect('requests/list');
    }
  } else if (form.keyExists('btnDelete')) {
    if (mMR.delete()) {
      flash.success('Member Request deleted.')
      router.redirect('requests/list');
    }
  } else if (form.keyExists('btnAccept')) {
    mMR.set({ mr_accepted: now() }).safe_save();
    new app.services.email.MemberRequestEmailer().SendAccept(mMR);
    flash.success('Member Acceptance / Payment Request Email sent.');
  } else if (form.keyExists('btnConvert')) {
    mMR.set(form);
    if (mMR.safe_save() && mMR.convert()) {
      flash.success('Member Request converted and user emailed. View the new user <a href="#router.hrefenc(page: "user/edit", usid: mMR.usid())#">#mMR.user()#.</a>');
      router.redirect('requests/list');
    }
  }

  mode = mMR.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfoutput>
  <div class='row justify-content-center'>
    <div class='col'>
      <form method='post'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# Member Request</div>
            </div>
          </div>
          <div class='card-body'>
            <div class='row g-3'>
              <div class='col-md-6'>
                <label class='form-label required' for='mr_firstname'>First name</label>
                <input type='text' class='form-control' name='mr_firstname' id='mr_firstname' value='#mMR.firstname()#' maxlength='50' required />
              </div>
              <div class='col-md-6'>
                <label class='form-label required' for='mr_lastname'>Last name</label>
                <input type='text' class='form-control' name='mr_lastname' id='mr_lastname' value='#mMR.lastname()#' maxlength='50' required />
              </div>
              <div class='col-md-6'>
                <label class='form-label required' for='mr_email'>Email Address</label>
                <input type='email' class='form-control' name='mr_email' id='mr_email' value='#mMR.email()#' maxlength='50' required />
              </div>
              <div class='col-md-6'>
                <label class='form-label required' for='mr_user'>Desired Username</label>
                <input type='text' class='form-control' id='mr_user' name='mr_user' value='#mMR.user()#' maxlength='50' required />
              </div>
              <div class='col-md-6'>
                <label class='form-label' for='mr_phone'>Cell Phone</label>
                <input type='tel' class='form-control' name='mr_phone' id='mr_phone' value='#mMR.phone()#' maxlength='12' placeholder='123-456-7890' />
              </div>
              <div class='col-md-6'>
                <label class='form-label' for='mr_promo'>Tee Shirt Size (US)</label>
                <select name='mr_promo' id='mr_promo' class='form-select'>
                  <option>Not Provided</option>
                  <cfloop list='Small (34-36),Medium (38-40),Large (42-44),X-Large (46-48),2X-Large (50-52),3X-Large (54-56)' item='size'>
                    <option value='#size#' #ifin(size==mMR.promo(), 'selected')#>#size#</option>
                  </cfloop>
                </select>
              </div>
              <div class='col-md-12'>
                <label class='form-label required' for='mr_location'>Location (displayed)</label>
                <input type='text' class='form-control' id='mr_location' name='mr_location' value='#mMR.location()#' maxlength='100' required />
              </div>
              <div class='col-12 col-md-6 mb-3'>
                <label class='form-label' for='mr_address1'>Address 1</label>
                <input type='text' class='form-control' name='mr_address1' id='mr_address1' value='#encodeForHTML(mMR.address1())#' maxlength='50' />
              </div>
              <div class='col-12 col-md-6 mb-3'>
                <label class='form-label' for='mr_address2'>Address 2</label>
                <input type='text' class='form-control' name='mr_address2' id='mr_address2' value='#encodeForHTML(mMR.address2())#' maxlength='25' />
              </div>
              <div class='col-12 col-md-6 mb-3'>
                <label class='form-label' for='mr_city'>City</label>
                <input type='text' class='form-control' name='mr_city' id='mr_city' value='#encodeForHTML(mMR.city())#' maxlength='25' />
              </div>
              <div class='col-12 col-md-3 mb-3'>
                <label class='form-label' for='mr_region'>State/Region Code</label>
                <input type='text' class='form-control' name='mr_region' id='mr_region' value='#encodeForHTML(mMR.region())#' maxlength='25' />
              </div>
              <div class='col-12 col-md-3 mb-3'>
                <label class='form-label' for='mr_postal'>ZIP/Postal Code</label>
                <input type='text' class='form-control' name='mr_postal' id='mr_postal' value='#mMR.postal()#' maxlength='12' />
              </div>
              <div class='col-12 col-md-6 mb-3'>
                <label class='form-label' for='mr_country'>Country Code</label>
                <input type='text' class='form-control' name='mr_country' id='mr_country' value='#mMR.country()#' maxlength='2' />
              </div>

              <div class='col-md-6'>
                <label class='form-label' for='mr_website1'>Personal Website Link <cfif isValid('url', mMR.website1())><a href='#mMR.website1()#' target='_blank'><i class='fa-solid fa-globe'></i></a></cfif></label>
                <input type='text' class='form-control' id='mr_website1' name='mr_website1' value='#mMR.website1()#' maxlength='100' />
              </div>
              <div class='col-md-6'>
                <label class='form-label' for='mr_website2'>Primary Social Media Link <cfif isValid('url', mMR.website2())><a href='#mMR.website2()#' target='_blank'><i class='fa-solid fa-globe'></i></a></cfif></label>
                <input type='text' class='form-control' id='mr_website2' name='mr_website2' value='#mMR.website2()#' maxlength='100' />
              </div>
              <div class='col-md-12 mb-3'>
                <label class='form-label' for='mr_history'>Neon experience</label>
                <textarea class='form-control' rows='6' name='mr_history' id='mr_history'>#mMR.history()#</textarea>
              </div>
              <div class='col-md-12 mb-3'>
                <label class='form-label' for='mr_hearabout'>Heard about NMG from</label>
                <input type='text' class='form-control' name='mr_hearabout' id='mr_hearabout' value='#encodeForHTML(mMR.hearabout())#' maxlength='200' />
              </div>
              <div class='col-md-12 mb-3'>
                <cfif mMR.email_validated()>
                  This email was validated on <span class='text-success'>#mMR.validated().format('yyyy-mm-dd HH:nn:ss')#</span>
                <cfelse>
                  This email is unvalidated.
                </cfif>
              </div>
              <div class='col-md-12 mb-3'>
                <cfif mMR.accept_sent()>
                  The acceptance email was sent on <span class='text-success'>#mMR.accepted().format('yyyy-mm-dd HH:nn:ss')#</span>
                <cfelse>
                  This member has not been accepted.
                </cfif>
              </div>
            </div>
            <div class='row mt-5'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <button type='submit' name='btnDelete' id='btnDelete' class='btn btn-nmg-delete'>Delete</button>
                <a href='#router.href('requests/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>

            <div class='row mt-5 justify-content-center'>
              <div class='col-12 text-center'>
                <button type='submit' name='btnAccept' id='btnAccept' class='btn btn-nmg'>Send Acceptance Email</button>
              </div>
              <div class='col-6 mt-3 smaller text-secondary'>
                Clicking <code>Send Acceptance Email</code> will let the member know they have been accepted and request
                initial payment.
              </div>
            </div>
            <div class='row mt-5 justify-content-center'>
              <div class='col-12 text-center'>
                <button type='submit' name='btnConvert' id='btnConvert' class='btn btn-nmg'>Convert to NMG Member!</button>
              </div>
              <div class='col-6 mt-3 smaller text-secondary'>
                Clicking <code>Convert to NMG Member!</code> will generate a new user account with the current data and
                delete the request. The new user will sent a welcome email with login credentials.
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
