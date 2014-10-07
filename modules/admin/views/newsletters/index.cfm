<cfoutput>	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Newsletters')>
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-pencil""></span> Add Newsletter",
				route		= "admin~Action",
				module		= "admin",
				controller	= "newsletters",
				action		= "new", 
				class		= "btn btn-default"
			)#		
		</li>')>
	
	<strong>Creating a Newsletter:</strong><br>
	<strong>Step 1:</strong> Add a newsletter, click the "Add" button to the top right.<br><br>
		
	<table class="table table-striped">
		<thead>
			<tr>
				<th>Newsletter Name</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody> 			
			<cfloop query="newsletters">
			<tr>
				<td>#newsletters.subject#</td>
				<td>				
					<a href='#urlFor(route="admin~Id", module="admin", controller="newsletterSections", action="index", id="#newsletters.id#")#'  class="tn btn-primary btn-xs"><span class="elusive icon-th-list"></span> Sections</a> 
					
					<a href='#urlFor(route="admin~Id", module="admin", controller="newsletters", action="preview", id="#newsletters.id#")#'  class="tn btn-info btn-xs"><span class="elusive icon-eye-open"></span> Preview</a>
					
					<a href='#urlFor(route="admin~Id", module="admin", controller="newsletters", action="edit",id="#newsletters.id#")#' class="tn btn-info btn-xs"><span class="elusive icon-edit"></span> Edit</a> 
					
					<a href='#urlFor(route="admin~Id", module="admin", controller="newsletters", action="delete",id="#newsletters.id#")#' class="btn btn-danger btn-xs confirmDelete"><span class="elusive icon-trash"></span> Delete</a>
				</td>
			</tr>			
			</cfloop>	
		</tbody>
	</table>
		
</cfoutput>