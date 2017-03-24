<cfoutput>
	#renderadminMenu(adminNavMain)#
	<li class="dropdown">#renderadminMenu(adminNavMore)#</li>
	
	<cfif !isNull(session.user)>	
		<cfset editAccount = urlFor(									
			route		= "admin~Id",
			module		= "admin",
			controller	= "profiles",
			action		= "profile",
			id			= session.user.id
		)>	

		<cfif !isNull(editBtn) AND isStruct(editBtn)>
			<li>
				<a href='#urlFor(							
					route		= "admin~Id",
					module		= "admin",
					controller	= editBtn.controllerName,
					action		= "edit",
					id			= editBtn.currentId
				)#'><span class="fa fa-pencil"></span> Edit #capitalize(singularize(editBtn.controllerName))#</a>
			</li>
		</cfif>

		<!--- <li class="dropdown admin-alignright admin-pad-right">
		 	 <a href="#editAccount#" class="dropdown-toggle" data-toggle="dropdown"><span class="fa fa-user"></span> Account <span class="fa fa-caret-down"></span></a>
			 <ul class="dropdown-menu">	
				
				<li>
				<a href='#editAccount#'><img style="padding-right:5px;max-width:30px;" src="#fileExists(expandThis('/assets/userpics/#session.user.id#.jpg')) ? assetUrlPrefix() & '/assets/userpics/#session.user.id#.jpg' : '/assets/img/user_thumbholder.jpg'#">
				#session.user.fullname#</a>
				</li>
				<li><a href='#urlFor(route="admin~Action", controller="users", action="logout")#'>Logout</a></li>
			 </ul>
		</li> --->
		
		<!---<li class="admin-alignright">
			<a href="/"><span class="fa fa-eye-open"></span> Visit Site</a>
		</li>--->
		
	</cfif>
</cfoutput>