

<cfparam name="ATTRIBUTES.title" default="">
<cfparam name="ATTRIBUTES.showHome" default="false">
<cfparam name="ATTRIBUTES.id" default="blogHeader">

<div data-role="header" data-position="fixed" data-id="<cfoutput>#ATTRIBUTES.id#</cfoutput>"  <cfif ATTRIBUTES.showHome EQ 1>data-backbtn="false"</cfif>>
  <cfif ATTRIBUTES.showHome NEQ 1>
    <a href="index.cfm?" data-icon="arrow-l" data-rel="back" data-direction="reverse">Back</a>
  </cfif>
  <h1><cfoutput>#ATTRIBUTES.title#</cfoutput></h1>
  <cfif ATTRIBUTES.showHome NEQ 1>
    <a href="index.cfm?" data-icon="home" data-iconpos="notext" data-direction="reverse" class="ui-btn-right">Home</a>
  </cfif>
</div>