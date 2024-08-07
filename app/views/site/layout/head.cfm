<cfoutput>
  <meta http-equiv='content-type' content='text/html; charset=utf-8' />
  <title>#session.site.title()#&reg;</title>
  <meta name='keywords' content='' />
  <meta name='description' content='' />

  <cfheader name='Content-Security-Policy' value="script-src 'self' 'unsafe-inline' *.tinymce.com *.tiny.cloud cdnjs.cloudflare.com cdn.jsdelivr.net code.jquery.com *.fontawesome.com *.neonmakersguild.org www.gstatic.com *.googletagmanager.com www.google.com www.google-analytics.com ajax.googleapis.com;" />
  <cfheader name='Content-Security-Policy' value="style-src 'self' 'unsafe-inline' *.tinymce.com *.tiny.cloud cdnjs.cloudflare.com cdn.jsdelivr.net *.fontawesome.com *.neonmakersguild.org neonmakersguild.org *.googleapis.com code.jquery.com;" />
  <cfheader name='Content-Security-Policy' value="font-src 'self' *.tinymce.com *.tiny.cloud fonts.googleapis.com fonts.gstatic.com *.fontawesome.com;" />
  <cfheader name='Content-Security-Policy' value="connect-src 'self' *.tinymce.com *.tiny.cloud *.fontawesome.com blob:;" />
  <cfheader name='Content-Security-Policy' value="img-src 'self' * neonmg.s3.amazonaws.com *.tinymce.com *.tiny.cloud data: blob:;" />

  <link rel='apple-touch-icon' sizes='180x180' href='/apple-touch-icon.png' />
  <link rel='icon' type='image/png' sizes='32x32' href='/favicon-32x32.png' />
  <link rel='icon' type='image/png' sizes='16x16' href='/favicon-16x16.png' />
  <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' integrity='sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH' crossorigin='anonymous' />
  <link rel='stylesheet' href='/assets/css/main.css' type='text/css' />
  <link rel='stylesheet' href='/assets/css/#session.site.get_site()#/main.css' type='text/css' />
  <link rel='stylesheet' href='/assets/css/passtrength.css' />
  <link rel='stylesheet' href='/assets/css/profile_image.css' />

  <link rel='preconnect' href='https://fonts.googleapis.com' crossorigin />
  <link rel='preconnect' href='https://fonts.gstatic.com' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Arimo&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Permanent+Marker&display=swap'>
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.css' integrity='sha512-zxBiDORGDEAYDdKLuYU9X/JaJo/DPzE42UubfBw9yg8Qvb2YRRIQ8v4KsGHOx2H1/+sdSXyXxLXv5r7tHc9ygg==' crossorigin='anonymous' referrerpolicy='no-referrer' />

  <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js' integrity='sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz' crossorigin='anonymous'></script>
  <script src='https://code.jquery.com/jquery-3.7.1.min.js' integrity='sha384-1H217gwSVyLSIfaLxHbE7dRb3v4mYCKbpQvzx0cegeju1MVsGrX5xXxAvs/HgeFs' crossorigin='anonymous'></script>
  <script src='https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js'></script>
  <script src='https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js'></script>
  <script src='https://cdn.jsdelivr.net/npm/jquery-validation@1.19.3/dist/jquery.validate.min.js'/></script>
  <script src='https://cdn.jsdelivr.net/npm/exif-js'></script>
  <script src='https://www.google.com/recaptcha/api.js?render=6LeaIakfAAAAAFfh-JbzqJOJlqyI6JlFIKbkZNjZ'></script>
  <script src='https://cdn.tiny.cloud/1/g2016x44cjzgv7h689qtbieaowb03dksphmy0umsojeab13b/tinymce/6/tinymce.min.js' referrerpolicy='origin'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.js' integrity='sha512-Gs+PsXsGkmr+15rqObPJbenQ2wB3qYvTHuJO6YJzPe/dTLvhy0fmae2BcnaozxDo5iaF8emzmCZWbQ1XXiX2Ig==' crossorigin='anonymous' referrerpolicy='no-referrer'></script>
  <script src="https://kit.fontawesome.com/e3031fb88c.js" crossorigin="anonymous"></script><!--- v6 --->
  <script src="https://cdn.jsdelivr.net/npm/bs5-lightbox@1.8.0/dist/index.bundle.min.js"></script>
  <script src='/assets/js/jquery/jquery.passtrength.js'></script>
  <script src='/assets/js/bs_needs_validation.js'></script>
  <script src='/assets/js/main.js'></script>
  <script src='/assets/js/tiny.js'></script>

  <script>
    var SERVER = {};
    SERVER.root = '#application.urls.root#';
  </script>
</cfoutput>
