component extends=BaseModel accessors=true {
  property name='up_upid'       type='numeric'  sqltype='integer'    primary_key;
  property name='up_usid'       type='numeric'  sqltype='integer';
  property name='up_firstname'  type='string'   sqltype='varchar';
  property name='up_lastname'   type='string'   sqltype='varchar';
  property name='up_bio'        type='string'   sqltype='varchar';
  property name='up_location'   type='string'   sqltype='varchar';
  property name='up_phone'      type='string'   sqltype='varchar';
  property name='up_promo'      type='string'   sqltype='varchar';
  property name='up_address1'   type='string'   sqltype='varchar';
  property name='up_address2'   type='string'   sqltype='varchar';
  property name='up_city'       type='string'   sqltype='varchar';
  property name='up_region'     type='string'   sqltype='varchar';
  property name='up_postal'     type='string'   sqltype='varchar';
  property name='up_country'    type='string'   sqltype='varchar';
  property name='up_latitude'   type='numeric'  sqltype='decimal';
  property name='up_longitude'  type='numeric'  sqltype='decimal';
  property name='up_dla'        type='date';

  belongs_to(class: 'Users',  key: 'up_usid', relation: 'us_usid');

  public query function search(struct params) {
    if (arguments.keyExists('params')) arguments = arguments.params;
    if (!isNumeric(arguments.get('maxrows'))) arguments.maxrows = -1;

    var sproc = new StoredProc(procedure: 'userprofile_search', datasource: datasource());
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('up_upid'), null: !arguments.keyExists('up_upid'));
    sproc.addParam(cfsqltype: 'integer', value: arguments.get('up_usid'), null: !arguments.keyExists('up_usid'));
    sproc.addProcResult(name: 'qry', resultset: 1, maxrows: arguments.maxrows);

    return sproc.execute().getProcResultSets().qry;
  }

  public string function name() {
    return trim(variables.up_firstname & ' ' & variables.up_lastname);
  }

  // PRIVATE

  private void function post_save() {
    if (geocode_needed()) geocode();
  }

  private boolean function geocode_needed() {
    if (!len(variables.up_city) && !len(variables.up_region)) return false;
    return field_changed('up_city') || field_changed('up_region') || field_changed('up_country');
  }

  private void function geocode() {
    var parts = [];
    if (len(variables.up_city))    parts.append(variables.up_city);
    if (len(variables.up_region))  parts.append(variables.up_region);
    if (len(variables.up_country)) parts.append(variables.up_country);
    if (!parts.len()) return;

    try {
      var result = new app.services.Geocoder().lookup(parts.toList(', '));
      if (!isNull(result)) {
        variables.up_latitude  = result.lat;
        variables.up_longitude = result.lng;
        update_db();
      }
    } catch (any e) {
      // geocoding is best-effort, don't block save
    }
  }
}
