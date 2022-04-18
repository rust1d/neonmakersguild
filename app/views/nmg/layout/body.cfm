<cfset router.include('layout/nav') />

<cfset router.include('shared/flash_container') />

<main class='content'>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9 p-3'>
        <cfset router.include() />
      </div>
      <div class='col-md-3 p-3'>
        <cfif mUserBlog.id()==1>
          <cfset router.include('shared/sidebar') />
          <!--- <cfif ListFind('member/view,user/home', router.template())> --->
        <cfelse>
          <cfset router.include('member/sidebar') />
        </cfif>
      </div>
    </div>
  </section>
</main>

<cfset router.include('shared/flash_onload') />

<cfset router.include('layout/footer') />
