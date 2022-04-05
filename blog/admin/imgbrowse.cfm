<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />

<cfset imageDirectory = udfMakeDirIfNot("#APPLICATION.DISK.BLOGIMG#\#REQUEST.BLOG#")  />

<cfparam name="URL.dir" default="/">
<cfset currentDirectory = imageDirectory & URL.dir>
<cfdirectory name="files" directory="#currentDirectory#" sort="type asc">

<!--- filter to gif,jpg,png --->
<cfquery name="files" dbtype="query">
	SELECT *
	  FROM files
	 WHERE UPPER(name) LIKE '%.JPG'
		 OR UPPER(name) LIKE '%.GIF'
		 OR UPPER(name) LIKE '%.PNG'
	<cfif isUserInRole("siteadmin")>
		 OR type = 'Dir'
	</cfif>
</cfquery>

<cfoutput>
<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/popout.css" />
<script>
	showImage = function(url) {
		cWin = window.open(url,"cWin","width=500,height=500,menubar=no,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	insertIt = function(url) {
		opener.newImage(url);
		window.close();
	}
	$(document).ready(function() {
		$("##tabImg").tablescroller({ height: 500, sort: true, print: false});
	});
</script>

<div id="content">
	<cfif isUserInRole("siteadmin") AND FALSE>
		<br>
		<h4>Current Directory: #URL.dir#
		<cfif URL.dir is not "/">
			<cfset higherdir = replace(URL.dir, "/" & listLast(currentDirectory, "/"), "")>
			&nbsp;&nbsp;&nbsp;<a href="#CGI.script_name#?dir=#higherdir#"><img src="#APPLICATION.PATH.ROOT#/blog/images/arrow_up.png" title="Go up one directory" border="0"></a>
		</cfif>
		</h4>
	</cfif>

	<table id="tabImg" class="datagrid" cellspacing="0">
		<caption><div class="pad10">#REQUEST.BLOG#'s Image Library</div></caption>
		<thead>
			<tr>
				<th class="icon" width="25"><img src="#APPLICATION.PATH.ROOT#/blog/images/photo.png"></td>
				<th width="200">Name</th>
				<th width="75">Size</th>
				<th width="240">Preview</th>
				<th width="75">Use</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="files">
			<tr>
			<cfif type is "Dir">
				<td class="icon"><img src="#APPLICATION.PATH.ROOT#/blog/images/folder.png"></td>
				<td><a href="#CGI.script_name#?dir=#URL.dir##urlencodedformat(name)#/">#name#</a></td>
			<cfelse>
				<td><img src="#APPLICATION.PATH.ROOT#/blog/images/photo.png"></td>
				<td>#name#</td>
				<cfset link = APPLICATION.BLOG.utils.fixUrl("#APPLICATION.PATH.BLOGIMG#/#REQUEST.BLOG#/#URL.dir#/#name#") />
			</cfif>
				<td class="right"><cfif type is not "Dir">#kbytes(size)#<cfelse>&nbsp;</cfif></td>
				<td><cfif type is not "Dir"><a href="javascript:showImage('#urlEncodedFormat(link)#')"><img src="#link#" width="50" height"50" align="absmiddle" border="0"></a><cfelse>&nbsp;</cfif></td>
				<td align="center">
					<cfif type is not "Dir">
						<!--- <cfset theurl = right(URL.dir & name, len(URL.dir & name) - 1)> --->
						<a href="javascript:insertIt('#link#')">Insert</a>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</div>
</cfoutput>


<cfsetting enablecfoutputonly="false" />
