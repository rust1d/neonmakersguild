<cfscript>
  results = mUserBlog.entries(ben_benid: router.decode('benid'));
  mBE = results.rows.first();
  mBE.view(); // inc views

  if (session.user.loggedIn()) {
    if (form.keyExists('btnCommentEdit')) {
      bcoid = utility.decode(form.bcoid);
      if (bcoid) {
        mComments = new app.models.BlogComments().where(bco_bcoid: bcoid, bco_usid: session.user.usid());
        if (mComments.len()==1) {
          mComment = mComments.first();
          if (mComment.set(bco_comment: form.edit_comment).safe_save()) {
            router.go(mBE.seo_link() & '##comment-' & mComment.bcoid());
          }
        }
      }
    } else if (form.keyExists('btnComment')) {
      form.bco_usid = session.user.usid();
      form.bco_blog = mBE.blog();
      form.bco_benid = mBE.benid();

      mComment = new app.models.BlogComments(form);
      if (mComment.safe_save()) {
        mBE.comment_cnt_inc();
        router.go(mBE.seo_link() & '##comment');
      }
    }
  }
</cfscript>

<cfset include_js('assets/js/blog/modals.js') />
<cfset include_js('assets/js/blog/comments.js') />

<cfif session.user.admin()>
  <script>
    $(function() {
      $('button[name=btnPromote]').on('click', function() {
        window.location.href = `/index.cfm?p=blog/entry/promote&pkid=${this.dataset.pkid}`;
      });
    });
  </script>
</cfif>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12 content-card'>
      #router.include('shared/blog/post', { mBE: mBE, fold: false })#
    </div>
    <div class='col-12 content-card'>
      <cfif mBE.comments()>
        #router.include('shared/blog/comments', { mBE: mBE })#
      <cfelse>
        <small class='text-muted'>Comments have been disabled for this post.</small>
      </cfif>
    </div>
  </div>
</cfoutput>
