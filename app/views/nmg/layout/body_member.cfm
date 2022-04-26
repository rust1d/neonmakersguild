<main class='content'>
  <section class='container-xxl'>
    <div class='row'>
      <div class='col-lg-9 p-3'>
        <cfset router.include() />
      </div>
      <div class='col-lg-3 p-3'>
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