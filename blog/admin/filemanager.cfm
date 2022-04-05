<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : /client/admin/filemanager.cfm
	Author       : Raymond Camden
	Created      : 09/14/06
	Last Updated : 3/9/07
	History      : Removed UDF to udf.cfm (rkc 11/29/06)
				 : Check filebrowse prop (rkc 12/12/06)
				 : Security fix (rkc 3/9/07)
--->

<cfif not APPLICATION.BLOG.filebrowse>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>

<cfset rootDirectory = getDirectoryFromPath(getCurrentTemplatePath())>
<cfset rootDirectory = reReplaceNoCase(rootDirectory, "[\\/]admin", "")>
<cfparam name="URL.dir" default="/">

<!--- do not allow any .. --->
<cfif find("..", URL.dir)>
	<cfset URL.dir = "/">
</cfif>

<cfset currentDirectory = rootDirectory & URL.dir>

<cfif StructKeyExists(URL, "download")>
	<cfset fullfile = currentDirectory & URL.download>
	<cfif fileExists(fullFile)>
		<cfheader name="Content-disposition" value="attachment;filename=#URL.download#">
		<cfcontent file="#fullfile#" type="application/unknown">
	</cfif>
</cfif>

<cfif StructKeyExists(URL, "delete")>
	<cfset fullfile = currentDirectory & URL.delete>
	<cfif fileExists(fullFile)>
		<cffile action="delete" file="#fullfile#">
	</cfif>
</cfif>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "fileupload")>
	<cffile action="upload" filefield="form.newfile" destination="#currentDirectory#" nameconflict="overwrite">
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="File Manager">

	<cfoutput>
	<p>
	This tool lets you manage the files on your blog. <b>WARNING: Deletes are FINAL.</b>
	If you do not know what you are doing, step away from the browser.
	</p>
	</cfoutput>

	<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
		<cfoutput>
		<div class="errors">
		Please correct the following error(s):
		<ul>
		<cfloop index="x" from="1" to="#arrayLen(errors)#">
		<li>#errors[x]#</li>
		</cfloop>
		</ul>
		</div>
		</cfoutput>
	</cfif>

	<cfdirectory name="files" directory="#currentDirectory#" sort="type asc">

	<cfoutput>
	<table border="1" width="100%">
		<tr bgcolor="##e0e0e0">
			<td colspan="3"><b>Current Directory:</b> #URL.dir#</td>
			<td align="center">
			<cfif URL.dir is not "/">
			<cfset higherdir = replace(URL.dir, "/" & listLast(currentDirectory, "/"), "")>
			<a href="filemanager.cfm?dir=#higherdir#"><img src="#APPLICATION.PATH.ROOT#/blog/images/arrow_up.png" title="Go up one directory" border="0"></a>
			<cfelse>
			&nbsp;
			</cfif>
			</td>
		</tr>
		<cfloop query="files">
		<tr <cfif currentRow mod 2>bgcolor="##fffecf"</cfif>>
			<td>
			<cfif type is "Dir">
				<img src="#APPLICATION.PATH.ROOT#/blog/images/folder.png"> <a href="filemanager.cfm?dir=#URL.dir##urlencodedformat(name)#/">#name#</a>
			<cfelse>
				<cfswitch expression="#listLast(name,".")#">
					<cfcase value="xls,ods">
						<cfset img = "page_white_excel.png">
					</cfcase>
					<cfcase value="ppt">
						<cfset img = "page_white_powerpoint.png">
					</cfcase>
					<cfcase value="doc,odt">
						<cfset img = "page_white_word.png">
					</cfcase>
					<cfcase value="cfm">
						<cfset img = "page_white_coldfusion.png">
					</cfcase>
					<cfcase value="zip">
						<cfset img = "page_white_compressed.png">
					</cfcase>
					<cfcase value="gif,jpg,png">
						<cfset img = "photo.png">
					</cfcase>
					<cfdefaultcase>
						<cfset img = "page_white_text.png">
					</cfdefaultcase>

				</cfswitch>

				<img src="#APPLICATION.PATH.ROOT#/blog/images/#img#"> #name#

			</cfif>
			</td>
			<td><cfif type is not "Dir">#kbytes(size)#<cfelse>&nbsp;</cfif></td>
			<td>#dateFormat(datelastmodified)# #timeFormat(datelastmodified)#</td>
			<td width="50" align="center">
			<cfif type is not "Dir">
				<a href="filemanager.cfm?dir=#urlencodedformat(URL.dir)#&download=#urlEncodedFormat(name)#"><img src="#APPLICATION.PATH.ROOT#/blog/images/disk.png" border="0" title="Download"></a>
				<a href="filemanager.cfm?dir=#urlencodedformat(URL.dir)#&delete=#urlEncodedFormat(name)#" onClick="return confirm('Are you sure?')"><img src="#APPLICATION.PATH.ROOT#/blog/images/bin_closed.png" border="0" title="Delete"></a>
			<cfelse>
				&nbsp;
			</cfif>
			</td>
		</tr>
		</cfloop>
		<tr>
			<td colspan="4" align="right">
			<form action="x.filemanager.cfm?dir=#urlencodedformat(URL.dir)#" method="post" enctype="multipart/form-data">
			<input type="file" name="newfile"> <input type="submit" name="fileupload" value="Upload File">
			</form>
			</td>
		</tr>
	</table>
	</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false" />