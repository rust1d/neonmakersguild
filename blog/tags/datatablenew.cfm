<cfsetting enablecfoutputonly="true">
<!---
  Name         : datatable.cfm
  Author       : Raymond Camden
  Created      : June 02, 2004
  Last Updated : January 25, 2007
  History      : JS fix (7/23/04)
           Minor formatting updates (rkc 8/29/05)
           finally add sorting (rkc 9/9/05)
           url format support (rkc 7/7/06)
           support for static data (rkc 7/13/06)
           better support for empty data (rkc 11/30/06)
           removed dupe cfparam (rkc 1/25/07)
  Purpose     : A VERY app specific datable tag.
--->

<cfif thisTag.hasEndTag and thisTag.executionMode is "start">
  <cfsetting enablecfoutputonly="false" />
  <cfexit method="EXITTEMPLATE">
</cfif>

<cfparam name="ATTRIBUTES.data" type="query">
<cfparam name="ATTRIBUTES.linkcol" default="#listFirst(ATTRIBUTES.data.columnList)#">
<cfparam name="ATTRIBUTES.linkval" default="id">
<cfparam name="ATTRIBUTES.list" default="#ATTRIBUTES.data.columnList#">
<cfparam name="ATTRIBUTES.labellist" default="#ATTRIBUTES.list#">
<cfparam name="ATTRIBUTES.defaultsort" default="">
<cfparam name="ATTRIBUTES.defaultdir" default="asc">
<cfparam name="URL.sort" default="#ATTRIBUTES.defaultsort#">
<cfparam name="URL.dir" default="#ATTRIBUTES.defaultdir#">
<cfparam name="URL.start" default="1">
<cfparam name="ATTRIBUTES.queryString" default="">
<cfparam name="ATTRIBUTES.deleteLink" default="#CGI.script_name#?#ATTRIBUTES.queryString#">

<cfparam name="ATTRIBUTES.deleteMsg" default="Are you sure?">
<cfparam name="ATTRIBUTES.noadd" default="false">

<!--- show add? --->
<cfparam name="ATTRIBUTES.showAdd" default="true">

<!--- allow us to say how many rows exist instead of using the query --->
<cfif structKeyExists(attributes, "totalRows")>
  <cfset totalRows = ATTRIBUTES.totalRows>
<cfelse>
  <cfset totalRows = ATTRIBUTES.data.RecordCount>
</cfif>

<cfset perpage = APPLICATION.BLOG.maxEntries>
<cfset colWidths = structNew()>
<cfset formatCols = structNew()>
<cfset leftCols = structNew()>
<cfset colData = structNew()>
<cfset dontSortList = "">

<!--- allow for datacol overrides --->
<cfif structKeyExists(thisTag,"assocAttribs")>
  <cfset ATTRIBUTES.list = "">
  <cfset ATTRIBUTES.labellist = "">

  <cfloop index="x" from="1" to="#arrayLen(thisTag.assocAttribs)#">
    <cfset ATTRIBUTES.list = listAppend(ATTRIBUTES.list, thisTag.assocAttribs[x].name)>
    <cfif structKeyExists(thisTag.assocAttribs[x], "label")>
      <cfset label = thisTag.assocAttribs[x].label>
    <cfelse>
      <cfset label = thisTag.assocAttribs[x].name>
    </cfif>
    <cfif structKeyExists(thisTag.assocAttribs[x], "format")>
      <cfset formatCols[thisTag.assocAttribs[x].name] = thisTag.assocAttribs[x].format>
    </cfif>
    <cfset ATTRIBUTES.labellist = listAppend(ATTRIBUTES.labellist, label)>
    <cfif structKeyExists(thisTag.assocAttribs[x], "width")>
      <cfset colWidths[label] = thisTag.assocAttribs[x].width>
    </cfif>
    <cfif structKeyExists(thisTag.assocAttribs[x], "left")>
      <cfset leftCols[label] = thisTag.assocAttribs[x].left>
    </cfif>
    <cfif structKeyExists(thisTag.assocAttribs[x], "data") and len(thisTag.assocAttribs[x].data)>
      <cfset colData[thisTag.assocAttribs[x].name] = thisTag.assocAttribs[x].data>
    </cfif>
    <cfif structKeyExists(thisTag.assocAttribs[x], "sort") and not thisTag.assocAttribs[x].sort>
      <cfset dontSortList = listAppend(dontSortList, thisTag.assocAttribs[x].name)>
    </cfif>

  </cfloop>
</cfif>

<cfif URL.dir is not "asc" and URL.dir is not "desc">
  <cfset URL.dir = "asc">
</cfif>
<cfif not isNumeric(URL.start) or URL.start lte 0>
  <cfset URL.start = 1>
</cfif>
<cfif isDefined("URL.msg")>
  <cfoutput><p><b>#URL.msg#</b></p></cfoutput>
</cfif>
<cfoutput>

<script>
  checksubmit = function() {
    if (document.forms["listing"].mark.length == null) {
      if (document["listing"].mark.checked) {
        document.forms["listing"].submit();
      }
    }
    for (i=0; i<document.forms["listing"].mark.length; i++) {
      if(document.forms["listing"].mark[i].checked) document.forms["listing"].submit();
    }
  }
  checkAll = function(set) {
    $(".itemcheckbox").each(function(item) {
      if (set) $(this).attr("checked", "checked");
      else $(this).removeAttr("checked");
    });
  }
</script>

