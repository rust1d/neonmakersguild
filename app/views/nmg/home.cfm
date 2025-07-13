<cfscript>
  results = mBlog.entries(utility.paged_term_params(ben_released: true, ben_promoted: true, maxrows: 10));
  results.pagination.next_href = '/blog';
  results.pagination.prev_href = '';
  section = 'front';
</cfscript>

<cfoutput>
  <cfif results.pagination.first>
    <cfset mHero = mBlog.textblock_by_label('home-hero') />
    <cfif mHero.persisted()>
      <div class='row mt-3'>
        <div class='col-12'>
          #mHero.body_cdn()#
        </div>
      </div>
    </cfif>
  </cfif>

  <div class='row g-2'>
    #router.include('shared/blog/entries', { results: results, section: section })#
  </div>
</cfoutput>
