<cfscript>
  locals.view = session.user.view();
  locals.dest = (mBlog.id()==1 && session.site.isA('admin')) ? 'blog' : 'user';
</cfscript>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col fs-5'>
          Images
        </div>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('#locals.dest#/image/edit')#' class='btn btn-sm btn-nmg' title='Add Image'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        #router.include('shared/partials/view_and_filter')#
      </div>
    </div>
    <div class='card-body'>
      <cfif locals.view=='list'>
        <cfloop array='#locals.mImages#' item='locals.mImage' index='idx'>
          <div class='row my-3'>
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
        </cfloop>
      <cfelse>
        <div class='row g-3'>
          <div class='col-2 text-center small'>
            <a href='#router.href('#locals.dest#/image/edit')#'>
              <img src='/assets/images/image_new.png' class='w-100 img-thumbnail' />
            </a>
          </div>
          <cfloop array='#locals.mImages#' item='locals.mImage' index='idx'>
            <div class='col-2 text-center' title='#locals.mImage.dimensions()# &bull; #locals.mImage.size_mb()#'>
              <div class='position-relative'>
                <a href='#router.hrefenc(page: '#locals.dest#/image/edit', uiid: locals.mImage.uiid())#' title='#locals.mImage.filename()#' class='align-bottom'>
                  <img src='#locals.mImage.thumbnail_src()#' class='w-100 img-thumbnail' />
                  <i class='fal fa-pencil btn btn-nmg btn-outline-dark btn-floating btn-floating-br'></i>
                </a>
              </div>
            </div>
          </cfloop>
        </div>
      </cfif>
    </div>
  </div>
</cfoutput>
