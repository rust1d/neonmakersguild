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
          location(mThread.seo_link(), false);
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
      <div class='content-card bg-nmg-dark text-white'>
        <div class='fs-4 text-marker'>
          <a href='#mForum.seo_link()#' class='text-white text-decoration-none'>#mForum.name()#</a>
        </div>
        <div class='small text-white-50'>
          #mForum.description()#
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card border-0 shadow-sm'>
        <div class='card-header bg-white'>
          <div class='row align-items-center'>
            <div class='col-auto'>
              <cfif session.user.loggedIn()>
                <cfif mSubscription.persisted()>
                  <button type='button' class='btn btn-sm btn-outline-nmg rounded-pill px-3' name='btnSubscribe' value='0' onclick='postButton(this)'><i class='fas fa-at'></i> Unsubscribe</button>
                <cfelse>
                  <button type='button' class='btn btn-sm btn-nmg rounded-pill px-3' name='btnSubscribe' value='1' onclick='postButton(this)' title='Receive an email when someone posts in this forum.'>
                    <i class='fas fa-at'></i> Subscribe to this forum
                  </button>
                </cfif>
              <cfelse>
                <a href='/login' class='btn btn-sm btn-nmg rounded-pill px-3' title='Login'>
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
              <div class='neon-red rounded d-flex align-items-center gap-3 p-2 mb-2'>
                <img class='avatar-circle flex-shrink-0' style='width:48px;min-width:48px' src='#session.user.profile_image().src()#' />
                <input type='text' class='form-control border-0 bg-transparent my-auto' name='ft_subject' id='ft_subject' value='' maxlength='100' placeholder='Start new thread, #session.user.UserProfile().firstname()#...' required />
              </div>
              <div class='message-field' style='display:none'>
                <textarea class='form-control tiny-forum' rows='8' name='fm_body' id='fm_body' data-roll='photo_roll'></textarea>
              </div>
              <div class='message-field my-2' style='display:none'>
                <div id='photo_roll' class='row g-1'></div>
              </div>
              <div class='row'>
                <cfif mSubscription.new_record()>
                  <div class='col message-field' style='display:none'>
                    <div class='form-check form-switch' title='Receive an email when someone posts in this thread.'>
                      <input class='form-check-input' type='checkbox' id='ft_subscribe' name='ft_subscribe' value='1' />
                      <label class='form-check-label smaller' for='ft_subscribe'>Subscribe to this thread</label>
                    </div>
                  </div>
                </cfif>
                <div class='col-auto message-field' style='display:none'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-sm btn-nmg rounded-pill px-3'>Post Thread</button>
                  <button type='button' name='btnCancel' id='btnCancel' class='btn btn-sm btn-outline-nmg rounded-pill px-3'>Close</a>
                </div>
              </div>
            </form>
          </cfif>
          <cfif arrList.len()==0>
            <div class='text-center text-muted fst-italic py-3'>"There is no heavier burden than an unfulfilled potential." <span class='d-block small mt-1'>- Charles Schulz</span></div>
          </cfif>
          <cfloop array='#arrList#' item='row'>
            <cfset mThread = new app.models.ForumThreads(row) />
            <cfset mMessage = new app.models.ForumMessages(row) />
            <cfset mUser = new app.models.Users(row) />
            <cfset mLastUser = new app.models.Users({ us_usid: row.lus_usid, us_user: row.lus_user}) />

            <div class='content-card hover-lift mt-3 position-relative'>
              <div class='fw-semibold'>
                <a href='#mThread.seo_link()#' class='stretched-link'>
                  #mThread.subject()#
                </a>
              </div>
              <div class='d-flex justify-content-between align-items-center mt-1'>
                <div class='d-flex align-items-center gap-2'>
                  <a href='#mUser.seo_link()#' class='d-inline d-xxs-none position-relative' style='z-index:2'>
                    <img class='avatar-circle' style='width:32px;min-width:32px' src='#mUser.profile_image().src()#' />
                  </a>
                  <div class='smaller'>
                    <a href='#mUser.seo_link()#' class='position-relative' style='z-index:2'>#mUser.user()#</a>
                    &bull;
                    #mThread.posted()#
                    <br>
                    #utility.plural_label(mThread.messages(), 'Post')#
                    &bull;
                    #utility.plural_label(mThread.views(), 'View')#
                  </div>
                </div>
                <div class='d-flex align-items-center gap-2'>
                  <div class='smaller text-end'>
                    <a href='#mLastUser.seo_link()#' class='position-relative' style='z-index:2'>#mLastUser.user()#</a>
                    &bull;
                    #mMessage.posted()#
                    <br>
                    <span class='small'>#mMessage.more()#</span>
                  </div>
                  <a href='#mLastUser.seo_link()#' class='d-inline d-xxs-none position-relative' style='z-index:2'>
                    <img class='avatar-circle' style='width:32px;min-width:32px' src='#mLastUser.profile_image().src()#' />
                  </a>
                </div>
              </div>
            </div>
          </cfloop>
        </div>
        <div class='card-footer bg-nmg-dark'>
          <div class='row align-items-center'>
            #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
          </div>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
