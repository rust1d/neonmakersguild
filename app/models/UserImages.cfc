component extends=BaseImage accessors=true {
  property name='ui_uiid'      type='numeric'  sqltype='integer'    primary_key;
  property name='ui_usid'      type='numeric'  sqltype='integer';
  property name='ui_width'     type='numeric'  sqltype='integer'    default='0';
  property name='ui_height'    type='numeric'  sqltype='integer'    default='0';
  property name='ui_size'      type='numeric'  sqltype='integer';
  property name='ui_filename'  type='string'   sqltype='varchar';
  property name='ui_type'      type='string'   sqltype='varchar';
  property name='ui_dla'       type='date';
  property name='filefield'    type='string'                        default='ui_filename';
  property name='file_rename'  type='string';
  property name='bei_caption'  type='string';   // LOAD VIA blogentryimages_search
  property name='bei_beiid'    type='numeric';  // LOAD VIA blogentryimages_search

  belongs_to(class: 'Users',          key: 'ui_usid', relation: 'us_usid');
  has_many(class: 'BlogEntryImages',  key: 'ui_uiid', relation: 'bei_uiid');

  variables.image_size = 1600;
  variables.thumb_size = 256;
  variables.image_root = 'user';

  public numeric function beiid() {
    return variables.bei_beiid ?: 0;
  }

  public string function caption() {
    return variables.bei_caption ?: '';
  }

  public string function ratio() {
    return variables.ui_height==0 ? 0 : variables.ui_width / variables.ui_height;
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'userimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ui_uiid'), null: !arguments.keyExists('ui_uiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ui_usid'), null: !arguments.keyExists('ui_usid'));
    sproc.addParam(cfsqltype: 'float',   value: arguments.get('ratio'),   null: !arguments.keyExists('ratio'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),    null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public array function uses() {
    if (new_record()) return [];

    if (isNull(variables._uses)) {
      var sproc = new StoredProc(procedure: 'userimages_uses', datasource: datasource());
      sproc.addParam(cfsqltype: 'varchar', value: utility.hashCC(ui_uiid));
      sproc.addProcResult(name: 'qry', resultset: 1);
      variables._uses = utility.query_to_array(sproc.execute().getProcResultSets().qry);
    }
    return variables._uses;
  }

  // PRIVATE

}
