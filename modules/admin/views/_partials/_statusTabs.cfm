<cfoutput>	
	<cfparam name="controllerName">
	
	<ul class="nav nav-tabs">		
		<cfloop list="all,published,draft" index="statusid">
			<li class="#params.status eq statusid ? 'active' : ''#">
				<a href='#urlFor(route="moduleIndex", module="admin", controller=controllerName, params="status=#statusid#")#'>
					#capitalize(statusid)# (#count[statusid]#)
				</a>
			</li>
		</cfloop>		
	</ul>
	<br class="clear" /><br />
	
</cfoutput>