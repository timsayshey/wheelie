<cfoutput>	
	<cfset params.modelname = "User">
	<cfset buttonParams = "">
	<script type='text/javascript' src="//code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
	<link href="//code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" type="text/css" rel="stylesheet" media="all">
	<script type='text/javascript' src="/views/layouts/admin/assets/js/reorder.js"></script>
	<script type="text/javascript">	
		$(function() {
			initSortable('#urlFor(				
				route		= "admin~Action",
				controller	= "users",
				action		= "updateOrder"
			)#');
		});
	</script>
	<cfset contentFor(headerTitle	= '<span class="fa fa-user"></span> Users')>
	<cfif !isNull(sortusers)>
			
		<style type="text/css">
			.actions .btn, .label {
				margin-bottom:3px !important;
				display:inline-block;
			}
		</style>
		
		<strong>Tip:</strong> You can change the order of the users by dragging and dropping.<br><br>
		
		<table class="table table-striped" id="sortable">
			<thead>
				<tr>
					<th class="col-md-1">&nbsp;</th>
					<th>Name</th>					
				</tr>
			</thead>
			<tbody> 	
				<cfloop query="sortusers">
					<tr rel="#sortusers.id#">
						<td class="text-center">
							<span class="fa fa-move"></span>
						</td>	
						<td>
							#firstname# #lastname#
						</td>	
					</tr>			
				</cfloop>	
			</tbody>
		</table>
	<cfelse>
		<h3>There was an issue, go back and try again.</h3><br><br>

	</cfif>
	
</cfoutput>