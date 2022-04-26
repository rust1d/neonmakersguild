<cfscript>
  try {
    mForum = new app.models.Forums().find(url.foid);
  } catch (record_not_found err) {
    router.go('/forums');
  }

  if (session.user.loggedIn() && form.keyExists('btnSubmit')) {
    if (form.fm_body.len()==0) {
      flash.error('A message body is required to start a new thread.');
    } else {
      form.ft_foid = mForum.foid();
      form.ft_usid = session.user.usid();
      mThread = new app.models.ForumThreads(form);
      if (mThread.safe_save()) {
        mForum.threads_inc();
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
        }
        mForum.safe_save();
      }
    }
  }

  mBlock = mBlog.textblock_by_label('forum-' & mForum.alias());
</cfscript>

<script>
  $(function() {
    $('#ft_subject').on('blur', function() {
      if (this.value.length==0) {
        $('div.message-field').slideUp();
      }
    });

    $('#ft_subject').on('focus', function() {
      if (this.value.length==0) {
        $('div.message-field').slideDown();
      }
    });

  })
</script>

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
          <li class='breadcrumb-item active' aria-current='page'><a href='#mForum.seo_link()#'>#mForum.name()#</a></li>
        </ol>
      </nav>
    </div>
    <div class='col-12'>
      <div class='fs-4'>
        <a href='#mForum.seo_link()#'>#mForum.name()#</a>
      </div>
      <div>
        #mForum.description()#
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
            <div class='col'>
              <div class='input-group input-group-sm'>
                <button class='btn btn-sm btn-nmg' type='button'><i class='fa-solid fa-caret-left'></i></button>
                <span class='input-group-text btn-nmg'>Page 1 of 1</span>
                <button class='btn btn-sm btn-nmg' type='button'><i class='fa-solid fa-caret-right'></i></button>
              </div>
            </div>
            #router.include('shared/partials/view_and_filter', { viewer: false })#
          </div>
        </div>
        <div class='card-body'>
          <cfif session.user.loggedIn()>
            <div class='row mb-3'>
              <div class='col-auto'>
                <img class='forum-thumbnail' src='#session.user.profile_image().src()#' />
              </div>
              <div class='col'>
                <form method='post' class='needs-validation' novalidate autocomplete='off'>
                  <div class='row g-3'>
                    <div class='12'>
                      <input type='text' class='form-control mt-2' name='ft_subject' id='ft_subject' value='' maxlength='100' placeholder='Start new thread...' required />
                    </div>
                    <div class='col-12 message-field' style='display:none'>
                      <textarea class='form-control tiny-forum' rows='8' name='fm_body' id='fm_body'></textarea>
                    </div>
                    <div class='col-12 message-field text-center' style='display:none'>
                      <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-sm btn-nmg'>Save</button>
                      <a href='#router.href('user/list')#' class='btn btn-sm btn-nmg-cancel'>Cancel</a>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </cfif>

          <cfloop array='#mForum.ForumThreads()#' item='mThread'>
            <div class='row border-top pt-3'>
              <div class='col-auto'>
                <a href='#mThread.User().seo_link()#'>
                  <img class='forum-thumbnail' src='#mThread.User().profile_image().src()#' />
                </a>
              </div>
              <div class='col'>
                <div class='small'>
                  <a href='#mThread.User().seo_link()#'>#mThread.User().user()#</a>
                  &bull;
                  <a href='#mThread.seo_link()#' class='small'>#mThread.posted()#</a>
                </div>
                <a href='#mThread.seo_link()#'>#mThread.subject()#</a>
              </div>
              <div class='col-1 text-center'>
                Posts<br>#mThread.messages()#
              </div>
              <div class='col-1 text-center'>
                Views<br>#mThread.views()#
              </div>
              <div class='col-2 text-end'>
                <div class='small'>
                  <a href='#mThread.last_message().User().seo_link()#'>#mThread.last_message().User().user()#</a>
                  &bull;
                  <a href='#mThread.last_message().seo_link()#' class='small'>#mThread.last_message().posted()#</a>
                </div>
                <a href='#mThread.last_message().seo_link()#' class='small'>#mThread.last_message().more()#</a>
              </div>
              <div class='col-auto'>
                <a href='#mThread.last_message().User().seo_link()#'>
                  <img class='forum-thumbnail' src='#mThread.last_message().User().profile_image().src()#' />
                </a>
              </div>
            </div>
          </cfloop>
        </div>
        <div class='card-footer'>
          <div class='row'>
            <div class='col-2'>
              Threads #mForum.threads()#
            </div>
            <div class='col-2'>
              Messages #mForum.messages()#
            </div>
            <div class='col-8'>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
