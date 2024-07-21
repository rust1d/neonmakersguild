<cfinclude template='_global.cfm' runonce='true' />

<!DOCTYPE html>
<html xmlns='http://www.w3.org/1999/xhtml' data-bs-theme='<cfoutput>#session.site.theme()#</cfoutput>'>
  <head>
    <cfset router.include('layout/head') />
  </head>
  <body>
    <cfset router.include('layout/body') />
    <div id='dialog'></div>
  </body>
</html>
