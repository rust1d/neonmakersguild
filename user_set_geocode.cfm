<cfscript>
  setting showdebugoutput='no' requesttimeout=600;

  try {
    geocoder = new app.services.Geocoder();

    qry = queryExecute("
      SELECT up_upid, up_city, up_region, up_country
        FROM userprofile
             INNER JOIN users ON us_usid = up_usid
       WHERE us_deleted IS NULL
         AND up_latitude IS NULL
         AND (up_city IS NOT NULL AND up_city <> '')
       ORDER BY up_upid
    ", {}, { datasource: application.dsn });

    results = [];

    for (row in qry) {
      parts = [];
      if (len(row.up_city))    parts.append(row.up_city);
      if (len(row.up_region))  parts.append(row.up_region);
      if (len(row.up_country)) parts.append(row.up_country);
      address = parts.toList(', ');

      geo = geocoder.lookup(address);
      status = 'not found';

      if (!isNull(geo)) {
        queryExecute("
          UPDATE userprofile SET up_latitude = :lat, up_longitude = :lng WHERE up_upid = :upid
        ", {
          lat:  { value: geo.lat, cfsqltype: 'float' },
          lng:  { value: geo.lng, cfsqltype: 'float' },
          upid: { value: row.up_upid, cfsqltype: 'integer' }
        }, { datasource: application.dsn });
        status = 'OK (#geo.lat#, #geo.lng#)';
      }

      results.append({ upid: row.up_upid, address: address, status: status });

      // Nominatim rate limit: 1 request per second
      sleep(1100);
    }
  } catch (any err) {
    writedump(err);
  }
</cfscript>

<cfoutput>
  <h3>Batch Geocode Results</h3>
  <p>Processed #results.len()# profiles</p>
  <table border='1' cellpadding='5'>
    <tr><th>UPID</th><th>Address</th><th>Status</th></tr>
    <cfloop array='#results#' item='r'>
      <tr>
        <td>#r.upid#</td>
        <td>#encodeForHTML(r.address)#</td>
        <td>#r.status#</td>
      </tr>
    </cfloop>
  </table>
</cfoutput>
