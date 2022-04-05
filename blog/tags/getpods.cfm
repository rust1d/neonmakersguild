<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfset podDir = APPLICATION.PATH.ROOT & "\blog\includes\pods">
<cfset podList = APPLICATION.BLOG.pod.getpods(podDir)>
<cfset podList = StructSort(podlist.pods,"numeric")>
<cfif arraylen(podlist)>  <!--- SEE IF THE METADATA EXISTS, IF NOT WE WILL LOAD ALL PODS --->
  <cfloop from="1" to="#arraylen(podlist)#" index="pod">
    <cfif FileExists(ExpandPath(podDir & "/#podlist[pod]#"))>
      <cfinclude template="#APPLICATION.PATH.ROOT#/blog/includes/pods/#podlist[pod]#">
    </cfif>
  </cfloop>
<cfelse>
  <cfdirectory action="list" filter="*.cfm" directory="#podDir#" name="Pods">
  <cfoutput query="pods">
    <cfif FileExists(ExpandPath(podDir & "/#name#"))>
      <cfinclude template="#APPLICATION.PATH.ROOT#/blogs/includes/pods/#name#">
    </cfif>
  </cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false" />
