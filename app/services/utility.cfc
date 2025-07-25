component {
  public string function age_format(required date since) {
    var span = '<span alt="#arguments.since.format('yyyy-mm-dd HH:nn:ss')#">';
    var diff = now().diff('d', arguments.since);
    if (diff > 60) return span & arguments.since.format('MMM, dd') & '</span>';
    diff = now().diff('h', arguments.since);
    if (diff > 1) return span & diff & 'h</span>';
    diff = now().diff('n', arguments.since);
    return span & diff & 'm</span>';
  }

  public numeric function age_in_days(date since = '1899-01-01') {
    return now().diff('d', since);
  }

  public struct function api_response(any error) {
    var data = { 'success': true, 'errors': [], 'data': {} }
    if (!isNull(arguments.error)) {
      data.success = false;
      data.errors.append(errorString(error));
    }
    arguments.delete('error');
    data.data = arguments;
    return data;
  }

  public struct function array_to_hash(required array rows, required string pkid) {
    return rows.reduce((data, row) => data.append({ '#row[pkid]#': row }), StructNew('ordered'));
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

  public string function body_cdn(string data='') {
    return data.replaceNoCase('"/assets/images/', '"#application.urls.cdn#/assets/images/');
  }

  public string function body_nocdn(string data='') {
    return data.ReplaceNoCase('#application.urls.cdn#/assets/images', '/assets/images');
  }

  public boolean function bool(boolean data=false) {
    return data ? true : false;
  }

  public string function capFirst(string data = '') {
    return data.lcase().ReReplace('\b(\w)', '\u\1', 'ALL');
  }

  public string function clean_tag(required string data) {
    return encodeForHTML(data.lcase().rereplace('[^a-z0-9]',' ','all').trim());
  }

  public numeric function compression(required numeric height, required numeric width, required numeric size) {
    var ratio = arguments.size / (arguments.height * arguments.width * 3);
    if (ratio > 0.8) return .70;
    if (ratio > 0.6) return .75;
    if (ratio > 0.5) return .80;
    if (ratio > 0.4) return .85;
    if (ratio > 0.3) return .90;
    return .95;
  }

  public numeric function days_passed(required date data) {
    return now().diff('d', data);
  }

  public string function decode(string data = '') {
    if (data.len()==0 || (data.len() MOD 2)!=0) return 0;
    var chrs = len(data) / 2;
    var id = Decrypt(data.left(chrs), application.secrets.phrase, 'CFMX_COMPAT', 'Hex');
    if (data.right(chrs)==left(hashCC(id) & data, chrs)) return id;
    return 0;
  }

  public string function digits(string data = '') {
    return data.reReplaceNoCase('[^[:digit:]]', '', 'all');
  }

  public string function encode(required string data) {
    var enc = Encrypt(data, application.secrets.phrase, 'CFMX_COMPAT', 'Hex');
    var hsh = left(hashCC(data) & enc, len(enc));
    return lcase('#enc##hsh#');
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

  public boolean function fileCopyS3(required string filename, required string remote) {
    try {
      var params = {
        'srcFile' : filename,
        'key' : remote.replace(application.s3.bucket & '/', '')
      }
      var result = request.s3Service.bucket('neonmg').uploadFile(params);
      return result.get('status')=='success';
    } catch (any err) {
      application.flash.cferror(err);
      return false;
    }
  }

  public boolean function fileDeleteS3(required string remote) {
    try {
      var params = {
        'key' : remote.replace(application.s3.bucket & '/', '')
      }
      var result = request.s3Service.bucket('neonmg').delete(params);
      return result.get('status')=='success';
    } catch (any err) {
      application.flash.cferror(err);
      return false;
    }
  }

  public string function formatTeaser(required string data, required numeric size, string href) {
    if (data.len() < size || !data.refind('[[:space:]]')) return data;

    var more = '...';
    if (arguments.keyExists('href')) more &= ' <a href="' & href & '">[more]</a>';

    if (data.mid(size + 1, 1)==' ') return data.left(size) & more;

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
      if (idx mod size==0 && idx!=arr.len()) groups.append([]);
    }
    return groups;
  }

  public string function hashCC(required string data) {
    return hash(arguments.data, 'CFMX_COMPAT', 'Base64');
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
    } catch (any err) { } // STILL ERRORS, RETURN BROKEN IMAGE
    return toB64(ImageNew(application.paths.root & '\assets\images\image_new.png'));
  }

  public string function ifin(required boolean state, string on='selected', string off='') {
    return state ? on : off;
  }

  public boolean function isAjax() output=false {
    var headers = getHttpRequestData().headers;
    return structKeyExists(headers, 'X-Requested-With') && (headers['X-Requested-With']=='XMLHttpRequest');
  }

  public boolean function isEmail(string data) {
    return arguments.keyExists('data') && REFindNoCase('^[A-Z0-9._%+-]+@[\w\.-]+\.[a-zA-Z]{2,32}$', data)==1;
  }

  public boolean function isPhone(string data, boolean clean = true) {
    if (clean) data = digits(data);
    return isValid('telephone', data);
  }

  public boolean function isPost() {
    return bool(cgi.request_method=='post');
  }

  public struct function json_content() {
    return DeserializeJSON(getHTTPRequestData().content);
  }

  public boolean function leftMatch(string data, string part, numeric cnt) {
    if (isNull(data) || isNull(part) || isNull(cnt)) return false;
    return data.left(cnt)==part.left(cnt);
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

  public string function nodomain(required string link) {
    return link.replace(application.urls.root, '');
  }

  public string function ordinalDate(required string data) {
    if (!isDate(data)) return data;
    var suff = listToArray('st,nd,rd,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,st,nd,rd,th,th,th,th,th,th,th,st');
    return "#data.format('mmm d')##suff[day(data)]# #data.format('yyyy')#";
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

  public any function orient_image(required any img) {
    try {
      var orientation = ImageGetEXIFTag(img, 'orientation') ?: 0;
      if (ListFind('2', orientation))     ImageFlip(arguments.img, 'horizontal');
      if (ListFind('4,5,7', orientation)) ImageFlip(arguments.img, 'vertical');
      if (ListFind('3', orientation))   ImageRotate(arguments.img, 180);
      if (ListFind('6,7', orientation)) ImageRotate(arguments.img, 90);
      if (ListFind('5,8', orientation)) ImageRotate(arguments.img, 270);
    } catch (any err) { }
    return arguments.img;
  }

  public struct function original_url(string href) {
    var data = arguments.get('href') ?: getHttpRequestData().headers.get('X-Original-URL') ?: request.router.url();
    return {
      'href': application.urls.root & '/' & data.listFirst('?').listToArray('/').toList('/'),
      'params': url_to_struct(data)
    }
  }

  public struct function paged_term_params(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.append(params);

    var term = url.get('term') ?: form.get('term') ?: '';
    var page = url.get('page') ?: 1;
    var args = { maxrows: form.get('maxrows') ?: 25 }
    args.append(arguments);
    if (len(term)) args.term = term;
    if (!form.keyExists('term') && page > 1) args.page = page;
    return args;
  }

  public string function page_url_next(struct pagination = {}) {
    var data = original_url(pagination.get('next_href'));
    if (pagination.term.len()) data.params['term'] = pagination.term;
    data.params['page'] = pagination.next;
    return data.href.listAppend(struct_to_url(data.params), '?', false);
  }

  public string function page_url_prev(struct pagination = {}) {
    var data = original_url(pagination.get('prev_href'));
    if (pagination.term.len()) data.params['term'] = pagination.term;
    if (pagination.page>2) {
      data.params['page'] = pagination.prev;
    } else {
      data.params.delete('page'); // canonical page 1
    }
    return data.href.listAppend(struct_to_url(data.params), '?', false);
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

  public string function recentDate(required string data, numeric past_days=5) {
    if (!isDate(data)) return data;
    var suff = listToArray('st,nd,rd,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,st,nd,rd,th,th,th,th,th,th,th,st')[day(data)];
    var mmmd = data.format('mmm d') & suff;
    if (days_passed(data) <= past_days) {
      return mmmd & data.format(' HH:nn');
    }
    return mmmd & data.format(' yy');
  }

  public boolean function safe_save(required BaseModel mModel) {
    var valid = false;
    try {
      valid = mModel.valid();
      if (valid) valid = mModel.save();
    } catch (any err) {
      valid = false;
      if (err.type != 'record_not_valid') {
        application.flash.cferror(err);
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

  public any function simple_cache(required string key, required any closer, boolean global=false) { // GLOBAL DETERMINES SCOPE: APP OR SESSION
    if (application.isDevelopment) return arguments.closer(); // NOT USED ON DEV

    if (arguments.key.listLen(':')==2) {
      arguments.mins = arguments.key.listLast(':');
      arguments.key = arguments.key.listFirst(':');
    }
    param arguments.mins = 15;
    var cacheID = (arguments.global ? application.applicationname : session.sessionID) & arguments.key;
    var data = cacheGet(cacheID);
    if (!isNull(data)) return data;

    data = arguments.closer();
    cachePut(cacheID, data, createTimeSpan(0, 0, arguments.mins, 0));
    return data;
  }


  public array function slice(required array data, required numeric size) {
    if (data.len()<=size) return data;
    return data.slice(1, size);
  }

  public string function slug(string data = 'slug') {
    data = replace(data.lcase(), '&amp;', '-', 'all');
    data = reReplace(data, '&[^;]+;', '-', 'all');
    data = reReplace(data,'[^_0-9a-zA-Z- ]','-','all');
    data = replace(data,' ','-','all');
    return data.listToArray('-').toList('-');
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

  public string function struct_to_url(required struct data) {
    var qry = [];
    for (var key in data.keyList()) qry.append('#key#=#data[key]#');
    return qry.toList('&');
  }

  public string function updatable_counter(required numeric cnt, required string id, string label='comment') {
    return '
    <span title="Comments">
      <span data-id="#arguments.id#" data-cnt="#arguments.cnt#">#arguments.cnt#</span>
      #arguments.label#
    </span>';
  }

  public string function url_add_protocol(string data = '') {
    if (data.trim().isEmpty()) return '';
    if (data.reMatch('^http*.').len()) return data;
    var proto = (cgi.https=='on') ? 'https' : 'http';
    return '#proto#://' & data;
  }

  public struct function url_to_struct(string data) {
    param data = urlDecode(cgi.query_string);
    if (data.listLen('?')==1) return {};
    return data.listLast('?').listToArray('&').map(v => v.listToArray('=')).reduce((h,v) => h.append({ '#v[1]#': v[2] ?: '' }), {});
  }
}
