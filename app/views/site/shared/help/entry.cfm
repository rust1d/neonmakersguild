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
        <h5 class='card-header' id='help_alias'>
          SEO Alias
          <span class='float-end smaller text-muted'>Auto-filled</span>
        </h5>
        <div class='card-body'>
          This field is auto-generated from the entry title and is best left alone. It is used in the
          link for search engine optimization. Messing with it could break the whole internet.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_image'>
          Header Image
          <span class='float-end smaller text-muted'>Required</span>
        </h5>
        <div class='card-body'>
          <p>
            All entries must have a header image. This image <cite>should</cite> have a width:height ratio of 2:1 with the
            recommended dimensions being 1200 x 600 pixels.
          </p>
          <p>
            Use the search field to find images in your library. Start typing to search the image name and display the
            matching image thumbnails. Images are sorted with recently uploaded displayed first. Images properly sized
            for use as a header image will have a <span class='border border-success'>green border</span> and others
            a <span class='border border-danger'>red border</span>. Any size image can be used but it may not display
            framed as expected. Click a thumbnail from the search results bar to load the image into the header area.
          </p>
          <p class='small'>
            Search tips:
            <ul class='small'>
              <li>Enter <code>..</code> (two periods) to return the 20 most recent image uploads.</li>
              <li>Enter <code>1200x</code> to find images 1200 pixels wide.</li>
              <li>Enter <code>x600</code> to find images 600 pixels high.</li>
              <li>Enter <code>2.0</code> to find images with 2:1 ratio.</li>
            </ul>
          </p>
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
        <h5 class='card-header' id='help_categories'>Categories</h5>
        <div class='card-body'>
          All entries should be placed into at least one category. To select or deselect a category, <code>ctrl+click</code>
          it from the category list. Categories can be added or selected by using the provided input field and clicking the
          <button class='btn btn-sm btn-nmg'>+ Add</button> button. In general, the number of categories should be kept to a
          minimum so try to find one that fits before adding a new one.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_summary'>
          Post Summary
          <span class='float-end smaller text-muted'>Required &bull; 50 words or less</span>
        </h5>
        <div class='card-body'>
          A brief introductory summary of the post that is image-free and contains little to no styling.
          Only used when the entry is displayed using the <code>READ MORE</code> format.
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
