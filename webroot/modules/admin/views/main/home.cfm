<cfoutput>
	
	<cfset contentFor(headerTitle	= '<span class="fa fa-dashboard"></span> Dashboard')>
	<cfset pageTemplate = getAdminTemplate("home")>
		
	<cfif len(pageTemplate)>
		<cfinclude template="#pageTemplate#">
	<cfelse>
		Add/Edit the admin home page at:<br>
		/views/layouts/admin/templates/home.cfm		
	</cfif>	
</cfoutput>