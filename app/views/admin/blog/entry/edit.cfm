<cfprocessingdirective pageencoding='utf-8'>
<cfscript>
  param url.id = 0;

  if (form.keyExists('cancel')) {
    session.user.destroy('saved_post');
    router.redirect('blog/home');
  }

  mBlogEntry = session.user.BlogEntries(find_or_create: { ben_benid: url.id });
  if (mBlogEntry.new_record()) {
    mBlogEntry.set(
      ben_released: blog.isBlogAuthorized('ReleaseEntries'),
      ben_posted: now(),
      ben_blog: blog.blogId()
    );
  }

  if (form.keyExists('btnSubmit')) {
    if (form.newcategory.len() && blog.isBlogAuthorized('AddCategory')) {
      params = { bec_blog: blog.blogId(), bec_category: form.newcategory }
      mBlogCategory = new app.models.BlogCategories();
      mMatches = mBlogCategory.where(params);
      if (mMatches.len()==0) {
        mBlogCategory.set(params).safe_save();
      } else {
        mBlogCategory = mMatches.first();
      }
      form.categories.listAppend(mBlogCategory.bca_bcaid);
    }
    mBlogEntry.set(form);
    if (mBlogEntry.safe_save()) {
      mBlogEntry.BlogEntryCategories(replace: form.categories);
      mBlogEntry.RelatedBlogEntries(replace: form.relatedEntries ?: '');
      router.redirect('blog/entries');
    }
  }

  param form.categories = mBlogEntry.BlogEntryCategories().map(row => row.bec_bcaid()).toList();
  qryCats = new app.models.BlogCategories().search();

  mode = mBlogEntry.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfparam name='form.oldben_attachment' default=''>
<cfparam name='form.oldben_filesize' default='0'>
<cfparam name='form.oldben_mimetype' default=''>
<cfparam name='form.sendemail' default='true'>
<cfparam name='form.newcategory' default=''>

