<cfscript>
  if (form.keyExists('btnSkip')) {
    if (mUser.grace_period_remaining()) session.user.store('skip_renew', 1);
    router.redirect('user/home');
  }
</cfscript>

<cfoutput>
  <div class='row g-3 justify-content-center'>
    <div class='col-12 col-lg-10'>
      <div class='card border-0 shadow-sm'>
        <div class='card-header bg-nmg-dark p-3 d-flex align-items-center gap-3'>
          <img src='#mUser.profile_image().src()#' class='avatar-circle' style='width:64px;min-width:64px' />
          <div>
            <div class='fs-4 text-marker text-white'>#mUser.user()#</div>
            <div class='text-white-50 small'>
              #mUser.UserProfile().name()#
              <cfif mUser.UserProfile().location().len()> &bull; #mUser.UserProfile().location()#</cfif>
              &bull; Member since #utility.ordinalDate(mUser.added())#
            </div>
          </div>
        </div>
        <div class='card-body p-4'>
          <form method='post'>
            <div class='fs-4 text-marker mb-3'>
              Your membership has expired
            </div>
            <p>
              Membership to the Neon Makers Guild is $50 a year.
              Please click the button below to make a payment through Paypal and restore full access to your member section.
              To speed up processing, include your username <code>#mUser.user()#</code> in the "What's this for" box.
              Once processed, we'll send out your NMG bumpersticker as a thank you for your support.
            </p>
            <hr>
            <div class='d-flex flex-wrap align-items-center gap-3'>
              <a href='#application.urls.paypalme#' class='btn btn-nmg btn-lg rounded-pill px-4 neon-glow' target='_blank' title='#utility.plural_label(mUser.past_due_days(), 'day')# past due'>
                <i class='fa-solid fa-credit-card me-2'></i>Make Payment
              </a>
              <cfif mUser.grace_period_remaining()>
                <button class='btn btn-outline-nmg rounded-pill px-3' name='btnSkip' type='submit'>
                  Skip for now (#utility.plural_label(mUser.grace_period_remaining(), 'day')# remaining)
                </button>
              </cfif>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
