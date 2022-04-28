<cfscript>
  try {
    mForum = new app.models.Forums().find(url.foid);
    mThread = new app.models.ForumThreads().find(url.ftid);
    if (mThread.alias()!=url.thread) throw(type: 'record_not_found');
  } catch (record_not_found err) {
    router.go(mForum.seo_link());
  }

  if (session.user.loggedIn() && form.keyExists('btnSubmit')) {
    if (form.fm_body.len()==0) {
      flash.error('A message body is required.');
    } else {
      form.fm_foid = mForum.foid();
      form.fm_ftid = mThread.ftid();
      form.fm_usid = session.user.usid();
      mMessage = new app.models.ForumMessages(form);
      if (mMessage.safe_save()) {
        mThread.messages_inc();
        mThread.last_fmid(mMessage.fmid());
        mThread.safe_save();
        mForum.messages_inc();
        mForum.last_fmid(mMessage.fmid());
        mForum.safe_save();
      }
    }
  }

  mBlock = mBlog.textblock_by_label('forum-' & mForum.alias());
</cfscript>

<cfoutput>
  <div class='row g-3 pt-3'>
    <cfif mBlock.persisted()>
      <div class='col-12'>
        #mBlock.body()#
      </div>
    </cfif>
    <div class='col-12'>
      <nav aria-label='breadcrumb'>
        <ol class='breadcrumb small m-0'>
          <li class='breadcrumb-item'><a href='/forums'>Forums</a></li>
          <li class='breadcrumb-item'><a href='#mForum.seo_link()#'>#mForum.name()#</a></li>
          <li class='breadcrumb-item active' aria-current='page'><a href='#mThread.seo_link()#'>#mThread.subject()#</a></li>
        </ol>
      </nav>
    </div>
    <div class='col-12'>
      <div class='fs-4'>
        <a href='#mThread.seo_link()#'>#mThread.subject()#</a>
      </div>
      <div>
        <a href='#mThread.User().seo_link()#'>#mThread.User().user()#</a>
        &bull;
        <a href='#mThread.seo_link()#' class='small'>#mThread.posted()#</a>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <div class='card-header'>
          <div class='row'>
            <cfif !session.user.loggedIn()>
              <div class='col'>
                <a href='/login' class='btn btn-sm btn-nmg' title='Login'>
                  <i class='fas fa-person-dots-from-line'></i> Login to post
                </a>
              </div>
            </cfif>
            #router.include('shared/partials/pager', { page: 1, records: mThread.ForumMessages().len() })#
            #router.include('shared/partials/view_and_filter', { viewer: false })#
          </div>
        </div>
        <cfloop array='#mThread.ForumMessages()#' item='mMessage' index='idx'>
          <div class='row g-0 bg-nmg border-top border-nmg'>
            <div class='col-auto text-center'>
              <div class='pt-4 thread-user'>
                <a href='#mMessage.User().seo_link()#'>
                  <img class='thread-thumbnail img-thumbnail rounded' src='#mMessage.User().profile_image().src()#' />
                </a>
                <div><a href='#mMessage.User().seo_link()#'>#mMessage.User().user()#</a></div>
                <div class='smaller'>#mMessage.User().UserProfile().location()#</div>
              </div>
            </div>
            <div class='col'>
              <div class='smaller px-3 mt-1'>
                <span class='ms-3'><a href='#mMessage.seo_link()#'>#mMessage.posted()#</a></span>
                <span class='float-end me-3'>Post ###idx#</span>
              </div>
              <div class='border bg-nmg-light me-2 mb-2 p-3 thread-message'>
                #mMessage.body()#
              </div>
            </div>
          </div>
        </cfloop>

        <cfif session.user.loggedIn()>
          <div class='row g-0 bg-nmg border-top border-nmg'>
            <div class='col-auto text-center'>
              <div class='pt-2 thread-user'>
                <img class='thread-thumbnail img-thumbnail rounded' src='#session.user.profile_image().src()#' />
                <div><a href='#session.user.seo_link()#'>#session.user.user()#</a></div>
                <div class='smaller'>#session.user.UserProfile().location()#</div>
              </div>
            </div>
            <div class='col'>
              <form method='post' class='needs-validation' novalidate autocomplete='off'>
                <div class='border bg-nmg-light me-2 my-2 p-3 thread-message'>
                  <div class='row g-3'>
                    <div class='col-12'>
                      <textarea class='form-control tiny-forum' rows='8' name='fm_body' id='fm_body'></textarea>
                    </div>
                    <div class='col-12 text-center'>
                      <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-sm btn-nmg'>Post Reply</button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </cfif>

        <div class='card-footer'>
          <div class='row'>
            <div class='col-2'>
              Messages #mThread.messages()#
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
