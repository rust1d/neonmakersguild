<cfscript>
  struct function json_content() {
    return DeserializeJSON(getHTTPRequestData().content);
  }

  if (session.user.isA('Users')) {
    data = json_content();
    if (data.term.len()>=2) {
      mImages = mBlog.images(term: data.term, maxrows: 20);
      options = [];
      for (mImage in mImages) {
        options.append({
          'filename': mImage.filename(),
          'image': mImage.image_src(),
          'thumbnail': mImage.thumbnail_src(),
          'dimensions': mImage.dimensions()
         });
      }
      request.xhr_data = options;
    }
  }
</cfscript>
