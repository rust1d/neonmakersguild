<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : C:\projects\blogcfc5\client\admin\users.cfm
	Author       : Raymond Camden
	Created      : 07/15/09
	Last Updated :
	History      :
--->

<cfif not SESSION.BROG.isBlogAuthorized('ManageUsers')>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset SESSION.BROG.deleteUser(u)>
	</cfloop>
</cfif>


<cfset users = SESSION.BROG.getUsers()>

<cfmodule template="../tags/adminlayout.cfm" title="Users">

	<cfoutput>
	<p>
	Your blog currently has
		<cfif users.RecordCount gt 1 or users.RecordCount is 0>
		#users.RecordCount# users.
		<cfelseif users.RecordCount is 1>
		1 user.
		</cfif>
	</p>
	<p>
	Note that deleting yourself is probably a bad idea. Deleting a user with blog entries will result in their blog entries no longer showing their name. It is <b>not</b> recommend to delete users with entries.
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#users#" editlink="x.user.cfm" label="Users"
			  linkcol="username" linkval="username">
		<cfmodule template="../tags/datacol.cfm" colname="username" label="Username" />
		<cfmodule template="../tags/datacol.cfm" colname="name" label="Name" />
	</cfmodule>

</cfmodule>


<cfsetting enablecfoutputonly="false" />