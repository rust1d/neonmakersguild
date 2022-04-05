<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfparam name="URL.id" default="0" />
<cftry>
	<cfif URL.id neq 0>
		<cfset entry = SESSION.BROG.getEntry(URL.id,true)>
		<cfif len(entry.morebody)>
			<cfset entry.body = entry.body & "<more/>" & entry.morebody>
		</cfif>
		<cfparam name="form.title" default="#entry.title#">
		<cfparam name="form.body" default="#entry.body#">
		<cfparam name="form.posted" default="#entry.posted#">
		<cfparam name="form.alias" default="#entry.alias#">
		<cfparam name="form.allowcomments" default="#entry.allowcomments#">
		<cfparam name="form.oldenclosure" default="#entry.enclosure#">
		<cfparam name="form.oldfilesize" default="#entry.filesize#">
		<cfparam name="form.oldmimetype" default="#entry.mimetype#">
		<cfparam name="form.released" default="#entry.released#">
		<cfparam name="form.duration" default="#entry.duration#">
		<cfparam name="form.keywords" default="#entry.keywords#">
		<cfparam name="form.subtitle" default="#entry.subtitle#">
		<cfparam name="form.summary" default="#entry.summary#">
		<cfif form.released>
			<cfparam name="form.sendemail" default="false">
		<cfelse>
			<cfparam name="form.sendemail" default="true">
		</cfif>
		<!--- handle case where form submitted, cant use cfparam --->
		<cfif not isDefined("form.save") and not isDefined("form.preview")>
			<cfset form.categories = structKeyList(entry.categories)>
			<cfset variables.relatedEntries = SESSION.BROG.getRelatedBlogEntries(URL.id, true, true, true)>
			<cfset form.relatedEntries = valueList(relatedEntries.id)>
		</cfif>
	<cfelse>
		<!--- look for savedtitle, savedbody from cookie, but only if not POSTing --->
		<cfif not structKeyExists(form, "title") and structKeyExists(cookie, "savedtitle")>
			<cfset form.title = cookie.savedtitle>
		</cfif>
		<cfif not structKeyExists(form, "body") and structKeyExists(cookie, "savedbody")>
			<cfset form.body = cookie.savedbody>
		</cfif>
		<cfif not isDefined("form.save") and not isDefined("form.return") and not isDefined("form.preview")>
			<cfset form.categories = "">
		</cfif>
		<cfparam name="form.title" default="">
		<cfparam name="form.body" default="">
		<cfparam name="form.alias" default="">
		<cfparam name="form.posted" default="#dateAdd("h", SESSION.BROG.getProperty("offset"), now())#">
		<cfparam name="form.allowcomments" default="">
		<cfparam name="form.oldenclosure" default="">
		<cfparam name="form.oldfilesize" default="0">
		<cfparam name="form.oldmimetype" default="">
		<!--- default released to false if no perms to release --->
		<cfparam name="form.released" default="#SESSION.BROG.isBlogAuthorized('ReleaseEntries')#">
		<cfparam name="form.duration" default="">
		<cfparam name="form.keywords" default="">
		<cfparam name="form.subtitle" default="">
		<cfparam name="form.summary" default="">
		<cfparam name="form.relatedEntries" default="">
		<cfparam name="form.sendemail" default="true">
	</cfif>
	<cfcatch>
		<cfrethrow>
	</cfcatch>
</cftry>
<cfset allCats = SESSION.BROG.getCategories()>
<cfparam name="form.newcategory" default="">
<cfif structKeyExists(form, "cancel")>
	<cfcookie name="savedtitle" expires="now">
	<cfcookie name="savedbody" expires="now">
	<cflocation url="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/entries/p.brewer.cfm" addToken="false">
</cfif>
<cfif isDefined("form.delete_enclosure")>
	<cfif URL.id is not "new">
		<cfset message = APPLICATION.BLOG.resourceBundle.getResource("enclosureentrywarning")>
	</cfif>
	<cfif len(form.oldenclosure)>
		<cfset chkfile = udfMakeDirIfNot("#APPLICATION.DISK.ATTACH#\#REQUEST.BLOG#") & "\" & GetFileFromPath(form.oldenclosure) />
		<cfif fileExists(chkfile)>
			<cffile action="delete" file="#chkfile#">
		<cfelse>
			<cfset message = "Attachment not found." />
		</cfif>
	</cfif>
	<cfset form.oldenclosure = "">
	<cfset form.oldfilesize = "0">
	<cfset form.oldmimetype = "">
