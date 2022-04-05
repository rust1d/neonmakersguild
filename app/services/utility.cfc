component {
  public struct function array_to_hash(required array rows, required string pkid) {
    return rows.reduce((data, row) => data.append({ '#row[pkid]#': row }), {});
  }

  public array function array_unique(required array arr) {
    return arr.toList('~').listRemoveDuplicates('~').listToArray('~');
  }

  public string function base64ToHex(required string data) {
    return base64ToString(data).binaryEncode('hex').lcase();
  }

  public string function base64ToString(required string data) {
    return binaryDecode(data, 'base64').toString();
  }

  public boolean function between(numeric data, numeric low, numeric high) {
    return (data >= low && data <= high);
  }

  public boolean function between_optional(string data, numeric low, numeric high) {
    if (data.len()==0) return true;
    data = val(data);
    return (data >= low && data <= high);
  }

  public string function capFirst(string data = '') {
    return data.lcase().ReReplace('\b(\w)', '\u\1', 'ALL');
  }

  public string function clean_tag(required string data) {
    return encodeForHTML(data.lcase().rereplace('[^a-z0-9]',' ','all').trim());
  }

  public string function decString(string data = '') {
    return data.len() ? Decrypt(data, application.secrets.phrase, 'CFMX_COMPAT', 'Hex') : '';
  }

  public string function digits(string data = '') {
    return data.reReplaceNoCase('[^[:digit:]]', '', 'all');
  }

  public string function encString(required string data) {
    var encoded = Encrypt(data, application.secrets.phrase, 'CFMX_COMPAT','Hex');
    return URLEncodedFormat(encoded);
  }

  public string function errorString(required any err) {
    var msg = [ err.errorCode, err.type, err.message, err.detail ];
    if (!application.isProduction && IsArray(err.tagContext)) { // ADD TEMPLATE + ERROR LINE IF NOT ON PROD
      for (var context in err.tagContext) {
        if (!context.keyExists('template') || context.template.contains('\cfusion\')) continue;
        msg.append('(' & GetFileFromPath(context.template).listfirst('.') & ':' & context.line & ')');
        break;
      }
    }
    return msg.toList(' ').trim();
  }

  public string function formatTeaser(required string data, required numeric size, string href) {
    if (data.len() < size || !data.refind('[[:space:]]')) return data;

    var more = '...';
    if (arguments.keyExists('href')) more &= ' <a href="' & href & '">[more]</a>';

    if (data.mid(size + 1, 1) == ' ') return data.left(size) & more;

    var space_at = size - data.mid(1,size).reverse().refind('[[:space:]]');
    if (space_at) return data.Left(space_at) & more;

    return left(str,1);
  }

  public string function getDomain(required string referer) {
    variables.javaurl = createObject('java', 'java.net.URL').init(javaCast('string', referer));
    return variables.javaurl.getHost().lcase().replace('www.','');
  }

  public array function groups_of(required array arr, required numeric size) {
    var groups = [[]];
    cfloop(index='idx', item='data', array=arr) {
      groups.last().append(data);
      if (idx mod size == 0 && idx!=arr.len()) groups.append([]);
    }
    return groups;
  }

  public string function hexToBase64(required string data) {
    return hexToString(data).binaryEncode('base64');
  }

  public string function hexToString(required string data) {
    return binaryDecode(data, 'hex').toString();
  }

  public string function imageToBase64(required string src) {
    var toB64 = (img) => 'data:image/*;base64,' & toBase64(imageGetBlob(img)); // CLOSURE/LAMDA
    try {
      var data = FileReadBinary(src); // WORKS WITH FILES OR URLS
      var img = ImageNew(data);
      try {
        return toB64(img); // imageGetBlob ERRORS ON webp FORMAT
      } catch (any err) { // SO RAM IT TO jpg AND TRY AGAIN
        imageWrite(img, 'ram:///temp.jpg');
        img = ImageNew('ram:///temp.jpg');
        return toB64(img);
      }
    } catch (any err) {} // STILL ERRORS, RETURN BROKEN IMAGE
    return toB64(ImageNew(application.paths.local.root & '\assets\images\broken.png'));
  }

  public string function ifin(required boolean state, string on='selected', string off='') {
    return state ? on : off;
  }

  public boolean function isAjax() output=false {
    var headers = getHttpRequestData().headers;
    return structKeyExists(headers, 'X-Requested-With') && (headers['X-Requested-With'] == 'XMLHttpRequest');
  }

  public boolean function isEmail(string data) {
    return arguments.keyExists('data') && REFindNoCase('^[A-Z0-9._%+-]+@[\w\.-]+\.[a-zA-Z]{2,32}$', data) == 1;
  }

  public boolean function isPhone(string data, boolean clean = true) {
    if (clean) data = digits(data);
    return isValid('telephone', data);
  }

  public boolean function leftMatch(string data, string part, numeric cnt) {
    if (isNull(data) || isNull(part) || isNull(cnt)) return false;
    return data.left(cnt) == part.left(cnt);
  }

  public struct function moreAfter(required array arr, required numeric limit) {
    var data = { rows: [], more: [] };
    if (arr.len()) {
      data.rows = arr.slice(1, min(arr.len(), limit));
      if (arr.len() > limit) data.more = arr.slice(limit+1);
    }
    data.has_more = data.more.len();
    return data;
  }

  public string function ordinalDate(required string data) {
    dateSuffix=["st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "st"];
    if (!isDate(data)) return data;
    strDate = data.format('mmm d') & '<sup>' & dateSuffix[data.format('d')] & '</sup>, ' & data.format('yyyy');
    return strDate;
  }

  public string function ordinalNumber(required numeric data) {
    if (int(data/10) mod 10 is 1) {
      return data & 'th';
    } else {
      switch(data MOD 10) {
        case '1':
          return data & 'st';
        break;
        case '2':
          return data & 'nd';
        break;
        case '3':
          return data & 'rd';
        break;
        default:
          return data & 'th';
        break;
      }
    }
  }

  public string function phoneFormat(string data = '', string mask = '(xxx) xxx-xxxx') {
    var phone = data.ReReplace('[^[:digit:]]', '', 'all').trim();
    var startpattern = mask.ListFirst('- ').ReReplace('[^x]', '', 'all');

    if (phone.Len() >= startpattern.Len()) {
      var idx = 1;
      var out = '';
      for (var pos in mask.reverse().listToArray('')) {
        if (pos != 'x') out &= pos;
        else out &= phone.reverse().mid(idx++, 1);
      }
      phone = out.reverse();
    }
    return phone;
  }

  public string function plural(required numeric cnt, required string data, string add = 's') {
    if (cnt==1) return data;
    return data.trim() & add;
  }

  public string function plural_label(required numeric cnt, required string data, string add = 's') {
    return cnt & ' ' & plural(cnt, data, add);
  }

  public array function preserveNulls(required query qry) {
    return deserializeJSON(serializeJSON(qry, 'struct'));
  }

  public array function query_to_array(required query qry, boolean show_all=true, numeric max_rows=50) {
    if (!qry.len()) return [];
    if (!show_all && qry.len() > max_rows) qry = qry.slice(1, max_rows);
    return qry.reduce((ary,row) => ary.append(row), []);
  }

  public struct function query_to_hash(required query qry, required string pkid) {
    return array_to_hash(query_to_array(qry), pkid);
  }

  public void function queryAppend(required query qryDst, required query qrySrc) {
    for (var row in qrySrc) queryAddRow(qryDst, row);
  }

  public query function queryStates() {
    var sproc = new StoredProc(procedure = 'states_get', datasource=application.dsn);
    sproc.addProcResult(name='qry', resultset=1);
    return sproc.execute().getProcResultSets().qry;
  }

  public boolean function safe_save(required BaseModel mModel) {
    var valid = false;
    try {
      valid = mModel.valid();
      if (valid) valid = mModel.save();
    } catch (any err) {
      valid = false;
      if (err.type != 'record_not_valid') {
        application.flash.error(application.utility.errorString(err));
      }
    }
    for (var err in mModel.errors()) application.flash.error(err);

    return valid;
  }

  public array function sample(required array data, required numeric size) {
    data = shuffle(data);
    if (data.len()<=size) return data;
    return data.slice(1, size);
  }

  public string function setRandomPassword(numeric passwordLength = '7') {
    var chars_lower = 'abcdefghjkmnpqrstuvwxyz';
    var chars_upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    var chars_number = '123456789';
    var chars_other = '!$?@';
    var chars_valid = chars_lower & chars_upper & chars_number;

    data = [];
    data.append(chars_number.mid(randRange(1, 10), 1));
    data.append(chars_upper.mid(randRange(1, 24), 1));
    data.append(chars_lower.mid(randRange(1, 24), 1));
    while (data.len() < passwordLength) data.append(chars_valid.mid(randRange(1, chars_valid.len()), 1));

    CreateObject('java', 'java.util.Collections').Shuffle(data);

    return data.toList('');
  }

  public array function shuffle(required array data) {
    CreateObject('java', 'java.util.Collections').shuffle(data);
    return arraynew(1).append(data, true); // CONVERTS BACK TO REAL JAVA ARRAY
  }

  public any function simple_cache(required string key, required any closer) {
    if (key.listLen(':')==2) {
      arguments.mins = key.listLast(':');
      arguments.key = key.listFirst(':');
    }
    param arguments.mins = 15;
    var cacheID = key & session.sessionID;
    var data = cacheGet(cacheID);
    if (!isNull(data)) return data;
    data = closer();
    cachePut(cacheID, data, createTimeSpan(0, 0, mins, 0));
    return data;
  }

  public array function slice(required array data, required numeric size) {
    if (data.len()<=size) return data;
    return data.slice(1, size);
  }

  public string function stringToBase64(required string data) {
    return binaryEncode(stringToBinary(data), 'base64');
  }

  public binary function stringToBinary(required string data) {
    return data.toBase64().toBinary();
  }

  public string function stringToHex(required string data) {
    return binaryEncode(stringToBinary(data), 'hex');
  }

  public string function url_add_protocol(required string url) {
    // ADD http:// TO URL IF MISSING
    if (isNull(arguments.url) || arguments.url.trim().isEmpty()) return;
    if (arguments.url.reMatch('^http*.').len()) return arguments.url;
    return 'http://' & arguments.url;
  }

  public struct function url_to_struct(string data) {
    param data = urlDecode(cgi.query_string);
    return data.listLast('?').listToArray('&').map(v => v.listToArray('=')).reduce((h,v) => h.append({ '#v[1]#': v[2] ?: '' }), {});
  }
}
