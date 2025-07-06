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
        <div class='comment-group border rounded bg-nmg-light w-100' id='#locals.id#'>
          <div class='comment-input' contenteditable='true' role='textbox' aria-label='Write a comment...' placeholder='Write a comment...'></div>
          <div class='comment-image row mx-0'></div>
          <div class='comment-toolbar'>
            <button class='btn btn-light py-0 btnUpload text-secondary'><i class='fas fa-camera'></i></button>
            <button class='btn btn-light py-0 btnComment text-secondary'><i class='fas fa-share'></i></button>
          </div>
        </div>
      </div>
    </div>
  <cfelse>
    <div class='p-3'>
      <a href='/login'>Login</a> to leave a comment...
    </div>
  </cfif>
</cfoutput>
