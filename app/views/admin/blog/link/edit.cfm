<cfoutput>
  #router.include('shared/user/link/edit', { mBlog: mBlog })#

  <div class='alert-info border rounded mt-3 p-3'>
    <div class='fw-semibold'>Link Types:</div>

    <div class='border-bottom my-2'>
      <i class='roundy d-inline-flex mt-0 me-2 fa-brands fa-fw fa-untappd'></i>
      <span class='fw-semibold w-200px d-inline-block'>social media</span>
      Displays as an icon in the website footer.
    </div>

    <div class='border-bottom my-2'>
      <i class='roundy d-inline-flex mt-0 me-2 fa-solid fa-fw fa-school'></i>
      <span class='fw-semibold w-200px d-inline-block'>Resource-Class</span>
      Displays in the Neon Classes section on the Learn Menu.
    </div>
    <div class='border-bottom my-2'>
      <i class='roundy d-inline-flex mt-0 me-2 fa-solid fa-fw fa-link'></i>
      <span class='fw-semibold w-200px d-inline-block'>Resource-Other</span>
      Displays in the General Resources section on the Learn Menu.
    </div>
    <div class='border-bottom my-2'>
      <i class='roundy d-inline-flex mt-0 me-2 fa-solid fa-fw fa-truck-field'></i>
      <span class='fw-semibold w-200px d-inline-block'>Resource-Supplier</span>
      Displays in the Suppliers section on the Learn Menu.
    </div>
  </div>
</cfoutput>