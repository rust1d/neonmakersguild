<cfscript>
  mBlog = new app.services.user.Blog(1);
</cfscript>

<cfoutput>
  #router.include('shared/user/link/edit')#

  <div class='alert-info border rounded mt-3 p-3'>
    Link Types:
    <ul>
      <li><i class='fa-solid fa-fw fa-square-arrow-up-right'></i> <b>bookmark</b> - Displays as a link your member profile sidebar.</li>
      <li><i class='fa-solid fa-fw fa-school'></i> <b>Resource-Class</b> - Displays in the Class section of the resource page.</li>
      <li><i class='fa-solid fa-fw fa-link'></i> <b>Resource-Other</b> - Displays in the Other section of the resource page</li>
      <li><i class='fa-solid fa-fw fa-truck-field'></i> <b>Resource-Supplier</b> - Displays in the Supplier section of the resource page</li>
      <li><i class='fa-regular fa-sparkles'></i> <b>social media</b> - Displays as an icon in your member profile.</li>
      <li><i class='fa-regular fa-globe'></i> <b>website</b> - Displays as an icon in your member profile. Your primary website.</li>
    </ul>
  </div>
</cfoutput>