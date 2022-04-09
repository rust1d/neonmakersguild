<cfscript>
  sSocials = new app.services.SocialIcons();
</cfscript>
<cfoutput>
  <div id='footer' class='bg-light pt-3'>
    <div class='container bg-light'>
      <div class='row'>
        <div class='col-9 text-center align-middle'>
          <p id='social' class='small'>
            <a href=''><img class='img-thumbnail' src='#sSocials.facebook()#' width='64'></a>
            <a href=''><img class='img-thumbnail' src='#sSocials.instagram()#' width='64'></a>
            <a href=''><img class='img-thumbnail' src='#sSocials.twitter_tweet()#' width='64'></a>
            <a href=''><img class='img-thumbnail' src='#sSocials.youtube_video()#' width='64'></a>
          </p>
          <p id='legal' class='small'>
            &copy; #now().year()# Neon Makers Guild&reg;
          </p>
        </div>
        <div class='col-3'>

        </div>
      </div>
    </div>
  </div>
</cfoutput>
