

<div data-role="page" >

	<div data-role="header" data-position="inline" data-theme="<cfoutput>#APPLICATION.BLOG.primaryTheme#</cfoutput>">
		<h1><cfoutput>#SESSION.BROG.getProperty("blogTitle")#</cfoutput></h1>
	</div>

	<div style="text-align: center;" data-role="content" data-theme="<cfoutput>#APPLICATION.BLOG.primaryTheme#</cfoutput>" >
         <p><img src="./assets/about.png" /></p>
        <p><strong><cfoutput>#SESSION.BROGMobile.getProperty("title")#</cfoutput></strong><br />Version <cfoutput>#SESSION.BROGMobile.getProperty("appVersion")#</cfoutput><br />
        <p>
      	  <cfoutput>#SESSION.BROG.getProperty("blogDescription")#</cfoutput>
        </p>
        <p>
        	<BR>
		    <a href="http://www.jquerymobile.com/" target="_blank">Built with jQuery Mobile</a>
        	<BR>
        </p>
        	<BR>
		<p><a href="mailto:<cfoutput>#SESSION.BROG.getProperty("owneremail")#</cfoutput>?subject=Mobile app" rel="external" class="grayButton goback">Contact Us</a></p>

	</div><!-- /content -->





</div><!-- /page -->


