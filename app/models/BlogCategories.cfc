component extends=BaseModel accessors=true {
  property name='bca_bcaid'     type='numeric'  sqltype='integer'  primary_key;
  property name='bca_blog'      type='numeric'  sqltype='integer';
  property name='bca_category'  type='string'   sqltype='varchar';
  property name='bca_alias'     type='string'   sqltype='varchar';
  property name='bca_entrycnt'  type='numeric';

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'blogcategories_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bca_bcaid'),    null: !arguments.keyExists('bca_bcaid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('bca_blog'),     null: !arguments.keyExists('bca_blog'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bca_category'), null: !arguments.keyExists('bca_category'));
    sproc.addParam(cfsqltype: 'varchar', value: arguments.get('bca_alias'),    null: !arguments.keyExists('bca_alias'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  private void function pre_save() {
    if (len(variables?.bca_alias)==0) variables.delete('bca_alias'); // defaults next line
    param variables.bca_alias = variables.bca_category;
    if (this.alias_changed()) {
      variables.bca_alias = utility.slug(bca_alias);
      var qry = this.search(bca_alias: bca_alias);
      if (qry.len() && qry.bca_bcaid != primary_key()) {
        errors().append('Category alias #bca_alias# is in use.');
      }
    }
  }
}
