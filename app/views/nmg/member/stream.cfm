<cfscript>
  mEntries = new app.models.BlogEntries().stream(utility.paged_term_params(days: 30, count: 3, maxrows: 10));
  pagination = request.pagination.last;
  mHero = mBlog.textblock_by_label('stream-hero');
</cfscript>

<cfoutput>
  <cfif pagination.page lt 2>
    <cfset mHero = mBlog.textblock_by_label('stream-hero') />
    <cfif mHero.persisted()>
      <div class='row mt-3'>
        <div class='col-12'>
          #mHero.body_cdn()#
        </div>
      </div>
    </cfif>
  </cfif>

  <cfif mEntries.len()>
    <div class='row g-3'>
      <cfloop array='#mEntries#' item='mEntry' index='idx'>
        <div class='col-12'>
          #router.include('shared/blog/summary', { mEntry: mEntry })#
        </div>
      </cfloop>
      <cfif !pagination.one_page>
        <div class='col-4 text-center text-uppercase'>
          <cfif !pagination.first>
            <a href='#utility.page_url_prev(pagination)#'><i class='fa-solid fa-xl fa-caret-left'></i> Newer Posts</a>
          </cfif>
        </div>
        <div class='col-4 text-center text-uppercase'>
          Page #pagination.page# of #pagination.pages#
        </div>
        <div class='col-4 text-center text-uppercase'>
          <cfif !pagination.last>
            <a href='#utility.page_url_next(pagination)#'>Older posts <i class='fa-solid fa-xl fa-caret-right'></i></a>
          </cfif>
        </div>
      </cfif>
    </div>
  <cfelse>
    <p>There are no recent blog entries by members.</p>
  </cfif>
</cfoutput>
