<cfset router.include('layout/nav') />
<cfset router.include('shared/flash_container') />

<main class='content'>
  <section class='container-xxl'>
    <cfif router.slug().listFirst('-')=='forum'>
      <cfset router.include() />
    <cfelseif router.slug().listFirst('-')=='user' || router.slug()=='member-view'>
      <div class='row'>
        <div class='col-lg-9 p-3'>
          <cfset router.include() />
        </div>
        <div class='col-lg-3 p-3'>
          <cfset router.include('member/sidebar') />
        </div>
      </div>
    <cfelse>
      <div class='row'>
        <div class='col-lg-9 p-3'>
          <cfset router.include() />
        </div>
        <div class='col-lg-3 p-3'>
          <cfset router.include('shared/sidebar') />
        </div>
      </div>
    </cfif>
  </section>
</main>

<cfset router.include('shared/flash_onload') />

<cfset router.include('layout/footer') />
