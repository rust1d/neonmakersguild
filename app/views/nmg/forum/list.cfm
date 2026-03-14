<cfscript>
  params = { };
  if (!session.user.get_admin()) params.fo_admin = 0;
  arrList = new app.models.Forums().list(params);
  mBlock = mBlog.textblock_by_label('forums');
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <cfif mBlock.persisted()>
      <div class='col-12'>
        #mBlock.body_cdn()#
      </div>
    </cfif>
    <cfloop array='#arrList#' item='row'>
      <cftry>
      <cfset mForum = new app.models.Forums(row) />
      <cfset mThread = new app.models.ForumThreads(row) />
      <cfset mMessage = new app.models.ForumMessages(row) />
      <cfset mUser = new app.models.Users(row) />

      <div class='col-12'>
        <div class='content-card hover-lift #ifin(mForum.private(),'card-private')# #ifin(mForum.admin(),'card-admin')#'>
          <div class='fs-5 fw-bold mb-1'>
            <a href='#mForum.seo_link()#'>#mForum.name()#</a>
            <cfif mForum.private()><span class='badge btn-nmg-cancel p-2 ms-2 small'>Members Only</span></cfif>
            <cfif mForum.admin()><span class='badge btn-nmg p-2 ms-2 small'>Admins Only</span></cfif>
          </div>
          <div class='mb-2'>
            <a href='#mForum.seo_link()#'>#mForum.description()#</a>
          </div>
          <div class='d-none d-sm-flex align-items-center gap-3 small text-muted border-top pt-2'>
            <span>Threads #mForum.threads()#</span>
            <span>Messages #mForum.messages()#</span>
            <cfif !isNull(mForum.last_fmid()) && !mMessage.deleted()>
              <span class='ms-auto d-flex align-items-center gap-2'>
                <span>
                  <a href='#mMessage.seo_link()#'>#mThread.subject()#</a>
                  <span class='smaller d-block'>
                    <a href='#mUser.seo_link()#'>#mUser.user()#</a> &bull; <a href='#mMessage.seo_link()#'>#mMessage.posted()#</a>
                  </span>
                </span>
                <a href='#mUser.seo_link()#'>
                  <img class='avatar-circle' style='width:36px;min-width:36px' src='#mUser.profile_image().src()#' />
                </a>
              </span>
            </cfif>
          </div>
          <div class='d-flex d-sm-none flex-column gap-1 border-top pt-2'>
            <cfif !isNull(mForum.last_fmid()) && !mMessage.deleted()>
              <div class='small'>
                <a href='#mMessage.seo_link()#'>#mThread.subject()#</a>
              </div>
              <div class='d-flex justify-content-between align-items-center'>
                <div class='d-flex align-items-center gap-2'>
                  <a href='#mUser.seo_link()#'>
                    <img class='avatar-circle' style='width:28px;min-width:28px' src='#mUser.profile_image().src()#' />
                  </a>
                  <div class='smaller'>
                    <a href='#mUser.seo_link()#'>#mUser.user()#</a> &bull; <a href='#mMessage.seo_link()#'>#mMessage.posted()#</a>
                  </div>
                </div>
                <div class='smaller text-muted'>
                  #mForum.threads()#T | #mForum.messages()#M
                </div>
              </div>
            </cfif>
          </div>
        </div>
      </div>
      <cfcatch any='err'>
        <marquee>#utility.errorString(err)#</marquee>
      </cfcatch>
    </cftry>
    </cfloop>
  </div>
</cfoutput>
