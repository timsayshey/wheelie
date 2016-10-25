<cfoutput>	
	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> #newsletter.subject# Sections')>
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~Action", 
				module		= "admin",
				controller	= "newsletters", 
				action		= "index", 
				class		= "btn btn-default"
			)#			
			#linkTo(
				text		= "<span class=""elusive icon-eye-open""></span> Preview",
				route		= "admin~Id", 
				module		= "admin", 
				controller	= "newsletters", 
				action		= "preview", 
				id			= newsletter.id,
				class		= "btn btn-default"
			)#
			#linkTo(
				text		= "<span class=""elusive icon-pencil""></span> Add Section",
				route		= "admin~Action",
				module		= "admin",
				controller	= "newsletterSections",
				action		= "new", 
				class		= "btn btn-default",
				params		= "newsletterid=#newsletter.id#"
			)#		
		</li>')>
		
	<strong>Creating a Newsletter (Continued):</strong><br>
	<strong>Step 2:</strong> Add sections of content, click the "Add" button to the top right.<br>
	<strong>Step 3:</strong> After sections have been added, click preview, once approved notify Tim.<br><br>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>Section Name</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody> 			
			<cfloop query="sections">
			<tr>
				<td>#sections.title#</td>
				<td>					
					<a href='#urlFor(route="admin~Id", module="admin", controller="newsletterSections", action="edit",id="#sections.id#",params="newsletterid=#newsletter.id#")#' class="tn btn-primary btn-xs"><span class="elusive icon-edit"></span> Edit</a> 
					
					<a href='#urlFor(route="admin~Id", module="admin", controller="newsletterSections", action="delete",id="#sections.id#",params="newsletterid=#newsletter.id#")#' class="btn btn-danger btn-xs confirmDelete"><span class="elusive icon-trash"></span> Delete</a>
				</td>
			</tr>			
			</cfloop>	
		</tbody>
	</table>
		
</cfoutput>