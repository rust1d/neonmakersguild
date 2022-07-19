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
          sendto = [ application.email.admin, 'membership@neonmakersguild.org' ];
          new app.services.email.AdminEmailer(to: sendto.toList(), subject: subject).send_form();
          router.go('/about');
        } else {
          if (mMR.safe_save()) {
            form['G-RECAPTCHA-RESPONSE'] = 'Success: ' & response.score;
            flash.success('Thanks #form.mr_firstname#! We will be in touch soon. Please add `support@neonmakersguild.org` to your email whitelist while you wait.');
            sendto = [ application.email.admin, 'membership@neonmakersguild.org' ];
            new app.services.email.AdminEmailer(to: sendto.toList(), subject: subject).send_form();
            new app.services.email.MemberRequestEmailer().SendConfirmation(mMR);
            router.go('/about');
          }
        }
      }
    } catch (any err) {
      flash.error(utility.errorString(err));
    }
  }
</cfscript>

<script>
  function onSubmit(token) {
    var frm = document.getElementById('membership-form')
    if (frm.reportValidity()) frm.submit();
  }
  $(function() {
    $('#legal').append('')
  })
</script>

<cfoutput>
  <div class='card '>
    <form method='post' id='membership-form'>
      <h5 class='card-header'>Membership Form</h5>
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
            <input type='text' class='form-control' id='mr_user' name='mr_user' value='#mMR.user()#' minlength='4' maxlength='16' required pattern='^[a-zA-Z]+[0-9A-Za-z_-]+$' title='16 Characters. Must start with a letter and can contain numbers, periods, underscores or dashes.' />
            <small class='smaller text-secondary'>Must start with a letter and can contain numbers, periods, underscores or dashes.</small>
          </div>
          <div class='col-md-12'>
            <label class='form-label required' for='mr_location'>Location (City/Region)</label>
            <input type='text' class='form-control' id='mr_location' name='mr_location' value='#mMR.location()#' maxlength='100' required />
          </div>
          <div class='col-md-6'>
            <label class='form-label' for='mr_phone'>Cell Phone</label>
            <input type='tel' class='form-control' name='mr_phone' id='mr_phone' value='#mMR.phone()#' maxlength='12' placeholder='123-456-7890' />
            <small class='smaller text-secondary'>We may call or text you to confirm membership information.</small>
          </div>
          <div class='col-md-6'>
            <label class='form-label' for='mr_promo'>T-Shirt Size</label>
            <select name='mr_promo' id='mr_promo' class='form-control'>
              <option>Not Provided</option>
              <cfloop list='Small (34-36),Medium (38-40),Large (42-44),X-Large (46-48),2X-Large (50-52),3X-Large (54-56)' item='size'>
                <option value='#size#' #ifin(size==mMR.promo(), 'selected')#>#size#</option>
              </cfloop>
            </select>
            <small class='smaller text-secondary'>US sizing.</small>
          </div>
          <div class='col-md-6'>
            <label class='form-label' for='mr_website1'>Personal Website Link</label>
            <input type='text' class='form-control' id='mr_website1' name='mr_website1' value='#mMR.website1()#' maxlength='100' />
          </div>
          <div class='col-md-6'>
            <label class='form-label' for='mr_website2'>Primary Social Media Link</label>
            <input type='text' class='form-control' id='mr_website2' name='mr_website2' value='#mMR.website2()#' maxlength='100' />
          </div>
          <div class='col-md-12 mb-3'>
            <label class='form-label' for='mr_history'>Tell us about your experience working with neon</label>
            <textarea class='form-control' rows='6' name='mr_history' id='mr_history'>#mMR.history()#</textarea>
          </div>
          <div class='col-12'>
            <div class='text-center'>
              <button type='submit' name='btnSubmit' class='btn btn-nmg g-recaptcha' data-sitekey='6LeaIakfAAAAAFfh-JbzqJOJlqyI6JlFIKbkZNjZ' data-callback='onSubmit' data-action='submit'>Send Form</button>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
  <div class='mt-1 smaller muted text-center'>
    Protected by reCAPTCHA &bull;
    <a href='https://policies.google.com/privacy' target='_blank'>Privacy</a> &bull;
    <a href='https://policies.google.com/terms' target='_blank'>Terms</a>
  </div>
</cfoutput>
