<cfscript>
  if (form.keyExists('uiid')) {
    mImage = new app.models.UserImages().find(utility.decode(form.uiid));
    if (mImage.usid()!=session.user.usid()) { // DOES NOT OWN THIS RECORD
      throw('Record not found.', 'record_not_found');
    }
    src = mImage.image_src64();
  } else {
    src = utility.imageToBase64(application.paths.images & 'profile_placeholder.png')
  }
  request.xhr_data = src;
</cfscript>
