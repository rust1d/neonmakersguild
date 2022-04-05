<cfsetting enablecfoutputonly=true showdebugoutput=false>
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : C:\projects\blogcfc5\client\admin\proxy.cfm
	Author       : Raymond Camden
	Created      : 11/2/09
	Last Updated :
--->

<cfif StructKeyExists(URL, "category") or StructKeyExists(URL, "text")>

	<cfset params = structNew()>
	<cfif StructKeyExists(URL, "category") and len(URL.category)>
		<cfset params.byCat = URL.category>
	</cfif>
	<cfif StructKeyExists(URL, "text") and len(URL.text)>
		<cfset params.searchterms = URL.text>
	</cfif>
	<cfset params.mode = "short">
	<cfset params.maxEntries = 200>
	<cfset entryData = SESSION.BROG.getEntries(params)>
	<cfset entries = entryData.entries>
	<cfquery name="entries" dbtype="query">
		select id, title, posted
		  from entries
	</cfquery>

	<cfset s = createObject('java','java.lang.StringBuffer')>
	<!--- hand craft the json myself, still supporting cf7 --->
	<cfset s.append("{")>
	<cfset out = "" />
	<cfloop query="entries">
		<cfset s.append("""#id#"":""#htmlEditFormat(title)#"",")>
		<cfset out = ListAppend(out,"""#id#"":""#htmlEditFormat(title)#""") />
	</cfloop>

	<cfset s.append("}")>
	<cfcontent reset="true" type="application/json">
	<cfoutput>{#out#}</cfoutput>
</cfif>