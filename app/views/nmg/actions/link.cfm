<cfscript>
  if (utility.isAjax()) {
    data = utility.json_content();
    if (data.keyExists('blog') && data.keyExists('pkid')) {
      request.xhr_data = new app.services.Incrementor().link(data.blog, data.pkid);
    }
  }
</cfscript>
