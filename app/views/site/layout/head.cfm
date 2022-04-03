<cfoutput>
  <meta http-equiv='content-type' content='text/html; charset=utf-8' />
  <title>#session.site.title()#&reg;</title>
  <meta name='keywords' content='' />
  <meta name='description' content='' />

  <cfheader name="Content-Security-Policy" value="script-src 'self' 'unsafe-inline' cdnjs.cloudflare.com cdn.jsdelivr.net stackpath.bootstrapcdn.com code.jquery.com *.fontawesome.com *.neonmakersguild.org *.googletagmanager.com www.google.com www.google-analytics.com ajax.googleapis.com connect.facebook.net;" />
  <cfheader name="Content-Security-Policy" value="style-src 'self' 'unsafe-inline' cdnjs.cloudflare.com cdn.jsdelivr.net stackpath.bootstrapcdn.com *.fontawesome.com *.neonmakersguild.org neonmakersguild.org *.googleapis.com code.jquery.com;" />
  <cfheader name="Content-Security-Policy" value="font-src 'self' fonts.googleapis.com fonts.gstatic.com *.fontawesome.com;" />

  <link rel='apple-touch-icon' sizes='180x180' href='/apple-touch-icon.png' />
  <link rel='icon' type='image/png' sizes='32x32' href='/favicon-32x32.png' />
  <link rel='icon' type='image/png' sizes='16x16' href='/favicon-16x16.png' />
  <link rel='manifest' href='/site.webmanifest' />
  <link rel='preconnect' href='https://fonts.gstatic.com' />
  <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css' integrity='sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC' crossorigin='anonymous' />
  <link rel='stylesheet' href='/assets/css/main.css'  type='text/css' />
  <link rel='stylesheet' href='/assets/css/passtrength.css' />
  <!---
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Arimo&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap' />
  --->

  <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js' integrity='sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM' crossorigin='anonymous'></script>
  <script src='https://code.jquery.com/jquery-3.6.0.min.js' integrity='sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=' crossorigin='anonymous'></script>
  <script src='https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js'></script>
  <script src='https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js'></script>
  <script src='/assets/js/jquery/jquery.passtrength.js'></script>
  <script src='/assets/js/bs_needs_validation.js'></script>

  <script>
    var SERVER = {};
    SERVER.root = '#application.paths.securesiteroot#';
  </script>
</cfoutput>
