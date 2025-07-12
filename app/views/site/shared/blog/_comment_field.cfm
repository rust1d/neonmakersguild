<cfscript>
  param locals.id = 'comment_field';
</cfscript>

<cfoutput>
  <cfif session.user.loggedIn()>
    <div class='d-flex align-items-start'>
      <a href='#session.user.seo_link()#' class='me-2'>
        <img class='forum-thumbnail rounded' src='#session.user.profile_image().src()#' />
      </a>
      <div class='flex-grow-1'>
        <div class='comment-input-group border rounded bg-nmg-light w-100' id='#locals.id#'>
          <div class='comment-input' contenteditable='true' role='textbox' aria-label='Write a comment...' placeholder='Write a comment...'></div>
          <div class='comment-image row g-1 mx-0 px-2 py-1'></div>
          <div class='comment-toolbar'>
            <button name='btnUpload' type='button' class='btn btn-light py-0 text-nmg' title='Upload Image'><i class='fas fa-camera'></i></button>
            <button name='btnComment' type='button' class='btn btn-light py-0 text-secondary' title='Post'><i class='fas fa-share'></i></button>
          </div>
        </div>
      </div>
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
    <div class='p-3 position-relative'>
      <a class='stretched-link' href='/login'>Login</a> to leave a comment...
    </div>
  </cfif>
</cfoutput>