</cfif>
<!--- ENCLOSURE LOGIC MOVE OUT TO ALWAYS RUN. THINKING IS THAT IT NEEDS TO RUN ON PREVIEW. --->
<cfif isDefined("form.enclosure") and len(trim(form.enclosure))>
	<cffile action="upload" filefield="enclosure" destination="#APPLICATION.DISK.TEMP#" nameconflict="overwrite">
	<cfif IsImageFile(cffile.serverDirectory & "/" & cffile.serverFile)>
		<cfset destination = udfMakeDirIfNot("#APPLICATION.DISK.BLOGIMG#\#REQUEST.BLOG#")>
	<cfelse>
		<cffile action="delete" file="#cffile.serverDirectory#/#cffile.serverFile#">
		<cfset destination = "" />
		<cfset message = "File '#cffile.serverFile#' is not a valid image." />
<!---
		DON'T DO ATTACHMENTS AT THIS TIME...
		<cfset destination = udfMakeDirIfNot("#APPLICATION.DISK.ATTACH#\#REQUEST.BLOG#")>
 --->
	</cfif>
	<cfif LEN(destination)>
		<cfset moveTo = destination & "/" & cffile.serverFile />
		<cfset form.oldenclosure = moveTo />
		<cfset form.oldfilesize = cffile.filesize />
		<cfset form.oldmimetype = cffile.contenttype & "/" & cffile.contentsubtype />
		<cffile action="move" source="#cffile.serverdirectory#/#cffile.serverfile#" destination="#moveTo#">
	</cfif>
<cfelseif isDefined("form.manualenclosure") and len(trim(form.manualenclosure))>
	<cfset destination = udfMakeDirIfNot("#APPLICATION.DISK.ATTACH#\#REQUEST.BLOG#")>
	<cfif NOT fileExists(destination & "/" & form.manualenclosure)>
		<cfset destination = udfMakeDirIfNot("#APPLICATION.DISK.BLOGIMG#\#REQUEST.BLOG#")>
		<cfif NOT fileExists(destination & "/" & form.manualenclosure)>
			<cfset destination = "" />
		</cfif>
	</cfif>
	<cfif LEN(destination)>
		<cfset form.oldenclosure = destination & "\" & form.manualenclosure>
		<cfdirectory action="list" directory="#destination#" filter="#form.manualenclosure#" name="getfile">
		<cfset form.oldfilesize = getfile.size>
		<cftry>
			<cfset form.oldmimetype = getPageContext().getServletContext().getMimeType(form.oldenclosure)>
			<cfcatch>
				<!--- silently fail for BD.Net --->
			</cfcatch>
		</cftry>
		<cfif not isDefined("form.oldmimetype")>
			<cfset form.oldmimetype = "application/unknown">
		</cfif>
	</cfif>
</cfif>
<cfif not isNumeric(form.oldfilesize)>
	<cfset form.oldfilesize = 0>
