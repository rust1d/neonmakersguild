<cfscript>
  include '_global.cfm' runonce = true;

  request.layout_title = session.site.title();
  request.layout_head = '';
  request.meta_desc = '';

  // GENERATE body BEFORE head TO ASSIGN DATA TO request.layout_head and layout_title
  // THIS ALLOWS THE BODY TO SET STUFF IN THE HEAD
  layout_body = router.generate('layout/body');
</cfscript>

<cfoutput>
  <!DOCTYPE html>
  <html xmlns='https://www.w3.org/1999/xhtml' lang='en' data-bs-theme='#session.site.theme()#'>
    <head>
      <title>#request.layout_title#</title>
      <meta name='description' content='#request.meta_desc#' />
      #router.include('layout/head')#
      #request.layout_head# <!--- DYNAMIC HEAD CONTENT SET IN INCLUDED TEMPLATES ie og:tags --->
    </head>
    <body id='main-body'>
      #layout_body#
      <div id='dialog'></div>
    </body>
  </html>
</cfoutput>