<cfoutput>
  <!--- <script type="text/javascript">
    $(document).ready(function() {

      //create tabs
      // $("##entrytabs").tabs()

      //handles searching
      getEntries = function() {
        $("##entries_dropdown").removeOption(/./);
        var id = $("##categories_dropdown option:selected").val()
        if(id==null) id=""
        var text = $("##titlefilter").val()
        text = $.trim(text)
        if(id == "" && text == "") return
        $("##entries_dropdown").ajaxAddOption("proxy.cfm?category="+id+"&text="+escape(text)+'&rand='+ Math.round(new Date().getTime()),{}, false)
      }

      $("##titlefilter").keyup(getEntries)

      //listen for select change on related
      $("##categories_dropdown").change(getEntries)

      $("##entries_dropdown").change(function () {
        var selid = $("option:selected", $(this)).val()
        var text = $("option:selected", $(this)).text()

        if($("##cbRelatedEntries").containsOption(selid)) return

        //sets the hidden form field
        var relEntry = $("##relatedentries")
        if(relEntry.val() == "") relEntry.val(selid)
        else relEntry.val(relEntry.val() + "," + selid)

        $("##cbRelatedEntries").addOption(selid,text,false)

      })

      $("##cbRelatedEntries").change(function() {
        var selid = $("option:selected", $(this)).val()

        if(selid == null) return
        $("##cbRelatedEntries").removeOption(selid)

        //quickly regen the hidden field
        var relEntry = $("##relatedentries")
        relEntry.val('')
        $("##cbRelatedEntries option").each(function() {
          var id = $(this).val()
          if(relEntry.val() == '') relEntry.val(id)
          else relEntry.val(relEntry.val() + "," + id)
        })
      })

      $("##uploadImage").click(function() {
        var imgWin = window.open('#application.paths.remote.root#/admin/imgwin.cfm','imgWin','width=400,height=100,toolbar=0,resizeable=1,menubar=0')
        return false
      })

      $("##browseImage").click(function() {
        var imgBrowse = window.open('#application.paths.remote.root#/admin/imgbrowse.cfm','imgBrowse','width=800,height=800,toolbar=1,resizeable=1,menubar=1,scrollbars=1')
        return false
      })


    })

    function newImage(str) {
      var imgstr = '<img src="#application.paths.local.images#"' + str + '" />';
      $("##body").val($("##body").val() + '\n' + imgstr)
    }

    //used to save your form info (title/body) in case your browser crashes
    function saveText() {
      var titleField = $("##title").val()
      var bodyField = $("##body").val()
      var expire = new Date();
      expire.setDate(expire.getDate()+7);
      //write title to cookie
      var cookieString = 'SAVEDTITLE='+escape(titleField)+'; expires='+expire.toGMTString()+'; path=/';
      document.cookie = cookieString;
      cookieString = 'SAVEDBODY='+escape(bodyField)+'; expires='+expire.toGMTString()+'; path=/';
      document.cookie = cookieString;
      window.setTimeout('saveText()',5000);
    }
    <cfif url.id eq 0>window.setTimeout('saveText()',5000);</cfif>
  </script> --->

  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
        <form role='form' method='post' enctype='multipart/form-data'>
          <input type='hidden' name='oldben_attachment' value='#form.oldben_attachment#'>
          <input type='hidden' name='oldben_filesize' value='#form.oldben_filesize#'>
          <input type='hidden' name='oldben_mimetype' value='#form.oldben_mimetype#'>

          <div class='card'>
            <h5 class='card-header bg-nmg'>#mode# Entry</h5>
            <div class='card-body border-left border-right'>
              <div class='row'>
                <ul class='nav nav-tabs' id='myTab' role='tablist'>
                  <li class='nav-item' role='presentation'>
                    <button class='nav-link active' id='main-tab' data-bs-toggle='tab' data-bs-target='##main' type='button' role='tab' aria-controls='main' aria-selected='true'>Main</button>
                  </li>
                  <li class='nav-item' role='presentation'>
                    <button class='nav-link' id='settings-tab' data-bs-toggle='tab' data-bs-target='##settings' type='button' role='tab' aria-controls='settings' aria-selected='false'>Additional Settings</button>
                  </li>
                  <li class='nav-item' role='presentation'>
                    <button class='nav-link' id='related-tab' data-bs-toggle='tab' data-bs-target='##related' type='button' role='tab' aria-controls='related' aria-selected='false'>Related Entries</button>
                  </li>
                  <cfif url.id neq 0>
                    <li class='nav-item' role='presentation'>
                      <button class='nav-link disabled' id='comments-tab' data-bs-toggle='tab' data-bs-target='##comments' type='button' role='tab' aria-controls='comments' aria-selected='false'>Comments Entries</button>
                    </li>
                  </cfif>
                </ul>
                <div class='tab-content border-bottom pb-3' id='myTabContent'>
                  <div class='tab-pane fade show active' id='main' role='tabpanel' aria-labelledby='main-tab'>
                    <div class='row mt-3'>
                      <div class='col-md-8'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_title'>Title</label>
                            <input type='text' class='form-control' name='ben_title' id='ben_title' value='#htmlEditFormat(mBlogEntry.title())#' maxlength='100' required />
                          </div>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_body'>Post (above fold)</label>
                            <textarea class='form-control' name='ben_body' id='ben_body' rows='5' required>#htmlEditFormat(mBlogEntry.body())#</textarea>
                          </div>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_morebody'>Post (below fold)</label>
                            <textarea class='form-control' name='ben_morebody' id='ben_morebody' rows='7' required>#htmlEditFormat(mBlogEntry.morebody())#</textarea>
                          </div>
                        </div>
                      </div>
                      <div class='col-md-4'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_posted'>Posted</label>
                            <input type='text' class='form-control' name='ben_posted' id='ben_posted' value='#mBlogEntry.posted().format('mm/dd/yyyy hh:mm')#' maxlength='20' required />
                          </div>
                          <div class='col-12'>
                            <label class='form-label required' for='categories'>Categories</label>
                            <select class='form-control' name='categories' id='categories' multiple='multiple' size='8'>
                              <cfloop query='qryCats'>
                                <option value='#bca_bcaid#' #ifin(listFind(form.categories,bca_bcaid), 'selected')#>#bca_category#</option>
                              </cfloop>
                            </select>
                          </div>
                          <cfif blog.isBlogAuthorized('AddCategory')>
                            <div class='col-12'>
                              <label class='form-label' for='newcategory'>Add New Category</label>
                              <input type='text' class='form-control' name='newcategory' id='newcategory' value='#htmlEditFormat(form.get('newcategory'))#' maxlength='50' />
                            </div>
                          </cfif>
                          <div class='col-12 text-center'>
                            <button type='button' id='uploadImage' class='btn btn-nmg'>Upload and Insert Image</button>
                            <button type='button' id='browseImage' id='btnPreview' class='btn btn-nmg'>Browse Image Library</button>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class='tab-pane fade' id='settings' role='tabpanel' aria-labelledby='settings-tab'>
                    <div class='row mt-3'>
                      <div class='col-md-6'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label' for='ben_alias'>Alias</label>
                            <input type='text' class='form-control' name='ben_alias' id='ben_alias' value='#mBlogEntry.alias()#' maxlength='20' />
                          </div>
                          <div class='col-12'>
                            <label class='form-label' for='ben_allowcomments'>Allow Comments</label>
                            <select class='form-control' name='ben_allowcomments' id='ben_allowcomments'>
                              <option value='true' #ifin(mBlogEntry.allowcomments(), 'selected')#>Yes</option>
                              <option value='false' #ifin(mBlogEntry.allowcomments(), 'selected')#>No</option>
                            </select>
                          </div>
                          <div class='col-12'>
                            <label class='form-label' for='ben_allowcomments'>Email Blog Entry</label>
                            <select class='form-control' name='sendemail' id='sendemail'>
                              <option value='true' #ifin(form.sendemail, 'selected')#>Yes</option>
                              <option value='false' #ifin(form.sendemail, 'selected')#>No</option>
                            </select>
                          </div>
                          <div class='col-12'>
                            <label class='form-label' for='ben_released'>Released</label>
                            <cfif blog.isBlogAuthorized('ReleaseEntries')>
                              <select class='form-control' name='ben_released' id='ben_released'>
                                <option value='true' #ifin(mBlogEntry.released(), 'selected')#>Yes</option>
                                <option value='false' #ifin(mBlogEntry.released(), 'selected')#>No</option>
                              </select>
                            <cfelse>
                              #yesNoFormat(mBlogEntry.released())#
                            </cfif>
                          </div>
                        </div>
                          </div>
                      <div class='col-md-6'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label' for='ben_attachment'>Attachment</label>
                            <input type='file' class='form-control' name='ben_attachment' id='ben_attachment' />
                            <small>
                              <cfif len(form.oldben_attachment)>
                                #listLast(form.oldben_attachment,'/\')#
                                <input type='button' class='btn btn-warning' name='delete_ben_attachment' value='Delete Attachment'><br/>
                                Download Link: TODO
                              <cfelse>
                                Download Link: Won't show up until you save the entry and file is processed.
                              </cfif>
                            </small>
                          </div>
                          <div class='col-12'>
                            <label class='form-label' for='manualben_attachment'>Manually Set Attachment</label>
                            <input type='text' class='form-control' name='manualben_attachment' id='manualben_attachment' maxlength='50' />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class='tab-pane fade' id='related' role='tabpanel' aria-labelledby='related-tab'>
                    <div class='row mt-3'>
                      <div class='col-12'>
                        Use the form below to search for and add related entries to this blog entry. When you relate one blog entry to another, you automatically create a connection from that entry back to this one.
                        To add a related entry, use either of the below filters to retrieve matching blog entries. (Note that the entries listed only contain the previous 200 blog entries posted that match your criteria.)
                        Click an entry to add it to the list of currently related entries.
                      </div>
                    </div>
                    <div class='row mt-3'>
                      <div class='col-md-4'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label' for='titlefilter'>Filter By Text</label>
                            <input type='text' class='form-control' name='titlefilter' id='titlefilter' maxlength='100' />
                          </div>
                          <div class='col-12'>
                            <label class='form-label' for='categories_dropdown'>Filter by Category</label>
                            <select class='form-control' name='categories_dropdown' id='categories_dropdown' size='6'>
                              <cfloop query='qryCats'>
                                <option value='#bca_bcaid#'>#bca_category#</option>
                              </cfloop>
                            </select>
                          </div>
                        </div>
                      </div>
                      <div class='col-md-8'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label' for='entries_dropdown'>Entries</label>
                            <select id='entries_dropdown' size='4' class='form-control'></select>
                          </div>
                          <div class='col-12'>
                            <label class='form-label' for='relatedEntries'>Current Related Entries (click to remove)</label>
                            <select id='relatedEntries' name='relatedEntries' multiple='multiple' size='4' class='form-control'>
                              <cfloop array='#mBlogEntry.RelatedBlogEntries()#' item='mRBE'>
                                <option value='#mRBE.RelatedBlogEntry().benid()#'>#mRBE.RelatedBlogEntry().title()#</option>
                              </cfloop>
                            </select>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <cfif url.id neq 0>
                    <div class='tab-pane fade' id='comments' role='tabpanel' aria-labelledby='comments-tab'>
                      TODO / TBD
                      <!--- <iframe src='entry_comments.cfm?id=#url.id#' id='commentsFrame' name='commentsFrame' style='width: 100%; min-height: 500px; overflow-y: hidden;' scrolling='false' frameborder='0' marginheight='0' marginwidth='0'></iframe> --->
                    </div>
                  </cfif>
                </div>
              </div>
              <div class='row mt-3'>
                <div class='col text-center'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                  <button type='submit' name='btnPreview' id='btnPreview' class='btn btn-nmg'>Preview</button>
                  <button type='submit' name='btnCancel' id='btnCancel' class='btn btn-warning' onClick='return confirm("Are you sure you want to cancel this entry?")'>Cancel</button>
                </div>
              </div>
            </div>
            <div class='card-footer bg-nmg border-top-0'></div>
          </div>
        </form>
      </div>
    </div>
  </section>
</cfoutput>
