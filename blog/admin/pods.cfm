<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />

<cfset dir = expandPath("blog/includes/pods")>
<cfif StructKeyExists(URL,"deletePod") and fileExists(dir & "/#URL.deletePod#")>
	<cffile action="delete" file="#dir#/#URL.deletePod#">
</cfif>
<!--- GET ALL OF THE CFM FILES IN THE POD FOLDER ---->
<cfdirectory directory="#dir#" name="pods" filter="*.cfm" />
<!--- Get the active pods and their sort order --->
<cfset podMetaData = APPLICATION.BLOG.pod.getInfo(dir)>
<!--- Add field to the query returned from cfdirectory --->
<cfset queryAddColumn(pods, "sortOrder", arrayNew(1))>
<cfloop query="pods">
	<cfif structKeyExists(podMetaData.pods,name)>
			<cfset querySetCell(pods, "sortOrder", podMetaData.pods[name], currentRow)>
		<cfelse>
			<cfset querySetCell(pods, "sortOrder", "", currentRow)>
	</cfif>
</cfloop>
<script>
	podSetSort = function(inp) {
		inp.title = inp.value || " ";
	}
	$(document).ready(function() {
		$("#tabPod").tablescroller({ height: 500, sort: true, print: false});
	});
</script>
<cfmodule template="../tags/adminlayout.cfm" title="Pods">
	<cfoutput>
	<p>
	The Pod Manager allows you to edit and organize the pods on your site. If none of the pods below are selected,
	then the default behavior (show all of them) will be used. In order to specify a particular set of pods, you must <b>both</b>
	select the pod and enter a numeric sort order.
	</p>
	<p>Select the Pods you want to display, and enter a numeric value for the sort order.</p>

	<form name="PodUpdate" method="POST" action="x.pod.cfm">
	<table id="tabPod" class="datagrid noborder" width="100%" cellspacing="0">
		<caption>Available Pods <span class="rowcnt">#pods.RecordCount# Defined / #StructCount(podMetaData.pods)# Active </span></caption>
		<thead>
			<tr>
				<th class="icon" width="25"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiIcon" src="bih-icon bih-icon-popout" title="View"/></th>
				<th class="icon" width="25"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiIcon" src="bih-icon bih-icon-pencil" title="Edit"/></th>
				<th class="icon" width="25"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiIcon" src="bih-icon bih-icon-delete" title="Delete"/></th>
				<th>Name</th>
				<th>Display</th>
				<th>Sort Order</th>
			</tr>
		</thead>
	</cfoutput>
		<tbody>
		<cfoutput query="pods">
			<tr class="bih-grid-row-stripe#currentRow mod 2#">
				<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="bih-icon bih-icon-popout" title="Preview" onclick="popOut('x.showpods.cfm?pod=#name#','PodWin',400,300);" /></td>
				<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="bih-icon bih-icon-pencil" title="Edit" href="x.podform.cfm?pod=#name#" /></td>
				<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="bih-icon bih-icon-delete" title="Delete" href="x.pods.cfm?deletePod=#name#" /></td>
				<td>#name#</td>
				<td class="center"><input type="checkbox" name="ShowPods" value="#name#" <cfif len(sortOrder)>checked</cfif>></td>
				<td align="center"><input type="text" name="#name#" value="#sortOrder#" size="3" tabindex="#currentrow#" title="#sortOrder#  " onblur="podSetTitle(this)"></td>
			</tr>
		</cfoutput>
	<cfoutput>
		</tbody>
	</table>
	<p>
	<div class="ui-widget ui-widget-content ui-corner-all right" style="padding: 5px">
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilnew" href="x.podform.cfm" text="Add New Pod"/>
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" onclick="this.form.submit()" text="Save Changes"/>
	</div>
	</p>
	</form>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly="false" />