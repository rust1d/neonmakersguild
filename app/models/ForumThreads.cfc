component extends=BaseModel accessors=true {
  property name='ft_ftid'         type='numeric'  sqltype='integer'    primary_key;
  property name='ft_foid'         type='numeric'  sqltype='integer';
  property name='ft_usid'         type='numeric'  sqltype='integer';
  property name='ft_subject'      type='string'   sqltype='varchar';
  property name='ft_alias'        type='string'   sqltype='varchar';
  property name='ft_sticky'       type='numeric'  sqltype='tinyint'    default='0';
  property name='ft_locked'       type='numeric'  sqltype='tinyint'    default='0';
  property name='ft_messages'     type='numeric'  sqltype='integer';
  property name='ft_views'        type='numeric'  sqltype='integer';
  property name='ft_last_fmid'    type='numeric'  sqltype='integer';
  property name='ft_deleted_by'   type='numeric'  sqltype='integer';
  property name='ft_deleted'      type='date'     sqltype='timestamp';
  property name='ft_added'        type='date';
  property name='ft_dla'          type='date';
  property name='fo_alias'        type='string';
  property name='us_user'         type='string';

  belongs_to(name: 'Forum',        class: 'Forums',        key: 'ft_foid',  relation: 'fo_foid');
  belongs_to(name: 'User',         class: 'Users',         key: 'ft_usid',  relation: 'us_usid');
  has_many(name: 'ForumMessages',  class: 'ForumMessages', key: 'ft_ftid',  relation: 'fm_ftid');

  public ForumMessages function last_message() {
    if (isNull(variables.ft_last_fmid)) return new app.models.ForumMessages();
    return new app.models.ForumMessages().find(ft_last_fmid);
  }

  public string function posted() {
    return isNull(variables.ft_added) ? '' : utility.ordinalDate(ft_added) & ft_added.format(' @ HH:nn');
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'forumthreads_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ft_ftid'), null: !arguments.keyExists('ft_ftid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ft_foid'), null: !arguments.keyExists('ft_foid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('ft_usid'), null: !arguments.keyExists('ft_usid'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),    null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  public string function seo_link() {
    if (new_record()) return 'forum/404';

    param variables.fo_alias = this.Forum().alias();

    return '/forum/#fo_alias#/#ft_ftid#/#ft_alias#';
  }

  public void function view() {
    if (new_record()) return;

    queryExecute(
      'UPDATE forumthreads SET ft_views=ft_views+1 WHERE ft_ftid=:pkid',
      { pkid: { value: variables.ft_ftid, cfsqltype: 'integer' } }, { datasource: datasource() }
    );
    variables.ft_views++;
  }

  // PRIVATE

  private void function pre_save() {
    param variables.ft_alias = variables.ft_subject;
    if (len(variables.ft_alias)==0) variables.delete('ft_alias');
    param variables.ft_alias = variables.ft_subject;
    if (this.alias_changed()) {
      variables.ft_alias = utility.slug(ft_alias);
    }
  }
}
