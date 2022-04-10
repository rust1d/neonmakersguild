<cfscript>
  mEntry = mBlog.entries(ben_benid: router.decode('benid')).first();
</cfscript>
<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9 border-end'>
        #router.include('shared/blog/entry', { mEntry: mEntry, fold: false })#
      </div>
      <div class='col-md-3 border-start'>
        #router.include('shared/sidebar')#
      </div>
    </div>
  </section>
</cfoutput>
