<cfscript>
  mPage = mBlog.page_by_alias(url.page);
  if (mPage.new_record()) {

  }
</cfscript>
<cfoutput>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9 border-end'>
        #router.include('shared/blog/page', { mPage: mPage })#
      </div>
      <div class='col-md-3 border-start'>
        #router.include('shared/sidebar')#
      </div>
    </div>
  </section>
</cfoutput>
