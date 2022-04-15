<cfset router.include('layout/nav') />

<cfset router.include('shared/flash_container') />

<main class='content py-3'>
  <section class='container'>
    <div class='row'>
      <div class='col-md-9'>
        <cfset router.include() />
      </div>
      <div class='col-md-3'>
        <cfif router.template().listFirst('/')=='member'>
          <cfset router.include('member/sidebar') />
        <cfelse>
          <cfset router.include('shared/sidebar') />
        </cfif>
      </div>
    </div>
  </section>
</main>

<cfset router.include('shared/flash_onload') />

<cfset router.include('layout/footer') />
