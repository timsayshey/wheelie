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
		<li class="admindropdown admin-alignright">
		 	 <a href="#editAccount#" class="admindropdown-toggle" data-toggle="admindropdown"><span class="elusive icon-user"></span> Account <span class="elusive icon-caret-down"></span></a>
			 <ul class="admindropdown-menu">	
				
				<li>
				<a href='#editAccount#'><img style="padding:0 5px;max-width:30px;" src="#fileExists(expandPath('/assets/userpics/#session.user.id#.jpg')) ? '/assets/userpics/#session.user.id#.jpg' : '/assets/img/user_thumbholder.jpg'#">
				#session.user.fullname#</a>
				</li>
				<li><a href='#urlFor(route="admin~Action", controller="users", action="logout")#'>Logout</a></li>
			 </ul>
		</li>	</cfif>
</cfoutput>