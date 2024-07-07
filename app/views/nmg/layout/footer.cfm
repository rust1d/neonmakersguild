<cfoutput>
  <div id='footer' class='bg-nmg mt-5'>
    <div class='container-xxl'>
      <div class='row pt-5'>
        <div class='col-12 text-center align-middle'>
          <p id='social'>
            <cfloop array='#mBlog.owner().profile_links()#' item='mLink'>
              <span class='p-3'>#mLink.icon_link()#</span>
            </cfloop>
            <span class='p-3'><a href='mailto:#application.email.supportplus#' target='_blank'><i class='fa-2x fa-solid fa-at'></i></a></span>
          </p>
          <p id='legal' class='small'>
            &copy; #now().year()# Neon Makers Guild&reg;
            &nbsp;|&nbsp;&nbsp;<cite class='smallest'>#utility.plural_label(now().Diff('s', GetPageContext().GetFusionContext().GetStartTime()), 'second')#</cite>
          </p>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
