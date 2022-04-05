<!---
  Name         : scopeCache
  Author       : Raymond Camden (jedimaster@mindseye.com)
  Created      : December 12, 2002
  Last Updated : August 21, 2008
  History      : Allow for clearAll (rkc 11/6/03)
         : Added dependancies, timeout, other misc changes (rkc 1/8/04)
         : Found bug where if you called it with clear and used />, the cache was screwed up (rkc 2/15/05)
         : Typos in msg for bad timeout (rkc 2/15/05)
         : Added locking to scopeCache subkey creation (rkc 2/15/05)
         : Added r_cacheItems (rkc 2/15/05)
         : Moved logic around to make it simpler (rkc 2/15/05)
         : Dependencies fix, and support Request scope (rkc 2/27/08)
         : Support for file based caching (rkc 8/21/08)
  Purpose     : Allows you to cache content in various scopes.
  Documentation:

  This tag allows you to cache content and data in various RAM based scopes.
  The tag takes the following attributes:

  name/cachename:  The name of the data. (required)
  scope:       The scope where cached data will reside. Must be either session,
          application, server, request, or file. (required)
  timeout:     When the cache will timeout. By default, the year 3999 (i.e., never).
          Value must be either a date/time stamp or a number representing the
          number of seconds until the timeout is reached. (optional)
  dependancies:  This allows you to mark other cache items as dependant on this item.
          When this item is cleared or timesout, any child will also be cleared.
          Also, any children of those children will also be cleared. (optional)
  clear:      If passed and if true, will clear out the cached item. Note that
          this option will NOT recreate the cache. In other words, the rest of
          the tag isn't run (well, mostly, but don't worry).
  clearAll:    Removes all data from this scope. Exits the tag immidiately.
  disabled:    Allows for a quick exit out of the tag. How would this be used? You can
          imagine using disabled="#REQUEST.disabled#" to allow for a quick way to
          turn on/off caching for the entire site. Of course, all calls to the tag
          would have to use the same value.
  r_cacheItems:  Returns a list of keys in the cache. Exists the tag when called. NOTICE! Some items
          may be expired. Items only get removed if you are fetching them or calling CLEAR on them.
  r_data:      Returns the value directly.
  data:      Sets the value directly.
  file:      Fully qualified file name for file based caching.
  suppressHitCount: Only used for file operations - if passed, we don't bother updating the file based cache with the hit count. Makes the file IO a bit less.

  License     : Use this as you will. If you enjoy it and it helps your application,
           consider sending me something from my Amazon wish list:
           http://www.amazon.com/o/registry/2TCL1D08EZEYE
--->

<!--- allow for quick exit --->
<cfif isDefined("ATTRIBUTES.disabled") and ATTRIBUTES.disabled>
  <cfexit method="exitTemplate">
</cfif>

<!--- Allow for cachename in case we use cfmodule --->
<cfif isDefined("ATTRIBUTES.cachename")>
  <cfset ATTRIBUTES.name = ATTRIBUTES.cachename>
</cfif>

<!--- Must pass scope, and must be a valid value. --->
<cfif not isDefined("ATTRIBUTES.scope") or not isSimpleValue(ATTRIBUTES.scope) or not listFindNoCase("APPLICATION,SESSION,SERVER,REQUEST,FILE",ATTRIBUTES.scope)>
  <cfthrow message="scopeCache: The scope attribute must be passed as one of: application, session, server, request, or file.">
</cfif>

<cfparam name="ATTRIBUTES.file" default="">

<!--- create pointer to scope --->
<cfif ATTRIBUTES.scope is not "file">
  <cfset ptr = structGet(ATTRIBUTES.scope)>

  <!--- init cache root --->
  <cflock scope="#ATTRIBUTES.scope#" type="readOnly" timeout="30">
    <cfif not structKeyExists(ptr,"scopeCache")>
      <cfset needInit = true>
    <cfelse>
      <cfset needInit = false>
    </cfif>
  </cflock>

  <cfif needInit>
    <cflock scope="#ATTRIBUTES.scope#" type="exclusive" timeout="30">
      <!--- check twice in cace another thread finished --->
      <cfif not structKeyExists(ptr,"scopeCache")>
        <cfset ptr["scopeCache"] = structNew()>
      </cfif>
    </cflock>
  </cfif>

