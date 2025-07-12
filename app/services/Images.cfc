component {
  variables.utility = request.utility;

  remote struct function bei(string p='') returnFormat='json' {
    try {
      var data = json_content();
      var response = utility.api_response();
      response.data['request'] = data;

      data.bei_beiid = request.router.decode('beiid', data);

      if (data.bei_beiid) {
        response.data['content'] = request.router.generate('shared/blog/_modal_image', data);
      } else {
        response.success = false;
      }
      return response;
    } catch (any err) {
      return utility.api_response(err);
    }
  }

  remote struct function ben(string p='') returnFormat='json' {
    try {
      var data = json_content();
      var response = utility.api_response();
      response.data['request'] = data;

      data.ben_benid = request.router.decode('benid', data);

      if (data.ben_benid) {
        response.data['content'] = request.router.generate('shared/blog/_modal_post', data);
      } else {
        response.success = false;
      }
      return response;
    } catch (any err) {
      return utility.api_response(err);
    }
  }

  remote struct function comment(string p='', string images) returnFormat='json' { // p = JSON STRING
    try {
      var data = json_content(form.p);
      var response = utility.api_response();
      add_comment(data, response);
      return response;
    } catch (any err) {
      x =  utility.api_response(err);
      x.data['err'] = err;
      return x;
    }
  }

  remote struct function read(string p='') returnFormat='json' {
    try {
      var data = json_content();
      var response = new_response();
      response.data['img'] = read_img(data.src);
      response.data['name'] = getFileFromPath(data.src);
      return response;
    } catch (any err) {
      return error_response(err);
    }
  }

  public string function read_img(required string src) {
    cfhttp(url: arguments.src, method: 'GET', result: 'imgResult', throwOnError: true, charset: 'utf-8', getAsBinary: true);
    if (!isBinary(imgResult.Filecontent)) {
      throw(type: 'InvalidImage', message: 'Invalid Filecontent.');
    }
    if (!imgResult.MimeType.contains('image')) {
      throw(type: 'InvalidImage', message: 'Invalid MimeType.');
    }
    var mimetype = 'image/jpeg';
    if (imgResult.MimeType.contains('image')) mimetype = imgResult.MimeType;
    return 'data:#mimetype#;base64,' & toBase64(imgResult.Filecontent);
  }

  // PRIVATE

  private void function add_comment(required struct data, required struct response) {
    response.success = false;
    response.data['comment'] = true;
    response.data['request'] = data;
    param data.comment = '';
    // GUARD
    if (!session.user.loggedIn()) return;
    if (data.comment.trim().len()==0) return;

    var benid = request.router.decode('benid', data);
    if (benid==0) return;

    var beiid = 0;

    if (data.keyExists('beiid')) {
      beiid = request.router.decode('beiid', data);
      if (beiid==0) return; // IF PASSED IT BETTER EXIST
      var mBEI = new app.models.BlogEntryImages().find(beiid);
      if (mBEI.benid()!=benid) return; // AND IT BETTER BELONG TO THE BE
      var mBE = mBEI.BlogEntry();
      if (mBE.image_cnt()==1) beiid = 0; // SINGLE IMAGE POST COMMENT IS ON ENTRY NOT IMAGE
    } else {
      var mBE = new app.models.BlogEntries().find(benid);
    }

    response.data['counter'] = beiid ? data.beiid : data.benid; // COUNTER ID IS ENCODED KEY OF PARENT

    var mComment = new app.models.BlogComments({
      bco_benid:   benid,
      bco_beiid:   beiid,
      bco_comment: data.comment,
      bco_blog:    mBE.blog(),
      bco_usid:    session.user.usid()
    });

    response.success = mComment.safe_save();
    if (response.success) {
      add_comment_images(mComment, data, response)
      response.data['content'] = request.router.generate('shared/blog/_comment', { mComment: mComment });
    } else {
      response.errors = mComment.errors();
    }
  }

  private void function add_comment_images(required BlogComments mComment, required struct data, struct response) {
    if (!form.keyExists('images')) return;

    response.data['images'] = form.images;

    var params = {
      ci_bcoid:   mComment.bcoid(),
      ci_benid:   mComment.benid(),
      ci_beiid:   mComment.beiid(),
      ci_usid:    mComment.usid(),
      filefield:  'tmp_file'
    }
    for (form.tmp_file in form.images) { // LIST OF ALREADY UPLOADED IMAGES
      params.ci_filename = arguments.data.filenames.shift();
      mComment.CommentImages(build: params).safe_save();
    }
  }

  private struct function error_response(required any err) {
    var response = new_response();
    response.success = false;
    response.errors.append(application.utility.errorString(err));
    return response;
  }

  private struct function json_content(string content) {
    try {
      param arguments.content = getHTTPRequestData().content;
      return DeserializeJSON(arguments.content);
    } catch (any err) {
      throw(message: 'Bad Request', detail: 'JSON is invalid', errorCode: 400, extendedinfo: err.detail);
    }
  }

  private struct function new_response() {
    return { 'success': true, 'errors': [], 'data': {} };
  }
}
