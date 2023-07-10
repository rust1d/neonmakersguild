<cfoutput>
  Hello #variables.firstname#,
  <p>
    There has been activity on one or more of your subscriptions on the Neon Makers Guild:
  </p>
  <ul>
    <cfloop array='#variables.messages#' item='message'>
      <li>#message#</li>
    </cfloop>
  </ul>
  <p>
    <small>
      Click <a href='#kill_link#' target='_blank'>this link to cancel <cite>all</cite> subscriptions</a> on the Neon Makers Guild.
    </small>
  </p>
</cfoutput>
