<cfscript>
  results = mUserBlog.entries(ben_benid: router.decode('benid'));
  mEntry = results.rows.first();
  mEntry.view(); // inc views

  if (session.user.loggedIn()) {
    if (form.keyExists('btnCommentEdit')) {
      bcoid = utility.decode(form.bcoid);
      if (bcoid) {
        mComments = new app.models.BlogComments().where(bco_bcoid: bcoid, bco_usid: session.user.usid());
        if (mComments.len()==1) {
          mComment = mComments.first();
          if (mComment.set(bco_comment: form.edit_comment).safe_save()) {
            flash.success('Your comment was updated.');
            router.go(mEntry.seo_link() & '##comment-' & mComment.bcoid());
          }
        }
      }
    } else if (form.keyExists('btnComment')) {
      form.bco_usid = session.user.usid();
      form.bco_blog = mEntry.blog();
      form.bco_benid = mEntry.benid();

      mComment = new app.models.BlogComments(form);
      if (mComment.safe_save()) {
        mEntry.comment_cnt_inc();
        flash.success('Thank you for your participation.');
        router.go(mEntry.seo_link() & '##comment');
      }
    }
  }
</cfscript>

<cfif session.user.admin()>
  <script>
    $(function() {
      $('button[name=btnPromote]').on('click', function() {
        window.location.href = `/index.cfm?p=blog/entry/promote&pkid=${this.dataset.pkid}`;
      });
    });
  </script>
</cfif>

<script src='/assets/js/blog/comments.js'></script>

<cfoutput>
  <div class='row g-3'>
    <div class='col-12'>
      #router.include('shared/blog/entry', { mEntry: mEntry, fold: false, promote: session.user.admin() })#
    </div>
    <div class='col-12'>
      <cfif mEntry.comments()>
        #router.include('shared/blog/comments', { mEntry: mEntry })#
      <cfelse>
        <small class='text-muted'>Comments have been disabled for this post.</small>
      </cfif>
    </div>
  </div>
</cfoutput>
