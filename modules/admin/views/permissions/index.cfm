<cfoutput>

	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Role Permissions')>
	
	<script src="/assets/vendor/checkboxToggle.js" type="text/javascript"></script>
	
	<form method="post" action='#urlFor(route="admin~Action", controller="permissions", action="permissionsSubmit")#'>
	
		<table width="100%" class="table table-striped table-border table-hover table-bordered">
			<tbody>
				<tr>
					<th>ID</th>
					<cfloop list="#permissionCols#" index="column">
						<th>#column#</th>
					</cfloop>
				</tr>				
				<cfloop query="permissions">
					<tr>
						<td>#permissions.id#</td>
						<cfloop list="#permissionCols#" index="column">
							<td class="checkboxes">
							<input class="setFalse" type="checkbox" name="permissions[#id#][#column#]" value="0" style="display:none;"
								<cfif permissions[column] eq 0>
									checked
								</cfif>
							>
							<input class="setTrue" type="checkbox" name="permissions[#id#][#column#]" value="1" 
								<cfif permissions[column] neq 0>
									checked
								</cfif>
							></td>
						</cfloop>
					</tr>	
				</cfloop>
			</tbody>
		</table>
		<input type="submit" class="btn btn-primary" value="Submit">
	</form>
</cfoutput>