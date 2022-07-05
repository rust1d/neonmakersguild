<cfscript>
  if (router.decode('mrid')) {
    mrid = router.decode('mrid');
    if (mrid==0) router.redirect();
    mMR = new app.models.MemberRequests().find(mrid);
    validated = mMR.validate_email();
  }
  param validated = false;
</cfscript>

<cfoutput>
  <cfif validated>
    <p>Thank you for validating your email.</p>
  <cfelse>
    <p>If trees could scream, would we be so cavalier about cutting them down?</p>
    <p>We might, if they screamed all the time, for no good reason.</p>
  </cfif>
</cfoutput>