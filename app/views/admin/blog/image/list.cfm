<cfscript>
  mImages = mBlog.images();
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col-md-6'>
        <h5>Images</h5>
      </div>
      <div class='col-md-6 text-end'>
        <form method="post">
          <input type="text" name="keywords" value="#form.get('keywords')#">
          <input class='btn btn-nmg btn-sm btn-outline-dark' type="submit" value="Filter">
        </form>
      </div>
    </div>

    <div class='row mb-3'>
      <div class='col-2 text-center small'>
        <a href='#router.href('blog/image/edit')#'>
          <img src='/assets/images/image_new.png' class='w-100 img-thumbnail' />
        </a>
        <a href='#router.href('blog/image/edit')#' class='w-100 btn btn-nmg btn-sm btn-outline-dark mt-1'>
          <i class='fal fa-plus'></i>
          Add New Image
        </a>
      </div>
      <cfloop array='#mImages#' item='mImage' index='idx'>
        <div class='col-2 text-center'>
          <a href='#router.hrefenc(page: 'blog/image/edit', uiid: mImage.uiid())#'>
            <img src='#mImage.thumbnail_src()#' class='w-100 img-thumbnail' />
          </a>
          <a href='#router.hrefenc(page: 'blog/image/edit', uiid: mImage.uiid())#' class='w-100 btn btn-nmg btn-sm btn-outline-dark mt-1'>
            <i class='fal fa-pencil'></i>
            #mImage.filename()#
          </a>
          <small>#mImage.dimensions()# &bull; #mImage.size_mb()#</small>
        </div>
      </cfloop>
    </div>
  </section>
</cfoutput>
