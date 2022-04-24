<cfscript>
  mPage = mBlog.page_by_alias(url.page ?: '');
</cfscript>

<cfoutput>
    #router.include('shared/blog/page', { mPage: mPage })#
</cfoutput>
