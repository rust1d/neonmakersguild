<cfoutput>
  <cfif mUser.UserProfile().bio().len()>
    <a class='btn btn-icon btn-icon-link me-1' href='#mUser.seo_link()#/about' title='#mUser.user()#&rsquo;s Bio'>
      <i class='fa-solid fa-circle-info fa-lg'></i>
    </a>
  </cfif>
</cfoutput>
