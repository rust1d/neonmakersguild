<cfscript>
  if (session.user.isA('User')) {
    if (form.keyExists('profile_image')) {
      rtn = {};
      if (form.keyExists('ui_filename')) { // SAVE ORIGINAL
        form.ui_usid = session.user.usid();
        form.ui_type = 'profile';
        mImage = new app.models.UserImages(form);
        if (!mImage.safe_save()) {
          flash.error('An error occurred while uploading. Please try again or contact us at #session.site.mailto_site()#.');
        } else {
          rtn = mImage.toStruct();
          rtn['thumbnail'] = mImage.thumbnail_src();
          rtn['image'] = mImage.image_src();
        }
      }
     if (session.user.profile_image().set()) {
       rtn['profile_image'] = session.user.profile_image().src();
       request.xhr_data = rtn;
       flash.success('Your profile image was uploaded.');
     }
    }
  }
</cfscript>
