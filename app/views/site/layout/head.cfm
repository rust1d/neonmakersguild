<cfoutput>
  <meta http-equiv='content-type' content='text/html; charset=utf-8' />
  <title>#session.site.title()#&reg;</title>
  <meta name='keywords' content='' />
  <meta name='description' content='' />

  <cfheader name='Content-Security-Policy' value="script-src 'self' 'unsafe-inline' cdnjs.cloudflare.com cdn.jsdelivr.net stackpath.bootstrapcdn.com code.jquery.com *.fontawesome.com *.neonmakersguild.org *.googletagmanager.com www.google.com www.google-analytics.com ajax.googleapis.com connect.facebook.net;" />
  <cfheader name='Content-Security-Policy' value="style-src 'self' 'unsafe-inline' cdnjs.cloudflare.com cdn.jsdelivr.net stackpath.bootstrapcdn.com *.fontawesome.com *.neonmakersguild.org neonmakersguild.org *.googleapis.com code.jquery.com;" />
  <cfheader name='Content-Security-Policy' value="font-src 'self' fonts.googleapis.com fonts.gstatic.com *.fontawesome.com;" />

  <link rel='apple-touch-icon' sizes='180x180' href='/apple-touch-icon.png' />
  <link rel='icon' type='image/png' sizes='32x32' href='/favicon-32x32.png' />
  <link rel='icon' type='image/png' sizes='16x16' href='/favicon-16x16.png' />
  <link rel='manifest' href='/site.webmanifest' />
  <link rel='preconnect' href='https://fonts.gstatic.com' />
  <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css' integrity='sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC' crossorigin='anonymous' />
  <link rel='stylesheet' href='/assets/css/#session.site.get_site()#.css'  type='text/css' />
  <link rel='stylesheet' href='/assets/css/passtrength.css' />
  <link rel='stylesheet' href='/assets/css/profile_image.css' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Arimo&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap' />
  <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500&display=swap' />
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.css' integrity='sha512-zxBiDORGDEAYDdKLuYU9X/JaJo/DPzE42UubfBw9yg8Qvb2YRRIQ8v4KsGHOx2H1/+sdSXyXxLXv5r7tHc9ygg==' crossorigin='anonymous' referrerpolicy='no-referrer' />
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/plupload/3.1.3/jquery.plupload.queue/css/jquery.plupload.queue.min.css' integrity='sha512-50UY9VY37/VxML0pGNJb59uufYoNCfrnYb81jx6AswTD5mRhdnXfBeyA6uxOfygxRZqj7jCjDjtIXRmTlOc48w==' crossorigin='anonymous' referrerpolicy='no-referrer' />
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/css/froala_editor.min.css' integrity='sha512-Icug+j3PewmVsC2tiG/QDVzn32orGfxRbRhkxNdl2qVnItdahtXk0V6N9u3C1rhEmejlCekuwzpn2gU15x017Q==' crossorigin='anonymous' />
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/css/froala_style.min.css' integrity='sha512-p0fJggmLtYbHafPnk/2TAbDF0ZFfYbWQUBhIO7Yk9fml7wz3YrYOaXM29oF5eNMdE+FqYyDhnpAwlTfaqAXGfg==' crossorigin='anonymous' />
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/css/plugins/char_counter.min.css' integrity='sha512-zGs1TKj1aloDnTvuZA5YNwcDlO7exugxZcSF0M3cOF18pLXoqyfbqFVperNASYqGLJ4u6d8P4/J+ERPv/Fot7Q==' crossorigin='anonymous' />
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/css/plugins/colors.min.css' integrity='sha512-vDTV2rU7IuLNamq/JL1LW8JCEp0AhUBQrNnx6vkblT6GGj2Vcr8XLDgtqaRyUaPYKac/JMn8XlXQcK2QYVMcuQ==' crossorigin='anonymous' />
  <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/froala-editor@latest/css/plugins/code_view.min.css' />

  <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js' integrity='sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM' crossorigin='anonymous'></script>
  <script src='https://code.jquery.com/jquery-3.6.0.min.js' integrity='sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=' crossorigin='anonymous'></script>
  <script src='https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js'></script>
  <script src='https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js'></script>
  <script src='https://cdn.jsdelivr.net/npm/jquery-validation@1.19.3/dist/jquery.validate.min.js'/></script>
  <script src='https://cdn.jsdelivr.net/npm/exif-js'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/plupload/3.1.3/jquery.plupload.queue/jquery.plupload.queue.min.js' integrity='sha512-mRFccErFADX+wynH+FMBQtUu2S9gK4T3x+bQoYWISL8L4Y7l7db1KEtYcoAAtmCkR353nAnkkNLeNjSxEWnUtw==' crossorigin='anonymous' referrerpolicy='no-referrer'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/plupload/3.1.3/plupload.full.min.js'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.js' integrity='sha512-Gs+PsXsGkmr+15rqObPJbenQ2wB3qYvTHuJO6YJzPe/dTLvhy0fmae2BcnaozxDo5iaF8emzmCZWbQ1XXiX2Ig==' crossorigin='anonymous' referrerpolicy='no-referrer'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/froala_editor.min.js' integrity='sha512-zwud+SxM0PHrGE0vq14zhkX2RmTBO20o9+sOytjGNUPhsGhMsnkuJ0WsJ1BYB2fVGuDMJ1O1tHAYJSU9q7lJqg==' crossorigin='anonymous'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/plugins/char_counter.min.js' integrity='sha512-WcYhr3P3df+VdzknNgtIhRhBT6svNC7PY4rY9fh7OeRRKpYJvZkLCs6syqY0M5zxeCxhpTRQMS12OEqP3zwb3Q==' crossorigin='anonymous'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/plugins/colors.min.js' integrity='sha512-bsPu5rildVjT7gjvG9hzDpjYJiKTaGyF/OwG2JXD8VbMXWZ4WNIrfv6KwZ+PGM4zu1BvQwFhaqYtv2Lz6m7y8w==' crossorigin='anonymous'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/plugins/font_family.min.js' integrity='sha512-F6yzhMFq821kjNP2Y167SGT/kSAUAUuK8fe+WCeYsXaxg0z50Ff56rUCbirQuel7hpm5Vd6GJNKzaIQ1shmMWQ==' crossorigin='anonymous'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/plugins/font_size.min.js' integrity='sha512-fwDu7uy7weGFTwE4OFUxh6yg1vHJaxayDPgBr5kxl6RMsVskxzkKD6mw9Z1oFI+CwHQv0sfTJbOWvgIxK4Y0Bg==' crossorigin='anonymous'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/plugins/lists.min.js' integrity='sha512-aG+gUeErTUBAikEp14kA4hyyBQu3tO0OWz4j+QLbezYG+h+ivWwKiNHDJTlFeWNMSJoYKDUJCjmsIoAuJJKa4g==' crossorigin='anonymous'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/plugins/paragraph_format.min.js' integrity='sha512-s732ssmcN5Mld9wj4mM1I0fiu4ObR/KtLzLHyLMvLSYxKE0PQQJawQWH0yfsOwCbGhracJVTnk/beKhvG41fHg==' crossorigin='anonymous'></script>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/3.2.6/js/plugins/paragraph_style.min.js' integrity='sha512-gy5ZX5bbK8ekJ2oAvIMe+til+3P30XuFbG7YFSQqIiBz6BwChE3q4WMouwQgPgTQRTFm9v5prs4SbSMVnAvSxA==' crossorigin='anonymous'></script>

  <script src='https://cdn.jsdelivr.net/npm/froala-editor@latest/js/plugins/code_view.min.js'></script>

  <script src='https://kit.fontawesome.com/46a01629b8.js' crossorigin='anonymous'></script><!--- v6 --->
  <script src='/assets/js/jquery/jquery.passtrength.js'></script>
  <script src='/assets/js/bs_needs_validation.js'></script>

  <script>
    var SERVER = {};
    SERVER.root = '#application.paths.remote.root#';
  </script>
</cfoutput>
