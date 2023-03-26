component extends=jSoup accessors=true {
  property name='btb_btbid'  type='numeric'  sqltype='integer'  primary_key;
  property name='btb_blog'   type='numeric'  sqltype='integer';
  property name='btb_label'  type='string'   sqltype='varchar';
  property name='btb_body'   type='string'   sqltype='varchar'  html;

  belongs_to(name: 'UserBlog', class: 'Users', key: 'btb_blog', relation: 'us_usid');

  public string function body_cdn() {
    return utility.body_cdn(variables.btb_body ?: '');
  }

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogtextblocks_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('btb_btbid'), null: !arguments.keyExists('btb_btbid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('btb_blog'),  null: !arguments.keyExists('btb_blog'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('btb_label'), null: !arguments.keyExists('btb_label'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('term'),      null: !arguments.keyExists('term'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return paged_search(sproc, arguments);
  }

  // PRIVATE

  private void function post_load() {
    if (!isNull(variables.btb_body)) variables.btb_body = utility.body_nocdn(variables.btb_body);
  }

  private void function pre_save() {
    if (this.label_changed()) {
      variables.btb_label = utility.slug(btb_label);
      var qry = this.search(btb_label: btb_label);
      if (qry.len() && qry.btb_bpaid != primary_key()) {
        errors().append('Page label #btb_label# is in use.');
      }
    }
  }
}
