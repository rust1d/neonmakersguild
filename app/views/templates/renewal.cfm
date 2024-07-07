<cfoutput>
  <p>Hello #mUser.UserProfile().firstname()#</p>
  <p>
    <cfif mUser.past_due_days() GT 0>
      Your membership to the Neon Makers Guild has expired.
    <cfelse>
      Your membership to the Neon Makers Guild will expire in #application.utility.plural_label(-mUser.past_due_days(), 'day')#.
    </cfif>
    Your $50/year ($4.17/month) membership fee helps to support the Neon Makers Guild in providing access
    to digitized rare and hard to find info, supporting a safe sharing space and forum for discussions,
    and the continuation of in-person meet ups and zoom happy hours. Please visit the Paypal link
    below to continue supporting this unique community space.
  </p>
  <p>
    Paypal link: <a href='#application.urls.paypalme#'>#application.urls.paypalme#</a>
  </p>
  <p>
    Once your payment is processed, you will get an email with a confirmation. As a thank you gift, you will
    recieve a Neon Makers Guild bumper sticker.
  </p>
</cfoutput>
