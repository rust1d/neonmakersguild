<cfset router.include('layout/nav') />
<cfset router.include('shared/flash_container') />
<main class='content py-3'>
  <cfset router.include() />
</main>
<cfset router.include('shared/flash_onload') />
<cfset router.include('layout/footer') />
