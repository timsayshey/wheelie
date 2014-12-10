<cfoutput>	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> #qform.name# Submissions')>
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~index",
				controller	= "forms",
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
				<th>Date</th>
				<th>From Page</th>
				<th>Referrer</th>
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
							)#'>#DateFormat(formsubmissions.createdAt,"MMMM D, YYYY")# at #TimeFormat(formsubmissions.createdAt, "short")#</a><br>
					</td>
					<td>
						#formsubmissions.fromPage#
					</td>
					<td>
						#formsubmissions.referrer#
					</td>
				</tr>			
			</cfloop>	
		</tbody>
	</table>
	
	<cfcatch><cfdump var="#cfcatch#"></cfcatch> 
	</cftry>
</cfoutput>