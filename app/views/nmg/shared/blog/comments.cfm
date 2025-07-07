<cfoutput>
  <div id='comments' class='post-comments'>
    <form method='post'>
      <cfif session.user.loggedIn()>
        #router.include('shared/blog/_comment_field')#

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
        <div class='p-3 position-relative'>
          <a class='stretched-link' href='/login'>Login</a> to leave a comment...
        </div>
      </cfif>
      <cfloop array='#locals.mBE.BlogComments()#' item='locals.mComment'>
        #router.include('shared/blog/_comment', { mComment: locals.mComment })#
      </cfloop>
    </form>
  </div>
</cfoutput>
