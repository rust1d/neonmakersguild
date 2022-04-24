<cfscript>
  mBlog = mUser.blog();
</cfscript>

<cfoutput>
  #router.include('shared/user/link/edit')#

  <div class='alert-info border rounded mt-3 p-3'>
    Link Types:
    <ul>
      <li><i class='fa-solid fa-square-arrow-up-right'></i> <b>bookmark</b> - Displays as a link your member profile sidebar.</li>
      <li><i class='fa-regular fa-sparkles'></i> <b>social media</b> - Displays as an icon in your member profile.</li>
      <li><i class='fa-regular fa-globe'></i> <b>website</b> - Displays as an icon in your member profile. Your primary website.</li>
    </ul>
  </div>
</cfoutput>
