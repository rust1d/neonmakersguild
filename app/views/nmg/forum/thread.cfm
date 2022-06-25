<cfscript>
  try {
    mForum = new app.models.Forums().find(url.foid);
    if (!session.user.get_admin() && mForum.admin()) router.go('/forums');

    mThread = new app.models.ForumThreads().find(url.ftid);
    if (mThread.alias()!=url.thread) throw(type: 'record_not_found');
  } catch (record_not_found err) {
    router.go(mForum.seo_link());
  }

  if (session.user.loggedIn()) {
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
            flash.success('Your thread was marked as deleted and archived.');
            router.go(mForum.seo_link());
          }
        }
      }
    } else if (form.keyExists('btnMessageEdit') || form.keyExists('btnMessageDelete')) {
      fmid = utility.decode(form.fmid);
      if (fmid) {
        mMessages = new app.models.ForumMessages().where(fm_fmid: fmid, fm_usid: session.user.usid());
        if (mMessages.len()==1) {
          mMessage = mMessages.first();
          if (mMessage.editable()) {
            if (form.keyExists('btnMessageEdit')) {
              if (mMessage.set(fm_body: form.edit_message).safe_save()) {
                flash.success('Your message was updated.');
                router.go(mThread.seo_link() & '##message-' & mMessage.fmid());
              }
            } else {
              if (mMessage.set(fm_deleted: now(), fm_deleted_by: session.user.usid()).safe_save()) {
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
  }

  mdl = new app.models.ForumMessages();
  mMessages = mdl.where(utility.paged_term_params(fm_ftid: mThread.ftid()));
  pagination = mdl.pagination();
  if (pagination.first) mThread.view();

  mBlock = mBlog.textblock_by_label('forum-' & mForum.alias());
</cfscript>

<script src='/assets/js/blog/messages.js'></script>

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
        <div id='thread_subject'>
          <div class='fs-4'>
            <a href='#mThread.seo_link()#'>#mThread.subject()#</a>
          </div>
          <div>
            <a href='#mThread.User().seo_link()#'>#mThread.User().user()#</a>
            &bull;
            <a href='#mThread.seo_link()#' class='small'>#mThread.posted()#</a>
            <cfif session.user.loggedIn() && mThread.usid()==session.user.usid() && mThread.editable()>
              &bull; <a class='thread-edit' data-ftid='#mThread.ftid()#' data-key='#mThread.encoded_key()#' title='editable for 24 hours'><i class='fal fa-pencil'></i></a>
              &bull; <a class='thread-delete' data-ftid='#mThread.ftid()#' data-key='#mThread.encoded_key()#' title='deletable for 24 hours'><i class='fal fa-trash-can-clock'></i></a>
            </cfif>
          </div>
        </div>
        <cfif session.user.loggedIn() && mThread.usid()==session.user.usid() && mThread.editable()>
          <div id='edit_subject' class='d-none'>
            <form method='post'>
              <div class='mb-2'>
                <input type='hidden' name='ftid' value='#mThread.encoded_key()#' />
                <button type='submit' name='btnThreadDelete' id='btnThreadDelete' class='d-none'>Delete</button>
                <input type='text' class='form-control mt-2' name='ft_subject' id='ft_subject' value='#mThread.subject()#' maxlength='100' required />
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
            <cfif !session.user.loggedIn()>
              <div class='col-auto'>
                <a href='/login' class='btn btn-sm btn-nmg' title='Login'>
                  <i class='fas fa-person-dots-from-line'></i> Login to post
                </a>
              </div>
            </cfif>
            #router.include('shared/partials/filter_and_page', { pagination: pagination })#
          </div>
        </div>
        <form method='post'>
          <cfloop array='#mMessages#' item='mMessage' index='idx'>
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
                  <cfif len(mMessage.history())>&bull; <small class='fst-italic muted' title='#mMessage.edited()#'>edited</small></cfif>
                  <cfif session.user.loggedIn() && mMessage.usid()==session.user.usid() && mMessage.editable()>
                    &bull; <a class='message-edit' data-fmid='#mMessage.fmid()#' data-key='#mMessage.encoded_key()#' title='editable for 24 hours'><i class='fal fa-pencil'></i></a>
                    &bull; <a class='message-delete' data-fmid='#mMessage.fmid()#' data-key='#mMessage.encoded_key()#' title='deletable for 24 hours'><i class='fal fa-trash-can-clock'></i></a>
                  </cfif>
                  <span class='float-end me-3'>Post ###idx#</span>
                </div>
                <div id='message-#mMessage.encoded_key()#' class='me-2 mb-2'>
                  <div class='message border bg-nmg-light p-3 thread-message'>
                    <cfif mMessage.deleted()>
                      <span class='fst-italic smaller'>#mMessage.deleted_label()#</span>
                    <cfelse>
                      #mMessage.body()#
                    </cfif>
                  </div>
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
                      <textarea class='form-control tiny-forum' rows='8' name='fm_body' id='fm_body'></textarea>
                    </div>
                    <div class='col-12 text-center'>
                      <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-sm btn-nmg'>Post Reply</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div id='edit_popin' class='row g-2 d-none'>
              <div class='col-12'>
                <input type='hidden' name='fmid' />
                <button type='submit' name='btnMessageDelete' id='btnMessageDelete' class='d-none'>Delete</button>
                <textarea class='form-control tiny-forum' rows='4' name='edit_message' id='edit_message'></textarea>
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
