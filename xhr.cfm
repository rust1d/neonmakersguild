<cfsetting showdebugoutput=false />

<cfinclude template='_global.cfm' runonce='true' />
<cfscript>
  if (utility.isAjax()) {
    setting showdebugoutput = false;
    cfheader(name: 'content-type', value: 'application/json');
    cfheader(name: 'Access-Control-Allow-Origin', value: '*');
    try {
      savecontent variable='content' { router.include() }
    } catch (any err) {
      flash.error(utility.errorString(err));
    }
    try {
      savecontent variable='messages' { router.include('shared/flash') }
    } catch (any err) {
      flash.error(utility.errorString(err));
    }
    param content = '';
    param messages = '';

    data = { 'content': content.trim(), 'messages': messages.trim(), 'data': request.get('xhr_data') }
    writeoutput(SerializeJson(data));
  } else {
    writeoutput('must be ajax.');
  }
</cfscript>
