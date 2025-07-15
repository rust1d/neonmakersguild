<cfscript>
  usid = router.decode('usid');
  mUser = new app.models.Users();
  if (usid) mUser = mUser.find(usid);


  if (form.keyExists('btnAction')) {
    url.tab = 'actions';
    if (form.btnAction=='send_reminder') {
      if (new app.services.user.Actions().SendReminder(mUser)) {
        flash.success(mUser.user() & ' was sent a payment reminder.');
        router.redirect('user/renew');
      }
    } else if (form.btnAction=='mark_paid') {
      if (new app.services.user.Actions().MarkPaid(mUser)) {
        flash.success(mUser.user() & ' was mark paid.');
        router.redirect('user/renew');
      }
    }
  }

  if (form.keyExists('btnSubmit')) {
    form.us_email = form.us_email.lcase();
    mUser.set(form);
    if (mUser.safe_save()) {
      flash.success('User data saved.')
      if (form.keyExists('up_firstname')) {
        mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});
        mProfile.set(form);
        mProfile.safe_save();
      }
      if (len(form.get('no_note'))) {
        if (mUser.Notes(build: { no_note: form.no_note }).safe_save()) {
          flash.success('Note added.');
        }
      }

      if (usid==0) router.redirenc(page: 'user/edit', usid: mUser.usid());
    }
  }

  mProfile = mUser.UserProfile() ?: mUser.UserProfile(build: {});

  mode = mUser.new_record() ? 'Add' : 'Edit';
  active_tab = url.get('tab') ?: 'profile';
</cfscript>

<script>
  $(function() {
    $('input[name=action_renew]').on('change', function() {
      $('button[name="btnAction"]').attr('disabled', true);
      $(`#${this.dataset.activate}`).attr('disabled', false);
    });
  });
</script>

