<cfoutput>
  <div id='footer' class='bg-nmg mt-5'>
    <div class='container-xxl'>
      <div class='row pt-5'>
        <div class='col-12 text-center align-middle'>
          <p id='social'>
            <cfloop array='#mBlog.owner().social_links()#' item='mLink'>
              <span class='p-3'>#mLink.icon_link()#</span>
            </cfloop>
          </p>
          <p id='legal' class='small'>
            &copy; #now().year()# Neon Makers Guild&reg;
          </p>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
