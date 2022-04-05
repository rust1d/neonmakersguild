<cfcomponent name="CF8 Ping" extends="ping">

  <cffunction name="pingAggregators" access="public" returnType="void" output="false"
        hint="Pings blog aggregators.">
    <cfargument name="pingurls" type="string" required="true">
    <cfargument name="blogtitle" type="string" required="true">
    <cfargument name="blogurl" type="string" required="true">

    <cfset var aURL = "">

    <cfloop index="aURL" list="#arguments.pingurls#">

      <cfthread action="run" name="#arguments.blogurl#_#arguments.blogtitle#_#aurl#" blogtitle="#arguments.blogtitle#" blogurl="#arguments.blogurl#" aURL="#aURL#">
        <cfif aURL is "@technorati">
          <cfset pingTechnorati(ATTRIBUTES.blogTitle, ATTRIBUTES.blogURL)>
        <cfelseif aURL is "@weblogs">
          <cfset pingweblogs(ATTRIBUTES.blogTitle, ATTRIBUTES.blogURL)>
        <cfelseif aURL is "@icerocket">
          <cfset pingIceRocket(ATTRIBUTES.blogTitle, ATTRIBUTES.blogURL)>
        <cfelse>
          <cfhttp url="#ATTRIBUTES.aURL#" method="GET" resolveurl="false">
        </cfif>
      </cfthread>

    </cfloop>

  </cffunction>

</cfcomponent>