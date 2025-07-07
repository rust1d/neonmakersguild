component extends=BaseImage accessors=true {
  property name='fi_fiid'      type='numeric'  sqltype='integer'    primary_key;
  property name='fi_foid'      type='numeric'  sqltype='integer';
  property name='fi_ftid'      type='numeric'  sqltype='integer';
  property name='fi_fmid'      type='numeric'  sqltype='integer';
  property name='fi_usid'      type='numeric'  sqltype='integer';
  property name='fi_width'     type='numeric'  sqltype='integer'    default='0';
  property name='fi_height'    type='numeric'  sqltype='integer'    default='0';
  property name='fi_size'      type='numeric'  sqltype='integer';
  property name='fi_filename'  type='string'   sqltype='varchar';
  property name='fi_added'     type='date';
  property name='filefield'    type='string'                        default='forum_image';
  property name='file_rename'  type='string';

  belongs_to(name: 'Forum',        class: 'Forums',         key: 'fi_foid',  relation: 'fo_foid');
  belongs_to(name: 'ForumThread',  class: 'ForumThreads',   key: 'fi_ftid',  relation: 'ft_ftid');
  belongs_to(name: 'ForumMessage', class: 'ForumMessages',  key: 'fi_fmid',  relation: 'fm_fmid');
  belongs_to(name: 'User',         class: 'Users',          key: 'fi_usid',  relation: 'us_usid');

  variables.image_size = 1000;
  variables.thumb_size = 196;
  variables.image_root = 'forum';

  public string function ratio() {
    return variables.fi_height==0 ? 0 : variables.fi_width / variables.fi_height;
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'forumimages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_fiid'), null: !arguments.keyExists('fi_fiid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_foid'), null: !arguments.keyExists('fi_foid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_ftid'), null: !arguments.keyExists('fi_ftid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_fmid'), null: !arguments.keyExists('fi_fmid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fi_usid'), null: !arguments.keyExists('fi_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  // PRIVATE
}
