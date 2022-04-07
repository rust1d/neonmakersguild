<cfscript>
  src = application.paths.root & '\assets\images\profile_placeholder.png';
  if (form.keyExists('uiid')) {
    mImage = new app.models.UserImages().find(form.uiid);
    if (mImage.usid()!=session.user.usid()) { // DOES NOT OWN THIS RECORD
      throw('Record not found.', 'record_not_found');
    }
    src = mImage.image_src();
  }
  request.xhr_data = utility.imageToBase64(src);
</cfscript>
