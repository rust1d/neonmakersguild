<cfsetting enablecfoutputonly="true">
<!---
  Name         : datacol.cfm
  Author       : Raymond Camden
  Created      : September 7, 2004
  Last Updated : September 7, 2004
  History      :
  Purpose     : Allows you to specify settings for datatable
--->

<cfassociate baseTag="cf_datatablenew">

<cfparam name="ATTRIBUTES.colname" type="string" default="">
<cfparam name="ATTRIBUTES.name" type="string" default="#ATTRIBUTES.colname#">
<cfparam name="ATTRIBUTES.label" type="string" default="#ATTRIBUTES.name#">
<cfparam name="ATTRIBUTES.data" type="string" default="">
<cfparam name="ATTRIBUTES.sort" type="string" default="true">

<cfif ATTRIBUTES.name is "" and ATTRIBUTES.data is "">
  <cfthrow message="dataCol: Both name and data cannot be empty.">
</cfif>

<cfif len(ATTRIBUTES.data)>
  <cfset ATTRIBUTES.name = ATTRIBUTES.data>
</cfif>

<cfsetting enablecfoutputonly="false" />

<cfexit method="EXITTAG">