</cfif>
<cfif isDefined("form.save")>
	<cfset errors = arrayNew(1)>
	<cfif not len(trim(form.title))>
		<cfset arrayAppend(errors, APPLICATION.BLOG.resourceBundle.getResource("mustincludetitle"))>
	<cfelse>
		<cfset form.title = trim(form.title)>
	</cfif>
	<!--- Set the locale --->
	<cfset setLocale(SESSION.BROG.getProperty("locale"))>
	<cfif not lsIsDate(form.posted)>
		<cfset arrayAppend(errors, APPLICATION.BLOG.resourceBundle.getResource("invaliddate"))>
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset arrayAppend(errors, APPLICATION.BLOG.resourceBundle.getResource("mustincludebody"))>
		<cfset origbody = "">
	<cfelse>
		<cfset form.body = trim(form.body)>
		<!--- Fix damn smart quotes. Thank you Microsoft! --->
		<!--- This line taken from Nathan Dintenfas' SafeText UDF --->
		<!--- www.cflib.org/udf.cfm/safetext --->
		<cfset form.body = replaceList(form.body,chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230),"',',"","",--,--,...")>
		<cfset origbody = form.body>
		<!--- Handle potential <more/> --->
		<cfset strMoreTag = "<more/>">
		<cfset moreStart = findNoCase(strMoreTag,form.body)>
		<cfif moreStart gt 1>
			<cfset moreText = trim(mid(form.body,(moreStart+len(strMoreTag)),len(form.body)))>
			<cfset form.body = trim(left(form.body,moreStart-1))>
		<cfelseif moreStart is 1>
			<cfset arrayAppend(errors, APPLICATION.BLOG.resourceBundle.getResource("mustincludebody"))>
		<cfelse>
			<cfset moreText = "">
		</cfif>
	</cfif>
	<cfif (not isDefined("form.categories") or form.categories is "") and not len(trim(form.newCategory))>
		<cfset arrayAppend(errors, APPLICATION.BLOG.resourceBundle.getResource("mustincludecategory"))>
	<cfelseif SESSION.BROG.isBlogAuthorized('AddCategory')>
		<cfset form.newCategory = trim(htmlEditFormat(form.newCategory))>
		<!--- double check if existing --->
		<cfset cats = valueList(allCats.bca_name)>
		<cfif listFindNoCase(cats, form.newCategory)>
			<!--- This category already existed, loop and find id --->
			<cfloop query="allCats">
				<cfif form.newCategory is bca_name>
					<cfif not isDefined("form.categories")>
						<cfset form.categories = "">
					</cfif>
					<cfset form.categories = listAppend(form.categories, bca_bcaid)>
					<cfset form.newcategory = "">
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	<cfif len(form.alias)>
		<cfset form.alias = trim(htmlEditFormat(form.alias))>
	<cfelse>
		<!--- Auto create the alias --->
		<cfset form.alias = SESSION.BROG.makeTitle(form.title)>
	</cfif>
	<!---
	The purpose of this code:

	If you try to add an entry with an enclosure and your session timed out,
	you get forced back to login.cfm. I can't recreate the form w/ your file upload.
	So on login.cfm I notice it - and add a special form var named enclosureerror.
	I throw an error to the user so he knows to re-pick the file fo rupload.
	--->
	<cfif structKeyExists(form, "enclosureerror")>
		<cfset arrayAppend(errors, "Your enclosure was removed because your session timed out. Please upload it again.")>
	</cfif>
	<cfif not arrayLen(errors)>
		<!--- convert datetime to native --->
		<cfset form.posted = lsParseDateTime(form.posted)>

		<!--- Before we save, modify the posted time by -1 * posted --->
		<cfset form.posted = dateAdd("h", -1 * SESSION.BROG.getProperty("offset"), form.posted)>

		<cfif isDefined("variables.entry")>
			<!--- Begin: Shane Zehnder | released posts should have the post date of when they're released --->
			<cfif (form.released eq "true") and (entry.released eq "false") and (dateCompare(dateAdd("h", SESSION.BROG.getProperty("offset"), form.posted), now()) lt 0)>
				<cfset form.posted = dateAdd("h", SESSION.BROG.getProperty("offset"), now()) />
			</cfif>
			<!--- End: Shane Zehnder --->

			<cfset SESSION.BROG.saveEntry(URL.id, form.title, form.body, moreText, form.alias, form.posted, form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype, form.released, form.relatedentries, form.sendemail, form.duration, form.subtitle, form.summary, form.keywords )>
		<cfelse>
			<cfif not SESSION.BROG.isBlogAuthorized('ReleaseEntries')>
				<cfset form.released = 0>
			</cfif>
			<cfset URL.id = SESSION.BROG.addEntry(form.title, form.body, moreText, form.alias, form.posted, form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype, form.released, form.relatedentries, form.sendemail, form.duration, form.subtitle, form.summary, form.keywords )>
		</cfif>
		<!--- remove all old cats that arent passed in --->
		<cfif URL.id is not "new">
			<cfset SESSION.BROG.removeCategories(URL.id)>
		</cfif>
		<!--- potentially add new cat --->
		<cfif len(trim(form.newCategory)) and SESSION.BROG.isBlogAuthorized('AddCategory')>
			<cfparam name="form.categories" default="">
			<cfset form.categories = listAppend(form.categories,SESSION.BROG.addCategory(form.newCategory, SESSION.BROG.makeTitle(newCategory)))>
		</cfif>
		<cfset SESSION.BROG.assignCategories(URL.id,form.categories)>
		<cfmodule template="../tags/scopecache.cfm" scope="application" clearall="true">
		<cfcookie name="savedtitle" expires="now">
		<cfcookie name="savedbody" expires="now">
		<!--- force category cache refresh --->
		<cfset SESSION.BROG.getCategories(false)>

		<cflocation url="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/entries/p.brewer.cfm" addToken="false">
	<cfelse>
		<!--- restore body, since it loses more body --->
		<cfset form.body = origbody>
	</cfif>
