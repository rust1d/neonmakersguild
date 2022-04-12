<cfscript>
  locals.view = session.user.gets('view');
  locals.dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
</cfscript>

<cfoutput>
  <section class='container'>
    <div class='card'>
      <div class='card-header bg-nmg'>
        <div class='row'>
          <div class='col fs-5'>
            Images
          </div>
          <div class='col-auto'>
            <form method='post'>
              <div class='input-group input-group-sm'>
                  <input type='text' class='form-control' name='term' placeholder='search...' aria-label='Search' required>
                  <button class='btn btn-nmg btn-sm btn-outline-dark' type='submit'><i class='fa fa-search'></i></button>
              </div>
            </form>
          </div>
          <div class='col-auto'>
            <form method='post'>
              <div class='btn-group' role='group'>
                <button class='btn btn-nmg btn-sm btn-outline-dark' type='#ifin(locals.view=='grid', 'button', 'submit')#' name='btnView' value='grid'><i class='#ifin(locals.view=='grid', 'text-white')# fad fa-th '></i></button>
                <button class='btn btn-nmg btn-sm btn-outline-dark' type='#ifin(locals.view!='grid', 'button', 'submit')#' name='btnView' value='list'><i class='#ifin(locals.view!='grid', 'text-white')# fad fa-list'></i></button>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class='card-body border-left border-right'>
        <cfif locals.view=='list'>
          <a href='#router.href('#locals.dest#/image/edit')#' class='btn btn-nmg btn-sm btn-outline-dark mt-1'>
            <i class='fal fa-plus'></i> Add Image
          </a>
          <cfloop array='#locals.mImages#' item='locals.mImage' index='idx'>
            <div class='row'>
              <div class='row p-2 my-2 border'>
                <div class='col-3'>
                  <a href='#router.hrefenc(page: '#locals.dest#/image/edit', uiid: locals.mImage.uiid())#'>
                    <img class='img-thumbnail w-75' src='#locals.mImage.image_src()#' />
                  </a>
                </div>
                <div class='col-9'>
                  <div class='lead'>
                    <a href='#router.hrefenc(page: '#locals.dest#/image/edit', uiid: locals.mImage.uiid())#'>
                      <i class='fal fa-pencil'></i> #locals.mImage.filename()#
                    </a>
                    </div>
                  <div>#locals.mImage.dimensions()# &bull; #locals.mImage.size_mb()#</div>
                  <div class='text-muted'>
                    <i class='fal fa-copy'></i> <span class='clipable' data-clip='#locals.mImage.image_src()#'>#locals.mImage.image_src()#</span> (#locals.mImage.dimensions()#)
                  </div>
                  <div class='text-muted'>
                    <i class='fal fa-copy'></i> <span class='clipable' data-clip='#locals.mImage.thumbnail_src()#'>#locals.mImage.thumbnail_src()#</span> (thumbnail)
                  </div>
                </div>
              </div>
            </div>
          </cfloop>
        <cfelse>
          <div class='row'>
            <div class='col-2 text-center small'>
              <a href='#router.href('#locals.dest#/image/edit')#'>
                <img src='/assets/images/image_new.png' class='w-100 img-thumbnail' />
              </a>
              <a href='#router.href('#locals.dest#/image/edit')#' class='w-100 btn btn-nmg btn-sm btn-outline-dark mt-1'>
                <i class='fal fa-plus'></i> Add Image
              </a>
            </div>
            <cfloop array='#locals.mImages#' item='locals.mImage' index='idx'>
              <div class='col-2 text-center' title='#locals.mImage.dimensions()# &bull; #locals.mImage.size_mb()#'>
                <a href='#router.hrefenc(page: '#locals.dest#/image/edit', uiid: locals.mImage.uiid())#'>
                  <img src='#locals.mImage.thumbnail_src()#' class='w-100 img-thumbnail' />
                </a>
                <a href='#router.hrefenc(page: '#locals.dest#/image/edit', uiid: locals.mImage.uiid())#' class='w-100 btn btn-nmg btn-sm btn-outline-dark mt-1'>
                  <i class='fal fa-pencil'></i> #locals.mImage.filename()#
                </a>
              </div>
            </cfloop>
          </div>
        </cfif>
      </div>
      <div class='card-footer bg-nmg border-top-0 text-end small'>#mBlog.name()#</div>
    </div>
  </section>
</cfoutput>
