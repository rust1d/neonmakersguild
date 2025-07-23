<cfset router.include('layout/nav') />
<cfset router.include('shared/flash_container') />

<main class='content'>
  <section class='container-fluid'>
    <div class='container-lg p-0 px-sm-3'>
      <cfset router.include() />
    </div>
  </section>
</main>

<cfset router.include('shared/flash_onload') />

<cfset router.include('layout/footer') />
