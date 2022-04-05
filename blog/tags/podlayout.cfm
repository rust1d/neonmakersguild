<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfparam name="ATTRIBUTES.title">
<cfoutput>
<cfif thisTag.executionMode is "start">
  <div class="brewer_sidebox ui-widget-content ui-corner-all">
    <div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all" title="Following Brewers">
      #ATTRIBUTES.title#
      <img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
    </div>
    <div class="pad5">
<cfelse>
    </div>
  </div>
</cfif>
</cfoutput>
<cfsetting enablecfoutputonly="false" />