<cfsetting enablecfoutputonly="true" showdebugoutput="true">
<cfinclude template="#APPLICATION.PATH.ROOT#/blog/SetContext.cfm" />
<cfinclude template="#APPLICATION.PATH.ROOT#/blog/includes/udf.cfm">
<cfset rb = APPLICATION.BLOG.utils.getResource><!--- LET'S MAKE A POINTER TO OUR RB --->
<cfif not StructKeyExists(SESSION,"viewedpages")><cfset SESSION.viewedpages = structNew()></cfif><!--- USED TO REMEMBER THE PAGES WE HAVE VIEWED. HELPS KEEP VIEW COUNT DOWN. --->
<cfif StructKeyExists(URL, "bco_kill")><cfset SESSION.BROG.bco_kill(URL.bco_kill)></cfif><!--- KILLSWITCH FOR COMMENTS. WE DON'T AUTHENTICATE BECAUSE THIS KILL UUID IS SOMETHING ONLY THE ADMIN CAN GET. --->
<cfif StructKeyExists(URL, "approvecomment")><cfset SESSION.BROG.approveComment(URL.approvecomment)></cfif><!--- QUICK APPROVAL FOR COMMENTS --->
<cfif StructKeyExists(URL, "nomobile")><cfset SESSION.nomobile = true></cfif>
<cfif not StructKeyExists(SESSION, "nomobile")
  and not findNoCase("blackberry",CGI.http_user_agent)
  and not findNoCase("xoom",CGI.http_user_agent)
  and not findNoCase("transformer",CGI.http_user_agent)
  and (reFindNoCase("android|avantgo|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0
      OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0
    )>
  <cfset urlVars=reReplaceNoCase(trim(CGI.path_info), ".+\.cfm/? *", "")>
  <cfif listlen(urlVars, "/") LTE 1> <!---NOT AN SES URL--->
    <cfset urlVars = "">
  </cfif>
  <cfset path = CGI.http_host & ListDeleteAt(CGI.script_name, listLen(CGI.script_name, "/"), "/")>
  <cfif NOT right(path, 6) EQ "mobile">
    <cflocation url="http://#path#/mobile/index.cfm#urlVars#" addToken="false">
  </cfif>
</cfif>
<cfsetting enablecfoutputonly="false">
