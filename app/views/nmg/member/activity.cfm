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
  <div class='card-body border-top-0 py-2'>
    <div class='row'>
      #router.include('shared/partials/filter_and_page', { pagination: pagination })#
    </div>
  </div>
  <div class='card-body pt-0'>
    <div class='row g-3'>
      <cfloop query='#qryActivity#'>
        <div class='col-12'>
          <cfif act_source=='post'>
            #mUser.user()# added a new blog post "<a href='/post/#act_seolink#'>#act_title#</a>".
            <div class='smaller'>#preview(act_words)#</div>
          <cfelseif act_source=='comment'>
            #mUser.user()# commented on blog post "#act_title#".
            <div class='smaller'>#preview(act_words)#</div>
          <cfelseif act_source=='thread'>
            #mUser.user()# started a new thread "<a href='/forum/#act_seolink#'>#act_words#</a>" in "<a href='/forum/#act_seolink.listFirst('/')#'>#act_title#</a>".
          <cfelseif act_source=='message'>
            #mUser.user()# posted a message in thread "<a href='/forum/#act_seolink####act_pkid#'>#act_title#</a>".
            <div class='smaller'>#preview(act_words)#</div>
          </cfif>
          <div class='smaller text-muted'>#utility.ordinalDate(act_dla)#</div>
        </div>
      </cfloop>
    </div>
  </div>
  <div class='card-footer bg-nmg-light'>
    <div class='row align-items-center'>
      #router.include('shared/partials/filter_and_page', { pagination: pagination, footer: true })#
    </div>
  </div>
</cfoutput>