</cfif>

<cfset allCats = SESSION.BROG.getCategories()>

<cfmodule template="../tags/adminlayout.cfm" title="Blog Entry Editor">
	<cfif not structKeyExists(form, "preview")>
		<cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {
				//create tabs
				$("##entrytabs").tabs()
				//handles searching
				getEntries = function() {
					$("##entries_dropdown").removeOption(/./);
					var id = $("##categories_dropdown option:selected").val()
					if(id==null) id=""
					var text = $("##titlefilter").val()
					text = $.trim(text)
					if(id == "" && text == "") return
					$("##entries_dropdown").ajaxAddOption("x.proxy.cfm?category="+id+"&text="+escape(text)+'&rand='+ Math.round(new Date().getTime()),{}, false)
				}
				$("##titlefilter").keyup(getEntries)
				//listen for select change on related
				$("##categories_dropdown").change(getEntries)
				$("##entries_dropdown").change(function () {
					var selid = $("option:selected", $(this)).val()
					var text = $("option:selected", $(this)).text()
					if($("##cbRelatedEntries").containsOption(selid)) return
					//sets the hidden form field
					var relEntry = $("##relatedentries")
					if(relEntry.val() == "") relEntry.val(selid)
					else relEntry.val(relEntry.val() + "," + selid)
					$("##cbRelatedEntries").addOption(selid,text,false)
				})
				$("##cbRelatedEntries").change(function() {
					var selid = $("option:selected", $(this)).val()
					if(selid == null) return
					$("##cbRelatedEntries").removeOption(selid)
					//quickly regen the hidden field
					var relEntry = $("##relatedentries")
					relEntry.val('')
					$("##cbRelatedEntries option").each(function() {
						var id = $(this).val()
						if(relEntry.val() == '') relEntry.val(id)
						else relEntry.val(relEntry.val() + "," + id)
					})
				})
			})
			function newImage(str) {
				$("##body").val($("##body").val() + "\n" + "<img src='" + str + "' />");
			}
			function more() {
				$("##body").val($("##body").val() + "\n" + "<more/>");
			}
			openImgWin = function() {
				var imgWin = popOut("#APPLICATION.PATH.ROOT#/u.imgwin.cfm","imgWin",725,400);
			}
			openImgBrowse = function() {
				var imgBrowse = popOut("#APPLICATION.PATH.ROOT#/u.imgbrowse.cfm","imgBrowse",725,600);
			}
			clearQuick = function(btn) {
				$(btn).remove();
				$(document.editForm.enclosure).removeClass("hide");
				document.editForm.oldenclosure.value = "";
				document.editForm.oldfilesize.value = "";
				document.editForm.oldmimetype.value = "";
			}
		<cfif URL.id eq 0>
			//used to save your form info (title/body) in case your browser crashes
			function saveText() {
				var titleField = $("##title").val()
				var bodyField = $("##body").val()
				var expire = new Date();
				expire.setDate(expire.getDate()+7);
				//write title to cookie
				var cookieString = 'SAVEDTITLE='+escape(titleField)+'; expires='+expire.toGMTString()+'; path=/';
				document.cookie = cookieString;
				cookieString = 'SAVEDBODY='+escape(bodyField)+'; expires='+expire.toGMTString()+'; path=/';
				document.cookie = cookieString;
				window.setTimeout('saveText()',5000);
			}
			window.setTimeout('saveText()',5000);
		</cfif>
		</script>
		</cfoutput>
		<!---
		Ok, so this line below here has been the cuase of MUCH pain in agony. The problem is in noticing
		when you save and ensuring you have a valid date. I don't know why this is so evil, but it caused
		me a lot of trouble a few months back. A new bug cropped up where if you hit the 'new entry'
		url direct (entry.cfm?id=0), the date would default to odbc date. So now the logic ensures
		that you either have NO form post, of a form post with username from the login.

		I can bet I'll be back here one day soon.
		--->

		<cfif lsIsDate(form.posted) and (not isDefined("form.fieldnames") or isDefined("form.username"))>
			<cfset form.posted = createODBCDateTime(form.posted)>
			<cfset form.posted = APPLICATION.BLOG.localeUtils.dateLocaleFormat(form.posted,"short") & " " & APPLICATION.BLOG.localeUtils.timeLocaleFormat(form.posted)>
		</cfif>
		<!--- tabs --->
		<cfoutput>
		<form action="?id=#URL.id#" method="post" enctype="multipart/form-data" name="editForm" id="editForm" class="inlineLabels">
		<div id="entrytabs">
			<ul>
				<li><a href="##main"><span>Main</span></a></li>
				<li><a href="##additional"><span>Additional Settings</span></a></li>
				<li><a href="##related"><span>Related Entries</span></a></li>
				<cfif URL.id neq 0><li><a href="##comments"><span>Comments</span></a></li></cfif>
			</ul>
			<div id="main">
			<p>
			To show only a portion of your entry on the main blog page, separate your content with the <span class="imgbtn" onclick="more()" title="click to insert">&lt;more/&gt;</span> tag.
			</p>
		</cfoutput>
		<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
			<cfoutput>
			<div class="errors">
				Please correct the following error(s):
				<div class="pad10">
					<div class="ui-state-default ui-state-error ui-corner-all pad10">
						<ul>
							<cfloop index="x" from="1" to="#arrayLen(errors)#"><li>#errors[x]#</li></cfloop>
						</ul>
					</div>
				</div>
			</div>
			</cfoutput>
		<cfelseif structKeyExists(variables, "message")>
			<cfoutput>
			<div class="message">#message#</div>
			</cfoutput>
		</cfif>
		<cfoutput>
		<table class="datagrid noborder" cellspacing="0" width="660">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td class="label required" width="135">Title:</td>
					<td><input type="text" name="title" id="title" value="#htmlEditFormat(form.title)#" maxlength="100" style="width:100%" class="textInput" /></td>
				</tr>
				<tr>
					<td class="label required">Body:</td>
					<td>
						<textarea name="body" id="body" class="txtArea">#htmlEditFormat(form.body)#</textarea>
						<br>
						<div class="right padt5">
							<span class="imgbtn ui-corner-all" title="Upload a new image and insert link into body" onclick="openImgWin()"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="ui-icon ui-icon-arrowreturnthick-1-n" />Upload New Image</span>
							<span class="imgbtn ui-corner-all" title="Insert a link to a previously uploaded image" onclick="openImgBrowse()"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="ui-icon ui-icon-image" /> Insert Existing Image</span>
						</div>
					</td>
				</tr>
				<tr>
					<td class="label">Quick Attach New Image:</td>
					<td>
						<input type="hidden" name="oldenclosure" value="#form.oldenclosure#">
						<input type="hidden" name="oldfilesize" value="#form.oldfilesize#">
						<input type="hidden" name="oldmimetype" value="#form.oldmimetype#">
						<cfif LEN(form.oldenclosure)>
							<span class="imgbtn ui-corner-all" title="Remove Image" onclick="clearQuick(this)"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-delete" /> #GetFileFromPath(form.oldenclosure)#</span>
						</cfif>
						<input name="enclosure" id="enclosure" size="30" type="file" class="fileUpload<cfif LEN(form.oldenclosure)> hide</cfif>" />
					</td>
				</tr>

				<tr>
					<td class="label">Categories:</td>
					<td>
						<cfif allCats.RecordCount>
							<select name="categories" id="categories" multiple="multiple" size="4" style="width: 50%">
							<cfloop query="allCats"><option value="#bca_bcaid#" <cfif isDefined("form.categories") and listFind(form.categories,bca_bcaid)>selected</cfif>>#bca_name#</option></cfloop>
							</select>
						</cfif>
					</td>
				</tr>
			<cfif SESSION.BROG.isBlogAuthorized("AddCategory")>
				<tr>
					<td class="label">Add New Category:</td>
					<td><input type="text" name="newcategory" id="newcategory" value="#htmlEditFormat(form.newcategory)#" maxlength="50"></td>
				</tr>
			</cfif>
