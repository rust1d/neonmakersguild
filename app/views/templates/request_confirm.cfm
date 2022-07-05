<cfoutput>
  <p>Hello #mMR.firstname()#!</p>
  <p>
    We have received your request to join the Neon Makers Guild. Thank you! Your application is
    being reviewed and we will get back to you shortly with an update. In the meantime, please
    <a href='#application.urls.root#/confirm?mrid=#mMR.encoded_key()#'>confirm your email by clicking this link</a>
    or copy and paste this url into your browser:
  </p>
  <p>
    #application.urls.root#/confirm?mrid=#mMR.encoded_key()#
  </p>
</cfoutput>
