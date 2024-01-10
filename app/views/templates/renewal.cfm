<cfoutput>
  <p>Hello #mUser.UserProfile().firstname()#</p>
  <p>
    <cfif mUser.past_due_days() GT 0>
      Your membership to the Neon Makers Guild has expired.
    <cfelse>
      Your membership to the Neon Makers Guild will expire in #application.utility.plural_label(-mUser.past_due_days(), 'day')#.
    </cfif>
    Membership to the Neon Makers Guild is $50 a year.
    Please visit the Paypal link below to make a payment.
  </p>
  <p>
    Paypal link: <a href='#application.urls.paypalme#'>#application.urls.paypalme#</a>
  </p>
  <p>Once your payment is processed, you will get an email with a confirmation.</p>
</cfoutput>
