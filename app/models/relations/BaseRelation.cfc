component accessors=true {
  property name='name'      type='string';
  property name='class'     type='string';
  property name='key'       type='string';
  property name='relation'  type='string';
  property name='type'      type='string';
  property name='children'  type='array';
  property name='parent'    type='BaseModel';
  property name='where'     type='struct';

  public BaseRelation function init(required struct params) {
    variables.class = params.get('class');
    variables.name = params.get('name');
    param variables.name = variables.class;
    variables.key = params.get('key');
    variables.relation = params.get('relation');
    variables.type = params.get('type');
    variables.where = params.get('where');
    param variables.where = {};

    return this;
  }

  public BaseModel function build(struct params) {
    if (singlar_exists()) throw('Relation is singlar and does not support `build`.', 'relation_error');

    if (arguments.keyExists('params')) arguments = arguments.params;
    param variables.children = [];

    arguments.append(variables.where, false);
    arguments[relation] = fkey();
    var mModel = new 'app.models.#variables.class#'(arguments);
    variables.children.append(mModel);
    return mModel;
  }

  public any function detect() { // RETURNS THE FIRST CHILD MATCHING params OR NULL
    if (singlar()) throw('Relation is singlar and does not support `detect`.', 'relation_error');
    try {
      var closer = arguments.get('closure');
      if (isNull(closer)) {
        var args = arguments; // HELPS W/CLOSURE CLARITY
        closer = mRow => mRow.matches(args);
      }
      var rows = records().filter(closer);
      return rows?.first();
    } catch (any err) {
      throw('An error occurred calling `detect`. #err.message#', 'relation_error');
    }
  }

  public array function filter() { // RETURNS ARRAY OF CHILDREN MATCHING params
    if (singlar()) throw('Relation is singlar and does not support `filter`.', 'relation_error');
    try {
      var closer = arguments.get('closure');
      if (isNull(closer)) {
        var args = arguments; // HELPS W/CLOSURE CLARITY
        closer = mRow => mRow.matches(args);
      }
      return records().filter(closer);
    } catch (any err) {
      throw('An error occurred calling `filter`. #err.message#', 'relation_error');
    }
  }

  public any function load(required BaseModel parent, BaseModel child) {
    if (IsNull(variables.children)) {
      variables.parent = arguments.parent;
      if (arguments.keyExists('child')) {
        variables.children = [ arguments.child ];
        fkey(); // SETS VAR
      } else {
        create_children();
      }
    }
    return records();
  }

  public boolean function loaded() {
    return !isNull(variables.children);
  }

  public array function map() { // RETURNS ARRAY OF VALUES
    if (singlar()) throw('Relation is singlar and does not support `map`.', 'relation_error');
    try {
      var closer = arguments.get('closure');
      if (isNull(closer)) {
        var field = arguments[1];
        closer = mRow => invoke(mRow, field);
      }
      return records().map(closer);
    } catch (any err) {
      throw('An error occurred calling `map`. #err.message#', 'relation_error');
    }
  }

  public any function records() {
    // IF WE HAVE CHILDREN AND PARENT KEY DOES NOT MATCH CHILD FKEY() RELOAD CHILDREN ie student.sport1id UPDATED TO NEW ID SO MODEL NEEDS TO RELOAD
    if (!isNull(variables.children) && !isNull(variables._fkey)) {
      if (variables._fkey != invoke(variables.parent, variables.key)) {
        reset();
      }
    }
    if (isNull(variables.children)) {
      create_children();
      if (isNull(variables.children)) {
        if (singlar()) return;
        return [];
      }
    }
    if (singlar()) {
      if (variables.children.len()) return variables.children.first();
      return;
    }
    return variables.children;
  }

  public void function reset() { // FORCES EVERYTHING TO REFRESH FROM DB
    clear_children();
    reload_parent_key();
  }

  public array function sort() {
    if (singlar()) throw('Relation is singlar and does not support `sort`.', 'relation_error');

    if (variables.children.isEmpty()) return records(); // NOTHING TO SORT
    try {
      if (arguments.keyExists('closure')) return variables.children.sort(arguments.closure);

      var params = {};
      if (arguments.keyExists('1')) { // SINGLE STRING WAS PASSED, ASSUME IT WAS A FIELD NAME
        params.key = arguments[1];
      } else if (arguments.keyExists('key')) { // STRUCT WAS PASSED WITH KEY DEFINED
        params.key = arguments.key;
        if (listFind('text,textnocase,numeric,date', arguments.get('type'))) params.type = arguments.type;
        if (arguments.get('order') == 'desc') params.order = -1;
      }
      param params.type = 'text';
      param params.order = 1;
      return variables.children.sort((m1, m2) => comparer(params, m1, m2) );
    } catch (any err) {
      throw('An error occurred calling `sort`. #err.message#', 'relation_error');
    }
  }

  // PRIVATE

  private void function clear_children() {
    variables.delete('children');
  }

  private numeric function comparer(required struct params, required baseModel m1, required baseModel m2) {
    var rtn = 0;
    try {
      var v1 = invoke(m1, params.key);
      param v1 = '';
      var v2 = invoke(m2, params.key);
      param v2 = '';
      if (params.type == 'numeric') {
        if (!isNumeric(v1)) v1 = 0;
        if (!isNumeric(v2)) v2 = 0;
        rtn = ((v1 > v2) ? 1 : (v1 < v2) ? -1 : 0);
      } else if (params.type == 'date') {
        if (!isDate(v1)) v1 = now();
        if (!isDate(v2)) v2 = now();
        rtn = dateCompare(v1, v2);
      } else {
        rtn = (params.type == 'text') ? compare(v1, v2) : compareNoCase(v1, v2);
      }
    } catch (any err) {}

    return params.order * rtn;
  }

  private void function create_children() {
    if (isNull(fkey())) return;

    var mModel = new 'app.models.#variables.class#'();
    var params = variables.where.duplicate();
    params[variables.relation] = fkey();
    variables.children = mModel.where(params, this);
  }

  private any function fkey() {
    if (IsNull(variables.parent)) return;

    if (isNull(variables._fkey)) {
      variables._fkey = invoke(variables.parent, variables.key);
    }

    return variables.get('_fkey');
  }

  private void function reload_parent_key() {
    variables.delete('_fkey'); // DELETING _fkey IS SUFFICENT. IT WILL RELOAD ON NEXT REQUEST FOR IT
  }

  private boolean function singlar() {
    return ListFind('belongs_to,has_one', variables.type);
  }

  private boolean function singlar_exists() {
    if (!singlar()) return false;
    return arraylen(variables.get('children') ?: []) > 0;
  }
}