<cfoutput>
  <div class='row justify-content-center'>
    <div class='col'>
      <form method='post'>
        <div class='card'>
          <div class='card-header bg-nmg'>
            <div class='row'>
              <div class='col fs-5'>#mode# User</div>
            </div>
          </div>
          <div class='card-body bg-nmg'>
            <cfif mUser.new_record()>
              <div class='row g-3 mb-3 justify-content-center'>
                <div class='col-md-8'>
                  <label class='form-label required' for='us_user'>Username</label>
                  <input type='text' class='form-control' name='us_user' id='us_user' value='' maxlength='50' required />
                </div>
                <div class='col-md-8'>
                  <label class='form-label required' for='password'>Password</label>
                  <input type='text' class='form-control' name='password' id='password' value='' maxlength='50' required />
                </div>
              </div>
            <cfelse>
              <ul class='nav nav-tabs'>
                <li class='nav-item'>
                  <button class='nav-link pe-5 #ifin(active_tab=='profile', 'active')# bg-nmg' id='profile-tab' data-bs-toggle='tab' data-bs-target='##profile' type='button' role='tab' aria-controls='profile' aria-selected='true'>Profile</button>
                </li>
                <li class='nav-item'>
                  <button class='nav-link pe-5 #ifin(active_tab=='bio', 'active')# bg-nmg' id='bio-tab' data-bs-toggle='tab' data-bs-target='##bio' type='button' role='tab' aria-controls='bio' aria-selected='true'>Bio</button>
                </li>
                <li class='nav-item'>
                  <button class='nav-link pe-5 #ifin(active_tab=='notes', 'active')# bg-nmg' id='notes-tab' data-bs-toggle='tab' data-bs-target='##notes' type='button' role='tab' aria-controls='notes' aria-selected='true'>Notes</button>
                </li>
                <li class='nav-item'>
                  <button class='nav-link pe-5 #ifin(active_tab=='actions', 'active')# bg-nmg' id='actions-tab' data-bs-toggle='tab' data-bs-target='##actions' type='button' role='tab' aria-controls='actions' aria-selected='true'>Actions</button>
                </li>
              </ul>
              <div class='tab-content border'>
                <div class='tab-pane p-3 #ifin(active_tab=='profile', 'active')#' id='profile' role='tabpanel' aria-labelledby='profile-tab'>
                  <div class='row g-3'>
                    <div class='col-md-6'>
                      <label class='form-label' for='us_user'>Username</label>
                      <input type='text' class='form-control' name='us_user' id='us_user' value='#encodeForHTML(mUser.user())#' maxlength='50' readonly />
                    </div>
                    <div class='col-md-6'>
                      <label class='form-label' for='password'>Change Password</label>
                      <input type='text' class='form-control' name='password' id='password' value='' maxlength='50' />
                    </div>
                    <div class='col-md-6'>
                      <label class='form-label required' for='up_firstname'>First name</label>
                      <input type='text' class='form-control' name='up_firstname' id='up_firstname' value='#encodeForHTML(mProfile.firstname())#' maxlength='50' required />
                    </div>
                    <div class='col-md-6'>
                      <label class='form-label required' for='up_lastname'>Last name</label>
                      <input type='text' class='form-control' name='up_lastname' id='up_lastname' value='#encodeForHTML(mProfile.lastname())#' maxlength='50' required />
                    </div>
                    <div class='col-md-6'>
                      <label class='form-label required' for='us_email'>Email Address</label>
                      <input type='email' class='form-control' name='us_email' id='us_email' value='#encodeForHTML(mUser.email())#' maxlength='50' required />
                    </div>
                    <div class='col-md-6'>
                      <label class='form-label' for='up_phone'>Phone</label>
                      <input type='tel' class='form-control' name='up_phone' id='up_phone' value='#mProfile.phone()#' maxlength='15' />
                    </div>
                    <div class='col-md-6'>
                      <label class='form-label' for='us_permissions'>Admin Level</label>
                      <select class='form-select' name='us_permissions' id='us_permissions'>
                        <cfloop list='0,None|1,Admin|2,Super Admin' item='val' delimiters='|'>
                          <option value='#val.listFirst()#' #ifin(val.listFirst() eq mUser.permissions(), 'selected')#>#val.listLast()#</option>
                        </cfloop>
                      </select>
                    </div>
                    <div class='col-md-6'>
                      <label class='form-label' for='up_promo'>T-Shirt Size</label>
                      <input type='promo' class='form-control' name='up_promo' id='up_promo' value='#encodeForHTML(mProfile.promo())#' maxlength='50' />
                    </div>
                    <div class='col-12'>
                      <label class='form-label' for='up_location'>Location</label>
                      <input type='text' class='form-control' id='up_location' name='up_location' value='#encodeForHTML(mProfile.location())#' maxlength='100' />
                    </div>
                    <div class='col-12 col-md-6 mb-3'>
                      <label class='form-label' for='up_address1'>Address 1</label>
                      <input type='text' class='form-control' name='up_address1' id='up_address1' value='#encodeForHTML(mProfile.address1())#' maxlength='50' />
                    </div>
                    <div class='col-12 col-md-6 mb-3'>
                      <label class='form-label' for='up_address2'>Address 2</label>
                      <input type='text' class='form-control' name='up_address2' id='up_address2' value='#encodeForHTML(mProfile.address2())#' maxlength='25' />
                    </div>
                    <div class='col-12 col-md-6 mb-3'>
                      <label class='form-label' for='up_city'>City</label>
                      <input type='text' class='form-control' name='up_city' id='up_city' value='#encodeForHTML(mProfile.city())#' maxlength='25' />
                    </div>
                    <div class='col-12 col-md-3 mb-3'>
                      <label class='form-label' for='up_region'>State/Region Code</label>
                      <input type='text' class='form-control' name='up_region' id='up_region' value='#encodeForHTML(mProfile.region())#' maxlength='25' />
                    </div>
                    <div class='col-12 col-md-3 mb-3'>
                      <label class='form-label' for='up_postal'>ZIP/Postal Code</label>
                      <input type='text' class='form-control' name='up_postal' id='up_postal' value='#mProfile.postal()#' maxlength='12' />
                    </div>
                    <div class='col-12 col-md-6 mb-3'>
                      <label class='form-label' for='up_country'>Country Code</label>
                      <input type='text' class='form-control' name='up_country' id='up_country' value='#mProfile.country()#' maxlength='2' />
                    </div>
                  </div>
                </div>
                <div class='tab-pane p-3 #ifin(active_tab=='bio', 'active')#' id='bio' role='tabpanel' aria-labelledby='bio-tab'>
                  <div class='row g-3'>
                    <div class='col-12'>
                      <label class='form-label' for='up_bio'>Bio</label>
                      <textarea class='tiny-mce form-control' rows='15' name='up_bio' id='up_bio'>#encodeForHTML(mProfile.bio())#</textarea>
                    </div>
                  </div>
                </div>
                <div class='tab-pane p-3 #ifin(active_tab=='notes', 'active')#' id='notes' role='tabpanel' aria-labelledby='notes-tab'>
                  <div class='row g-3'>
                    <div class='col-12'>
                      <table class='table table-sm table-striped table-hover'>
                        <thead>
                          <tr>
                            <td class='col-auto'><i class='fa-solid fa-fw fa-pencil me-3'></i> Date</td>
                            <td class='col-auto'>Poster</td>
                            <td class='col-8'>Note</td>
                          </tr>
                        </thead>
                        <tbody>
                          <cfloop array='#mUser.Notes()#' item='mNote'>
                            <tr>
                              <td>
                                <a href='#router.hrefenc(page: 'user/note', noid: mNote.noid())#'>
                                  <i class='fa-solid fa-fw fa-pencil me-3'></i>
                                  #mNote.added().format('yyyy-mm-dd HH:nn')#
                                </a>
                              </td>
                              <td>
                                #mNote.poster()#
                              </td>
                              <td>#mNote.note()#</td>
                            </tr>
                          </cfloop>
                        </tbody>
                      </table>
                    </div>
                  </div>
                  <div class='row'>
                    <div class='col-12'>
                      <label for='no_note'>Add Note</label>
                      <textarea name='no_note' id='no_note' class='form-control' maxlength='2000'></textarea>
                    </div>
                  </div>
                </div>
                <div class='tab-pane p-3 #ifin(active_tab=='actions', 'active')#' id='actions' role='tabpanel' aria-labelledby='actions-tab'>
                  <cfif mUser.past_due_days() GT -30>
                    <div class='card'>
                      <div class='card-header'>Membership Renewal</div>
                      <div class='card-body'>
                        <div class='row'>
                          <div class='col-6'>
                            <div class='row'>
                              <div class='col-4'>Renew Date</div>
                              <div class='col-8'>#mUser.next_renewal()#</div>
                            </div>
                            <div class='row'>
                              <div class='col-4'>
                                <cfif mUser.past_due_days() GT 0>
                                  Past Due
                                <cfelse>
                                  Due In Days
                                </cfif>
                              </div>
                              <div class='col-8'>
                                #utility.plural_label(abs(mUser.past_due_days()), 'day')#
                              </div>
                            </div>
                          </div>
                          <div class='col-6'>
                            <div class='form-check'>
                              <input class='form-check-input' type='radio' name='action_renew' id='send_reminder' data-activate='btnSendReminder'>
                              <label class='form-check-label text-small' for='send_reminder'>
                                <cfif new app.services.user.Actions().SentReminder(mUser)>
                                  <span class='text-warning'>A reminder was sent in the past #utility.plural_label(application.settings.renewal_reminder_cooldown, 'day')#</span>
                                <cfelse>
                                  Send this member a payment reminder.
                                </cfif>
                              </label>
                            </div>
                            <div class='text-center mt-2'>
                              <button type='button' class='btn btn-nmg w-50' disabled name='btnAction' id='btnSendReminder' onclick='postButton(this)' value='send_reminder'>Send Renewal Email</button>
                            <hr>
                            <div class='form-check'>
                              <input class='form-check-input' type='radio' name='action_renew' id='mark_paid' data-activate='btnMarkPaid'>
                              <label class='form-check-label text-small' for='mark_paid'>
                                Mark this member paid and renew their membership.
                              </label>
                            </div>
                            <div class='text-center mt-2'>
                              <button type='button' class='btn btn-nmg w-50' disabled name='btnAction' id='btnMarkPaid' onclick='postButton(this)' value='mark_paid'>Renew Membership</button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  <cfelse>
                    <p>There are no actions available for this user currently.</p>
                  </cfif>
                </div>
              </div>
            </cfif>
            <div class='row mb-3'>
              <div class='col text-center'>
                <button type='submit' name='btnSubmit' id='btnSubmit' class='btn btn-nmg'>Save</button>
                <a href='#router.href('user/list')#' class='btn btn-nmg-cancel'>Cancel</a>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</cfoutput>
