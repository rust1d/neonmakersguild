component {
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

  private struct function error_response(required any err) {
    var response = new_response();
    response.success = false;
    response.errors.append(application.utility.errorString(err));
    return response;
  }

  private struct function json_content() {
    try {
      return DeserializeJSON(getHTTPRequestData().content);
    } catch (any err) {
      throw(message: 'Bad Request', detail: 'JSON is invalid', errorCode: 400, extendedinfo: err.detail);
    }
  }

  private struct function new_response() {
    return { 'success': true, 'errors': [], 'data': {} };
  }
}
