<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9 border-end'>
        #router.include('shared/user/view', { mUser: mUser })#
      </div>
      <div class='col-md-3 border-start'>
        #router.include('shared/sidebar')#
      </div>
    </div>
  </section>
</cfoutput>
