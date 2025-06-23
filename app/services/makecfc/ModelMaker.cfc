component {
  public ModelMaker function init() {
    variables.utility = application.utility;
    return this;
  }

  public string function db_path(required string schema) {
    return 'c:\_work\nmg\db\sprocs\';
  }

  public array function get_schemas() {
    if (isNull(variables._schemas)) {
      var qry = queryExecute(
        "SELECT schema_name FROM information_schema.schemata WHERE schema_name REGEXP 'neonmakersguild'",
        {},
        { datasource: application.dsn }
      );
      variables._schemas = utility.query_to_array(qry);
    }
    return variables._schemas;
  }

  public array function get_tables(required string schema) {
    var qry = queryExecute(
      "SELECT table_name FROM information_schema.TABLES WHERE table_schema=:schema ORDER BY table_name",
      { schema: { cfsqltype: 'varchar', value: arguments.schema } },
      { datasource: application.dsn }
    );
    return utility.query_to_array(qry);
  }

  public ModelTable function get_table(required string schema, required string table) {
    return new app.services.makecfc.ModelTable(schema, table, db_path(schema));
  }
}
