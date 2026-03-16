<cfscript>
  setting showdebugoutput='no';
  sproc = new StoredProc(procedure: 'users_map', datasource: application.datasource);
  sproc.addProcResult(name: 'qry', resultset: 1);
  qryUsers = sproc.execute().getProcResultSets().qry;
</cfscript>

<cfset router.include('layout/_head_leaflet') />

<cfoutput>
  <div class='row'>
    <div class='col-12 content-card'>
      <div class='row pb-3 g-2 align-items-center'>
        <div class='col fs-4 text-marker'>NMG Members Map</div>
        <div class='col-auto'>
          <a href='/?p=member/list' class='btn btn-outline-nmg rounded-pill btn-sm'>
            <i class='fa-solid fa-list me-1'></i> List View
          </a>
        </div>
      </div>
      <div id='member-map' style='height:600px;border-radius:.5rem'></div>
    </div>
  </div>

  <script>
    var mapUsers = [
      <cfloop query='qryUsers'>
        {
          usid: #qryUsers.us_usid#,
          user: '#encodeForJavaScript(qryUsers.us_user)#',
          name: '#encodeForJavaScript(trim(qryUsers.up_firstname & ' ' & qryUsers.up_lastname))#',
          location: '#encodeForJavaScript(qryUsers.up_location)#',
          lat: #qryUsers.up_latitude#,
          lng: #qryUsers.up_longitude#,
          img: '#application.urls.cdn#/assets/images/profile/#qryUsers.us_usid MOD 10#/#utility.hashCC(qryUsers.us_usid)#.jpg',
          placeholder: '#application.urls.cdn#/assets/images/profile_placeholder.png',
          link: '/member/#utility.slug(qryUsers.us_user)#'
        }<cfif qryUsers.currentRow LT qryUsers.recordCount>,</cfif>
      </cfloop>
    ];
  </script>
</cfoutput>

<script src='/assets/js/member-map.js'></script>
