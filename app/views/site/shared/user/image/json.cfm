<cfscript>
  array function blog_images() {
    var options = [];
    if (session.user.isA('Users')) {
      var data = utility.json_content();
      var usid = utility.decode('usid', data);
      var mBlog = new app.services.user.Blog(usid ? usid : 1);
      if (data.term.len()>=2) {
        var mImages = mBlog.images(term: data.term, maxrows: 20);
        for (var mImage in mImages) {
          options.append({
            'filename': mImage.filename(),
            'image': mImage.image_src(),
            'thumbnail': mImage.thumbnail_src(),
            'dimensions': mImage.dimensions()
          });
        }
      }
    }
    return options;
  }

  request.xhr_data = blog_images();
</cfscript>
