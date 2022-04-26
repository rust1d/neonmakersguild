<cfset router.include('layout/nav') />

<cfset router.include('shared/flash_container') />

<main class='content py-3'>
  <section class='container-xxl'>
    <cfset router.include() />
  </section>
</main>

<cfset router.include('shared/flash_onload') />

<cfset router.include('layout/footer') />
