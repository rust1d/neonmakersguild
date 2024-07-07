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
      <cfset mForum = new app.models.Forums(row) />
      <cfset mThread = new app.models.ForumThreads(row) />
      <cfset mMessage = new app.models.ForumMessages(row) />
      <cfset mUser = new app.models.Users(row) />

      <div class='col-12'>
        <div class='card #ifin(mForum.private(),'card-private')# #ifin(mForum.admin(),'card-admin')#'>
          <div class='card-header fs-5'>
            <a href='#mForum.seo_link()#'>#mForum.name()#</a>
            <cfif mForum.private()><span class='float-end badge btn-nmg-cancel p-2'>Members Only</span></cfif>
            <cfif mForum.admin()><span class='float-end badge btn-nmg p-2'>Admins Only</span></cfif>
          </div>
          <div class='card-body'>
            <a href='#mForum.seo_link()#'>#mForum.description()#</a>
          </div>
          <div class='card-footer'>
            <div class='row'>
              <div class='col-2 text-center'>
                Threads<br>#mForum.threads()#
              </div>
              <div class='col-2 text-center'>
                Messages<br>#mForum.messages()#
              </div>
              <div class='col-8 text-end'>
                <cfif !isNull(mForum.last_fmid()) && !mMessage.deleted()>
                  <div class='row'>
                    <div class='col text-end'>
                      <div class='small'>
                        <a href='#mUser.seo_link()#'>#mUser.user()#</a>
                        &bull;
                        <a href='#mMessage.seo_link()#' class='small'>#mMessage.posted()#</a>
                      </div>
                      <a href='#mMessage.seo_link()#'>#mThread.subject()#</a>
                    </div>
                    <div class='col-auto'>
                      <a href='#mUser.seo_link()#'>
                        <img class='forum-thumbnail' src='#mUser.profile_image().src()#' />
                      </a>
                    </div>
                  </div>
                </cfif>
              </div>
            </div>
          </div>
        </div>
      </div>
    </cfloop>
  </div>
</cfoutput>
