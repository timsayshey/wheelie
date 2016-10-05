<cfoutput>	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Forms')>
	<cfset contentFor(headerButtons = 
				'<li class="headertab">
					#linkTo(
						text		= "<span class=""elusive icon-user""></span> Add Form",
						route		= "admin~Action",
						module		= "admin",
						controller	= "forms",
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
				<th class="col-md-3">Actions</th>
			</tr>
		</thead>
		<tbody> 	
			<cfloop query="forms">
				<tr> 
					<td>
						<h5 style="margin:0"><strong>#name#</strong></h5>
						<a href='#urlFor(
								route		= "admin~Id",
								controller	= "forms",
								action		= "show",
								id			= id
							)#'>Admin Form</a> - 
						<a href='#urlFor(
								route		= "public~id", 
								controller	= "pforms", 
								action		= "show",
								id			= id
							)#'>Public Form</a> - 
						Shortcode: [formly formid="#id#"]
					</td>
					<td class="actions">						
						
						<a href='#urlFor(
								route		= "admin~Id",
								controller	= "forms",
								action		= "edit",
								id			= id
							)#' class="btn btn-default btn-sm"><span class="elusive icon-pencil"></span></a>
							
						<a href='#urlFor(
								route		= "admin~Id",
								controller	= "forms",
								action		= "formsubmissions",
								id			= id
							)#' class="btn btn-default btn-sm">Submissions</a>
							
						<a href='#urlFor(
								route		= "admin~Field",
								controller	= "metafields",
								action		= "index",
								modelName	= "formfield",
								params		= "modelid=#id#"
							)#' class="btn btn-default btn-sm">Fields</a>
						<a href="/m/admin/forms/delete/#id#" class="btn btn-danger btn-sm confirmDelete"><span class="elusive icon-trash"></span></a>
					</td>
				</tr>			
			</cfloop>	
		</tbody>
	</table>
	
	<cfcatch><cfdump var="#cfcatch#"></cfcatch> 
	</cftry>
</cfoutput>