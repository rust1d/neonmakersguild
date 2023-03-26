<cfscript>
  try {
    mForum = new app.models.Forums().find(url.foid);
    if (!session.user.get_admin() && mForum.admin()) router.go('/forums');
  } catch (record_not_found err) {
    router.go('/forums');
  }

  if (session.user.loggedIn()) {
    mSubscription = mForum.subscription(session.user.usid());

    if (form.keyExists('btnSubscribe')) {
      if (form.btnSubscribe==0) {
        mSubscription.unsubscribe();
      } else {
        mSubscription.subscribe();
      }
    }

    if (form.keyExists('btnSubmit')) {
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

          param form.ft_subscribe = 0;
          if (form.ft_subscribe==1) mThread.subscription(session.user.usid()).subscribe();
        }
      }
    }
  } else {
    mSubscription = mForum.subscription();
  }

  mdl = new app.models.ForumThreads();
  params = { ft_foid: mForum.foid() }
  if (!session.user.admin() || !url.keyExists('deleted')) params.deleted = 0;
  mThreads = mdl.where(utility.paged_term_params(params));
  pagination = mdl.pagination();

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
        #mBlock.body_cdn()#
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
          <div class='row align-items-center'>
            <div class='col-auto'>
              <cfif session.user.loggedIn()>
                <cfif mSubscription.persisted()>
                  <button type='button' class='btn btn-sm btn-nmg-cancel' name='btnSubscribe' value='0' onclick='postButton(this)'><i class='fas fa-at'></i> Unsubscribe</button>
                <cfelse>
                  <button type='button' class='btn btn-sm btn-nmg' name='btnSubscribe' value='1' onclick='postButton(this)' title='Receive an email when someone posts in this forum.'>
                    <i class='fas fa-at'></i> Subscribe to this forum
                  </button>
                </cfif>
              <cfelse>
                <a href='/login' class='btn btn-sm btn-nmg' title='Login'>
                  <i class='fas fa-person-dots-from-line'></i> Login to post
                </a>
              </cfif>
            </div>
            #router.include('shared/partials/filter_and_page', { pagination: pagination })#
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
                    <div class='col-12 message-field' style='display:none'>
                      <div class='form-check form-switch float-end' title='Receive an email when someone posts in this thread.'>
                        <input class='form-check-input' type='checkbox' id='ft_subscribe' name='ft_subscribe' value='1' />
                        <label class='form-check-label' for='ft_subscribe'>Subscribe to this thread</label>
                      </div>
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
          <cfif mThreads.len()==0>
            <div class='small'>"There is no heavier burden than an unfulfilled potential." - Charles Schulz</div>
          </cfif>
          <cfloop array='#mThreads#' item='mThread'>
            <hr class='my-3' />
            <div class='row'>
              <div class='col-auto'>
                <a href='#mThread.User().seo_link()#'>
                  <img class='forum-thumbnail' src='#mThread.User().profile_image().src()#' />
                </a>
              </div>
              <div class='col #ifin(mThread.deleted(), 'text-decoration-line-through')#'>
                <div class='smaller'>
                  <a href='#mThread.User().seo_link()#'>#mThread.User().user()#</a>
                  &bull;
                  <a href='#mThread.seo_link()#'>#mThread.posted()#</a>
                  &bull;
                  #utility.plural_label(mThread.messages(), 'Post')#
                  &bull;
                  #utility.plural_label(mThread.views(), 'View')#
                </div>
                <a href='#mThread.seo_link()#'>#mThread.subject()#</a>
              </div>
              <div class='col-4 text-end #ifin(mThread.last_message().deleted(), 'text-decoration-line-through')#'>
                <div class='smaller'>
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
        <div class='card-footer bg-nmg'>
          <div class='row align-items-center'>
            #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
