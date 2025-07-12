<cfoutput>
  <div class='row g-3'>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_title'>
          Title field
          <span class='float-end smaller text-muted'>Required &bull; 100 chars max</span>
        </h5>
        <div class='card-body'>
          Title of the blog entry.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_posted'>
          Post Date / Post Time
          <span class='float-end smaller text-muted'>Required</span>
        </h5>
        <div class='card-body'>
          The date and time of the entry. The post will not display to the public until this date has passed.
          Set this date in the future to have the schedule the post.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_released'>Released</h5>
        <div class='card-body'>
          Controls whether the entry is displayed to the public regardless of post date/time.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_comments'>Comments</h5>
        <div class='card-body'>
          Controls whether members can comment on this entry.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_summary'>
          Post Summary
          <span class='float-end smaller text-muted'>50 words or less</span>
        </h5>
        <div class='card-body'>
          A brief summary of the post. This is displayed in the member stream instead of the full Post Body. If not entered,
          the first ~50 words of your post will be used.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_body'>
          Post Body
          <span class='float-end smaller text-muted'>Required</span>
        </h5>
        <div class='card-body'>
          The full blog entry. Use the image search to locate images from your library and insert them into the post body
          at the cursor location.
        </div>
      </div>
    </div>
  </div>
</cfoutput>
