<cfscript>
  map_pins = [];
  for (mUser in mUsers) {
    mUserProfile = mUser.UserProfile();
    if (isNull(mUserProfile.latitude())) continue;
    map_pins.append({
      'usid': mUser.usid(),
      'user': mUser.user(),
      'name': mUserProfile.name(),
      'location': mUserProfile.location(),
      'lat': mUserProfile.latitude(),
      'lng': mUserProfile.longitude(),
      'img': mUser.profile_image().src(),
      'link': mUser.seo_link()
    });
  }
</cfscript>

<cfset router.include('layout/_head_leaflet') />
<cfset include_js('/assets/js/member-map.js') />

<cfoutput>
  <script data-json='map_pins' type='application/json'>
    #serializejson(map_pins)#
  </script>

  <div id='member-map' style='height:600px;border-radius:.5rem'></div>
  <div class='text-center text-muted small mt-2'>Zoom out to see all members worldwide</div>
</cfoutput>
