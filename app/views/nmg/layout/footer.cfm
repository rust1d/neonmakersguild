<cfscript>
  mLinks = mBlog.owner().social_links();
</cfscript>

<style>
</style>

<cfoutput>
  <div id='footer' class='bg-light pt-3'>
    <div class='container bg-light'>
      <div class='row mt-3'>
        <div class='col-12 text-center align-middle'>
          <p id='social'>
            <cfloop array='#mLinks#' item='mLink'>
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
