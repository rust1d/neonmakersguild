<cfoutput>
  <div class='row g-3'>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_filename'>
          Title / Filename
          <span class='float-end smaller text-muted'>Required &bull; 100 chars max</span>
        </h5>
        <div class='card-body'>
          Document title. Used to generate filename when user downloads the file.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_description'>
          Description
          <span class='float-end smaller text-muted'>Required &bull; 500 chars max</span>
        </h5>
        <div class='card-body'>
          A brief introductory summary of the contents of the document.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_tags'>Tags vs Categories</h5>
        <div class='card-body'>
          What is the difference between tags and categories? Categories allow you to broadly group common
          documents, while you can use tags to describe the document content in finer detail.
          In an ideal world, we want to group content into a few dozen categories at most, while tags
          can be any relevant keyword associated with the content.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_tags'>Tags</h5>
        <div class='card-body'>
          All documents should be tagged with multiple keywords. Start typing a word to display a list of existing tags.
          Press enter to select a suggested tag, or add a new one if the tag doesn't already exist in the database.
        </div>
      </div>
    </div>
    <div class='col-12'>
      <div class='card'>
        <h5 class='card-header' id='help_categories'>Categories</h5>
        <div class='card-body'>
          All documents should be placed into at least one category. Use the input field to search for an existing category,
          or scroll through the select alphabetically manually to find one. To select or deselect a category,
          <code>ctrl+click</code> it from the category list. New categories can be added from the Category menu.
        </div>
      </div>
    </div>
  </div>
</cfoutput>
