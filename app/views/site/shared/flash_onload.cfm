<!---
  Usage:
  * USE `router.include('shared/flash')` TO PUT MESSAGES IN-LINE ON A PAGE EXACTLY WHERE YOU WANT THEM
  * USE `router.include('shared/flash_container')` TO HAVE MESSAGES NOT DISPLAYED IN-LINE MOVED TO WHERE THIS PARTIAL IS INCLUDED - CAN ONLY BE USED ONCE PER REQUEST
  * IF NO ELEMENT WITH ID `flash-messages` IS FOUND, UNDISPLAYED MESSAGES WILL BE FLOATED AT THE TOP OF THE PAGE
--->

<cfif flash.len()>
  <style>
    #flash.flash-fixed {
      z-index: 9999;
      top: 5rem;
    }
  </style>
  <div id='flash' class='d-flex w-100 position-fixed flash-fixed'>
    <div id='flash-onload' class='container d-none'>
      <cfset router.include('shared/flash') />
    </div>
  </div>
  <script>
    $(function () {
      if ($('#flash-messages').length) {
        $('#flash-onload div.alert').detach().appendTo('#flash-messages');
      } else {
        $('#flash-onload').toggleClass('d-none');
      }
    });
  </script>
</cfif>
