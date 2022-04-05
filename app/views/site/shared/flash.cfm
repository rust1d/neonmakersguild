<cfoutput>
  <cfif flash.len()>
    <cfset groups = flash.grouped() />
    <cfloop collection='#groups#' item='type'>
      <cfset messages = groups[type] />
      <cfset closeable = messages.filter(msg => msg.closeable).len() />
      <cfset dismissible = closeable ? 'alert-dismissible' : '' />

      <div class='alert #dismissible# fade show alert-#type# my-2' role='alert'>
        <cfif type EQ 'danger'>
          One or more errors have been detected:
          <ul class='mb-0'>
            <cfloop array='#messages#' item='message'>
              <li class='my-2'>#message.text#</li>
            </cfloop>
          </ul>
        <cfelse>
          <cfloop array='#messages#' item='message'>
            <div>#message.text#</div>
          </cfloop>
        </cfif>
        <cfif closeable>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </cfif>
      </div>
    </cfloop>

    <cfset flash.clear()/>
  </cfif>
</cfoutput>
