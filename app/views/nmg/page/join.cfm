<cfscript>
  if (form.keyExists('mr_user')) form.mr_user = form.mr_user.rereplace('[^0-9A-Za-z_-]','','all');
  mMR = new app.models.MemberRequests(form);

  if (form.keyExists('G-RECAPTCHA-RESPONSE')) {
    try {
      service = new http(method: 'post', url: ' https://www.google.com/recaptcha/api/siteverify');
      service.addParam(type: 'url', name: 'secret', value: application.secrets.recaptcha);
      service.addParam(type: 'url', name: 'response', value: form['G-RECAPTCHA-RESPONSE']);
      result = service.send().getPrefix();
      response = deserializeJSON(result.fileContent);
      if (response.success) {
        subject = 'Membership Form';
        if (response.score lt 0.3) {
          subject = 'SPAM LIKELY: ' & subject;
          form['G-RECAPTCHA-RESPONSE'] = 'Spam likely: ' & response.score;
          flash.warning('Thanks Robot! Beep boop to you too.');
          // sendto = [ application.email.admin, 'membership@neonmakersguild.org' ];
          new app.services.email.AdminEmailer(to: 'membership@neonmakersguild.org', cc: application.email.admin, subject: subject).send_form();
          router.go('/page/application-submitted');
        } else {
          if (mMR.safe_save()) {
            form['G-RECAPTCHA-RESPONSE'] = 'Success: ' & response.score;
            flash.success('Thanks #form.mr_firstname#! We will be in touch soon. Please add `support@neonmakersguild.org` to your email whitelist while you wait.');
            // sendto = [ application.email.admin, 'membership@neonmakersguild.org' ];
            new app.services.email.AdminEmailer(to: 'membership@neonmakersguild.org', cc: application.email.admin, subject: subject).send_form();
            new app.services.email.MemberRequestEmailer().SendConfirmation(mMR);
            router.go('/page/application-submitted');
          }
        }
      }
    } catch (any err) {
      flash.cferror(err);
    }
  }
  mByLaws = mBlog.page_by_alias('bylaws');
</cfscript>

<script>
  function onSubmit(token) {
    var frm = document.getElementById('membership-form');
    if (frm.reportValidity()) frm.submit();
  }
</script>

