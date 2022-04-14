<cfscript>
  locals.view = session.user.view();
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
          #router.include('shared/partials/view_and_filter')#
        </div>
      </div>
      <div class='card-body'>
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
