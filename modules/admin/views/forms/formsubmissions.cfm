<cfoutput>	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> #qform.name# Submissions')>
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
			</tr>
		</thead>
		<tbody> 	
			<cfloop query="formsubmissions">
				<tr> 
					<td>
						<a href='#urlFor(
								route		= "admin~Id",
								controller	= "forms",
								action		= "formsubmission",
								id			= id
							)#'>#DateFormat(formsubmissions.createdAt,"MMMM D, YYYY")#</a><br>
					</td>
				</tr>			
			</cfloop>	
		</tbody>
	</table>
	
	<cfcatch><cfdump var="#cfcatch#"></cfcatch> 
	</cftry>
</cfoutput>