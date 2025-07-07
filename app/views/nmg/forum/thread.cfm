<cfscript>
  try {
    mForum = new app.models.Forums().find(url.foid);
    if (!session.user.loggedIn() && mForum.private()) router.go('/forums');
    if (!session.user.get_admin() && mForum.admin()) router.go('/forums');

    mThread = new app.models.ForumThreads().find(url.ftid);
    if (mThread.alias()!=url.thread) throw(type: 'record_not_found');
    if (mThread.deleted() && !session.user.admin()) throw(type: 'record_not_found');
  } catch (record_not_found err) {
    router.go(mForum.seo_link());
  }

  if (session.user.loggedIn()) {
    mThreadSubscript = mThread.subscription(session.user.usid());
    mForumSubscript = mForum.subscription(session.user.usid());

    if (form.keyExists('btnSubscribe') || form.keyExists('btnSubmit')) {
      if (form.keyExists('btnSubscribe')) form.ft_subscribe = form.btnSubscribe;
      param form.ft_subscribe = 0;
      if (form.ft_subscribe==0) {
        mThreadSubscript.unsubscribe();
      } else {
        mThreadSubscript.subscribe();
      }
    }

    if (form.keyExists('btnThreadEdit') || form.keyExists('btnThreadDelete')) {
      ftid = utility.decode(form.ftid);
      if (ftid==mThread.ftid() && mThread.editable() && session.user.usid()==mThread.usid()) {
        if (form.keyExists('btnThreadEdit')) {
          if (mThread.set(ft_subject: form.ft_subject).safe_save()) {
            flash.success('Your thread subject updated.');
            router.go(mThread.seo_link());
          }
        } else {
          if (mThread.set(ft_deleted: now(), ft_deleted_by: session.user.usid()).safe_save()) {
            mForum.messages_dec();
            mForum.safe_save();

            flash.success('Your thread was marked as deleted and archived.');
            router.go(mForum.seo_link());
          }
        }
      }
    } else if (form.keyExists('btnMessageEdit') || form.keyExists('btnMessageDelete')) {
      variables.fmid = utility.decode(form.fmid);
      if (variables.fmid) {
        mMessages = new app.models.ForumMessages().where(fm_fmid: variables.fmid, fm_usid: session.user.usid());
        if (mMessages.len()==1) {
          mMessage = mMessages.first();
          if (mMessage.editable()) {
            if (form.keyExists('btnMessageEdit')) {
              if (mMessage.set(fm_body: form.edit_message).safe_save()) {
                flash.success('Your message was updated.');
                save_images(mMessage);
                for (form.fiid in form.fiids) {
                  variables.fiid = utility.decode(form.fiid);
                  if (variables.fiid) {
                    mFI = mMessage.ForumImages(detect: { fi_fiid: variables.fiid } );
                    if (!isNull(mFI)) {
                      mFI.destroy();
                      flash.success('Your image #mFI.filename()# was deleted.');
                    }
                  }
                }
                router.go(mThread.seo_link() & '##message-' & mMessage.fmid());
              }
            } else {
              if (mMessage.set(fm_deleted: now(), fm_deleted_by: session.user.usid()).safe_save()) {
                mThread.messages_dec();
                mThread.safe_save();
                flash.success('Your message was marked as deleted and archived.');
                router.go(mThread.seo_link());
              }
            }
          }
        }
      }
    } else if (form.keyExists('btnSubmit')) {
      if (form.fm_body.len()==0) {
        flash.error('A message body is required.');
      } else {
        form.fm_foid = mForum.foid();
        form.fm_ftid = mThread.ftid();
        form.fm_usid = session.user.usid();
        mMessage = new app.models.ForumMessages(form);
        if (mMessage.repost()) {
          flash.warning('Double post caught. Please try again in a minute.');
          router.reload();
        }
        if (mMessage.safe_save()) {
          mThread.messages_inc();
          mThread.last_fmid(mMessage.fmid());
          mThread.safe_save();
          mForum.messages_inc();
          mForum.last_fmid(mMessage.fmid());
          mForum.safe_save();
          save_images(mMessage);
          router.reload();
        }
      }
    }
  } else {
    mThreadSubscript = mThread.subscription();
    mForumSubscript = mForum.subscription();
  }

  mdl = new app.models.ForumMessages();
  params = { fm_ftid: mThread.ftid() }
  if (!session.user.admin()) params.deleted = 0;
  arrList = mdl.list(utility.paged_term_params(params));
  pagination = mdl.pagination();
  if (pagination.first) mThread.view();

  mBlock = mBlog.textblock_by_label('forum-' & mForum.alias());
