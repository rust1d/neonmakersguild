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
            save_images(mMessage);
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
  arrList = mdl.list(utility.paged_term_params(params));
  pagination = mdl.pagination();

  mBlock = mBlog.textblock_by_label('forum-' & mForum.alias());
</cfscript>

<cfset include_js('assets/js/forums/threads.js') />
<cfset include_js('assets/js/forums/images.js') />
<cfset router.include('shared/partials/image_dropdown') />
<cfset router.include('shared/partials/process_overlay') />

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
            <cfif session.user.loggedIn()>
              #router.include('shared/partials/filter_and_page', { pagination: pagination })#
            </cfif>
          </div>
        </div>
        <div class='card-body'>
          <cfif session.user.loggedIn()>
            <form method='post' class='needs-validation' novalidate autocomplete='off' enctype='multipart/form-data'>
              <input type='file' id='filePicker' accept='image/*' multiple class='d-none' />
              <div class='row g-3 align-items-end align-items-sm-center mb-2'>
                <div class='col-auto'>
                  <img class='resp-thumbnail-lg' src='#session.user.profile_image().src()#' />
                </div>
                <div class='col'>
                  <input type='text' class='form-control neon-red my-auto' name='ft_subject' id='ft_subject' value='' maxlength='100' placeholder='Start new thread...' required />
                </div>
              </div>
              <div class='message-field' style='display:none'>
                <textarea class='form-control tiny-forum' rows='8' name='fm_body' id='fm_body' data-roll='photo_roll'></textarea>
              </div>
              <div class='message-field my-2' style='display:none'>
                <div id='photo_roll' class='row g-1'></div>
              </div>
              <cfif mSubscription.new_record()>
                <div class='message-field' style='display:none'>
                  <div class='form-check form-switch float-end' title='Receive an email when someone posts in this thread.'>
                    <input class='form-check-input' type='checkbox' id='ft_subscribe' name='ft_subscribe' value='1' />
                    <label class='form-check-label' for='ft_subscribe'>Subscribe to this thread</label>
                  </div>
                </div>
              </cfif>
              <div class='message-field text-center' style='display:none'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-sm btn-nmg'>Save</button>
                <a href='#router.url()#' class='btn btn-sm btn-nmg-cancel'>Cancel</a>
              </div>
            </form>
          </cfif>
          <cfif arrList.len()==0>
            <div class='small'>"There is no heavier burden than an unfulfilled potential." - Charles Schulz</div>
          </cfif>
          <cfloop array='#arrList#' item='row'>
            <cfset mThread = new app.models.ForumThreads(row) />
            <cfset mMessage = new app.models.ForumMessages(row) />
            <cfset mUser = new app.models.Users(row) />
            <cfset mLastUser = new app.models.Users({ us_usid: row.lus_usid, us_user: row.lus_user}) />

            <hr class='my-3' />

            <div class='fw-semibold me-3'>
              <a href='#mThread.seo_link()#'>
                #mThread.subject()#
              </a>
            </div>
            <div class='d-flex justify-content-between align-items-center w-100'>
              <div class='d-flex align-items-center gap-2'>
                <a href='#mUser.seo_link()#' class='d-inline d-xxs-none'>
                  <img class='resp-thumbnail' src='#mUser.profile_image().src()#' />
                </a>
                <div class='smaller'>
                  <a href='#mUser.seo_link()#'>#mUser.user()#</a>
                  &bull;
                  <a href='#mThread.seo_link()#'>#mThread.posted()#</a>
                  <br>
                  #utility.plural_label(mThread.messages(), 'Post')#
                  &bull;
                  #utility.plural_label(mThread.views(), 'View')#
                </div>
              </div>
              <div class='d-flex align-items-center gap-2'>
                <div class='smaller'>
                  <a href='#mLastUser.seo_link()#'>#mLastUser.user()#</a>
                  &bull;
                  <a href='#mMessage.seo_link()#'>
                    <span class='d-inline d-xxs-none'>#mMessage.posted()#</span>
                    <span class='d-none d-xxs-inline'>#mMessage.posted_short()#</span>
                  </a>
                  <br>
                  <a href='#mMessage.seo_link()#' class='small'>#mMessage.more()#</a>
                </div>
                <a href='#mLastUser.seo_link()#' class='d-inline d-xxs-none'>
                  <img class='resp-thumbnail' src='#mLastUser.profile_image().src()#' />
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