<!--- 				<tr>
					<td class="label">Attach Existing:</td>
					<td><input type="text" name="manualenclosure" id="manualenclosure" class="textInput"> <span class="bco_moderated">...Must know existing file name</span></td>
				</tr>
			<cfif len(form.oldenclosure)>
				<tr>
					<td class="label">#listLast(form.oldenclosure,"/\")#:</td>
					<td><input type="submit" name="delete_enclosure" value="#APPLICATION.BLOG.resourceBundle.getResource("deleteenclosure")#"></td>
				</tr>
			</cfif> --->
			</tbody>
		</table>
		</div>
		</cfoutput>
		<!--- tab 2 --->
		<cfoutput>
		<div id="additional">
			<table class="datagrid noborder" cellspacing="0" width="660">
				<tbody class="bih-grid-form nobevel">
					<tr>
						<td class="label">Released:</td>
						<td>
							<cfif SESSION.BROG.isBlogAuthorized('ReleaseEntries')>
								<select name="released" id="released">
									<option value="true" <cfif form.released is "true">selected</cfif>>Yes</option>
									<option value="false" <cfif form.released is "false">selected</cfif>>No</option>
								</select>
							<cfelse>
								#yesNoFormat(form.released)#
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="label" width="135">Post Date:</td>
						<td><input type="text" name="posted" id="posted" value="#udfUserDateFormat(form.posted)# #udfUserTimeFormat(form.posted)#" maxlength="100" class="textInput"></td>
					</tr>
					<tr>
						<td class="label">SES Alias:</td>
						<td>
							<input type="text" name="alias" id="alias" value="#form.alias#" maxlength="100" class="textInput" readonly="readonly">
							<span class="bco_moderated">...autogenerated</span>
						</td>
					</tr>
					<tr>
						<td class="label">Allow Comments:</td>
						<td>
							<select name="allowcomments" id="allowcomments">
								<option value="true" <cfif form.allowcomments is "true">selected</cfif>>Yes</option>
								<option value="false" <cfif form.allowcomments is "false">selected</cfif>>No</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="label">Email Blog Entry:</td>
						<td>
							<select name="sendemail" id="sendemail">
								<option value="true" <cfif form.sendemail is "true">selected</cfif>>Yes</option>
								<option value="false" <cfif form.sendemail is "false">selected</cfif>>No</option>
							</select>
						</td>
					</tr>
