<cfoutput>
  <div id='footer' class='bg-nmg-dark text-white-50 mt-5 text-center py-4'>
    <div class='mb-3'>
      <img src='#application.urls.cdn#/assets/images/logo-256.png' alt='NMG' height='48' class='mb-2' />
    </div>
    <div class='mb-3'>
      <cfloop array='#mBlog.owner().profile_links()#' item='mLink'>
        <span class='px-2'>#mLink.icon_link('fa-xl')#</span>
      </cfloop>
      <span class='px-2'><a class='btn btn-icon btn-icon-link' href='mailto:#application.email.membership#' target='_blank'><i class='fa-solid fa-at fa-xl'></i></a></span>
    </div>
    <div class='small mb-2'>
      <a href='/page/privacy' class='text-white-50'>Privacy Policy</a>
      &nbsp;&bull;&nbsp;
      <a href='/page/bylaws' class='text-white-50'>NMG Bylaws</a>
    </div>
    <div class='smallest text-marker' title='#utility.plural_label(now().Diff('s', GetPageContext().GetFusionContext().GetStartTime()), 'second')#'>&copy; #now().year()# Neon Makers Guild&reg;</div>
  </div>
</cfoutput>
