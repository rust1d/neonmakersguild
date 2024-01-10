<cfscript>
  mdl = new app.models.Users();

  param form.days_past_due = -30;
  params = {
    days_past_due: form.days_past_due,
    maxrows: 100
  }

  options = StructNew('ordered');
  options['-30'] = 'Due in the next 30 days';
  options['7'] =   '1 week past due';
  options['14'] =  '2 weeks past due';
  options['30'] =  '30 days past due';

  mUsers = mdl.where(utility.paged_term_params(params));
  sActions = new app.services.user.Actions();

  if (form.keyExists('btnSubmit')) {
    renews = mUsers.filter(row => row.past_due_days() GTE form.days_past_due);
    arrUsers = [];
    for (mUser in renews) {
      if (sActions.SentReminder(mUser)) continue;
      sActions.SendReminder(mUser);
      arrUsers.append('<span class="badge bg-warning">#mUser.user()#</span>');
    }
    if (arrUsers.len()) {
      flash.success('Sent renewal reminders to the following users: <br>' & arrUsers.toList(', '));
    }
  }

  pagination = mdl.pagination();
</cfscript>

<script>
  $(function() {
    $('#btnToggleSent').on('click', function() {
      var state = (parseInt(this.dataset.state)+1)%2;
      this.dataset.state = state;
      var lbl = state ? 'Hide' : 'Show';
      $(this).text(lbl + ' Already Sent');
      var cnt = $('#user_rows').find('div[data-state=true]').toggle(state==1).length;
      if (state) {
        $('#users_found').text(`Found ${this.dataset.cnt} record(s)`);
      } else {
        $('#users_found').text(`Showing ${this.dataset.cnt-cnt} of ${this.dataset.cnt} record(s)`);
      }

    });
  });
</script>

<cfoutput>
  <div class='card'>
    <div class='card-header bg-nmg'>
      <div class='row'>
        <div class='col-auto'>
          <div class='input-group input-group-sm'>
            <a href='#router.href('user/edit')#' class='btn btn-sm btn-nmg' title='Add'>
              <i class='fal fa-plus'></i>
            </a>
          </div>
        </div>
        <div class='col fs-5'>Users</div>
        #router.include('shared/partials/filter_and_page', { pagination: pagination })#
      </div>
    </div>
    <div class='card-header'>
      <form method='post'>
        <div class='row border border-warning pt-3'>
          <div class='col-6'>
            <div class='input-group mb-3 w-100'>
              <label class='input-group-text' for='days_past_due'>Show users that are </label>
              <select class='form-select' id='days_past_due' name='days_past_due' onchange='this.form.submit()'>
                <cfloop collection='#options#' item='key'>
                  <option value='#key#' #ifin(form.days_past_due EQ key)#>#options[key]#</option>
                </cfloop>
              </select>
              <button name='btnGo' class='btn btn-nmg' type='submit'>Display</button>
            </div>
          </div>
          <div class='col-6'>
            <button type='button' id='btnToggleSent' class='btn btn-nmg' data-state='1' data-cnt='#mUsers.len()#'>Hide Already Sent</button>
            <span class='p-2 smaller' id='users_found'>
              Found #mUsers.len()# record(s)
            </span>
          </div>
          <div class='col-6'>
            <div class='input-group mb-3 w-100'>
              <label class='input-group-text' for='days_past_due'>Send reminder emails to displayed users</label>
              <button name='btnSubmit' class='btn btn-nmg' data-confirm='Are you sure you want to send reminders to all users #options[form.days_past_due].lcase()#?' type='submit'>Send</button>
            </div>
          </div>
          <div class='col-6 smaller'>
            User sent reminders in the past #utility.plural_label(application.settings.renewal_reminder_cooldown, 'day')# will be skipped.
          </div>
        </div>
      </form>
    </div>
    <div class='card-body' id='user_rows'>
      <cfloop array='#mUsers#' item='mUser'>
        <div class='row my-3' data-state='#sActions.SentReminder(mUser)#'>
          <div class='col-1'>
            <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#'>
              <img class='img-thumbnail w-auto' src='#mUser.profile_image().src()#' />
            </a>
          </div>
          <div class='col-5'>
            <div class='lead'>
              <a href='#router.hrefenc(page: 'user/edit', usid: mUser.usid())#'>
                <i class='fal fa-pencil'></i> #mUser.user()#
              </a>
              <div>#mUser.UserProfile().firstname()# #mUser.UserProfile().lastname()#</div>
              <div>#mUser.UserProfile().location()#</div>
            </div>
          </div>
          <div class='col-4'>
            #mUser.next_renewal()# (#utility.plural_label(abs(mUser.past_due_days()), 'day')#)
            <cfif sActions.SentReminder(mUser)>
              <div class='form-text text-warning smaller'>
                Reminder sent #mUser.renewal().format('yyyy-dd-mm')#
              </div>
            </cfif>
          </div>
        </div>
      </cfloop>
    </div>
    <div class='card-footer bg-nmg'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
