<!---
TODO:
release entry
sort entries
paging
filtering
--->
<cfscript>
  mEntries = mBlog.entries();
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col-md-6'>
        <h5>Entries</h5>
      </div>
      <div class='col-md-6 text-end'>
        <form method="post">
          <input type="text" name="keywords" value="#form.get('keywords')#">
          <input class='btn btn-nmg btn-sm btn-outline-dark' type="submit" value="Filter">
        </form>
      </div>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th scope="col"><a href='#router.href('blog/entry/edit')#' class='btn btn-nmg btn-sm btn-outline-dark'><i class='fal fa-plus'></i></a></th>
          <th scope="col">Title</th>
          <th scope="col">Released</th>
          <th scope="col">Posted</th>
          <th scope="col">Views</th>
        </tr>
      </thead>
      <tbody>
        <cfloop array='#mEntries#' item='mEntry'>
          <tr>
            <th scope="row">
              <a href='#router.hrefenc(page: 'blog/entry/edit', benid: mEntry.benid())#' class='btn btn-nmg btn-sm btn-outline-dark'>
                <i class='fal fa-pencil'></i>
              </a>
            </th>
            <td>#mEntry.title()#</td>
            <td>#mEntry.released()#</td>
            <td>#mEntry.posted()#</td>
            <td>#mEntry.views()#</td>
          </tr>
        </cfloop>
      </tbody>
    </table>
  </section>
</cfoutput>
