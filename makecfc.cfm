<cfscript>
  param form.table_schema = 'neonmakersguild';
  param form.writeto = 'C:\_work\nmg\db\sprocs';
  param form.tabname = '';
</cfscript>

<cfquery datasource="neonmakersguild" name="qryTabs">
  select table_name
    from information_schema.TABLES
   where table_schema='#form.table_schema#'
   order by table_name
</cfquery>

<cfform method="post">
  <cfoutput>
    Table Name: <cfselect name="tabname" value="table_name" query="qryTabs" size="1" selected="#form.tabname#"></cfselect><br>
    Write Sprocs! <input type="Checkbox" name="writeit"><br>
    Write Sprocs To: <input type="text" name="writeto" size='50' value="#form.writeto#"/><br>
    <input type="submit">
    <input type='hidden' name='table_schema' value='#form.table_schema#'>
  </cfoutput>
</cfform>

<cfif form.tabname is not "">
  <cfscript>
    array function write_sproc_params(required query qry, required string which) {
      var sproc = '#form.tabname#_#which#';
      cfquery(name='qryPad', dbtype='query') {
        writeOutput('SELECT MAX(LEN_COLUMN_NAME) AS MAX_COLUMN_NAME FROM qry');
      }
      var params = [];
      for (row in qry) {
        if (which=='insert' && row.COLUMN_KEY=='PRI') continue;

        var suffix = '_' & row.COLUMN_NAME.listRest('_');
        var _name = left(suffix & string50, qryPad.MAX_COLUMN_NAME).lcase();
        var _type = row.COLUMN_TYPE;
        params.append("  IN #_name# #_type#,");
      }
      return params;
    }

    array function write_delete_params(required query qry, required string which) {
      cfquery(name='qryKey', dbtype='query') {
        writeOutput("SELECT lower(COLUMN_NAME) FROM qry WHERE COLUMN_KEY = 'PRI'");
      }
      var suffix = '_' & qryKey.COLUMN_NAME.listRest('_').lcase();
      var params = ['  IN #suffix# integer'];
      return params;
    }

    array function write_search_params(required query qry, required string which) {
      cfquery(name='qryPad', dbtype='query') {
        writeOutput("SELECT MAX(LEN_COLUMN_NAME) AS MAX_COLUMN_NAME FROM qry WHERE COLUMN_KEY IN ('PRI','MUL')");
      }

      cfquery(name='qryKey', dbtype='query') {
        writeOutput("SELECT lower(COLUMN_NAME), lower(COLUMN_TYPE) FROM qry WHERE COLUMN_KEY IN ('PRI','MUL')");
      }
      var params = [];
      for (row in qryKey) {
        var suffix = '_' & row.COLUMN_NAME.listRest('_').lcase();
        var _name = left(suffix & string50, qryPad.MAX_COLUMN_NAME).lcase();
        var _type = row.COLUMN_TYPE;
        params.append("  IN #_name# #_type#,");
      }
      return params;
    }


    array function write_get_by_params(required query qry, required string which) {
      var params = ['  IN _ids text'];
      return params;
    }

    array function write_sproc_get_by_ids(required query qry) {
      cfquery(name='qryKey', dbtype='query') {
        writeOutput("SELECT lower(COLUMN_NAME) FROM qry WHERE COLUMN_KEY = 'PRI'");
      }
      var cols = valueList(qry.COLUMN_NAME, ', ').lcase();
      var key = '';
      var params = [];
      params.append('  CALL create_temp_table_id_list(_ids);#CR#');
      params.append('  SELECT *');
      params.append('    FROM #form.tabname#');
      params.append('         INNER JOIN _id_list ON _il_id = #qryKey.COLUMN_NAME.lcase()#;');
      return params;
    }

    array function write_sproc_delete(required query qry) {
      cfquery(name='qryKey', dbtype='query') {
        writeOutput("SELECT lower(COLUMN_NAME) FROM qry WHERE COLUMN_KEY = 'PRI'");
      }
      var key = '';
      var params = [];
      var suffix = '_' & qryKey.COLUMN_NAME.listRest('_');
      params.append('  DELETE');
      params.append('    FROM #form.tabname#');
      params.append('   WHERE #qryKey.COLUMN_NAME# = #suffix#;#cr#');
      params.append('  SELECT ROW_COUNT() AS delete_count;');
      return params;
    }

    array function write_sproc_update(required query qry) {
      cfquery(name='qryPad', dbtype='query') {
        writeOutput('SELECT MAX(LEN_COLUMN_NAME) AS MAX_COLUMN_NAME FROM qry');
      }
      var params = [];
      params.append('  UPDATE #form.tabname#');
      var set = '     SET';
      var where = [];
      for (row in qry) {
        var suffix = '_' & row.COLUMN_NAME.listRest('_').lcase();
        if (row.COLUMN_KEY == 'PRI') {
          where = [row.column_name.lcase(), suffix];
          continue;
        }
        suffix = left(suffix & ',' & string50, qryPad.MAX_COLUMN_NAME).lcase();
        var _name = left(row.COLUMN_NAME & string50, qryPad.MAX_COLUMN_NAME).lcase();
        params.append("#set# #_name# = IFNULL(#suffix##row.column_name.lcase()#),");
        set = '        ';
      }
      params[params.len()] = params.last().left(params.last().len()-1);
      params.append('   WHERE #where.first()# = #where.last()#;#CR#');
      params.append('  CALL #form.tabname#_get_by_ids(#where.last()#);');
      return params;
    }

    array function write_sproc_insert(required query qry) {
      cfquery(name='qryPad', dbtype='query') {
        writeOutput('SELECT MAX(LEN_COLUMN_NAME) AS MAX_COLUMN_NAME FROM qry');
      }
      cfquery(name='qryDefs', dbtype='query') {
        writeOutput('SELECT * FROM qry WHERE COLUMN_DEFAULT IS NOT NULL');
      }
      var params = []
      for (row in qryDefs) {
        var name = '_' & row.column_name.listRest('_').lcase();
        var val = row.COLUMN_DEFAULT;
        if (row.arg_type!='numeric') val = "'#val#'";
        params.append('  SET #name# = IFNULL(#name#, #val#);');
      }
      params.append('');
      params.append('  INSERT INTO #form.tabname# (');
      var cols_arr = qry.valueArray('COLUMN_NAME').slice(2, -1); // REMOVE 1ST ELEMENT
      var cols = cols_arr.map(function(val) { return val }).toList(', ');
      var vals = [];
      for (column_name in cols_arr) {
        vals.Append('_' & column_name.listRest('_'));
      }

      params.append('    ' & cols.lcase());
      params.append('  ) VALUES (');
      params.append('    ' & vals.toList(', ').lcase());
      params.append('  );#CR#');
      params.append('  CALL #form.tabname#_get_by_ids(LAST_INSERT_ID());');
      return params;
    }

    string function write_sproc(required query qry, required string which, string param_proc = 'write_sproc_params') {
      var sproc = '#form.tabname#_#which#';
      var body = variables['write_sproc_#which#'](qry);
      var inputs = variables['#param_proc#'](qry, which);
      inputs[inputs.len()] = inputs.last().replace(',','');
      var params = [];
      params.append('DROP procedure IF EXISTS #sproc#;#cr#');
      params.append('delimiter ;;#cr#');
      params.append('CREATE PROCEDURE #sproc#(');
      params.append(inputs, true);
      params.append(')#CR#BEGIN');
      params.append(body, true);
      params.append('END;;#CR#');
      params.append('delimiter ;#CR#');
      var sql = params.toList('#cr#');
      if (form.keyExists('writeit') && DirectoryExists(form.writeto)) {
        var name = form.writeto & '\' & sproc & '.sql';
        fileWrite(name, sql);
      }
      return sql;
    }

    array function write_sproc_search(required query qry) {
      cfquery(name='qryKey', dbtype='query') {
        writeOutput("SELECT lower(COLUMN_NAME) FROM qry WHERE COLUMN_KEY = 'PRI'");
      }
      var key = '';
      var params = [];
      var suffix = '_' & qryKey.COLUMN_NAME.listRest('_');
      params.append('  SELECT *');
      params.append('    FROM #form.tabname#');
      params.append('   WHERE (#suffix# IS NULL OR #qryKey.COLUMN_NAME# = #suffix#)');
      for (row in qry) {
        var suffix = '_' & row.COLUMN_NAME.listRest('_').lcase();
        if (row.COLUMN_KEY == 'MUL') {
          params.append('     AND (#suffix# IS NULL OR #row.COLUMN_NAME# = #suffix#)');
        }
      }
      params[params.len()] = params.last() & ';'
      return params;
    }

    string function write_method_search(required query qry) {
      var sproc = '#form.tabname#_search';
      cfquery(name='qryKey', dbtype='query') {
        writeOutput("SELECT * FROM qry WHERE COLUMN_KEY IN ('MUL', 'PRI')");
      }
      cfquery(name='qryPad', dbtype='query') {
        writeOutput('SELECT MAX(LEN_QP_TYPE) AS MAX_QP_TYPE, MAX(LEN_COLUMN_NAME) AS MAX_COLUMN_NAME FROM qryKey');
      }
      lines = [''];
      lines.append('  public query function search(struct params) {');
      lines.append("    if (arguments.keyExists('params')) arguments = arguments.params;");
      lines.append("    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;");
      lines.append('');
      lines.append("    var sproc = new StoredProc(procedure: '#sproc#', datasource: datasource());");

      for (row in qryKey) {
        _type = left("'#row.QP_TYPE#',#string50#", qryPad.MAX_QP_TYPE + 3).lcase();
        _name = left("('#row.COLUMN_NAME#'),#string50#", qryPad.MAX_COLUMN_NAME + 5).lcase();
        _null = lcase("'#row.COLUMN_NAME#'");
        lines.append("    sproc.addParam(cfsqltype: #_type# value: arguments.get#_name# null: !arguments.keyExists(#_null#));");
      }
      lines.append("    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);");
      lines.append("");
      lines.append("    return sproc.execute().getProcResultSets().qry;");
      lines.append("  }");
      var out = lines.toList('#cr#');
      return out;
    }

    string function write_method(required string which, required boolean has_results) {
      var sproc = '#form.tabname#_#which#';
      cfquery(name='qryProc', datasource='neonmakersguild') {
        writeOutput("
          SELECT fields.*, LENGTH(fields.PARAMETER_NAME) AS LEN_PARAMETER_NAME, LENGTH(fields.QP_TYPE) AS LEN_QP_TYPE
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
                     END AS QP_TYPE
                FROM information_schema.PARAMETERS
               WHERE specific_schema='#form.table_schema#'
                 AND specific_name='#sproc#'
          ) AS fields
          ORDER BY ORDINAL_POSITION
        ");
      }
      if (!qryProc.len()) return '';

      cfquery(name='qryPad', dbtype='query') {
        writeOutput('SELECT MAX(LEN_PARAMETER_NAME) AS MAX_PARAMETER_NAME, MAX(LEN_QP_TYPE) AS MAX_QP_TYPE FROM qryProc');
      }
      lines = [];
      if (which == 'search') {
        lines.append('public query function #which#(struct params) {');
      } else {
        lines.append('public query function #which#(required struct params) {');
      }
      lines.append("  if (arguments.keyExists('params')) arguments = arguments.params;");
      if (which == 'search') lines.append("  if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;");
      lines.append('');
      lines.append("  var sproc = new StoredProc(procedure: '#sproc#', datasource: datasource());");
      for (row in qryProc) {
        _type = left("'#row.QP_TYPE#',#string50#", qryPad.MAX_QP_TYPE + 3).lcase();
        _name = left("('#prefix##row.PARAMETER_NAME#'),#string50#", qryPad.MAX_PARAMETER_NAME + 8).lcase();
        _null = lcase("'#prefix##row.PARAMETER_NAME#'");
        lines.append("  sproc.addParam(cfsqltype: #_type# value: arguments.get#_name# null: !arguments.keyExists(#_null#));");
      }
      if (has_results) {
        if (which == 'search') {
          lines.append("  sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);");
        } else {
          lines.append("  sproc.addProcResult(name: 'qry', resultset: 1);");
        }
        lines.append("");
        lines.append("  return sproc.execute().getProcResultSets().qry;");
      } else {
        lines.append("  sproc.execute();");
        lines.append("");
        lines.append("  return;");
      }
      lines.append("}");
      var out = lines.toList('#cr#');

      out = '';
      for (line in lines) out &= cr & '  ' & line;
      return out;
    }

    cfquery(name="qry", datasource='neonmakersguild') {
      writeOutput("
        SELECT fields.*, LENGTH(fields.COLUMN_NAME) AS LEN_COLUMN_NAME, LENGTH(fields.ARG_TYPE) AS LEN_ARG_TYPE, LENGTH(fields.QP_TYPE) AS LEN_QP_TYPE
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
                      END AS QP_TYPE,
                      CASE DATA_TYPE
                        WHEN 'char'       THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'longtext'   THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'mediumtext' THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'text'       THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'tinytext'   THEN CHARACTER_MAXIMUM_LENGTH
                        WHEN 'varchar'    THEN CHARACTER_MAXIMUM_LENGTH
                        ELSE 10
                      END AS CHAR_MAXLEN,
                      IF(COLUMN_KEY<>'' AND DATA_TYPE='int', 'KEY', '') AS SEARCH_KEY,
                      IF(IS_NULLABLE='YES', 'false', 'true') AS ARG_REQUIRED
                  FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA='#form.table_schema#'
                  AND TABLE_NAME='#form.tabname#'
          ) AS fields
        ORDER BY ORDINAL_POSITION
      ");
    }

    cfquery(name="qryKeys", dbtype="query") {
      writeOutput("
        SELECT *
          FROM qry
        WHERE COLUMN_KEY <> ''
        ORDER BY ORDINAL_POSITION
      ");
    }

    CR = chr(13) & chr(10);
    QT = chr(34);
    OB = chr(60);
    CB = chr(62);
    SP = chr(32);
    OB = '&lt;';
    CB = '&gt;';
    STRING50='                                                  ';
    outModel = 'component extends=BaseModel accessors=true {#CR#';
    prefix = qry.COLUMN_NAME.listFirst('_');
    search = write_method('search', true);
    if (search.len()==0) search = write_method_search(qry);
    delete = write_method('delete', true);
    insert = write_method('insert', true);
    update = write_method('update', true);
    cfquery(name='qryPad', dbtype='query') {
      writeOutput('SELECT MAX(LEN_COLUMN_NAME) AS MAX_COLUMN_NAME, MAX(LEN_ARG_TYPE) AS MAX_ARG_TYPE, MAX(LEN_QP_TYPE) AS MAX_QP_TYPE FROM qry');
    }
    cfquery(name='qryKey', dbtype='query') {
      writeOutput("SELECT lower(COLUMN_NAME) FROM qry WHERE COLUMN_KEY = 'PRI'");
    }
    for (row in qry) {
      cfquery(name='qryDef', dbtype='query') {
        writeOutput("SELECT * FROM qry WHERE COLUMN_NAME='#row.column_name#' AND COLUMN_DEFAULT IS NOT NULL AND COLUMN_DEFAULT<>'CURRENT_TIMESTAMP'");
      }
      _name = left("'#row.COLUMN_NAME.lcase()#'#string50#", qryPad.MAX_COLUMN_NAME + 3);
      _type = left("'#row.ARG_TYPE#'#string50#", qryPad.MAX_ARG_TYPE + 3);
      _sqlt = left("'#row.QP_TYPE#'#string50#", qryPad.MAX_QP_TYPE + 3); // "'#row.QP_TYPE#'";
      if (qryKey.COLUMN_NAME == row.COLUMN_NAME) _sqlt &= ' primary_key';
      else if (qryDef.len()) _sqlt &= " default='#qryDef.COLUMN_DEFAULT#'";
      outmodel &= '  property name=#_name# type=#_type# sqltype=#_sqlt.trim()#;#CR#';
    }
    outmodel &= search & CR & '}' & CR;

    if (form.keyExists('writeit') && DirectoryExists(form.writeto)) {
      name = form.writeto & '\' & form.tabname & '.cfc';
      fileWrite(name, outmodel);
    }
  </cfscript>

  <cfoutput>
  PROPERTIES<br>

  <textarea cols=140 rows=#Min(outmodel.listToArray(cr).len() + 6, 40)# onfocus="clip(this)">#outmodel#</textarea><br>
  INSERT<br>
  <textarea cols=140 rows=10 onfocus=clip(this)>#write_sproc(qry, 'insert')#</textarea><br>
  UPDATE<br>
  <textarea cols=140 rows=10 onfocus=clip(this)>#write_sproc(qry, 'update')#</textarea><br>
  DELETE<br>
  <textarea cols=140 rows=10 onfocus=clip(this)>#write_sproc(qry, 'delete', 'write_delete_params')#</textarea><br>
  GET BY ID<br>
  <textarea cols=140 rows=10 onfocus=clip(this)>#write_sproc(qry, 'get_by_ids', 'write_get_by_params')#</textarea><br>
  SEARCH<br>
  <textarea cols=140 rows=10 onfocus=clip(this)>#write_sproc(qry, 'search', 'write_search_params')#</textarea><br>
  <cfif search.len()>SEARCH METHOD<BR><textarea cols=140 rows=10 onfocus="clip(this)">#search#</textarea><br></cfif>
  <cfif delete.len()>DELETE METHOD<BR><textarea cols=140 rows=10 onfocus="clip(this)">#delete#</textarea><br></cfif>
  <cfif insert.len()>INSERT METHOD<BR><textarea cols=140 rows=10 onfocus="clip(this)">#insert#</textarea><br></cfif>
  <cfif update.len()>UPDATE METHOD<BR><textarea cols=140 rows=10 onfocus="clip(this)">#update#</textarea><br></cfif>
  </cfoutput>
</cfif>
<script>
  clip = function(fld) {
    fld.select();
    fld.setSelectionRange(0, 99999);
    document.execCommand("copy");
  }
</script>