<cfoutput>
  <form method='post' id='membership-form'>

    <div class='row g-2 mt-2 content-card pt-0'>
      <div class='col-12 alert alert-info p-1 mb-0 text-center smaller fst-italic fw-semibold'>
        Fields marked with <span class='btn btn-warning btn-sm p-1 px-2 mx-1'><i class='fa-solid fa-shield-heart'></i></span>
        will not be made public or shown on your member profile.
      </div>
      <div class='col-12 fs-5 fw-semibold py-2'>Membership Form </div>
      <div class='col-md-6'>
        <label class='form-label required' for='mr_user'>Desired Username</label>
        <input type='text' class='form-control' id='mr_user' name='mr_user' value='#mMR.user()#' minlength='4' maxlength='16' required pattern='^[a-zA-Z]+[0-9A-Za-z_-]+$' title='16 Characters. Must start with a letter and can contain numbers, periods, underscores or dashes.' />
      </div>
      <div class='d-none d-md-block col-md-6'></div>
      <div class='col-12 mt-1 smaller text-secondary'>Must start with a letter and can contain numbers, periods, underscores or dashes.</div>
      <div class='col-md-6'>
        <label class='form-label required' for='mr_firstname'>First name</label>
        <input type='text' class='form-control' name='mr_firstname' id='mr_firstname' value='#mMR.firstname()#' maxlength='50' required />
      </div>
      <div class='col-md-6'>
        <label class='form-label required' for='mr_lastname'>Last name</label>
        <input type='text' class='form-control' name='mr_lastname' id='mr_lastname' value='#mMR.lastname()#' maxlength='50' required />
      </div>
      <div class='col-md-6'>
        <label class='form-label required private' for='mr_email'>Email Address</label>
        <div class='input-group'>
          <input type='email' class='form-control' name='mr_email' id='mr_email' value='#mMR.email()#' maxlength='50' required />
          <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
        </div>
      </div>
      <div class='col-md-6'>
        <label class='form-label' for='mr_phone private'>Cell Phone</label>
        <div class='input-group'>
          <input type='tel' class='form-control' name='mr_phone' id='mr_phone' value='#mMR.phone()#' maxlength='12' placeholder='123-456-7890' />
          <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
        </div>
        <small class='smaller text-secondary'>We may contact you to confirm membership information.</small>
      </div>
      <div class='col-lg-6'>
        <label class='form-label required' for='mr_location'>Location</label>
        <input type='text' class='form-control' id='mr_location' name='mr_location' value='#mMR.location()#' maxlength='100' placeholder='general location, ie New York, NY' required />
      </div>
      <div class='col-lg-6'>
        <label class='form-label' for='mr_hearabout'>How did you hear about the NMG?</label>
        <input type='text' class='form-control' name='mr_hearabout' id='mr_hearabout' value='#encodeForHTML(mMR.hearabout())#' maxlength='200' />
      </div>
      <div class='col-lg-6'>
        <label class='form-label' for='mr_website1'>Personal Website Link</label>
        <input type='text' class='form-control' id='mr_website1' name='mr_website1' value='#mMR.website1()#' maxlength='100' />
      </div>
      <div class='col-lg-6'>
        <label class='form-label' for='mr_website2'>Primary Social Media Link</label>
        <input type='text' class='form-control' id='mr_website2' name='mr_website2' value='#mMR.website2()#' maxlength='100' />
      </div>
      <div class='col-12'>
        <label class='form-label' for='mr_history'>Tell us about your experience working with neon</label>
        <textarea class='form-control' rows='6' name='mr_history' id='mr_history'>#mMR.history()#</textarea>
      </div>

      <div class='col-12 fs-5 mt-4 fw-semibold py-2'>NMG Member T-Shirt</div>

      <div class='col-12 smaller'>
        An official Neon Maker's Guild T-Shirt is included with your membership. Please provide a shipping address.
      </div>

      <div class='col-12 col-lg-6 mb-3'>
        <div class='row'>
          <div class='col-12 mb-3'>
            <label class='form-label private' for='mr_address1'>Street Address</label>
            <div class='input-group'>
              <input type='text' class='form-control' name='mr_address1' id='mr_address1' value='#encodeForHTML(mMR.address1())#' maxlength='50' />
              <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
            </div>
          </div>
          <div class='col-12 mb-3'>
            <label class='form-label private' for='mr_address2'>Apartment / Suite / Unit</label>
            <div class='input-group'>
              <input type='text' class='form-control' name='mr_address2' id='mr_address2' value='#encodeForHTML(mMR.address2())#' maxlength='25' />
              <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
            </div>
          </div>
          <div class='col-12 col-md-6 mb-3'>
            <div class='row'>
              <div class='col-12 mb-3'>
                <label class='form-label private' for='mr_city'>City</label>
                <div class='input-group'>
                  <input type='text' class='form-control' name='mr_city' id='mr_city' value='#encodeForHTML(mMR.city())#' maxlength='25' />
                  <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
                </div>
              </div>
              <div class='col-12 mb-3'>
                <label class='form-label private' for='mr_region'>State/Region Code</label>
                <div class='input-group'>
                  <input type='text' class='form-control' name='mr_region' id='mr_region' value='#encodeForHTML(mMR.region())#' maxlength='25' />
                  <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
                </div>
              </div>
              <div class='col-12 mb-3'>
                <label class='form-label private' for='mr_postal'>ZIP/Postal Code</label>
                <div class='input-group'>
                  <input type='text' class='form-control' name='mr_postal' id='mr_postal' value='#mMR.postal()#' maxlength='12' />
                  <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
                </div>
              </div>
              <div class='col-12 mb-3'>
                <label class='form-label private' for='mr_country'>Country Code</label>
                <div class='input-group'>
                  <input type='text' class='form-control' name='mr_country' id='mr_country' value='#mMR.country()#' maxlength='2' />
                  <span class='input-group-text btn-nmg-cancel' title='This information will not be made public'><i class='fa-solid fa-shield-heart'></i></span>
                </div>
              </div>
            </div>
          </div>
          <div class='col-12 col-md-6 mb-3'>
            <img src='assets/images/shirtsample.png' class='w-100' />
          </div>
        </div>
      </div>
      <div class='col-12 col-lg-6 mb-3'>
        <label class='form-label' for='mr_promo'>Select your T-Shirt Size</label>
        <select name='mr_promo' id='mr_promo' class='form-select'>
          <option>Select your size...</option>
          <cfloop list='Small (34-36),Medium (38-40),Large (42-44),X-Large (46-48),2X-Large (50-52),3X-Large (54-56)' item='size'>
            <option value='#size#' #ifin(size==mMR.promo(), 'selected')#>#size#</option>
          </cfloop>
        </select>
        <div class='smaller mt-3'>
          <p>
            T-shirts are Gildan, unisex 100% ring-spun, pre-shrunk cotton. Use the following size chart:
          </p>
          <table class='table table-sm'>
            <thead>
              <tr class='table-warning smaller'>
                <th>Size</th><th>INCHES</th><th>Chest</th><th>Sleeve length</th>
              </tr>
            </thead>
            <tr><td>Small</td><td class='font-monospace'>28</td><td class='font-monospace'>34 - 37</td><td class='font-monospace'>15 &frac34;</td></tr>
            <tr><td>Medium</td><td class='font-monospace'>29 &frac14;</td><td class='font-monospace'>38 - 41</td><td class='font-monospace'>17</td></tr>
            <tr><td>Large</td><td class='font-monospace'>30 &frac14;</td><td class='font-monospace'>42 - 45</td><td class='font-monospace'>18 &frac14;</td></tr>
            <tr><td>X-Large</td><td class='font-monospace'>31 &frac14;</td><td class='font-monospace'>46 - 49</td><td class='font-monospace'>19 &frac12;</td></tr>
            <tr><td>2X-Large</td><td class='font-monospace'>32 &frac12;</td><td class='font-monospace'>50 - 53</td><td class='font-monospace'>20 &frac34;</td></tr>
            <tr><td>3X-Large</td><td class='font-monospace'>33 &frac12;</td><td class='font-monospace'>54 - 57</td><td class='font-monospace'>22</td></tr>
            <thead>
              <tr class='table-warning smaller'>
                <th>Size</th><th>CENTIMETERS</th><th>Chest</th><th>Sleeve length</th>
              </tr>
            </thead>
            <tr><td>Small</td><td class='font-monospace'>71</td><td class='font-monospace'>86.4 - 94</td><td class='font-monospace'>40</td></tr>
            <tr><td>Medium</td><td class='font-monospace'>74.3</td><td class='font-monospace'>96.5 - 104</td><td class='font-monospace'>43.2</td></tr>
            <tr><td>Large</td><td class='font-monospace'>76.8</td><td class='font-monospace'>106.7 - 114.3</td><td class='font-monospace'>46.4</td></tr>
            <tr><td>X-Large</td><td class='font-monospace'>79.4</td><td class='font-monospace'>116.8 - 124.5</td><td class='font-monospace'>49.5</td></tr>
            <tr><td>2X-Large</td><td class='font-monospace'>82.6</td><td class='font-monospace'>127 - 134.6</td><td class='font-monospace'>52.7</td></tr>
            <tr><td>3X-Large</td><td class='font-monospace'>85</td><td class='font-monospace'>137.2 - 144.8</td><td class='font-monospace'>56</td></tr>
          </table>
        </div>
      </div>

      <div class='col-12 text-center'>
        <button type='submit' name='btnSubmit' class='btn btn-nmg g-recaptcha' data-sitekey='6LeaIakfAAAAAFfh-JbzqJOJlqyI6JlFIKbkZNjZ' data-callback='onSubmit' data-action='submit'>Send Form</button>
      </div>
    </div>
  </form>

  <div class='mt-1 smaller text-muted text-center'>
    Protected by reCAPTCHA &bull;
    <a href='https://policies.google.com/privacy' target='_blank'>Privacy</a> &bull;
    <a href='https://policies.google.com/terms' target='_blank'>Terms</a>
  </div>
</cfoutput>
