


<cfset cats = SESSION.BROG.getCategories()>
<cfset lastAlpha = ''>

<cfoutput>

<div data-role="page" data-theme="#APPLICATION.BLOG.primaryTheme#">

  <cf_header title="Categories" showHome="2" id="blogHeader">

  <div data-role="content" >
    <ul data-role="listview">

      <cfloop query="cats">
        <cfif lastAlpha NEQ left(cats.bca_name, 1)>
          <li data-role="list-divider">#ucase(left(cats.bca_name, 1))#</li>
        </cfif>
        <li><span class="ui-li-count">#cats.ENTRYCOUNT#</span><a href="catDetail.cfm?catid=#cats.bca_alias#">#cats.bca_name#</a></li>
        <cfset lastAlpha = left(cats.bca_name, 1)>
      </cfloop>

    </ul>

  </div><!-- /content -->


  <cf_footer />
  <!-- /footer -->


</div><!-- /page -->
</cfoutput>