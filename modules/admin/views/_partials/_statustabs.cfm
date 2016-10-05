<cfoutput>	
	<cfparam name="controllerName">
	<cfparam name="statusUrl" default='#urlFor(route="admin~Index", module="admin", controller=controllerName)#'>
	
	<ul class="nav nav-tabs">		
		<cfloop list="all,published,draft" index="statusid">
			<li class="#params.status eq statusid ? 'active' : ''#">
				<a href='#statusUrl#?status=#statusid#'>
					#capitalize(statusid)# (#count[statusid]#)
				</a>
			</li>
		</cfloop>		
	</ul>
	<br class="clear" /><br />
	
</cfoutput>