<!--- 					<tr>
						<td class="label">iTunes Subtitle:</td>
						<td><input type="text" name="subtitle" id="subtitle" value="#form.subtitle#" maxlength="100" class="textInput"></td>
					</tr>
					<tr>
						<td class="label">iTunes Keywords:</td>
						<td><input type="text" name="keywords" id="keywords" value="#form.keywords#" maxlength="100" class="textInput"></td>
					</tr>
					<tr>
						<td class="label">iTunes Summary:</td>
						<td><textarea name="summary" id="summary" class="txtArea">#htmlEditFormat(form.summary)#</textarea></td>
					</tr>
					<tr>
						<td class="label">Duration:</td>
						<td><input type="text" name="duration" id="duration" value="#form.duration#" maxlength="10" class="textInput"></td>
					</tr> --->
				</tbody>
			</table>
		</div>
		<div id="related">
			<p>
			Use the form below to search for and add related entries to this blog entry. When you relate one blog entry to another, you automatically create a connection from that entry back to this one.
			To add a related entry, use either of the below filters to retrieve matching blog entries. (Note that the entries listed only contain the previous 200 blog entries posted that match your criteria.)
			Click an entry to add it to the list of currently related entries.
			</p>
			<table class="datagrid noborder" cellspacing="0" width="660">
				<tbody class="bih-grid-form nobevel">
					<tr>
						<td class="label" width="135">Filter By Text:</td>
						<td><input type="text" name="titlefilter" id="titlefilter" maxlength="100" class="textInput"></td>
					</tr>
					<tr>
						<td class="label">Filter by Category:</td>
						<td>
							<select id="categories_dropdown" size="4" style="width:50%">
								<cfloop query="allCats"><option value="#bca_bcaid#">#bca_name#</option></cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td class="label">Entries:</td>
						<td><select id="entries_dropdown" size="4" style="width:100%;cursor:pointer;"></select></td>
					</tr>
					<tr>
						<td class="label">Currently Related:</td>
						<td>
							<input type="hidden" name="relatedentries" id="relatedentries" value="#form.relatedentries#">
							<select id="cbRelatedEntries" name="cbRelatedEntries" multiple="multiple" size="4" style="width: 100%;cursor:pointer;" >
								<cfif structKeyExists(variables, "relatedEntries")>
									<cfloop query="relatedEntries"><option value="#id#">#title#</option></cfloop>
								<cfelse>
									<cfloop list="#form.relatedentries#" index="i"><option value="#i#">#SESSION.BROG.getEntry(i).title#</option></cfloop>
								</cfif>
							</select>
							<span class="bco_moderated">(clicking removes an entry)</span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<cfif URL.id neq 0>
		<div id="comments">
				<iframe
					src="u.entry_comments.cfm?id=#URL.id#"
					id="commentsFrame"
					name="commentsFrame"
					style="width: 100%; min-height: 500px; overflow-y: hidden;"
					scrolling="false"
					frameborder="0"
					marginheight="0"
					marginwidth="0"></iframe>
		</div>
		</cfif>
		<!--- closes tabs area --->
		</div>

		<div class="post_buttons ui-widget-content ui-corner-all">
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-cancel" name="cancel" text="Cancel" onclick="return confirm('Are you sure you want to cancel this entry?')" />
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-report" name="Preview" text="Preview" submit="true" />
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-disk" name="Save" text="Save" submit="true" />
		</div>
		</form>
		</cfoutput>
	<cfelse>
		<cfif structKeyExists(variables, "message")>
			<cfoutput><div class="pad10"><div class="ui-state-default ui-state-error ui-corner-all pad10">#message#</div></div></cfoutput>
		</cfif>
		<cfset setLocale(SESSION.BROG.getProperty("locale"))>
		<cfset posted = lsParseDateTime(form.posted)>
		<cfset posted = dateAdd("h", -1 * SESSION.BROG.getProperty("offset"), posted)>
		<cfparam name="form.categories" default="">
		<!--- Handles previews. --->
		<cfoutput>
		<div class="previewEntry">
			<h1>#form.title#</h1>
			<div style="margin-bottom: 10px">#APPLICATION.BLOG.resourceBundle.getResource("postedat")# : #APPLICATION.BLOG.localeUtils.dateLocaleFormat(posted)# #APPLICATION.BLOG.localeUtils.timeLocaleFormat(posted)#
				| #APPLICATION.BLOG.resourceBundle.getResource("postedby")# : #SESSION.BROG.getNameForUser(getAuthUser())#<br />
				#APPLICATION.BLOG.resourceBundle.getResource("relatedcategories")#:
				<cfloop index="x" from=1 to="#listLen(form.categories)#">
					<a href="#SESSION.BROG.makeCategoryLink(listGetAt(form.categories,x))#">#SESSION.BROG.getCategory(listGetAt(form.categories,x)).bca_name#</a><cfif x is not listLen(form.categories)>,</cfif>
				</cfloop>
			</div>
			#SESSION.BROG.renderEntry(form.body,false,form.oldenclosure)#
		</div>
		<form action="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/entry/p.brewer.cfm?#CGI.query_string#" method="post">
		<cfloop item="key" collection="#form#">
			<cfif not listFindNoCase("preview,fieldnames,enclosure,username", key)>
				<input type="hidden" name="#key#" value="#htmlEditFormat(form[key])#">
			</cfif>
		</cfloop>
		<input type="submit" name="return" value="Return"> <input type="submit" name="save" value="Save">
		</form>
		</cfoutput>
	</cfif>
</cfmodule>
<cfsetting enablecfoutputonly="false" />
