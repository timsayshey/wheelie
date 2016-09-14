<cfoutput>	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Sites')>
	<cfset contentFor(headerButtons = 
				'<li class="headertab">
					#linkTo(
						text		= "<span class=""elusive icon-user""></span> Add Site",
						route		= "admin~Action",
						module		= "admin",
						controller	= "sites",
						action		= "new", 
						class		= "btn btn-default"
					)#		
				</li>')>
	<cftry>
		
	<style type="text/css">
		.actions .btn, .label {
			margin-bottom:3px !important;
			display:inline-block;
		}
	</style>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>Id</th>
				<th>Domain</th>
				<th>Has SSL?</th>
				<th>Theme</th>
				<th>URL Extension</th>
				<th class="col-md-2">Actions</th>
			</tr>
		</thead>
		<tbody> 	
			<cfloop query="sites">
				<tr>
					<td>#id#</td>
					<td>#urlid#</td>
					<td>#sslenabled#</td>
					<td>#theme#</td>
					<td>#urlExtension#</td>
					<td class="actions">						
						<a href="/m/admin/sites/edit/#id#" class="btn btn-default btn-sm"><span class="elusive icon-pencil"></span></a>						
						<a href="/m/admin/sites/delete/#id#" class="btn btn-danger btn-sm confirmDelete"><span class="elusive icon-trash"></span></a>
					</td>
				</tr>			
			</cfloop>	
		</tbody>
	</table>
	
	<cfcatch><cfdump var="#cfcatch#"></cfcatch> 
	</cftry>
</cfoutput>