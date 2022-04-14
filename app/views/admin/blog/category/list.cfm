<cfscript>
  arrCategories = mBlog.Categories();
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col-md-6'>
        <h5>Categories</h5>
      </div>
      <div class='col-md-6 text-end'>
        <form method='post'>
          <input type='text' name='keywords' value='#form.get('keywords')#'>
          <input class='btn btn-nmg btn-sm btn-outline-dark' type='submit' value='Filter'>
        </form>
      </div>
    </div>

    <table class='table'>
      <thead>
        <tr>
          <th scope='col'><a href='#router.href('blog/category/edit')#' class='btn btn-nmg btn-sm btn-outline-dark'><i class='fal fa-plus'></i></a></th>
          <th scope='col'>Category</th>
          <th scope='col'>Entries</th>
        </tr>
      </thead>
      <tbody>
        <cfloop array='#arrCategories#' item='mCategory'>
          <tr>
            <th scope='row'>
              <a href='#router.hrefenc(page: 'blog/category/edit', bcaid: mCategory.bcaid())#' class='btn btn-nmg btn-sm btn-outline-dark'>
                <i class='fal fa-pencil'></i>
              </a>
            </th>
            <td>#mCategory.category()#</td>
            <td>#mCategory.entryCnt()#</td>
          </tr>
        </cfloop>
      </tbody>
    </table>
  </section>
</cfoutput>
