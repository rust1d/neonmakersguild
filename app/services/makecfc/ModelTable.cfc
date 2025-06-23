 component {
  public ModelTable function init(required string schema, required string table, string path) {
    variables.schema = arguments.schema;
    variables.table = arguments.table;
    variables.utility = application.utility;
    variables.ifin = utility.ifin;
    variables.bool = utility.bool;
    variables.meta = table_data();

    variables.CR = chr(13) & chr(10);
    if (!isNull(arguments.path)) {
      variables.local_path = arguments.path
    } else {
      variables.local_path = utility.ensure_path(application.paths.physicalroot & 'tmp\makecfc\');
    }
    return this;
  }

  public struct function data() {
    return variables.meta;
  }

  public string function model() {
    var output = 'component extends=BaseModel accessors=true {#CR#';
    for (var col in meta.columns) {
      var _name = pad_prop(col.name, meta.max_column_name);
      var _type = pad_prop(col.ARG_TYPE, meta.max_arg_type);
      if (col.stamp.len()==0) {
        _type &= ' sqltype=' & pad_prop(col.qp_type, meta.max_qp_type);
        _type &= col.primary ? ' primary_key' : '';
        _type &= col.default.len() ? " default='#col.default#'" : '';
      }

      output &= "  property name=#_name# type=#_type.trim()#;";
      if (!col.last) output &= variables.CR;
    }
    var search = write_method('search', true);
    if (search.len()) output &= variables.CR & search & variables.CR;
    output &= '}' & variables.CR;
    if (form.get('writeit')==1) {
      var name = local_path & meta.table & '.cfc';
      fileWrite(name, output);
    }
    return output.trim();
  }

  public string function sproc_delete() {
    return write_sproc('delete', 'write_sproc_params_delete');
  }

  public string function sproc_get_by_ids() {
    return write_sproc('get_by_ids', 'write_sproc_params_get_by');
  }

  public string function sproc_insert() {
    return write_sproc('insert', 'write_sproc_params_insert');
  }

  public string function sproc_search() {
    return write_sproc('search', 'write_sproc_params_search');
  }

  public string function sproc_update() {
    return write_sproc('update', 'write_sproc_params_update');
  }

  // PRIVATE

  private array function chomp(required array data) {
    if (data.len()) data[data.len()] = data.last().replace(',','');
    return data;
  }

  private boolean function find_timestamp(required array rows, required string type) {
    var col = rows.filter(row => row.arg_type=='date' && row.suffix contains '_#type#')?.first();
    if (isNull(col)) return false;
    col.stamp = type.ucase();
    col.default = '';
    return true;
  }

  private array function get_columns() {
    var qry = queryExecute("
      SELECT fields.*, LENGTH(fields.column_name) AS len_column_name, LENGTH(fields.ARG_TYPE) AS len_arg_type, LENGTH(fields.qp_type) AS len_qp_type
        FROM (
               SELECT *,
                      CASE DATA_TYPE
                        WHEN 'bigint'     THEN 'numeric'
                        WHEN 'bit'        THEN 'boolean'
                        WHEN 'char'       THEN 'string'
                        WHEN 'date'       THEN 'date'
                        WHEN 'datetime'   THEN 'date'
                        WHEN 'decimal'    THEN 'numeric'
                        WHEN 'double'     THEN 'numeric'
                        WHEN 'float'      THEN 'numeric'
                        WHEN 'int'        THEN 'numeric'
                        WHEN 'longtext'   THEN 'string'
                        WHEN 'mediumint'  THEN 'numeric'
                        WHEN 'mediumtext' THEN 'string'
                        WHEN 'smallint'   THEN 'numeric'
                        WHEN 'text'       THEN 'string'
                        WHEN 'timestamp'  THEN 'date'
                        WHEN 'tinyint'    THEN 'numeric'
                        WHEN 'tinytext'   THEN 'string'
                        WHEN 'varchar'    THEN 'string'
                        ELSE CONCAT('UNKNOWN_', DATA_TYPE)
                      END AS ARG_TYPE,
                      CASE DATA_TYPE
                        WHEN 'bigint'     THEN 'bigint'
                        WHEN 'bit'        THEN 'bit'
                        WHEN 'blob'       THEN 'blob'
                        WHEN 'longblob'   THEN 'blob'
                        WHEN 'mediumblob' THEN 'blob'
                        WHEN 'char'       THEN 'char'
                        WHEN 'date'       THEN 'date'
                        WHEN 'double'     THEN 'double'
                        WHEN 'decimal'    THEN 'float'
                        WHEN 'float'      THEN 'float'
                        WHEN 'int'        THEN 'integer'
                        WHEN 'mediumint'  THEN 'integer'
                        WHEN 'smallint'   THEN 'smallint'
                        WHEN 'datetime'   THEN 'timestamp'
                        WHEN 'time'       THEN 'time'
                        WHEN 'timestamp'  THEN 'timestamp'
                        WHEN 'tinyint'    THEN 'tinyint'
                        WHEN 'longtext'   THEN 'varchar'
                        WHEN 'mediumtext' THEN 'varchar'
                        WHEN 'text'       THEN 'varchar'
                        WHEN 'tinytext'   THEN 'varchar'
                        WHEN 'varchar'    THEN 'varchar'
                        ELSE CONCAT('UNKNOWN_', DATA_TYPE)
                      END AS qp_type,
                      CASE DATA_TYPE
                        WHEN 'char'       THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'longtext'   THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'mediumtext' THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'text'       THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'tinytext'   THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'varchar'    THEN CHARACTER_MAXIMUM_LENGTH
                        ELSE 10
                      END AS CHAR_MAXLEN,
                      IF(column_key<>'' AND DATA_TYPE='int', 'KEY', '') AS SEARCH_KEY,
                      IF(IS_NULLABLE='YES', 'false', 'true') AS ARG_REQUIRED
                 FROM information_schema.COLUMNS
                WHERE table_schema=:schema
                  AND table_name=:table
             ) AS fields
       ORDER BY ordinal_position",
      {
        schema: { cfsqltype: 'varchar', value: variables.schema },
        table:  { cfsqltype: 'varchar', value: variables.table  }
      },
      { datasource: application.dsn }
    );
    var rows = utility.preserveNulls(qry);
    for (var row in rows) {
      row.name = row.column_name.lcase();
      row.default = row.column_default ?: '';
      row.primary = bool(row.extra=='auto_increment');
      var ln = row.name.listRest('_');
      row.suffix = '_' & (ln.len() ? ln : row.name);
      row.last = false;
      row.key = bool(row.column_key.len());
      row.last_key = false;
      row.stamp = '';
    }
    // FIND AUTO UPDATE TIMESTAMPS
    find_timestamp(rows, 'ADD');
    find_timestamp(rows, 'DLA');
    // MOVE TIMESTAMPS TO END OF COLUMN LIST
    var stamps = rows.filter(row => row.stamp.len());
    rows = rows.filter(row => row.stamp.len()==0);
    rows.append(stamps, true);
    rows.last().last = true;
    // for (var idx=1;idx<=rows.len();idx++) row.ordinal_position = idx;
    return rows;
  }

  private array function get_sproc_body(required string sproc) {
    var qry = queryExecute("
      SELECT *
        FROM information_schema.ROUTINES
       WHERE routine_schema = :schema
         AND specific_name = :sproc",
      {
        schema: { cfsqltype: 'varchar', value: variables.schema },
        sproc:  { cfsqltype: 'varchar', value: arguments.sproc  }
      },
      { datasource: application.dsn }
    );
    var body = qry.routine_definition;
    if (body.len()) {
      var rows = body.listToArray(chr(10), true);
      rows.pop(); // BEGIN
      rows.shift(); // END
      return rows;
    }
    return [];
  }

  private array function get_sproc_inputs(required string prefix, required string sproc) {
    var qry = queryExecute("
      SELECT fields.*, LENGTH(fields.parameter_name) AS LEN_parameter_name, LENGTH(fields.qp_type) AS len_qp_type
        FROM (
               SELECT *,
                      CASE DATA_TYPE
                        WHEN 'bigint'     THEN 'bigint'
                        WHEN 'bit'        THEN 'bit'
                        WHEN 'blob'       THEN 'blob'
                        WHEN 'longblob'   THEN 'blob'
                        WHEN 'mediumblob' THEN 'blob'
                        WHEN 'char'       THEN 'char'
                        WHEN 'date'       THEN 'date'
                        WHEN 'double'     THEN 'double'
                        WHEN 'decimal'    THEN 'float'
                        WHEN 'float'      THEN 'float'
                        WHEN 'int'        THEN 'integer'
                        WHEN 'mediumint'  THEN 'integer'
                        WHEN 'smallint'   THEN 'smallint'
                        WHEN 'datetime'   THEN 'timestamp'
                        WHEN 'time'       THEN 'time'
                        WHEN 'timestamp'  THEN 'timestamp'
                        WHEN 'tinyint'    THEN 'tinyint'
                        WHEN 'longtext'   THEN 'varchar'
                        WHEN 'mediumtext' THEN 'varchar'
                        WHEN 'text'       THEN 'varchar'
                        WHEN 'tinytext'   THEN 'varchar'
                        WHEN 'varchar'    THEN 'varchar'
                        ELSE CONCAT('UNKNOWN_', DATA_TYPE)
                      END AS qp_type
                 FROM information_schema.PARAMETERS
                WHERE specific_schema = :schema
                  AND specific_name = :sproc
             ) AS fields
       ORDER BY ordinal_position",
      {
        schema: { cfsqltype: 'varchar', value: variables.schema },
        sproc:  { cfsqltype: 'varchar', value: arguments.sproc  }
      },
      { datasource: application.dsn }
    );
    var rows = utility.preserveNulls(qry);
    for (var row in rows) {
      row.suffix = row.parameter_name.lcase();
      row.name = prefix & row.suffix;
      row.column_type = row.dtd_identifier;
      row.last = bool(row.ordinal_position == rows.len());
    }

    return rows;
  }

  private string function pad_arg(required string col, numeric ln=0) {
    if (ln==0) return col;
    return left(col & RepeatString(' ', 50), ln);
  }

  private string function pad_prop(required string col, numeric ln=0) {
    if (ln==0) return "'#col#'";
    return left("'#col#'" & RepeatString(' ', 50), ln);
  }

  private struct function table_data() {
    var columns = get_columns();
    var pk = columns.filter(row => row.primary)?.first() ?: {};
    if (pk.isEmpty()) throw('No primary key (auto_increment) defined.', 'no_primary_key');

    var keys = columns.filter(row => row.search_key=='key');
    if (keys.len()) keys.last().last_key = true;

    var prefix = pk.name.listFirst('_');
    var inputs = get_sproc_inputs(prefix, '#pk.table_name#_search'); // EXISTING SEARCH INPUTS
    if (!inputs.len()) inputs = keys;

    var defaults = columns.filter(row => row.default.len());

    var searches = listAppend(keys.map(col => col.name).toList(), inputs.map(col => col.name).toList()).listRemoveDuplicates()
    for (var col in columns) col.search = bool(searches.listFind(col.column_name));

    return {
      columns:          columns,
      col_cnt:          columns.len(),
      keys:             keys,
      key_cnt:          keys.len(),
      inputs:           inputs,
      inputs_cnt:       inputs.len(),
      defaults:         defaults,
      prefix:           prefix,
      table:            pk.table_name,
      schema:           pk.table_schema,
      primary:          pk,
      max_column_name:  columns.map(col => col.len_column_name).max() + 3,
      max_arg_type:     columns.map(col => col.len_arg_type).max() + 3,
      max_qp_type:      columns.map(col => col.len_qp_type).max() + 3
    }
  }

  private string function write_method(required string which, boolean has_results=true) {
    var sproc = '#meta.table#_#which#';
    var rtn = has_results ? 'query' : 'void';
    var lines = [];
    lines.append('public #rtn# function #which#(struct params) {');
    lines.append("  if (arguments.keyExists('params')) arguments = arguments.params;");
    lines.append("  if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;");
    lines.append('');
    lines.append("  var sproc = new StoredProc(procedure: '#sproc#', datasource: datasource());");
    for (var col in meta.inputs) {
      var _type = pad_arg("'#col.qp_type#',", meta.max_qp_type);
      var _get = pad_arg("('#col.name#'),", meta.max_column_name + 2);
      lines.append("  sproc.addParam(cfsqltype: #_type# value: arguments.get#_get# null: !arguments.keyExists('#col.name#'));");
    }
    if (has_results) {
      lines.append("  sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);");
      lines.append('  return sproc.execute().getProcResultSets().qry;');
    } else {
      lines.append('  sproc.execute();');
    }
    lines.append('}');
    return lines.map(line => cr & '  ' & line).toList('');
  }

  // SPROC BODY

  private string function write_sproc(required string which, required string param_proc) {
    var sproc = '#meta.table#_#which#';
    var body = invoke('', 'write_sproc_#which#', []);
    var inputs = invoke('', param_proc, []);
    var params = [];
    params.append('DROP procedure IF EXISTS #sproc#;#CR#');
    params.append('delimiter ;;#CR#');
    params.append('CREATE PROCEDURE #sproc#(');
    params.append(chomp(inputs), true);
    params.append(')#CR#BEGIN');
    params.append(body, true);
    params.append('END;;#CR#');
    params.append('delimiter ;#CR#');
    var sql = params.toList('#CR#');
    if (form.get('writeit')==1) {
      var name = local_path & sproc & '.sql';
      fileWrite(name, sql);
    }
    return sql;
  }

  private array function write_sproc_delete() {
    var params = [];
    params.append('  DELETE');
    params.append('    FROM #meta.table#');
    params.append(write_sproc_where(), true);
    params.append('');
    params.append('  SELECT ROW_COUNT() AS delete_count;');
    return params;
  }

  private array function write_sproc_get_by_ids() {
    var params = [];
    params.append('  CALL create_temp_table_id_list(_ids);#CR#');
    params.append('  SELECT *');
    params.append('    FROM #meta.table#');
    params.append('         INNER JOIN _id_list ON _il_id = #meta.primary.name#;');
    return params;
  }

  private array function write_sproc_insert() {
    var notpk = meta.columns.filter(col => !col.primary); // REMOVE PKID, AUTO FIELDS
    var fill = notpk.filter(col => col.stamp.len()==0);
    var stamp = notpk.filter(col => col.stamp.len());
    var names = fill.map(row => row.name);
    names.append(stamp.map(row => row.name), true);
    var datas = fill.map(row => row.suffix);
    datas.append(stamp.map(row => 'CURRENT_TIMESTAMP'), true);
    // SPLIT INTO MULTIPLE LINES
    var cols = utility.groups_of(names, 8).map(rows => '    ' & rows.toList(', ')).toList(',#CR#');
    var vals = utility.groups_of(datas, 8).map(rows => '    ' & rows.toList(', ')).toList(',#CR#');
    // SET DEFAULTS
    var def_cols = meta.columns.filter(row => !isNull(row.column_default) && row.stamp.len()==0);
    var params = [];
    for (var col in def_cols) {
      var name = '_' & col.name.listRest('_');
      var val = col.column_default;
      if (col.arg_type!='numeric') val = "'#val#'";
      params.append('  SET #name# = IFNULL(#name#, #val#);');
    }
    params.append('');
    params.append('  INSERT INTO #meta.table# (');
    params.append(cols);
    params.append('  ) VALUES (');
    params.append(vals);
    params.append('  );#CR#');
    params.append('  CALL #meta.table#_get_by_ids(LAST_INSERT_ID());');
    return params;
  }

  private array function write_sproc_search() {
    var params = get_sproc_body('#meta.table#_search');
    if (params.len()) return params;

    params.append('  SELECT *');
    params.append('    FROM #meta.table#');
    // params.append('   WHERE (#meta.primary.suffix# IS NULL OR #meta.primary.name# = #meta.primary.suffix#)');
    var pad = '   WHERE';
    for (var col in meta.keys) {
      params.append('#pad# (#col.suffix# IS NULL OR #col.name# = #col.suffix#)');
      pad = '     AND';
    }
    params[params.len()] = params.last() & ';'
    return params;
  }

  private array function write_sproc_update() {
    var fill = meta.columns.filter(col => col.stamp.len()==0);
    var stamp = meta.columns.filter(col => col.stamp=='DLA');
    fill.append(stamp, true);

    var params = [];
    params.append('  UPDATE #meta.table#');
    var pad = '     SET';
    for (var col in fill) {
      if (col.column_key=='PRI') continue;
      var suffix = pad_arg(col.suffix & ',', meta.max_column_name);
      var name = pad_arg(col.name, meta.max_column_name);
      if (col.stamp=='DLA') {
        params.append('#pad# #name# = CURRENT_TIMESTAMP,');
      } else {
        params.append('#pad# #name# = IFNULL(#suffix##col.name#),');
      }
      pad = '        ';
    }

    params = chomp(params);
    params.append(write_sproc_where(), true);
    params.append('');
    params.append('  CALL #meta.table#_get_by_ids(#meta.primary.suffix#);');
    return params;
  }

  private array function write_sproc_where() {
    return ['   WHERE #meta.primary.name# = #meta.primary.suffix#;'];
    var params = [];
    var pad = '   WHERE';
    for (var col in meta.keys) {
      if (!col.primary) continue;
      var end = ifin(col.last_key, ';', ',');
      var name = pad_arg(col.name, meta.max_column_name);
      var suffix = pad_arg(col.suffix & end, meta.max_column_name);
      params.append('#pad# #name# = #suffix#');
      pad = '     AND';
    }

    return params;
  }

  // SPROC PARAMETERS

  private array function write_sproc_params_delete() {
    var params = [];
    var cols = meta.columns.filter(col => col.column_key=='PRI'); // ONLY PRIMARY KEY
    for (col in cols) {
      var _name = pad_arg(col.suffix, meta.max_column_name);
      params.append('  IN #_name# #col.column_type.ucase()#,');
    }
    return params;
  }

  private array function write_sproc_params_get_by() {
    return ['  IN _ids text'];
  }

  private array function write_sproc_params_insert() {
    var params = [];
    var cols = meta.columns;
    cols = cols.filter(col => col.column_key!='PRI'); // REMOVE PRIMARY KEYS
    for (col in cols) {
      if (col.stamp.len()) continue;
      var _name = pad_arg(col.suffix, meta.max_column_name);
      params.append('  IN #_name# #col.column_type.ucase()#,');
    }
    return params;
  }

  private array function write_sproc_params_search() {
    var params = [];
    for (var col in meta.inputs) {
      var _name = pad_arg(col.suffix, meta.max_column_name);
      var _type = col.column_type;
      params.append("  IN #_name# #_type#,");
    }
    return params;
  }

  private array function write_sproc_params_update() {
    var params = [];
    var cols = meta.columns;
    for (col in cols) {
      if (col.stamp.len()) continue;
      var _name = pad_arg(col.suffix, meta.max_column_name);
      params.append('  IN #_name# #col.column_type.ucase()#,');
    }
    return params;  }

}
