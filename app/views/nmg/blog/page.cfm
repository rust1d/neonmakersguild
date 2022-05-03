<cfscript>
  // mPage = mBlog.page_by_alias(url.page ?: '');
  mPage = mBlog.page_find_or_create(router.decode('bpaid'));
</cfscript>

<cfoutput>
    #router.include('shared/blog/page', { mPage: mPage })#
</cfoutput>
