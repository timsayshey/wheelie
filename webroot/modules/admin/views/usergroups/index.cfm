<cfoutput>	
	<cfset contentFor(headerTitle	= '<span class="fa fa-user"></span> Usergroups')>
	<cfset contentFor(headerButtons = 
				'<li class="headertab">
					#linkTo(
						text		= "<span class=""fa fa-user""></span> Add Usergroup",
						route		= "admin~Action",
						module		= "admin",
						controller	= "usergroups",
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
				<th>Name</th>
				<th class="col-md-2">Actions</th>
			</tr>
		</thead>
		<tbody> 	
			<cfloop query="usergroups">			
				<cfif usergroups.globalized eq 1 AND checkPermission("superadmin") OR usergroups.globalized eq 0>			
					<tr>
						<td>
							#groupname# <cfif usergroups.globalized eq 1><strong>*All Sites</strong></cfif><br>
						</td>
						<td class="actions">						
							<a href="/m/admin/usergroups/edit/#id#" class="btn btn-default btn-sm"><span class="fa fa-pencil"></span></a>
							<a href='#urlFor(
									route		= "admin~Field",
									controller	= "metafields",
									action		= "index",
									modelName	= "usergroupfield",
									params		= "modelid=#id#"
								)#' class="btn btn-default btn-sm">Fields</a>
							<a href="/m/admin/usergroups/delete/#id#" class="btn btn-danger btn-sm confirmDelete"><span class="fa fa-trash"></span></a>
						</td>
					</tr>
				</cfif>			
			</cfloop>	
		</tbody>
	</table>
	
	<cfcatch><cfdump var="#cfcatch#"></cfcatch> 
	</cftry>
</cfoutput>