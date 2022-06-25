<cfscript>
  params = { };
  if (!session.user.get_admin()) params.fo_admin = 0;
  mForums = new app.models.Forums().where(params);
  mBlock = mBlog.textblock_by_label('forums');
</cfscript>

<cfoutput>
  <div class='row g-3'>
    <cfif mBlock.persisted()>
      <div class='col-12'>
        #mBlock.body()#
      </div>
    </cfif>
    <cfloop array='#mForums#' item='mForum'>
      <div class='col-12'>
        <div class='card #ifin(mForum.admin(),'card-admin')#'>
          <div class='card-header fs-5'>
            <a href='#mForum.seo_link()#'>#mForum.name()#</a>
            <cfif mForum.admin()><span class='float-end badge btn-nmg'>Admins Only</span></cfif>
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
                <cfif !isNull(mForum.last_fmid())>
                  <div class='row'>
                    <div class='col text-end'>
                      <div class='small'>
                        <a href='#mForum.last_message().User().seo_link()#'>#mForum.last_message().User().user()#</a>
                        &bull;
                        <a href='#mForum.last_message().seo_link()#' class='small'>#mForum.last_message().posted()#</a>
                      </div>
                      <a href='#mForum.last_message().seo_link()#'>#mForum.last_message().ForumThread().subject()#</a>
                    </div>
                    <div class='col-auto'>
                      <a href='#mForum.last_message().User().seo_link()#'>
                        <img class='forum-thumbnail' src='#mForum.last_message().User().profile_image().src()#' />
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
