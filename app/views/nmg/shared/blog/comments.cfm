<cfoutput>
  <div id='comments' class='post-comments'>
    <form method='post'>
      <cfloop array='#locals.mBE.BlogComments()#' item='locals.mComment'>
        #router.include('shared/blog/_comment', { mComment: locals.mComment })#
      </cfloop>
      <div class='mt-2'>
        #router.include('shared/blog/_comment_field', { id: 'entryComment'})#
      </div>
    </form>
  </div>
</cfoutput>
