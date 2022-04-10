<cfprocessingdirective pageencoding='utf-8'>
<!---
TODO:
save/remove attach
comments tab?
related entries
cancel
preview
--->

<cfscript>
  if (form.keyExists('cancel')) {
    session.user.destroy('saved_post');
    router.redirect('blog/home');
  }

  mEntry = mBlog.entry_find_or_create(router.decode('benid'));

  if (form.keyExists('btnSubmit')) {
    param form.categories = '';
    if (len(form.get('bca_category'))) {
      qry = mBlog.category_search(bca_category: form.bca_category);
      if (qry.len()) {
        form.categories = form.categories.listAppend(qry.bca_bcaid);
      } else {
        mCategory = mBlog.category_build(form);
        if (mBlog.category_save(mCategory)) form.categories = form.categories.listAppend(mCategory.bcaid());
      }
    }

    mEntry.set(form);
    if (mEntry.safe_save()) {
      mEntry.BlogEntryCategories(replace: form.categories ?: '');
      mEntry.RelatedBlogEntries(replace: form.relatedEntries ?: '');
      flash.success('Your entry was saved.');
      router.redirect('blog/entry/list');
    }
  }

  param form.categories = mEntry.BlogEntryCategories().map(row => row.bec_bcaid()).toList();
  qryCats = new app.models.BlogCategories().search();
  mode = mEntry.new_record() ? 'Add' : 'Edit';
</cfscript>

<cfparam name='form.sendemail' default='true'>
<cfparam name='form.bca_category' default=''>

<script src='/assets/js/admin/blog/entry.js'></script>


