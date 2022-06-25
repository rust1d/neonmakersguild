component extends=jsoup accessors=true {
  property name='fm_fmid'        type='numeric'  sqltype='integer'    primary_key;
  property name='fm_foid'        type='numeric'  sqltype='integer';
  property name='fm_ftid'        type='numeric'  sqltype='integer';
  property name='fm_usid'        type='numeric'  sqltype='integer';
  property name='fm_body'        type='string'   sqltype='varchar'    html;
  property name='fm_history'     type='string'   sqltype='varchar';
  property name='fm_deleted_by'  type='numeric'  sqltype='integer';
  property name='fm_deleted'     type='date'     sqltype='timestamp';
  property name='fm_added'       type='date';
  property name='fm_dla'         type='date';
  property name='fo_alias'       type='string';
  property name='ft_alias'       type='string';
  property name='us_user'        type='string';

  belongs_to(name: 'Forum',        class: 'Forums',        key: 'fm_foid',  relation: 'fo_foid');
  belongs_to(name: 'ForumThread',  class: 'ForumThreads',  key: 'fm_ftid',  relation: 'ft_ftid');
  belongs_to(name: 'User',         class: 'Users',         key: 'fm_usid',  relation: 'us_usid');

  public numeric function age() {
    return now().diff('h', fm_added ?: now());
  }

  public boolean function editable() {
    return age() <= 24 && !deleted();
  }

  public boolean function deleted() {
    return !isNull(variables.fm_deleted);
  }

  public Users function deleted_by() {
    return variables._deleted_by = variables._deleted_by ?: new app.models.Users().find(fm_deleted_by);
  }

  public string function deleted_label() {
    return 'Deleted by #deleted_by().user()# on #deleted_on()#';
  }

  public string function deleted_on() {
    return isNull(variables.fm_deleted) ? '' : utility.ordinalDate(fm_deleted) & fm_deleted.format(' @ HH:nn');
  }

  public string function more() {
    if (isNull(variables.fm_body)) return '';
    var data = words().toList().left(30).listToArray();
    return utility.slice(data, max(3, max(data.len()-1, 1))).toList(' ') & '&hellip;';
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'forummessages_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_fmid'), null: !arguments.keyExists('fm_fmid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_foid'), null: !arguments.keyExists('fm_foid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_ftid'), null: !arguments.keyExists('fm_ftid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('fm_usid'), null: !arguments.keyExists('fm_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),    null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function posted() {
    return isNull(variables.fm_added) ? '' : utility.ordinalDate(fm_added) & fm_added.format(' @ HH:nn');
  }

  public string function seo_link() {
    if (new_record()) return 'forum/404';

    param variables.ft_alias = this.ForumThread().alias();
    param variables.fo_alias =this.ForumThread().fo_alias();

    return '/forum/#fo_alias#/#fm_ftid#/#ft_alias####fm_fmid#';
  }
}
