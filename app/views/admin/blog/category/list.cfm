<!---
TODO:
release entry
sort Categories
paging
filtering
--->
<cfscript>
  arrRows = new app.models.BlogCategories().search(bca_blog: blog.blogId(), maxrows: 50);
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col-md-6'>
        <h5>Categories</h5>
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
          <th scope="col">Category</th>
          <th scope="col">Entries</th>
        </tr>
      </thead>
      <tbody>
        <cfloop array='#utility.query_to_array(arrRows)#' item='row'>
          <cfset mBlogCategory = new app.models.BlogCategories(row) />
          <tr>
            <th scope="row">
              <a href='#router.hrefenc(page: 'blog/category/edit', bcaid: mBlogCategory.bcaid())#' class='btn btn-nmg btn-sm btn-outline-dark'>
                <i class='fal fa-pencil'></i>
              </a>
            </th>
            <td>#mBlogCategory.category()#</td>
            <td>#mBlogCategory.entryCnt()#</td>
          </tr>
        </cfloop>
      </tbody>
    </table>
  </section>
</cfoutput>
