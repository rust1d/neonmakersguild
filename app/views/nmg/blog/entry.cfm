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
            // flash.success('Your comment was updated.');
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
        // flash.success('Thank you for your participation.');
        router.go(mEntry.seo_link() & '##comment');
      }
    }
  }
</cfscript>

<cfset include_js('assets/js/blog/entry.js') />
<cfset include_js('assets/js/blog/images.js') />
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
      #router.include('shared/blog/post', { mEntry: mEntry, fold: false })#
    </div>
    <div class='col-12 content-card'>
      <cfif mEntry.comments()>
        #router.include('shared/blog/comments', { mEntry: mEntry })#
      <cfelse>
        <small class='text-muted'>Comments have been disabled for this post.</small>
      </cfif>
    </div>
  </div>
</cfoutput>
