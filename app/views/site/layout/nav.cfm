<cfoutput>
  <nav class='navbar fixed-top bg-light navbar-light px-lg-5'>
    <div class='container-fluid px-lg-5'>
      <a class='navbar-brand abs' href='##'>
        <img src='/assets/images/nmg_logo.png' class='img-fluid'>
      </a>
      <cfif len(session.site.logo_path())>
        <div class='navbar-nav ms-auto d-none d-md-block d-lg-block'>
          <img src='#session.site.logo_path()#' class='img-fluid' style='max-width:200px;height:auto'/>
        </div>
      </cfif>
    </div>
  </nav>
</cfoutput>
