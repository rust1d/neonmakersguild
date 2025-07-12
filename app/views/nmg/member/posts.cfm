<cfscript>
  results = { rows: new app.models.BlogEntries().where(ben_blog: mUser.usid(), ben_released: true, maxrows: 5) };
  results.pagination = request.pagination.last;
  section = 'user';
</cfscript>

<cfoutput>
  #router.include('shared/blog/entries', { results: results, section: section })#
</cfoutput>
