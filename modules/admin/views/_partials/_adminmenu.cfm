<cfoutput>
	#renderadminMenu(adminNavMain)#
	<li class="admindropdown">#renderadminMenu(adminNavMore)#</li>
	
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
				)#'><span class="elusive icon-pencil"></span> Edit #capitalize(singularize(editBtn.controllerName))#</a>
			</li>
		</cfif>

		<li class="admindropdown admin-alignright admin-pad-right">
		 	 <a href="#editAccount#" class="admindropdown-toggle" data-toggle="admindropdown"><span class="elusive icon-user"></span> Account <span class="elusive icon-caret-down"></span></a>
			 <ul class="admindropdown-menu">	
				
				<li>
				<a href='#editAccount#'><img style="padding-right:5px;max-width:30px;" src="#fileExists(expandPath('/assets/userpics/#session.user.id#.jpg')) ? '/assets/userpics/#session.user.id#.jpg' : '/assets/img/user_thumbholder.jpg'#">
				#session.user.fullname#</a>
				</li>
				<li><a href='#urlFor(route="admin~Action", controller="users", action="logout")#'>Logout</a></li>
			 </ul>
		</li>
		
		<!---<li class="admin-alignright">
			<a href="/"><span class="elusive icon-eye-open"></span> Visit Site</a>
		</li>--->
		
	</cfif>
</cfoutput>