<cfscript>
  locals.dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
  locals.results = locals.mBlog.entries(utility.paged_term_params());
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('#locals.dest#/entry/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        <div class='col fs-5'>Entries</div>
        #router.include('shared/partials/filter_and_page', { pagination: locals.results.pagination })#
      </div>
    </div>
    <div class='card-body table-responsive'>
      <table class='table table-sm table-nmg'>
        <thead>
          <tr>
            <th scope='col'><a href='#router.href('#locals.dest#/entry/edit')#' class='btn btn-sm btn-nmg'><i class='fal fa-plus'></i></a></th>
            <th scope='col'>Title</th>
            <th scope='col'>Released</th>
            <th scope='col'>Posted</th>
            <th scope='col'>Words</th>
          </tr>
        </thead>
        <tbody>
          <cfloop array='#locals.results.rows#' item='locals.mEntry'>
            <tr>
              <th scope='row'>
                <a href='#router.hrefenc(page: '#locals.dest#/entry/edit', benid: locals.mEntry.benid())#' class='btn btn-sm btn-nmg'>
                  <i class='fal fa-pencil'></i>
                </a>
              </th>
              <td>#locals.mEntry.title()#</td>
              <td class='text-center'><i class='fa-solid #ifin(locals.mEntry.released(), 'fa-toggle-on','fa-toggle-off')# fa-xl')></i></td>
              <td nowrap>#locals.mEntry.posted()#</td>
              <td class='text-end'>#locals.mEntry.words().len()#</td>
            </tr>
          </cfloop>
        </tbody>
      </table>
    </div>
  </div>
</cfoutput>
