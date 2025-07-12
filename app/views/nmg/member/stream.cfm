<cfscript>
  mBEs = new app.models.BlogEntries().stream(utility.paged_term_params(days: 5000, count: 50, maxrows: 15)); // NO LIMITS FOR NOW
  section = 'stream';
  pagination = request.pagination.last;
  mHero = mBlog.textblock_by_label('stream-hero');
</cfscript>

<cfset include_js('assets/js/blog/modals.js') />

<cfoutput>
  <cfif pagination.page lt 2>
    <cfset mHero = mBlog.textblock_by_label('stream-hero') />
    <cfif mHero.persisted()>
      <div class='row g-3 mb-3'>
        <div class='col-12'>
          #mHero.body_cdn()#
        </div>
      </div>
    </cfif>
  </cfif>

  <cfif mBEs.len()>
    <div class='row g-3'>
      <cfloop array='#mBEs#' item='mBE' index='idx'>
        <div class='col-12 content-card p-0'>
          #router.include('shared/blog/summary', { mBE: mBE, section: section })#
        </div>
      </cfloop>
      <cfif !pagination.one_page>
        <div class='col-4 text-center text-uppercase'>
          <cfif !pagination.first>
            <a href='#utility.page_url_prev(pagination)#'><i class='fa-solid fa-fw fa-xl fa-caret-left'></i> Newer Posts</a>
          </cfif>
        </div>
        <div class='col-4 text-center text-uppercase'>
          Page #pagination.page# of #pagination.pages#
        </div>
        <div class='col-4 text-center text-uppercase'>
          <cfif !pagination.last>
            <a href='#utility.page_url_next(pagination)#'>Older posts <i class='fa-solid fa-fw fa-xl fa-caret-right'></i></a>
          </cfif>
        </div>
      </cfif>
    </div>
  <cfelse>
    <p>There are no recent blog entries by members.</p>
  </cfif>
</cfoutput>
