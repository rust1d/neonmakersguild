<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : slideshow.cfm
	Author       : Raymond Camden
	Created      : 9/02/06
	Last Updated : 2/28/07
	History      : Don't show file upload if new slideshow (rkc 9/6/06)
				 : Support for getting folder from CFC (rkc 12/14/06)
				 : update to getting right folder (rkc 2/28/07)
--->

<cfif structKeyExists(form, "cancel")>
	<cflocation url="x.slideshows.cfm" addToken="false">
</cfif>

<cfset dir = APPLICATION.BLOG.slideshow.getSlideShowDir()>
<!--- remove ending /\ --->
<cfif right(dir,1) is "/" or right(dir,1) is "\">
	<cfset dir = left(dir, len(dir)-1)>
</cfif>

<cfif structKeyExists(form, "id")>
	<cfset URL.id = form.id>
</cfif>
<!--- kind of a hack based on my datatable tag --->
<cfif StructKeyExists(URL, "id") and URL.id is 0>
	<cfset URL.id = "">
</cfif>

<cfparam name="URL.id" default="">

<!--- Slideshow may not exist --->
<cfif URL.id is "" or not directoryExists(dir & "/" & URL.id)>
	<cfset direxists = false>
<cfelse>
	<cfset direxists = true>
	<cfset metadata = APPLICATION.BLOG.slideshow.getInfo(dir & "/" & URL.id)>
	<cfset images = APPLICATION.BLOG.slideshow.getImages(dir & "/" & URL.id)>
	<cfparam name="form.formalname" default="#metadata.formalname#">
</cfif>

<!--- look for deletes --->
<cfif isDefined("images")>
	<cfloop query="images">
		<cfif structKeyExists(form, "delete_#currentrow#")>
			<cfset toDelete = form["image_#currentRow#"]>
			<cffile action="delete" file="#dir#/#URL.id#/#toDelete#">
			<!--- reget --->
			<cfset images = APPLICATION.BLOG.slideshow.getImages(dir & "/" & URL.id)>
		</cfif>
	</cfloop>
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>

	<cfif not len(trim(URL.id))>
		<cfset arrayAppend(errors, "The name cannot be blank.")>
	<cfelse>
		<cfset URL.id = trim(URL.id)>
	</cfif>

	<cfif reFindNoCase("[^ [:alnum:]]", URL.id)>
		<cfset arrayAppend(errors, "The name must only contain letters, numbers, and spaces.")>
	</cfif>

	<cfif structKeyExists(form, "newimage") and len(trim(form.newimage))>
		<cffile action="upload" filefield="form.newimage" destination="#dir#/#URL.id#" nameconflict="makeunique">
		<!--- reget --->
		<cfset images = APPLICATION.BLOG.slideshow.getImages(dir & "/" & URL.id)>
	</cfif>

	<cfif not arrayLen(errors)>
		<!--- first, try to rename if needed --->
		<cfif URL.id neq form.oldname>
			<!--- new? --->
			<cfif form.oldname is "">
				<cfdirectory action="create" directory="#dir#/#URL.id#">
				<!--- imediate reload --->
				<cflocation url="x.slideshow.cfm?id=#urlEncodedFormat(URL.id)#" addToken="false">
			<cfelse>
				<cfdirectory action="rename" directory="#dir#/#form.oldname#" newdirectory="#dir#/#URL.id#">
			</cfif>
		</cfif>

		<!--- update metadata --->
		<cfset metadata = structNew()>
		<cfif len(trim(form.formalname))>
			<cfset metadata.formalname = trim(form.formalname)>
		<cfelse>
			<cfset metadata.formalname = "">
		</cfif>

		<cfset metadata.images = structNew()>
		<cfset x = 1>
		<cfloop condition="isDefined('form.image_#x#')">
			<cfif len(form["caption_#x#"])>
				<cfset metadata.images[form["image_#x#"]] = form["caption_#x#"]>
			</cfif>
			<cfset x = x + 1>
		</cfloop>
		<cfset APPLICATION.BLOG.slideshow.updateInfo(dir & "/" & URL.id, metadata)>
	</cfif>

</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Slideshow Editor">

	<cfoutput>
	<script>
	function showImage(url) {
		cWin = window.open(url,"cWin","width=500,height=500,menubar=no,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	</script>
	</cfoutput>

	<cfif not direxists>
		<cfoutput>
		<p>
		Please enter the name of of your new slideshow below. Once you have named the slide
		show you will be able to enter more information and upload images. Please use just letters
		and numbers with no spaces.
		</p>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<p>
		Edit your slideshow below. If you rename the slideshow, please use just letter and numbers with
		no spaces.
		</p>
		</cfoutput>
	</cfif>

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

	<cfoutput>
	<form action="x.slideshow.cfm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="oldname" value="#URL.id#">
	<table>
		<tr>
			<td align="right">name:</td>
			<td><input type="text" name="id" value="#URL.id#" class="txtField" maxlength="50"></td>
		</tr>
		<cfif direxists>
		<tr>
			<td align="right">descriptive name:</td>
			<td><input type="text" name="formalname" value="#form.formalname#" class="txtField" maxlength="50"></td>
		</tr>
		<cfif images.RecordCount>
		<tr>
			<td colspan="2">
			<p>
			Below are the images in the slide show. You may enter a caption for an image or delete it.
			Click on an image for a larger view.
			</p>
			</td>
		</tr>
		</cfif>
		<cfloop query="images">
			<cfif structKeyExists(metadata.images, name)>
				<cfset value = metadata.images[name]>
			<cfelse>
				<cfset value = "">
			</cfif>
			<tr valign="middle" <cfif currentRow mod 2>bgcolor="##c0c0c0"</cfif>>
				<td align="right">#name#</td>
				<td>
				<a href="javaScript:showImage('#urlEncodedFormat("../images/slideshows#APPLICATION.DISK.BLOGIMG#\#URL.id#/#name#")#')"><img src="../images/slideshows/#APPLICATION.DISK.BLOGIMG#\#URL.id#/#name#" width="50" height"50" align="absmiddle" border="0"></a>
				<input type="text" name="caption_#currentrow#" value="#value#" class="txtField">
				<input type="hidden" name="image_#currentrow#" value="#name#">
				<input type="submit" name="delete_#currentrow#" value="Delete">
				</td>
			</tr>
		</cfloop>
		<tr>
			<td align="right">upload new image:</td>
			<td><input type="file" name="newimage"></td>
		</tr>
		</cfif>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="cancel" value="Cancel"> <input type="submit" name="save" value="Save"></td>
		</tr>
	</table>
	</form>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly="false" />
