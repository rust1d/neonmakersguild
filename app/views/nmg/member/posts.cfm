<cfscript>
  string function morecols(numeric idx, numeric size) {
    if (idx==1) return 'col-12';
    if (size%2==0 && idx==2) return 'col-12';
    return 'col-6'
  }

  results = { rows: new app.models.BlogEntries().where(ben_blog: mUser.usid(), ben_released: true, maxrows: 5) };
  results.pagination = request.pagination.last;
</cfscript>

<cfoutput>
  #router.include('shared/blog/entries', { results: results })#
</cfoutput>