<cfif totalRows gt perpage>
  <p align="right">
  &laquo;
  <cfif URL.start gt 1>
    <a href="#CGI.script_name#?start=#URL.start-perpage#&amp;sort=#urlEncodedFormat(URL.sort)#&amp;dir=#URL.dir#&amp;#ATTRIBUTES.querystring#">Previous</a>
  <cfelse>
    Previous
  </cfif>
  --
  <cfif URL.start + perpage lte totalRows>
    <a href="#CGI.script_name#?start=#URL.start+perpage#&amp;sort=#urlEncodedFormat(URL.sort)#&amp;dir=#URL.dir#&amp;#ATTRIBUTES.querystring#">Next</a>
  <cfelse>
    Next
  </cfif>
  &raquo;
  </p>
</cfif>

<form name="listing" action="#ATTRIBUTES.deletelink#" method="post">
<table class="datagrid" width="100%" cellspacing="0">
  <thead>
    <tr>
      <th class="icon" width="25"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiIcon" src="bih-icon bih-icon-delete" title="Delete"/></th>
      <cfset counter = 0>
      <cfloop index="c" list="#ATTRIBUTES.labellist#">
        <cfset counter = counter + 1>
        <cfset col = listGetAt(ATTRIBUTES.list, counter)>
        <cfif URL.sort is col and URL.dir is "asc"><cfset dir = "desc"><cfelse><cfset dir = "asc"></cfif>
        <th <cfif structKeyExists(colWidths, c)>width="#colWidths[c]#"</cfif>>
          <cfif not listFind(dontSortList, col)>
            <a href="#CGI.script_name#?start=#URL.start#&amp;sort=#urlEncodedFormat(col)#&amp;dir=#dir#&amp;#ATTRIBUTES.querystring#">#c#</a>
          <cfelse>
            #c#
          </cfif>
        </th>
      </cfloop>
    </tr>
  </thead>
</cfoutput>
<cfif ATTRIBUTES.data.RecordCount>
  <cfset columnlist = ATTRIBUTES.data.columnlist>
  <cfoutput query="ATTRIBUTES.data">
    <cfset theVal = ATTRIBUTES.data[ATTRIBUTES.linkval][currentRow]>
    <cfset theLink = ATTRIBUTES.editlink & "?id=#theVal#">
    <tr class="bih-grid-row-stripe#currentRow mod 2#">
      <td><input type="checkbox" name="mark" value="#ATTRIBUTES.data[ATTRIBUTES.linkval][currentRow]#" class="itemcheckbox" /></td>
      <cfloop index="c" list="#ATTRIBUTES.list#">
        <cfif not structKeyExists(colData, c)>
          <cfset value = ATTRIBUTES.data[c][currentRow]>
          <cfset value = htmlEditFormat(value)>
        <cfelse>
          <cfset value = colData[c]>
          <cfif findNoCase("$id$", value)>
            <cfset value = replace(value, "$id$", id, "all")>
          </cfif>
          <cfif findNoCase("$viewurl$", value)>
            <cfset value = replace(value, "$viewurl$", viewurl, "all")>
          </cfif>
          <cfif findNoCase("$email$", value)>
            <cfset value = replace(value, "$email$", urlEncodedFormat(email), "all")>
          </cfif>
          <cfif findNoCase("$name$", value)>
            <cfset value = replace(value, "$name$", name, "all")>
          </cfif>
          <cfif listFindNoCase(columnlist, "entryidfk")><cfset value = replace(value, "$entryidfk$", entryidfk, "all")></cfif>
        </cfif>
        <cfif structKeyExists(formatCols, c) and value neq "">
          <cfswitch expression="#formatCols[c]#">
            <cfcase value="yesno">
              <cfset value = yesNoFormat(value)>
            </cfcase>
            <cfcase value="datetime">
              <cfset value = udfUserDateFormat(value) & " " & timeFormat(value,"h:mm tt")>
            </cfcase>
            <cfcase value="date">
              <cfset value = udfUserDateFormat(value)>
            </cfcase>
            <cfcase value="currency">
              <cfset value = dollarFormat(value)>
            </cfcase>
            <cfcase value="number">
              <cfset value = numberFormat(value)>
            </cfcase>
            <cfcase value="url">
              <cfset value = "<a href=""#value#"">#value#</a>">
            </cfcase>
          </cfswitch>
        </cfif>
        <cfif value is ""><cfset value = "&nbsp;"></cfif>
        <cfif structKeyExists(leftCols, c) and len(value) gt leftCols[c]>
          <cfset value = left(value, leftCols[c]) & "...">
        </cfif>
        <cfif c is ATTRIBUTES.linkcol>
          <td><a href="#ATTRIBUTES.editlink#?id=#ATTRIBUTES.data[ATTRIBUTES.linkval][currentRow]#&amp;#ATTRIBUTES.queryString#">#value#</a></td>
        <cfelse>
          <td>#value#</td>
        </cfif>
      </cfloop>
    </tr>
  </cfoutput>
<cfelse>

</cfif>
<cfoutput>
</table>
<p>
<div class="ui-widget ui-widget-content ui-corner-all right" style="padding: 5px">
  <cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-checkall1" onclick="checkAll(1)" text="Check All"/>
  <cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-checkall0" onclick="checkAll(0)" text="Uncheck All"/>
  <cfif ATTRIBUTES.showAdd>
    <cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilnew" href="#ATTRIBUTES.editlink#?id=0&#ATTRIBUTES.querystring#" text="Add #ATTRIBUTES.label#"/>
  </cfif>
  <cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-delete" onclick="checksubmit()" text="Delete Selected"/>
</div>
</p>
</form>
</cfoutput>
<cfsetting enablecfoutputonly="false" />
<cfexit method="EXITTAG">