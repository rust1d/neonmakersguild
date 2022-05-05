<cfscript>
  array function blog_images() {
    var options = [];
    if (session.user.isA('Users')) {
      var data = utility.json_content();
      var usid = utility.decode(data.usid);
      var mBlog = new app.services.user.Blog(usid ? usid : 1);
      if (data.term.len()>=2) {
        var mImages = mBlog.images(term: data.term, maxrows: 20).rows;
        for (var mImage in mImages) {
          options.append({
            'usid': data,
            'filename': mImage.filename(),
            'image': mImage.image_src(),
            'thumbnail': mImage.thumbnail_src(),
            'dimensions': mImage.dimensions(),
            'ratio': mImage.ratio()
          });
        }
      }
    }
    return options;
  }

  request.xhr_data = blog_images();
</cfscript>
