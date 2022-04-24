component extends=BaseModel accessors=true {
  property name='bco_bcoid'    type='numeric'  sqltype='integer'    primary_key;
  property name='bco_blog'     type='numeric'  sqltype='integer';
  property name='bco_benid'    type='numeric'  sqltype='integer';
  property name='bco_usid'     type='numeric'  sqltype='integer';
  property name='bco_comment'  type='string'   sqltype='varchar';
  property name='bco_history'  type='string'   sqltype='varchar';
  property name='bco_added'    type='date';
  property name='bco_dla'      type='date';

  belongs_to(name: 'User',      class: 'Users',        key: 'bco_usid', relation: 'us_usid');
  belongs_to(name: 'BlogEntry', class: 'BlogEntries',  key: 'bco_benid', relation: 'ben_benid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogcomments_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bco_bcoid'), null: !arguments.keyExists('bco_bcoid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bco_blog'),  null: !arguments.keyExists('bco_blog'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bco_benid'), null: !arguments.keyExists('bco_benid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bco_usid'),  null: !arguments.keyExists('bco_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function edited() {
    return isNull(variables.bco_dla) ? '' : utility.ordinalDate(bco_dla) & bco_dla.format(' @ HH:nn');
  }

  public string function posted() {
    return isNull(variables.bco_added) ? '' : utility.ordinalDate(bco_added) & bco_added.format(' @ HH:nn');
  }

  // PRIVATE

  private void function pre_update() {
    if (this.comment_changed()) {
      application.flash.warning(this.comment_was());
      try {
        param variables.bco_history = '[]';
        var data = deserializeJSON(bco_history);
        writedump(data);
        data.prepend({ 'comment': this.comment_was(), 'time': now().format('yyyy-mm-dd HH:nn:ss') });
        variables.bco_history = serializeJSON(data);
      } catch (any err) {
        application.flash.error(utility.errorString(err));
      }
    }
  }
}
