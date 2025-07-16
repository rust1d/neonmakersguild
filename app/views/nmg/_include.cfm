<cfscript>
  string function nmg_divider() {
    return "<div class='centered-logo-line'>" &
             "<span class='bull-1'>&bull;</span>" &
             "<span class='bull-2'>&bull;</span>" &
             "<span class='bull-3'>&bull;</span>" &
             "<img src='#application.urls.cdn#/assets/images/logo-256.png' />" &
             "<span class='bull-3'>&bull;</span>" &
             "<span class='bull-2'>&bull;</span>" &
             "<span class='bull-1'>&bull;</span>" &
           "</div>";
  }

  variables.mUserBlog = new app.services.user.Blog(url.blogid ?: 1);
  variables.mBlog = new app.services.user.Blog(1);
</cfscript>

<cfset router.include('shared/blog/_modal_image') />
<cfset router.include('shared/blog/_modal_post') />
