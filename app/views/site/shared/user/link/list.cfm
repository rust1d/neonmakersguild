<cfscript>
  locals.view = session.user.view();
  locals.dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='card'>
      <div class='card-header bg-nmg'>
        <div class='row'>
          <div class='col fs-5'>Links</div>
        </div>
      </div>
      <div class='card-body'>
        <table class='table'>
          <thead>
            <tr>
              <th scope='col'><a href='#router.href('#locals.dest#/link/edit')#' class='btn btn-nmg btn-sm btn-outline-dark'><i class='fal fa-plus'></i></a></th>
              <th scope='col'>Type</th>
              <th scope='col'>Title</th>
              <th scope='col'>Url</th>
            </tr>
          </thead>
          <tbody>
            <cfloop array='#locals.mLinks#' item='locals.mLink'>
              <tr>
                <th scope='row'>
                  <a href='#router.hrefenc(page: '#locals.dest#/link/edit', bliid: locals.mLink.bliid())#' class='btn btn-nmg btn-sm btn-outline-dark'>
                    <i class='fal fa-pencil'></i>
                  </a>
                  <span class='ps-2'>#locals.mLink.social_link('2xl')#</span>
                </th>
                <td>#locals.mLink.type()#</td>
                <td>#locals.mLink.title()#</td>
                <td>#locals.mLink.url()#</td>
              </tr>
            </cfloop>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</cfoutput>
