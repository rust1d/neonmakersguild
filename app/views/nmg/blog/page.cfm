<cfscript>
  mPage = mBlog.page_by_alias(url.page ?: '');
</cfscript>

<cfoutput>
  <div class='row'>
    <div class='col'>
      #router.include('shared/blog/page', { mPage: mPage })#
    </div>
  </div>
</cfoutput>
