component {

  public Geocoder function init() {
    return this;
  }

  /**
   * Geocodes an address string using OpenStreetMap Nominatim.
   * Returns struct with lat/lng keys, or null if not found.
   */
  public any function lookup(required string address) {
    var url = 'https://nominatim.openstreetmap.org/search'
            & '?q=' & encodeForURL(arguments.address)
            & '&format=json&limit=1';

    cfhttp(url: url, method: 'GET', timeout: 10, result: 'local.response') {
      cfhttpparam(type: 'header', name: 'User-Agent', value: 'NMG-MemberMap/1.0');
    }

    if (local.response.statusCode contains '200' && isJSON(local.response.fileContent)) {
      var data = deserializeJSON(local.response.fileContent);
      if (isArray(data) && data.len()) {
        return { lat: val(data[1].lat), lng: val(data[1].lon) };
      }
    }

    return javacast('null', '');
  }

}
