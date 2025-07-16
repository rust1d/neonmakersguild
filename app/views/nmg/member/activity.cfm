<cfscript>
  soup = createObject('java', 'org.jsoup.Jsoup');

  string function preview(required string words, numeric chars=200) {
    var parsed = soup.parse(words).text();
    if (parsed.len() < chars) return parsed;
    var data = parsed.left(chars).listToArray(' ');
    data.pop();
    return data.toList(' ') & '&hellip;';
  }

  qryActivity = mUser.recent_activity(utility.paged_term_params(maxrows: 50));
  sProfImg = new app.services.user.ProfileImage(0);
  pagination = request.pagination.last;
</cfscript>

<cfoutput>
  <div class='col-12'>
    <div class='row justify-content-end'>
      #router.include('shared/partials/filter_and_page', { pagination: pagination, placeholder: 'activity search...'  })#
    </div>
  </div>
  <cfloop query='#qryActivity#' group='act_date'>
    <div class='col-12 content-card activity-card'>
      <div class='activity-date'>
        #act_date.format('mmmm dd, yyyy')#
      </div>
      <cfloop>
        <div class='d-flex align-items-start gap-2 mt-2 position-relative'>
          <img src='#sProfImg.setId(act_ownid).src()#' class='flex-shrink-0' alt=''>
          <div class='flex-grow-1'>
            <div class='activity-header'>
              <span class='activity-date me-3'>#act_dla.format('h:nn tt')#</span>
              <span class='fw-semibold'>#mUser.user()#</span>
              <cfif act_source=='post'>
                added a new post <a class='activity-link stretched-link' href='#act_seolink#'>#act_title#</a>.
              <cfelseif act_source=='comment'>
                commented on <span class='fw-semibold'>#act_owner#</span>'s post <a class='activity-link stretched-link' href='#act_seolink#'>#act_title#</a>.
              <cfelseif act_source=='thread'>
                started a thread in <a class='activity-link stretched-link' href='#act_seolink#'>#act_title#</a>.
              <cfelseif act_source=='message'>
                replied in <span class='fw-semibold'>#act_owner#</span>'s thread <a class='activity-link stretched-link' href='#act_seolink####act_pkid#'>#act_title#</a>.
              </cfif>
            </div>
            <div class='activity-detail mt-1'>#preview(act_words)#</div>
          </div>

        </div>
      </cfloop>
    </div>
  </cfloop>
  <div class='col-12'>
    <div class='row justify-content-end'>
      #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
    </div>
  </div>

    <!--- <table class='table table-borderless bg-nmg-light'>
      <thead>
        <tr>
          <td class='w-120px'></td>
          <td class='w-50'></td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        <cfloop query='#qryActivity#' group='act_date'>
          <tr><td colspan='3'>#act_date#</td></tr>
          <cfoutput>
            <tr class='position-relative align-middle'>
              <td class='smaller w-120px'>
                #act_dla.format('yyyy-mm-dd')#
              </td>
              <cfif act_source=='post'>
                <td>
                  #mUser.user()# added a new post "<a class='stretched-link' href='/post/#act_seolink#'>#act_title#</a>".
                </td>
                <td class='small'>#preview(act_words)#</td>
              <cfelseif act_source=='comment'>
                <td>
                  #mUser.user()# commented on post "#act_title#".
                </td>
                <td class='small'>#preview(act_words)#</td>
              <cfelseif act_source=='thread'>
                <td >
                  #mUser.user()# started a thread in "<a class='stretched-link' href='/forum/#act_seolink.listFirst('/')#'>#act_title#</a>".
                </td>
                <td class='small'><a href='/forum/#act_seolink#'>#act_words#</a></td>
              <cfelseif act_source=='message'>
                <td>
                  #mUser.user()# replied in thread "<a class='stretched-link' href='/forum/#act_seolink####act_pkid#'>#act_title#</a>".
                </td>
                <td class='small'>#preview(act_words)#</td>
              </cfif>
            </tr>
          </cfoutput>
        </cfloop>
      </tbody>
    </table> --->

</cfoutput>
