<cfoutput>
  <span class='dropdown-center me-1'>
    <a class='btn btn-icon btn-icon-link' data-bs-toggle='dropdown' aria-expanded='false' title='#mUser.user()#&rsquo;s Bio'>
      <i class='fa-solid fa-circle-info fa-lg'></i>
    </a>
    <div class='dropdown-menu content-card member-about p-0'>
      <div class='d-flex justify-content-between align-items-start border-bottom p-2'>
        <div class='fw-semibold'>#mUser.user()#&rsquo;s Bio</div>
        <button type='button' class='btn-close' data-bs-dismiss='dropdown' aria-label='Close'></button>
      </div>
      <div class='px-3 py-2 member-about-body'>
        #mUser.UserProfile().bio()#
      </div>
    </div>
  </span>
</cfoutput>
