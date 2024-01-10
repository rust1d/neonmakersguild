<cfscript>
  if (form.keyExists('btnSkip')) {
    if (mUser.grace_period_remaining()) session.user.store('skip_renew', 1);
    router.redirect('user/home');
  }
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12'>
      <div class='card'>
        <div class='card-body'>
          <div class='row'>
            <div class='col-3'>
              <img class='img-thumbnail' src='#mUser.profile_image().src()#' />
            </div>
            <div class='col-9 position-relative'>
              <div class='fs-3'>#mUser.user()#</div>
              <div>
                <cfif mUser.usid() LT 8><span class='badge bg-secondary'>Founder</span></cfif>
                <cfif mUser.permissions() GT 0><span class='badge bg-secondary'>Admin</span></cfif>
              </div>
              <div>#mUser.UserProfile().name()#</div>
              <div>#mUser.UserProfile().location()#</div>
              <div class='mt-1 small'>Member since #utility.ordinalDate(mUser.added())#</div>
              <form method='post'>
                <div class='fs-3 my-3'>
                  Your membership to the Neon Makers Guild has expired. Membership to the Neon Makers Guild is $50 a year.
                </div>
                <p>
                  Please click the button below to make a payment through Paypal and restore full access to your member section.
                  To speed up processing, include your username <code>#mUser.user()#</code> in the "What's this for" box.
                  Once processed, we'll send out your NMG bumpersticker as a thank you for your support.
                </p>
                <hr>
                <a href='#application.urls.paypalme#' class='btn btn-nmg mr-3' target='_blank' title='#utility.plural_label(mUser.past_due_days(), 'day')# past due'>Make Payment</a>
                <cfif mUser.grace_period_remaining()>
                  <button class='btn btn-cancel' name='btnSkip' type='submit'>
                    Or skip this for now
                    (#utility.plural_label(mUser.grace_period_remaining(), 'day')# remaining)
                  </button>
                </cfif>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
