<cfoutput>
  <div id='comments' class='post-comments'>
    <form method='post'>
      #router.include('shared/blog/_comment_field')#
      <cfloop array='#locals.mBE.BlogComments()#' item='locals.mComment'>
        #router.include('shared/blog/_comment', { mComment: locals.mComment })#
      </cfloop>
    </form>
  </div>
</cfoutput>
