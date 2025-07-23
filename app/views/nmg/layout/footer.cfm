<cfoutput>
  <div id='footer' class='bg-nmg mt-5 text-center'>
    <p id='social'>
      <cfloop array='#mBlog.owner().profile_links()#' item='mLink'>
        <span class='p-3'>#mLink.icon_link('fa-lg')#</span>
      </cfloop>
      <span class='p-3'><a class='btn btn-icon btn-icon-link' href='mailto:#application.email.membership#' target='_blank'><i class='fa-solid fa-at fa-lg'></i></a></span>
    </p>
    <p id='legal' class='small'>
      <a href='/page/privacy' class='smallest'>Privacy Policy</a>
      &nbsp;&bull;&nbsp;&nbsp;
      <a href='/page/bylaws' class='smallest'>NMG Bylaws</a>
    </p>
    <p class='small' title='#utility.plural_label(now().Diff('s', GetPageContext().GetFusionContext().GetStartTime()), 'second')#'>&copy; #now().year()# Neon Makers Guild&reg;</p>
  </div>
</cfoutput>
