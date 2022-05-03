component {
  public BaseModel function init(struct params, boolean db = false) {
    variables.utility = application.utility;
    variables._db = {};
    pre_init(argumentcollection: arguments);
    if (arguments.keyExists('params')) {
      setter(data: arguments.params, db: arguments.db);
    } else {
      set(argumentcollection: arguments);
    }

    post_init();

    return this;
  }

  public array function all() {
    return this.where();
  }

  public string function class() {
    return GetMetaData(this).fullname.listLast('.');
  }

  public numeric function count(struct params) {
    return search(argumentcollection: arguments).len();
  }

  public boolean function destroy() {
    if (arguments.keyList().len()) throw('Woah! Did you mean to call destroy?');
    if (!persisted()) throw('Record not persisted.', 'record_not_saved');

    var success = delete_db();
    post_destroy(success);
    return success;
  }

  public boolean function changed() {
    for (var field in GetMetaData(this).properties) if (field_changed(field)) return true;
    return false;
  }

  public array function changes() {
    var changed = [];
    for (var field in GetMetaData(this).properties) {
      if (field_changed(field)) {
        var data = {};
        data[field.name] = [field_was(field), variables.get(field.name)];
        changed.append(data);
      }
    }
    return changed;
  }

  public string function encoded_key() {
    return utility.encode(primary_key());
  }

  public array function errors() {
    param variables._errors=[];

    return variables._errors;
  }

  public BaseModel function find(required numeric id) {
    load_db(get_by_ids(ids: id));
    if (!persisted()) throw('Record not found.', 'record_not_found');

    return this;
  }

  public BaseModel function find_or_create(string id) {
    if (!isNumeric(arguments.get('id'))) id = 0;
    if (arguments.id) load_db(get_by_ids(ids: id));

    return this;
  }

  public boolean function has_errors() {
    return errors().len() != 0;
  }

  public query function get_by_ids(required string ids) {
    var sproc = new StoredProc(procedure: '#class()#_get_by_ids', datasource: datasource());
    sproc.addParam(cfsqltype: 'varchar', value: ids.listRemoveDuplicates());
    sproc.addProcResult(name: 'qry', resultset: 1);

    return sproc.execute().getProcResultSets().qry;
  }

  public boolean function matches(required struct params) {
    for (var key in params) if (variables.get(key) != params[key]) return false;
    return true;
  }

  public boolean function new_record() {
    return IsNull(primary_key());
  }

  public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
    // CHECK IF METHOD MATCHES A DEFINED RELATION
    if (relation_exists(missingMethodName)) return relation_load(missingMethodName, missingMethodArguments);

    // TRY TO FIND A MATCHING FIELD W/NAME OF METHOD CALLED
    var field = find_field(missingMethodName); // FULL NAME PASSED? ie us_usid()
    if (field.isEmpty()) field = find_field(table_prefix() & missingMethodName); // UNPREFIXED NAME PASSED? ie usid()
    if (!field.isEmpty()) { // FIELD FOUND, SET OR GET IT
      if (missingMethodArguments.isEmpty()) return variables.get(field.name); // NO VALUE PASSED, GET AND RETURN

      if (isNull(missingMethodArguments[1])) {
        variables[field.name] = javacast('null',0);
      } else {
        clear_errors();
        var value = cast(missingMethodArguments[1], field);
        if (isNull(value)) return; // ERROR OCCURED WHEN CASTING, RETURN NULL AND DO. NOT. SET.
        set_field(field, value);
      }
      return variables.get(field.name);
    }

    // CHECK IF METHOD IS A CHANGE REQUEST OR INC/DEC
    var match = missingMethodName.reMatch('(_changed|_changes|_was|_inc|_dec)$');
    if (match.len()) {
      var suffix = match.first();
      var name = table_prefix() & missingMethodName.replace(suffix, '');
      var field = find_field(name);
      if (!field.isEmpty()) {
        if (suffix == '_changed') return field_changed(field);
        if (suffix == '_changes') {
          if (field_changed(field)) return [field_was(field), variables.get(field.name)];
          return;
        }
        if (suffix == '_was') return field_was(field);
        if (field.type == 'numeric' && suffix.reMatch('(_inc|_dec)').len()) {
          var change = isNumeric(missingMethodArguments[1]) ? missingMethodArguments[1] : 1;
          if (suffix == '_dec') change = -change;
          var value = variables.get(field.name);
          param value = 0;
          return variables[field.name] = value + change;
        }
      }
    }

    // NO PSUEDO METHOD WAS FOUND, RAISE AN ERROR
    throw('Method #missingMethodName# not found in #class()#', 'method_missing');
  }

  public boolean function persisted() {
    return !IsNull(primary_key());
  }

  public any function primary_key() {
    return invoke(this, 'get' & primary_key_field());
  }

  public void function reload() {
    if (!persisted()) return;
    this.find(primary_key());
  }

  public boolean function safe_save() {
    try {
      save();
    } catch (any err) {
      if (err.type != 'record_not_valid') application.flash.error(application.utility.errorString(err));
    }
    for (var err in errors()) application.flash.error(err);
    return errors().len() ? false : true;
  }

  public boolean function save() {
    var success = false;
    clear_errors();
    validate();
    raise_errors();
    pre_save();
    if (persisted()) {
      pre_update();
      raise_errors();
      success = update_db();
      post_update(success);
    } else {
      pre_insert();
      raise_errors();
      success = insert_db();
      post_insert(success);
    }
    post_save(success);
    return success;
  }

  public query function search(struct params) {
    throw('not implemented - define in extended class', 'not_implemented');
  }

  public query function search_paged(required StoredProc sproc, required struct params) {
    sproc.addParam(cfsqltype: 'varchar', value: utility.paging(params));
    sproc.addProcResult(name: 'qryPage', resultset: 2);
    var results = sproc.execute().getProcResultSets();
    var paging = results.qryPage.getRow(1);
    paging['count'] = results.qry.len();
    variables._pagination = utility.pagination(paging);
    if (params.keyExists('term')) variables._pagination['term'] = params.term;

    return results.qry;
  }

  public struct function pagination() {
    return variables._pagination ?: {};
  }

  public BaseModel function set(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    setter(arguments);
    return this;
  }

  public struct function toStruct() {
    var data = {}
    for (var field in GetMetaData(this).properties) data[field.name] = variables.get(field.name);
    return data;
  }

  public boolean function valid() {
    clear_errors();
    validate();
    return errors().isEmpty();
  }

  public array function where(struct params, BaseRelation relation) {
    var qry = search(argumentcollection: arguments);
    var rows = preserveNulls(qry);
    var models = [];
    for (var row in rows) {
      if (!isNull(arguments.relation)) row._relation = arguments.relation;
      models.append(new '#getMetaData().fullname#'(row, true));
    }
    return models;
  }

  public array function wrap(required query qry, BaseRelation relation) {
    var rows = preserveNulls(qry);
    var models = [];
    for (var row in rows) {
      if (!isNull(arguments.relation)) row._relation = arguments.relation;
      models.append(new '#getMetaData().fullname#'(row, true));
    }
    return models;
  }

  // PRIVATE

  private any function cast(any value, required struct field) {
    if (IsNull(arguments.get('value'))) return;
    try {
      if (field.type == 'boolean' && isBoolean(value)) return value ? true : false;
      if (field.type == 'date' && IsValid('date', value)) return cast_date(argumentcollection=arguments);
      if (field.type == 'numeric' && isNumeric(value)) return value;
      if (field.type == 'string') return format(toString(value), field);
      errors().append('Field #field.name# could not be cast to #field.type# for value `#value#`.');
    } catch (any err) {
      trap_error(err, class() & '.' & GetFunctionCalledName());
    }
  }

  private any function cast_date(any value, required struct field) {
    try {
      return parseDateTime(value);
    } catch (any err) {
      errors().append('Field #field.name# could not be cast to #field.type# for value `#value#`.');
    }
  }

  private void function clear_errors() {
    errors().clear();
  }

  private string function datasource() {
    return application.dsn;
  }

  private boolean function field_changed(required struct field) {
    var current = variables.get(field.name);
    var old = field_was(field);

    if (isNull(current) && isNull(old)) return false;
    if (isNull(current) || isNull(old)) return true;
    return current != old;
  }

  private any function field_was(required struct field) {
    return variables._db.get(field.name);
  }

  private struct function find_field(required string name) {
    for (var field in GetMetaData(this).properties) if (field.name == name) return field;
    return {};
  }

  private boolean function found(BaseModel model) {
    if (IsNull(model)) return false;
    return model.persisted();
  }

  private string function format(required string value, required struct field) {
    try {
      var method = 'format_' & field.get('format');
      if (!variables.keyExists(method)) return value;
      return variables.get(method)(value);
    } catch (any err) {
      trap_error(err, class() & '.' & GetFunctionCalledName());
    }
    return '';
  }

  private string function format_digits(required string data) {
    if (data.len()) data = data.reReplaceNoCase('[^[:digit:]]', '', 'all');
    return data;
  }

  private void function load(required struct data, boolean db = false) {
    if (db) variables._db = {};
    for (var field in GetMetaData(this).properties) {
      if (!data.keyArray().findNoCase(field.name)) continue;
      try {
        if (isNull(data[field.name])) {
          variables[field.name] = javacast('null', 0);
        } else {
          var value = cast(data[field.name], field);
          if (isNull(value)) continue; // ERROR OCCURED
          set_field(field, value);
          if (db) variables._db[field.name] = value;
        }
      } catch (any err) {
        errors().append('#err.message# for field #field.name#');
      }
    }
  }

  private void function load_db(required query qry) {
    relation_reset_all();
    if (!qry.len()) return;
    var data = preserveNulls(qry).first(); // PRESERVES NULLS IN DB
    setter(data, true);
  }

  private void function null_if_empty(required struct data, required string field) {
    if (IsNull(data.get(field))) return;
    if (data.get(field).trim().len()==0) data.delete(field);
  }

  private array function preserveNulls(required query qry) {
    try {
      return deserializeJSON(serializeJSON(qry, 'struct'));
    } catch (any err) {
      writedump(err);
      writedump(arguments);
    }
  }

  private string function primary_key_field() {
    for (var field in GetMetaData(this).properties) {
      if (field.keyExists('primary_key')) return field.name;
    }
  }

  private void function set_field(required struct field, required any value) {
    try {
      invoke(this, 'set' & field.name, [value]);
    } catch (any err) {
      if (err.type.contains('CFTypeValidatorFactory')) {
        errors().append('Field #field.name# could not be validated as #field.validate# for value `#value#`.');
      } else {
        trap_error(err, class() & '.' & GetFunctionCalledName());
      }
    }
  }

  private void function raise_errors() {
    if (errors().len()) throw('An error occured.', 'record_not_valid');
  }

  private void function require_params_all(required struct params, required array keys) {
    for (var key in keys) {
      if (params.keyExists(key)) continue;
      throw('Missing Required Parameter: ' & key, 'parameter_all_missing');
    }
  }

  private void function require_params_any(required struct params, required array keys) {
    for (var key in keys) if (params.keyExists(key)) return;
    throw('Missing Required Parameter: ' & keys.toList(), 'parameter_any_missing');
  }

  private void function setter(struct data, boolean db = false) {
    clear_errors();
    pre_load(data);
    load(argumentcollection: arguments);
    post_load();
    relation_link(data); // CHECKS IF ANOTHER MODEL IS AUTO-GENERATING THIS ONE SO IT CAN SET CHILD-PARENT RELATION
    validate();
  }

  private struct function sql_args(required struct field) {
    var args = { cfsqltype: field.sqltype, value: variables.get(field.name) };
    args.null = IsNull(args.value);
    return args;
  }

  private string function table_prefix() {
    var parts = primary_key_field().listToArray('_');
    if (parts.len()==1) return '';
    return parts[1] & '_';
  }

  private void function trap_error(required any err, string method = '') {
    //application.sentry.captureException(exception: arguments.err);
    var data = application.utility.errorString(err);
    if (method.len()) data &= ' in #method#';
    errors().append(data);
  }

  // DATABASE CRUD METHODS

  private boolean function delete_db() {
    try {
      var sproc = new StoredProc(procedure: '#class()#_delete', datasource: datasource());
      for (var field in delete_db_params()) {
        sproc.addParam(argumentcollection: sql_args(field));
      }
      sproc.addProcResult(name: 'qry', resultset: 1);
      var row = sproc.execute().getProcResultSets().qry.getRow(1);
      return (row.delete_count == 1);
    } catch (any err) {
      trap_error(err, class() & '.' & GetFunctionCalledName());
    }
    return false;
  }

  private array function delete_db_params() {
    return GetMetaData(this).properties.filter(
      function(field) { return field.keyExists('primary_key') }
    );
  }

  private boolean function insert_db() {
    try {
      var sproc = new StoredProc(procedure: '#class()#_insert', datasource: datasource());
      for (var field in GetMetaData(this).properties) {
        if (!field.keyExists('sqltype') || field.keyExists('primary_key')) continue; // SKIP NON-DB FIELDS AND PRIMARY KEY
        sproc.addParam(argumentcollection: sql_args(field));
      }
      sproc.addProcResult(name: 'qry', resultset: 1);
      var qry = sproc.execute().getProcResultSets().qry;
      load_db(qry);
    } catch (any err) {
      trap_error(err, class() & '.' & GetFunctionCalledName());
      return false;
    }
    return true;
  }

  private boolean function update_db() {
    try {
      var sproc = new StoredProc(procedure: '#class()#_update', datasource: datasource());
      for (var field in GetMetaData(this).properties) {
        if (!field.keyExists('sqltype')) continue; // SKIP NON-DB FIELDS
        sproc.addParam(argumentcollection: sql_args(field));
      }
      sproc.addProcResult(name: 'qry', resultset: 1);
      var qry = sproc.execute().getProcResultSets().qry;
      load_db(qry);
    } catch (any err) {
      trap_error(err, class() & '.' & GetFunctionCalledName());
      return false;
    }
    return true;
  }

  // MODEL TO MODEL RELATIONS
  private BaseRelation function add_relation(required struct params) {
    var subclass = GetDirectoryFromPath(GetCurrentTemplatePath()) & 'relations\#params.class#.cfc';
    var klass = fileExists(subclass) ? params.class : 'BaseRelation';
    var relation = new 'app.models.relations.#klass#'(params);
    relations().append(relation);
    return relation;
  }

  private BaseRelation function belongs_to(required string class, required string key, required string relation, string type = GetFunctionCalledName()) {
    return add_relation(arguments);
  }

  private BaseRelation function has_one(required string class, required string key, required string relation, string type = GetFunctionCalledName()) {
    return add_relation(arguments);
  }

  private BaseRelation function has_many(required string class, required string key, required string relation, string type = GetFunctionCalledName()) {
    return add_relation(arguments);
  }

  private any function relation_find(required string name) {
    var match = relations().filter(relation => relation.getName() == name);
    return match?.first();
  }

  private boolean function relation_exists(required string name) {
    return !isNull(relation_find(name));
  }

  private any function relation_load(required string name, struct params = {}) {
    var relation = relation_find(name);
    var data = relation.load(this);
    var method = params.keyList();

    if (method.len()) { // CALLING METHOD ON RELATION
      if (!structKeyExists(relation, method)) throw('Relation does not support `#method#`.', 'relation_error');
      try {
        params = params[method];
        if (isClosure(params)) params = { closure: params };
        if (isObject(params) || !isStruct(params)) params = { 1: params }; // HANDLE SIMPLE VALUES POSITIONALLY ie func('medium')
        return invoke(relation, method, params);
      } catch (any err) {
        if (err.type == 'relation_error') rethrow;
        trap_error(err, class() & '.' & GetFunctionCalledName());
        return;
      }
    }
    if (isNull(data)) return; // has_one WITH NO FKEY DEFINED
    return data;
  }

  private array function relations() {
    param variables._relations = [];
    return variables._relations;
  }

  private void function relation_reset_all() {
    for (var relation in relations()) relation.reset();
  }

  private void function relation_reset(required string name) {
    for (var relation in relations()) {
      if (relation.getName() == name) return relation.reset();
    }
  }

  public void function relation_link(required struct params) {
    if (!params.keyExists('_relation')) return;

    var klass = params._relation.getParent().class();
    for (relation in relations()) {
      if (relation.getType()=='belongs_to' && relation.getClass()==klass && isNull(relation.records())) {
        relation.load(this, params._relation.getParent());
      }
    }
  }

  // CALLBACK STUBS
  private void function pre_init(struct data) {}
  private void function post_init() {}
  private void function pre_insert() {}
  private void function post_insert(required boolean success) {}
  private void function pre_load(required struct data) {}
  private void function post_load() {}
  private void function pre_save() {}
  private void function post_save(required boolean success) {}
  private void function pre_update() {}
  private void function post_update(required boolean success) {}
  private void function post_destroy(required boolean success) {}
  private void function validate() {}
}
