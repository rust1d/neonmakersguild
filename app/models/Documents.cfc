component extends=BaseModel accessors=true {
  property name='doc_docid'        type='numeric'  sqltype='integer'    primary_key;
  property name='doc_blog'         type='numeric'  sqltype='integer';
  property name='doc_type'         type='string'   sqltype='varchar';
  property name='doc_filename'     type='string'   sqltype='varchar';
  property name='doc_description'  type='string'   sqltype='varchar';
  property name='doc_size'         type='numeric'  sqltype='integer';
  property name='doc_views'        type='numeric'  sqltype='integer'    default='0';
  property name='doc_downloads'    type='numeric'  sqltype='integer'    default='0';
  property name='doc_added'        type='date';
  property name='doc_dla'          type='date';
  property name='doc_rename'       type='string';

  has_many(class: 'DocumentTags', key: 'doc_docid', relation: 'dt_docid');
  has_many_through(class: 'Tags', through: 'DocumentTags');
  has_many(name: 'DocumentCategories',  class: 'DocumentCategories',  key: 'doc_docid',  relation: 'dc_docid');
  has_many_through(class: 'BlogCategories', through: 'DocumentCategories');

  public string function datadash() {
    if (new_record()) return '';
    return serializeJSON({ 'blog': doc_blog, 'pkid': doc_docid });
  }

  public void function download() {
    if (new_record() || !fileExists(local_src())) return;

    cfheader(name: 'content-disposition', value: 'attachment; filename=#download_filename()#');
    cfheader(name: 'Expires', value: Now());
    cfheader(name: 'Content-Length', value: doc_size);
    cfcontent(file: local_src());
  }

  public string function download_filename() {
    if (new_record()) return '';
    return utility.slug(doc_filename) & '.#doc_type#';
  }

  public string function preview(numeric chars=100) {
    var text = variables.doc_description ?: '';
    if (text.len() < chars) return text;
    var data = text.left(chars).listToArray(' ');
    data.pop(); // REMOVES LAST WORD, WHICH IS LIKELY CUT OFF
    return data.toList(' ') & '&hellip;';
  }

  public boolean function recent() {
    return doc_added.add('m', 1) > now();
  }

  public string function src() {
    return application.urls.cdn & remote_path() & document_name();
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'documents_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('doc_docid'), null: !arguments.keyExists('doc_docid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('doc_blog'),  null: !arguments.keyExists('doc_blog'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bcaid'),     null: !arguments.keyExists('bcaid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('tag'),       null: !arguments.keyExists('tag'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),      null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return paged_search(sproc, arguments);
  }

  public string function size_mb() {
    if (isNull(variables.doc_size)) return 0;
    var kb = variables.doc_size/1024;
    return kb > 1000 ? numberFormat(kb/1024, '.0') & ' MB' : numberFormat(kb, '.0') & ' KB';
  }

  public string function seo_link() {
    if (new_record()) return 'library/404';

    return '/library/#doc_docid#/#doc_filename#';
  }

  // PRIVATE

  private void function delete_document(required string filefield) {
    var field = find_field(filefield);
    if (field.isEmpty()) return;

    try {
      if (fileExists(local_src())) {
        fileDelete(local_src());
        utility.fileDeleteS3(remote_src());
      }
      return;
    } catch (any err) { }
    errors().append('Could not delete #document_name()#.');
  }

  private string function document_name() {
    param variables.doc_type = 'tmp';
    return hash(doc_docid) & '.' & doc_type;
  }

  private string function local_path() {
    return application.paths.documents & 'user\'  & doc_blog % 10 & '\';
  }

  private string function local_src() {
    return local_path() & document_name();
  }

  private string function remote_path() {
    return  application.urls.documents & '/user/'  & doc_blog % 10 & '/';
  }

  private string function remote_src() {
    return application.s3.bucket & remote_path() & document_name();
  }

  private void function post_destroy(required boolean success) {
    if (success) delete_document('doc_filename');
  }

  private void function post_insert(required boolean success) {
    if (!success) return;
    if (upload_document()) {
      update_db(); // DIRECTLY CALL UPDATE TO AVOID CALLBACKS
    } else {
      delete_db(); // REMOVE THE RECORD IF UPLOAD FAILS
    }
  }

  private void function pre_save() {
    if (!isNull(variables.doc_rename)) variables.doc_filename = variables.doc_rename;
    // if (this.filename_changed()) {
    //   variables.doc_filename = utility.slug(doc_filename);
    // }
  }

  private boolean function upload_document() {
    var filefield = 'doc_filename';
    if (len(form.get(filefield))==0) return false; // NO FILE
    cffile(action: 'upload', filefield: filefield, destination: application.paths.root & 'tmp', result: 'result', nameconflict: 'overwrite');
    if (result.fileWasSaved) {
      if (!directoryExists(local_path())) directoryCreate(local_path());
      var filename = result.serverDirectory & '\' & result.serverfile;
      if (!result.keyExists('contentSubType')) {
        writedumP(result);abort;
      }
      if (listFindNoCase('pdf,gif,jpeg,png,mpeg,mp4,quicktime,csv,plain', result.contentSubType)) {
        variables.doc_type = result.contentSubType;
        if (listFindNoCase('csv,plain', doc_type)) variables.doc_type = 'txt';
        if (doc_type=='jpeg') variables.doc_type = 'jpg';
        if (doc_type=='quicktime') variables.doc_type = 'mov';
        if (doc_type=='mpeg') variables.doc_type = (result.contentType=='audio') ? 'mp3' : 'mp4';
      } else {
        errors().append('Uploaded file type is invalid (#result.contentType#/#result.contentSubType#).');
        return false;
      }
      if (!isNull(variables.doc_type)) {
        variables.doc_size = result.filesize;
        fileMove(filename, local_src());
        utility.fileCopyS3(local_src(), remote_src());
        return true;
      }

      errors().append('Uploaded file is invalid.');
      return false;
    }
    errors().append('Could not upload #result.clientFile#.');
    return false;
  }
}
