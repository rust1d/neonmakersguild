<cfscript>
  if (session.user.isA('Users')) {
    if (form.keyExists('profile_image')) {
      rtn = {};
      // NO LONGER SAVING AS USERIMAGE
      // if (form.keyExists('ui_filename')) { // SAVE ORIGINAL
      //   form.ui_usid = session.user.usid();
      //   form.ui_type = 'profile';
      //   mImage = new app.models.UserImages(form);
      //   if (!mImage.safe_save()) {
      //     flash.error('An error occurred while uploading. Please try again or contact #session.site.mailto_site()#.');
      //   } else {
      //     rtn = mImage.toStruct();
      //     rtn['thumbnail'] = mImage.thumbnail_src();
      //     rtn['image'] = mImage.image_src();
      //   }
      // }
      if (session.user.profile_image().set()) {
        rtn['thumbnail'] = session.user.profile_image().src();
        request.xhr_data = rtn;
        flash.success('Your profile image was uploaded.');
      }
    } else if (form.keyExists('thumbnail') && form.keyExists('uiid')) {
      uiid = utility.decode(form.uiid);
      if (uiid) {
        mImage = locals.mBlog.image_find_or_create(uiid);
        request.xhr_data = mImage.thumbnail_update();
        flash.success('Your thumbnail was updated.');
      }
    }
  }
</cfscript>