</cfscript>

<cfset include_js('assets/js/forums/thread.js') />
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
      <nav aria-label='breadcrumb' class='breadcrumb-card'>
        <ol class='breadcrumb small m-0'>
          <li class='breadcrumb-item'><a href='/forums'>Forums</a></li>
          <li class='breadcrumb-item'><a href='#mForum.seo_link()#'>#mForum.name()#</a></li>
          <li class='breadcrumb-item active' aria-current='page'><a href='#mThread.seo_link()#'>#mThread.subject()#</a></li>
        </ol>
      </nav>
    </div>
    <div class='col-12'>
      <div id='thread_subject' class='content-card'>
        <div class='fs-4 #ifin(mThread.deleted(), 'text-decoration-line-through')#'>
          <a href='#mThread.seo_link()#'>#mThread.subject()#</a>
        </div>
        <div class='smaller'>
          <a href='#mThread.User().seo_link()#'>#mThread.User().user()#</a>
          &bull;
          <a href='#mThread.seo_link()#'>#mThread.posted()#</a>
          <cfif session.user.loggedIn() && mThread.usid()==session.user.usid() && mThread.editable()>
            &bull; <a class='thread-edit' data-ftid='#mThread.ftid()#' data-key='#mThread.encoded_key()#' title='editable for 24 hours'><i class='fa-solid fa-fw fa-pencil'></i></a>
            &bull; <a class='thread-delete' data-ftid='#mThread.ftid()#' data-key='#mThread.encoded_key()#' title='deletable for 24 hours'><i class='fa-solid fa-fw fa-trash'></i></a>
          </cfif>
        </div>
      </div>
      <cfif session.user.loggedIn() && mThread.usid()==session.user.usid() && mThread.editable()>
        <div id='edit_subject' class='d-none'>
          <form method='post'>
            <div class='mb-2'>
              <input type='hidden' name='ftid' value='#mThread.encoded_key()#' />
              <button type='submit' name='btnThreadDelete' id='btnThreadDelete' class='d-none'>Delete</button>
              <input type='text' class='form-control form-control-lg mt-2' name='ft_subject' id='ft_subject' value='#mThread.subject()#' maxlength='100' required />
            </div>
            <div class='text-center'>
              <button type='submit' name='btnThreadEdit' id='btnThreadEdit' class='btn btn-sm btn-nmg'>Save</button>
              <a id='thread-revert' class='btn btn-sm btn-nmg-cancel'>Cancel</a>
            </div>
          </form>
        </div>
      </cfif>
    </div>
    <div class='col-12'>
      <div class='card'>
        <div class='card-header'>
          <div class='row align-items-center'>
            <div class='col-auto'>
              <cfif session.user.loggedIn()>
                <cfif mForumSubscript.persisted()>
                  <span class='badge bg-warning'>You are subscribed to this forum.</span>
                <cfelseif mThreadSubscript.persisted()>
                  <button type='button' class='btn btn-sm btn-nmg-cancel' name='btnSubscribe' value='0' onclick='postButton(this)'><i class='fas fa-at'></i> Unsubscribe</button>
                <cfelse>
                  <button type='button' class='btn btn-sm btn-nmg' name='btnSubscribe' value='1' onclick='postButton(this)' title='Receive an email when someone posts in this thread.'>
                    <i class='fas fa-at'></i> Subscribe to this thread
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
        <form method='post' class='needs-validation' novalidate autocomplete='off' enctype='multipart/form-data'>
          <input type='hidden' name='fmid' />
          <input type='hidden' name='fiids' />

          <input type='file' id='filePicker' accept='image/*' multiple class='d-none' />
          <!--- <div id='hidden-inputs'></div> --->

          <cfloop array='#arrList#' item='row' index='idx'>
            <cfset mMessage = new app.models.ForumMessages(row) />
            <cfset mUser = new app.models.Users(row) />
            <cfset mUserProfile = new app.models.UserProfile(row) />

            <div class='row g-0 bg-nmg border-top border-nmg'>
              <div class='col-auto text-center'>
                <div class='pt-4 thread-user'>
                  <a href='#mUser.seo_link()#'>
                    <img class='thread-thumbnail img-thumbnail rounded' src='#mUser.profile_image().src()#' alt='' />
                  </a>
                  <div class='smallest'><a href='#mUser.seo_link()#'>#mUser.user()#</a></div>
                  <div class='smallest'>#mUserProfile.location()#</div>
                </div>
              </div>
              <div class='col'>
                <div class='ms-2 smaller px-3 mt-1'>
                  <a href='#mMessage.seo_link()#'>#mMessage.posted()#</a>
                  <cfif len(mMessage.history())>&bull; <small class='fst-italic muted' title='#mMessage.edited()#'>edited</small></cfif>
                  <cfif session.user.loggedIn() && mMessage.usid()==session.user.usid() && mMessage.editable()>
                    &bull; <a class='message-edit' data-fmid='#mMessage.fmid()#' data-key='#mMessage.encoded_key()#' title='editable for 24 hours'><i class='fa-solid fa-fw fa-pencil'></i></a>
                    &bull; <a class='message-delete' data-fmid='#mMessage.fmid()#' data-key='#mMessage.encoded_key()#' title='deletable for 24 hours'><i class='fa-solid fa-fw fa-trash'></i></a>
                  </cfif>
                  <span class='float-end me-3'>Post ###idx#</span>
                </div>
                <div id='message-#mMessage.encoded_key()#' class='me-2 mb-2'>
                  <div class='message border bg-nmg-light p-3 thread-message #ifin(mMessage.deleted(), 'text-decoration-line-through')#'>
                    <div class='body'>
                      <cfif mMessage.deleted() && !session.user.admin()>
                        <span class='fst-italic smaller'>#mMessage.deleted_label()#</span>
                      <cfelse>
                        #mMessage.body()#
                      </cfif>
                    </div>
                  </div>
                  <cfif row.fm_image_cnt GT 0>
                    <div class='message-roll row g-2 mt-1'>
                      <cfloop array='#mMessage.ForumImages()#' item='mFI'>
                        <div class='col-3 col-xl-2 position-relative'>
                          <a data-lightbox='message-#mMessage.fmid()#' data-title='#mFI.filename()#' href='#mFI.image_src()#' title='#mFI.filename()#'>
                            <img data-pkid=#mFI.encoded_key()# class='w-100 img-thumbnail' src='#mFI.thumbnail_src()#' />
                          </a>
                        </div>
                      </cfloop>
                    </div>
                  </cfif>
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
                <div class='border bg-nmg-light me-2 my-2 p-3 thread-message'>
                  <div class='row g-3'>
                    <div class='col-12'>
                      <textarea class='form-control tiny-forum' rows='8' name='fm_body' id='fm_body' data-roll='photo_roll'></textarea>
                    </div>
                    <div class='col-12'>
                      <div id='photo_roll' class='row g-1 mb-2'></div>
                    </div>
                    <cfif mForumSubscript.new_record()>
                      <div class='col-12'>
                        <div class='form-check form-switch float-end' title='Receive an email when someone posts in this thread.'>
                          <input class='form-check-input' type='checkbox' id='ft_subscribe' name='ft_subscribe' value='1' #ifin(mThreadSubscript.persisted(), 'checked')# />
                          <label class='form-check-label' for='ft_subscribe'>Subscribe to this thread</label>
                        </div>
                      </div>
                    </cfif>
                    <div class='col-12 text-center'>
                      <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-sm btn-nmg'>Post Reply</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div id='edit_popin' class='row g-2 d-none'>
              <div class='col-12'>
                <button type='submit' name='btnMessageDelete' id='btnMessageDelete' class='d-none'>Delete</button>
                <textarea class='form-control tiny-forum' rows='4' name='edit_message' id='edit_message' data-roll='edit_roll'></textarea>
              </div>
              <div class='col-12'>
                <div id='edit_roll' class='row g-1 mb-2'></div>
              </div>
              <div class='col-12 text-center'>
                <button type='submit' name='btnMessageEdit' id='btnMessageEdit' class='btn btn-sm btn-nmg'>Save</button>
                <a id='message-revert' class='btn btn-sm btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </cfif>
        </form>
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