</cfif>

<!--- Do they simply want the keys? --->
<cfif isDefined("ATTRIBUTES.r_cacheItems") and ATTRIBUTES.scope neq "file">
  <cfset caller[ATTRIBUTES.r_cacheItems] = structKeyList(ptr.scopeCache)>
  <cfexit method="exitTag">
</cfif>

<!--- Do they want to nuke it all? --->
<cfif isDefined("ATTRIBUTES.clearAll") and ATTRIBUTES.scope neq "file">
  <cfset structClear(ptr["scopeCache"])>
  <cfexit method="exitTag">
</cfif>

<!--- Require name if we get this far. --->
<cfif not isDefined("ATTRIBUTES.name") or not isSimpleValue(ATTRIBUTES.name)>
  <cfthrow message="scopeCache: The name attribute must be passed as a string.">
</cfif>

<!--- The default timeout is no timeout, so we use the year 3999. We will have flying cars then. --->
<cfparam name="ATTRIBUTES.timeout" default="#createDate(3999,1,1)#">
<!--- Default dependancy list --->
<cfparam name="ATTRIBUTES.dependancies" default="" type="string">

<cfif not isDate(ATTRIBUTES.timeout) and (not isNumeric(ATTRIBUTES.timeout) or ATTRIBUTES.timeout lte 0)>
  <cfthrow message="scopeCache: The timeout attribute must be either a date/time or a number greater than zero.">
<cfelseif isNumeric(ATTRIBUTES.timeout)>
  <!--- convert seconds to a time --->
  <cfset ATTRIBUTES.timeout = dateAdd("s",ATTRIBUTES.timeout,now())>
</cfif>


<!--- This variable will store all the guys we need to update --->
<cfset cleanup = "">
<!--- This variable determines if we run the caching. This is used when we clear a cache --->
<cfset dontRun = false>

<cfif isDefined("ATTRIBUTES.clear") and ATTRIBUTES.clear and thisTag.executionMode is "start">
  <cfif ATTRIBUTES.scope neq "file" and structKeyExists(ptr.scopeCache,ATTRIBUTES.name)>
    <cfset cleanup = ptr.scopeCache[ATTRIBUTES.name].dependancies>
    <cfset structDelete(ptr.scopeCache,ATTRIBUTES.name)>
  <cfelseif fileExists(ATTRIBUTES.file)>
    <cffile action="delete" file="#ATTRIBUTES.file#">
  </cfif>
  <cfset dontRun = true>
</cfif>