<cfoutput>
  <section class='container'>
    <div class='row mb-3'>
      <div class='col'>
        <form role='form' method='post' id='blogform'>
          <div class='card'>
            <h5 class='card-header bg-nmg'>#mode# Entry</h5>
            <div class='card-body border-left border-right'>
              <div class='row'>
                <!--- <ul class='nav nav-tabs' id='myTab' role='tablist'>
                  <li class='nav-item' role='presentation'>
                    <button class='nav-link active' id='main-tab' data-bs-toggle='tab' data-bs-target='##main' type='button' role='tab' aria-controls='main' aria-selected='true'>Main</button>
                  </li>
                  <li class='nav-item' role='presentation'>
                    <button class='nav-link' id='settings-tab' data-bs-toggle='tab' data-bs-target='##settings' type='button' role='tab' aria-controls='settings' aria-selected='false'>Additional Settings</button>
                  </li>
                  <li class='nav-item' role='presentation'>
                    <button class='nav-link' id='related-tab' data-bs-toggle='tab' data-bs-target='##related' type='button' role='tab' aria-controls='related' aria-selected='false'>Related Entries</button>
                  </li>
                  <cfif mEntry.persisted()>
                    <li class='nav-item' role='presentation'>
                      <button class='nav-link disabled' id='comments-tab' data-bs-toggle='tab' data-bs-target='##comments' type='button' role='tab' aria-controls='comments' aria-selected='false'>Comments Entries</button>
                    </li>
                  </cfif>
                </ul> --->
                <div class='tab-content border-bottom pb-3' id='myTabContent'>
                  <div class='tab-pane fade show active' id='main' role='tabpanel' aria-labelledby='main-tab'>
                    <div class='row mt-3'>
                      <div class='col-md-8'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_title'>Title</label>
                            <input type='text' class='form-control' name='ben_title' id='ben_title' value='#htmlEditFormat(mEntry.title())#' maxlength='100' required />
                          </div>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_body'>Post (above fold)</label>
                            <textarea class='tiny-mce form-control' name='ben_body' id='ben_body'>#htmlEditFormat(mEntry.body())#</textarea>
                          </div>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_morebody'>Post (below fold)</label>
                            <textarea class='tiny-mce form-control' name='ben_morebody' id='ben_morebody'>#htmlEditFormat(mEntry.morebody())#</textarea>
                          </div>
                        </div>
                      </div>
                      <div class='col-md-4'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label' for='ben_alias'>Alias</label>
                            <input type='text' class='form-control' name='ben_alias' id='ben_alias' value='#mEntry.alias()#' maxlength='100' />
                          </div>
                          <div class='col-12'>
                            <label class='form-label required' for='ben_posted'>Posted</label>
                            <input type='text' class='form-control' name='ben_posted' id='ben_posted' value='#mEntry.posted()#' maxlength='20' required />
                          </div>
                          <div class='col-12'>
                            <label class='form-label required' for='categories'>Categories</label>
                            <select class='form-control' name='categories' id='categories' multiple='multiple' size='8'>
                              <cfloop query='qryCats'>
                                <option value='#bca_bcaid#' #ifin(listFind(form.categories, bca_bcaid), 'selected')#>#bca_category#</option>
                              </cfloop>
                            </select>
                          </div>
                          <cfif mBlog.isAuthorized('AddCategory')>
                            <div class='col-12'>
                              <label class='form-label' for='bca_category'>Add New Category</label>
                              <input type='text' class='form-control' name='bca_category' id='bca_category' value='#htmlEditFormat(form.get('bca_category'))#' maxlength='50' />
                            </div>
                          </cfif>

                          <div class='col-12'>
                            <div class='input-group'>
                              <span class='input-group-text btn-nmg'>Search Images</span>
                              <input id='imagesearch' type='text' class='form-control' placeholder='Search' maxlength='20' aria-label='Search' aria-describedby='imagesearch'>
                            </div>
                          </div>

                          <div class='col-12'>
                            <div id='imageselect' class='row g-0'>
                              <div class='col p-1'><img width='128' src='/assets/images/profile_placeholder.png' /></div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!--- <div class='tab-pane fade' id='settings' role='tabpanel' aria-labelledby='settings-tab'>
                    <div class='row mt-3'>
                      <div class='col-md-6'>
                        <div class='row g-3'>
                          <div class='col-12'>
                            <label class='form-label' for='ben_allowcomments'>Allow Comments</label>
                            <select class='form-control' name='ben_allowcomments' id='ben_allowcomments'>
                              <option value='true' #ifin(mEntry.allowcomments(), 'selected')#>Yes</option>
                              <option value='false' #ifin(mEntry.allowcomments(), 'selected')#>No</option>
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
                            <cfif mBlog.isAuthorized('ReleaseEntries')>
                              <select class='form-control' name='ben_released' id='ben_released'>
                                <option value='true' #ifin(mEntry.released(), 'selected')#>Yes</option>
                                <option value='false' #ifin(mEntry.released(), 'selected')#>No</option>
                              </select>
                            <cfelse>
                              #yesNoFormat(mEntry.released())#
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
                              <cfif len(mEntry.attachment())>
                                #listLast(mEntry.attachment(),'/')#
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
                  </div> --->

                  <!--- <div class='tab-pane fade' id='related' role='tabpanel' aria-labelledby='related-tab'>
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
                              <cfloop array='#mEntry.RelatedBlogEntries()#' item='mRBE'>
                                <option value='#mRBE.RelatedBlogEntry().benid()#'>#mRBE.RelatedBlogEntry().title()#</option>
                              </cfloop>
                            </select>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <cfif mEntry.persisted()>
                    <div class='tab-pane fade' id='comments' role='tabpanel' aria-labelledby='comments-tab'>
                      TODO / TBD
                      <!--- <iframe src='entry_comments.cfm?id=#url.id#' id='commentsFrame' name='commentsFrame' style='width: 100%; min-height: 500px; overflow-y: hidden;' scrolling='false' frameborder='0' marginheight='0' marginwidth='0'></iframe> --->
                    </div>
                  </cfif> --->
                </div>
              </div>
              <div class='row mt-3'>
                <div class='col text-center'>
                  <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                  <button type='button' name='btnPreview' id='btnPreview' class='btn btn-nmg'>Preview</button>
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
