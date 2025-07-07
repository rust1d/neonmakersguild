<cfscript>
  soup = createObject('java', 'org.jsoup.Jsoup');

  string function preview(required string words, numeric chars=150) {
    var parsed = soup.parse(words).text();
    if (parsed.len() < chars) return parsed;
    var data = parsed.left(chars).listToArray(' ');
    data.pop();
    return data.toList(' ') & '&hellip;';
  }

  qryActivity = mUser.recent_activity(utility.paged_term_params(maxrows: 30));
  pagination = request.pagination.last;
</cfscript>

<cfoutput>
  <div class='col-12 content-card'>
    <cfif !pagination.one_page>
      <div class='row mb-3'>
        #router.include('shared/partials/filter_and_page', { pagination: pagination })#
      </div>
    </cfif>

    <table class='table table-borderless bg-nmg-light'>
      <thead>
        <tr>
          <td class='w-120px'></td>
          <td class='w-50'></td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        <cfloop query='#qryActivity#'>
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
        </cfloop>
      </tbody>
    </table>


    <!--- <div class='card'>
      <cfif !pagination.one_page>
        <div class='card-body border-top-0 pt-2 pb-0'>
          <div class='row'>
            #router.include('shared/partials/filter_and_page', { pagination: pagination })#
          </div>
        </div>
      </cfif>
      <div class='card-body'>

      </div>
      <div class='card-footer bg-nmg-light'>
        <cfif pagination.one_page>
          #utility.plural_label(pagination.total, 'record')#
        <cfelse>
          <div class='row align-items-center'>
            #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
          </div>
        </cfif>
      </div>
    </div> --->

    <div class='border-top pt-3'>
      <div class='row align-items-center'>
        #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
      </div>
    </div>
  </div>
</cfoutput>
