<cfscript>
  if (form.keyExists('G-RECAPTCHA-RESPONSE')) {
    try {
      service = new http(method: 'post', url: ' https://www.google.com/recaptcha/api/siteverify');
      service.addParam(type: 'url', name: 'secret', value: '6LeaIakfAAAAALk0-X9XpTdt3rbnuE8Nt9ydcbxl');
      service.addParam(type: 'url', name: 'response', value: form['G-RECAPTCHA-RESPONSE']);
      result = service.send().getPrefix();
      response = deserializeJSON(result.fileContent);
      if (response.success) {
        subject = 'Membership Form';
        if (response.score lt 0.5) {
          subject = 'SPAM LIKELY: ' & subject;
          form['G-RECAPTCHA-RESPONSE'] = 'Spam likely: ' & response.score;
          flash.warning('Thanks Robot! Beep boop to you too.');
        } else {
          form['G-RECAPTCHA-RESPONSE'] = 'Success: ' & response.score;
          flash.success('Thanks #form.mf_firstname#! You should hear back from us soon.');
        }
        sendto = [ application.email.admin, 'membership@neonmakersguild.org' ];
        new app.services.email.AdminEmailer(to: sendto.toList(), subject: subject).send_form();
        router.go('/about');
      }
    } catch (any err) {
      writeDump(err);
    }
  }
</cfscript>

<script>
  function onSubmit(token) {
    document.getElementById('membership-form').submit();
  }
</script>

<cfoutput>
  <div class='card '>
    <form method='post' id='membership-form'>
      <h5 class='card-header'>Membership Form</h5>
      <div class='card-body'>
        <div class='row g-3'>
          <div class='col-md-6'>
            <label class='form-label required' for='mf_firstname'>First name</label>
            <input type='text' class='form-control' name='mf_firstname' id='mf_firstname' value='#form.get('mf_firstname')#' maxlength='50'  required />
          </div>
          <div class='col-md-6'>
            <label class='form-label required' for='mf_lastname'>Last name</label>
            <input type='text' class='form-control' name='mf_lastname' id='mf_lastname' value='#form.get('mf_lastname')#' maxlength='50'  required />
          </div>
          <div class='col-md-6'>
            <label class='form-label required' for='mf_email'>Email Address</label>
            <input type='email' class='form-control' name='mf_email' id='mf_email' value='#form.get('mf_email')#' maxlength='50' required />
          </div>
          <div class='col-md-6'>
            <label class='form-label required' for='mf_location'>Location</label>
            <input type='text' class='form-control' id='mf_location' name='mf_location' value='#form.get('mf_location')#' maxlength='100' required />
          </div>
          <div class='col-md-12 mb-3'>
            <label class='form-label' for='mf_history'>Your experience working with neon</label>
            <textarea class='form-control' rows='6' name='mf_history' id='mf_history'>#form.get('mf_history')#</textarea>
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
</cfoutput>
