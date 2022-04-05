<cfscript>
  if (session.user.isA('User')) {
    if (form.keyExists('uiid')) {
      mImage = new app.models.UserImages().find(form.uiid);
      if (mImage.usid()!=session.user.usid()) { // DOES NOT OWN THIS RECORD
        throw('Record not found.', 'record_not_found');
      }
      mImage.destroy(); // HANDLES S3 DELETE
      request.xhr_data = { 'uiid': form.uiid };
    } else if (form.keyExists('delete')) {
      session.user.profile_image().destroy();
      request.xhr_data = { 'profile_image': session.user.profile_image().src() };
    }
  }
</cfscript>
