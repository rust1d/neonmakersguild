<cfscript>
  sSocials = new app.services.SocialIcons();
</cfscript>
<cfoutput>
  <div id='footer bg-nmg-secondary'>
    <div class="text-center py-4 mt-2 mx-4 sm-text-end">
      <p id='social' class='small'>
        <a href=''><img src='#sSocials.facebook()#' width='64'></a>
        <a href=''><img src='#sSocials.instagram()#' width='64'></a>
        <a href=''><img src='#sSocials.twitter_tweet()#' width='64'></a>
        <a href=''><img src='#sSocials.youtube_video()#' width='64'></a>
      </p>
      <p id='legal' class='small'>
        &copy; #now().year()# Neon Makers Guild&reg;
      </p>
    </div>
  </div>
</cfoutput>
