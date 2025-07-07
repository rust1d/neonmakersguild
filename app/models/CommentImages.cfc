component extends=BaseImage accessors=true {
  property name='ci_ciid'      type='numeric'  sqltype='integer'    primary_key;
  property name='ci_bcoid'     type='numeric'  sqltype='integer';
  property name='ci_benid'     type='numeric'  sqltype='integer';
  property name='ci_beiid'     type='numeric'  sqltype='integer';
  property name='ci_usid'      type='numeric'  sqltype='integer';
  property name='ci_width'     type='numeric'  sqltype='integer'    default='0';
  property name='ci_height'    type='numeric'  sqltype='integer'    default='0';
  property name='ci_size'      type='numeric'  sqltype='integer';
  property name='ci_filename'  type='string'   sqltype='varchar';
  property name='ci_added'     type='date';
  property name='filefield'    type='string'                        default='comment_image';
  property name='file_rename'  type='string';

  belongs_to(name: 'BlogEntry',      class: 'BlogEntries',      key: 'ci_benid',  relation: 'ben_benid');
  belongs_to(name: 'BlogEntryImage', class: 'BlogEntryImages',  key: 'ci_beiid',  relation: 'bei_beiid');
  belongs_to(name: 'BlogComment',    class: 'BlogComments',     key: 'ci_bcoid',  relation: 'bco_bcoid');
  belongs_to(name: 'User',           class: 'Users',            key: 'ci_usid',   relation: 'us_usid');

  variables.image_size = 1200;
  variables.thumb_size = 256;
  variables.image_root = 'comment';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'commentimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_ciid'),     null: !arguments.keyExists('ci_ciid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_bcoid'),    null: !arguments.keyExists('ci_bcoid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_benid'),    null: !arguments.keyExists('ci_benid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_beiid'),    null: !arguments.keyExists('ci_beiid'));
    sproc.addParam(cfsqltype: 'integer',   value: arguments.get('ci_usid'),     null: !arguments.keyExists('ci_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);
    return sproc.execute().getProcResultSets().qry;
  }

  // PRIVATE
}