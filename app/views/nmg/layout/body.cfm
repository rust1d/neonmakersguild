<cfset router.include('layout/nav') />
<cfset router.include('shared/flash_container') />

<main class='content'>
  <section class='container-lg'>
    <cfset router.include() />
  </section>
</main>

<cfset router.include('shared/flash_onload') />

<cfset router.include('layout/footer') />
