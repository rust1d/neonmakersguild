<cfscript>
  if (form.keyExists('uiid')) {
    mImage = new app.models.UserImages().find(utility.decode(form.uiid));
    if (session.user.get_admin() || session.user.usid()==mImage.usid()) {
      src = mImage.image_src64();
    } else { // DOES NOT OWN THIS RECORD
      src = utility.imageToBase64(application.paths.images & 'profile_placeholder.png')
      // throw('Record not found.', 'record_not_found');
    }
  } else {
    src = utility.imageToBase64(application.paths.images & 'profile_placeholder.png')
  }
  request.xhr_data = src;
</cfscript>
