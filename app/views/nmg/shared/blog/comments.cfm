<cfoutput>
  <div id='comments' class='card border'>
    <div class='card-body'>
      <form method='post'>
        <div class='row g-3'>
          <cfif session.user.loggedIn()>
            <div class='d-none d-sm-inline col-sm-2'>
              <img class='img-thumbnail w-auto' src='#session.user.profile_image().src()#' />
            </div>
            <div class='col-12 col-sm-10'>
              <label class='form-label required' for='bco_comment'>Comment</label>
              <textarea class='form-control' rows='4' name='bco_comment' id='bco_comment' placeholder='leave a comment...'>#form.get('bco_comment')#</textarea>
            </div>
            <div class='col-12 text-center'>
              <button type='submit' name='btnComment' id='btnComment' class='btn btn-sm btn-nmg'>Post Comment</button>
            </div>
            <div id='edit_popin' class='row g-2 d-none'>
              <div class='col-12'>
                <input type='hidden' name='bcoid' />
                <textarea class='form-control' rows='4' name='edit_comment' id='edit_comment'></textarea>
              </div>
              <div class='col-12 text-center'>
                <button type='submit' name='btnCommentEdit' id='btnCommentEdit' class='btn btn-sm btn-nmg'>Save</button>
                <a id='comment-revert' class='btn btn-sm btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          <cfelse>
            <div class='col-12'>
              <a href='/login'>Login</a> to leave a comment...
            </div>
          </cfif>
          <div class='col-12 fs-5 text-uppercase'>
            #utility.plural_label(locals.mEntry.comment_cnt(), 'comment')# on "#locals.mEntry.title()#"
          </div>
          <cfloop array='#locals.mEntry.BlogComments()#' item='mComment'>
            <div class='d-none d-sm-inline col-sm-1'>
              <a href='#mComment.User().seo_link()#'>
                <img class='img-thumbnail w-auto' src='#mComment.User().profile_image().src()#' />
              </a>
            </div>
            <div class='col-12 col-sm-11'>
              <div class='small mb-2'>
                <a href='#mComment.User().seo_link()#'>#mComment.User().user()#</a>
                &bull; <small>#mComment.posted()#</small>
                <cfif len(mComment.history())>&bull; <small class='fst-italic muted' title='#mComment.edited()#'>edited</small></cfif>
                <cfif session.user.loggedIn() && mComment.usid()==session.user.usid()>&bull; <a class='comment-edit' data-bcoid='#mComment.bcoid()#' data-key='#mComment.encoded_key()#'><i class='fal fa-pencil'></i></a></cfif>
              </div>
              <div id='comment-#mComment.encoded_key()#' class='mb-3'>
                <div class='comment border rounded bg-nmg px-3 py-1'>#mComment.comment()#</div>
              </div>
            </div>
          </cfloop>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
