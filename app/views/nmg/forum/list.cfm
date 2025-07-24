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
            <div class='row g-0 d-none d-sm-flex'>
              <div class='col-2 text-center small'>
                Threads <br/> #mForum.threads()#
              </div>
              <div class='col-2 text-center small'>
                Messages <br/> #mForum.messages()#
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
                        <img class='resp-thumbnail' src='#mUser.profile_image().src()#' />
                      </a>
                    </div>
                  </div>
                </cfif>
              </div>
            </div>
            <div class='row d-flex d-sm-none'>
              <cfif !isNull(mForum.last_fmid()) && !mMessage.deleted()>
                <div class='small'>
                  <a href='#mMessage.seo_link()#'>#mThread.subject()#</a>
                </div>
                <div class='d-flex justify-content-between align-items-center w-100'>
                  <div class='d-flex align-items-center gap-2'>
                    <div class='d-xs-inline d-sm-none'>
                      <a href='#mUser.seo_link()#'>
                        <img class='resp-thumbnail' src='#mUser.profile_image().src()#' />
                      </a>
                    </div>
                    <div class='smaller'>
                      <a href='#mUser.seo_link()#'>#mUser.user()#</a>
                      &bull;
                      <a href='#mMessage.seo_link()#' class='small'>#mMessage.posted()#</a>
                    </div>
                  </div>
                  <div class='smaller'>
                    Threads #mForum.threads()# | Messages #mForum.messages()#
                  </div>
                </div>
              </cfif>
            </div>
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
