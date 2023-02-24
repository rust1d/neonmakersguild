<cfscript>
  usid = router.decode('usid');
  if (usid==0) router.redirect();

  mUser = new app.models.Users().find(usid);
  mSubscriptions = new app.models.Subscriptions().where(ss_usid: usid);

  if (form.keyExists('btnSubmit')) {
    param form.ssid = '';
    cnt = 0;
    for (mSubscription in mSubscriptions) {
      if (form.ssid.listFind(mSubscription.ssid())) {
        mSubscription.destroy();
        flash.success('deleted `#mSubscription.model().class()# - #mSubscription.model().subject()#`');
        cnt++;
      }
    }
    if (cnt) {
      msg = application.utility.plural_label(cnt, 'subscription');
      flash.success('Deleted #msg#.');
      mSubscriptions = new app.models.Subscriptions().where(ss_usid: usid);
    }
  }
</cfscript>

<cfoutput>
  <cfif mSubscriptions.isEmpty()>
    <p>You have no active subscriptions.</p>
  <cfelse>
    <form method='post'>
      <p>Select the subscriptions to delete:</p>
      <cfloop array='#mSubscriptions#' item='mSubscription'>
        <div class='input-group mb-3'>
          <div class='input-group-text'>
            <input class='form-check-input mt-0' type='checkbox' id='ssid_#mSubscription.ssid()#' name='ssid' value='#mSubscription.ssid()#'>
          </div>
           <div class='input-group-text w-75'>
            <label for='ssid_#mSubscription.ssid()#'>#mSubscription.model().class()# - #mSubscription.model().subject()#</label>
          </div>
          <div class='input-group-text'>
            <a href='#mSubscription.model().seo_link()#' target='_blank'><i class='fa fad fa-external-link'></i></a>
          </div>
        </div>
      </cfloop>
      <div class='row mt-5'>
        <div class='col text-center'>
          <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Unsubscribe</button>
          <a href='#router.href()#' class='btn btn-nmg-cancel'>Cancel</a>
        </div>
      </div>
    </form>
  </cfif>
</cfoutput>
