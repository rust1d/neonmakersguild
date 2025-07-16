<cfoutput>
  #router.include('shared/user/link/edit', { mBlog: mUserBlog })#

  <div class='alert-info border rounded mt-3 p-3'>
    <div class='fw-semibold'>Link Types:</div>

    <div class='border-bottom my-2'>
      <i class='roundy d-inline-flex mt-0 me-2 fa-solid fa-fw fa-globe'></i>
      <span class='fw-semibold w-120px d-inline-block'>website</span>
      Your primary personal website. Displays directly on your member profile.
    </div>

    <div class='border-bottom my-2'>
      <i class='roundy d-inline-flex mt-0 me-2 fa-solid fa-fw fa-link'></i>
      <span class='fw-semibold w-120px d-inline-block'>bookmark</span>
      Link to a general website. Displays in the "Links" popout on your member profile.
    </div>

    <div class='border-bottom my-2'>
      <i class='roundy d-inline-flex mt-0 me-2 fa-brands fa-fw fa-untappd'></i>
      <span class='fw-semibold w-120px d-inline-block'>social media</span>
      A social media website. Displays directly on your member profile.
    </div>
  </div>
</cfoutput>