<cfif not dontRun>
  <cfif thisTag.executionMode is "start">
    <!--- determine if we have the info in cache already --->
    <cfif ATTRIBUTES.scope neq "file" and structKeyExists(ptr.scopeCache,ATTRIBUTES.name)>
      <cfif dateCompare(now(),ptr.scopeCache[ATTRIBUTES.name].timeout) is -1>
        <cflock scope="#ATTRIBUTES.scope#" type="exclusive" timeout="30">
          <cfset ptr.scopeCache[ATTRIBUTES.name].hitCount = ptr.scopeCache[ATTRIBUTES.name].hitCount + 1>
        </cflock>
        <cfif not isDefined("ATTRIBUTES.r_Data")>
          <cfoutput>#ptr.scopeCache[ATTRIBUTES.name].value#</cfoutput>
        <cfelse>
          <cfset caller[ATTRIBUTES.r_Data] = ptr.scopeCache[ATTRIBUTES.name].value>
        </cfif>
        <cfexit method="exitTag">
      </cfif>
    <!--- Fix by Ken Gladden --->
    <cfelseif (ATTRIBUTES.file is not "") and fileExists(ATTRIBUTES.file)>
      <!--- read the file in to check metadata --->
      <cflock name="#ATTRIBUTES.file#" type="readonly" timeout="30">
        <cffile action="read" file="#ATTRIBUTES.file#" variable="contents" charset="UTF-8">
        <cfwddx action="wddx2cfml" input="#contents#" output="data">
      </cflock>
      <cfif dateCompare(now(),data.timeout) is -1>
        <cfif not isDefined("ATTRIBUTES.r_Data")>
          <cfoutput>#data.value#</cfoutput>
        <cfelse>
          <cfset caller[ATTRIBUTES.r_Data] = data.value>
        </cfif>
        <cfif not structKeyExists(attributes, "suppressHitCount")>
          <cflock name="#ATTRIBUTES.file#" type="exclusive" timeout="30">
            <cfset data.hitCount = data.hitCount + 1>
            <cfwddx action="cfml2wddx" input="#data#" output="packet">
            <cffile action="write" file="#ATTRIBUTES.file#" output="#packet#" charset="UTF-8">
          </cflock>
        </cfif>
        <cfexit method="exitTag">
      </cfif>
    </cfif>
  <cfelse>
    <!--- It is possible I'm here because I'm refreshing. If so, check my dependancies --->
    <cfif ATTRIBUTES.scope neq "file" and structKeyExists(ptr.scopeCache,ATTRIBUTES.name)>
      <cfif structKeyExists(ptr.scopeCache[ATTRIBUTES.name],"dependancies")>
        <cfset cleanup = listAppend(cleanup, ptr.scopeCache[ATTRIBUTES.name].dependancies)>
      </cfif>
    </cfif>
    <cfif ATTRIBUTES.scope neq "file">
      <cfset ptr.scopeCache[ATTRIBUTES.name] = structNew()>
      <cfif not isDefined("ATTRIBUTES.data")>
        <cfset ptr.scopeCache[ATTRIBUTES.name].value = thistag.generatedcontent>
      <cfelse>
        <cfset ptr.scopeCache[ATTRIBUTES.name].value = ATTRIBUTES.data>
      </cfif>
      <cfset ptr.scopeCache[ATTRIBUTES.name].timeout = ATTRIBUTES.timeout>
      <cfset ptr.scopeCache[ATTRIBUTES.name].dependancies = ATTRIBUTES.dependancies>
      <cfset ptr.scopeCache[ATTRIBUTES.name].hitCount = 0>
      <cfset ptr.scopeCache[ATTRIBUTES.name].created = now()>
      <cfif isDefined("ATTRIBUTES.r_Data")>
        <cfset caller[ATTRIBUTES.r_Data] = ptr.scopeCache[ATTRIBUTES.name].value>
      </cfif>
    <cfelse>
      <cfset data = structNew()>
      <cfif not isDefined("ATTRIBUTES.data")>
        <cfset data.value = thistag.generatedcontent>
      <cfelse>
        <cfset data.value = ATTRIBUTES.data>
      </cfif>
      <cfset data.timeout = ATTRIBUTES.timeout>
      <cfset data.dependancies = ATTRIBUTES.dependancies>
      <cfset data.hitCount = 0>
      <cfset data.created = now()>
      <cflock name="#ATTRIBUTES.file#" type="exclusive" timeout="30">
        <cfwddx action="cfml2wddx" input="#data#" output="packet">
        <cffile action="write" file="#ATTRIBUTES.file#" output="#packet#" charset="UTF-8">
      </cflock>
      <cfif isDefined("ATTRIBUTES.r_Data")>
        <cfset caller[ATTRIBUTES.r_Data] = data.value>
      </cfif>
    </cfif>
  </cfif>
</cfif>

<!--- Do I need to clean up? --->
<cfloop condition="listLen(cleanup)">
  <cfset toKill = listFirst(cleanup)>
  <cfset cleanUp = listRest(cleanup)>
  <cfif structKeyExists(ptr.scopeCache, toKill)>
    <cfloop index="item" list="#ptr.scopeCache[toKill].dependancies#">
      <cfif not listFindNoCase(cleanup, item)>
        <cfset cleanup = listAppend(cleanup, item)>
      </cfif>
    </cfloop>
    <cfset structDelete(ptr.scopeCache,toKill)>
  </cfif>
</cfloop>

<cfif dontRun>
  <cfexit method="exitTag">
</cfif>
