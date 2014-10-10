<cfoutput>
	<!-- Navigation items -->
	<ul class="nav navbar-nav">

		<li>
			<a href='#urlFor(route="admin~Action", controller="main", action="home")#'><span class="elusive icon-dashboard"></span> Dashboard</a>
		</li>
		<li class="dropdown">
			<a href="##" class="dropdown-toggle" data-toggle="dropdown"><span class="elusive icon-user"></span> People <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<cfloop query="qUsergroups">
					<li><a href='#urlFor(route="admin~peopleTypes", currentGroup="#id#")#'>#groupname#</a></li>		
				</cfloop>
				<cfif checkPermission("user_save_role_admin")>
					<li class="divider"></li>
					<li><a href='#urlFor(route="admin~Category", action="rearrange", modelName="userTag")#'>Tags</a></li>										
					<li><a href='#urlFor(route="admin~Action", controller="usergroups", action="index")#'>Groups</a></li>
					<li><a href='#urlFor(route="admin~Action", controller="users", action="approval")#'>Pending Changes</a></li>
				</cfif>
			</ul>
		</li>
		
		<li><a href='#urlFor(route="admin~Action", controller="todos", action="rearrange")#'><span class="elusive icon-list-alt"></span> To-Dos</a></li>	
		<li><a href='#urlFor(route="admin~id", controller="videos", action="category", id="staff")#'><span class="elusive icon-video"></span> Videos</a></li>
                
		<cfsavecontent variable="settingsNav">							
			<a href="##" class="dropdown-toggle" data-toggle="dropdown"><span class="elusive icon-cog"></span> More <b class="caret"></b></a>
			<ul class="dropdown-menu">							
				<li><a href='#urlFor(route="admin~Action", controller="emails", action="index")#'>Emails</a></li>					
				<li><a href='#urlFor(route="admin~Action", controller="options", action="index")#'>Options</a></li>
				<li><a href='#urlFor(route="admin~Action", controller="forms", action="index")#'>Forms</a></li>
                <li><a href='#urlFor(route="public~otherPages", action="sharepics")#'>Share Pics</a></li>
				<li class="dropdown-submenu">
					<cfif checkPermission("super_admin")>
						<a href="##" class="dropdown-toggle" data-toggle="dropdown">Super Admin</a>
						<ul class="dropdown-menu">
							<li><a href='#urlFor(route="admin~index", controller="permissions")#'>Permissions</a></li>
							<li><a href='#urlFor(route="admin~Action", controller="sites", action="index")#'>Sites</a></li>
							<li><a href='#urlFor(route="admin~Action", controller="usergroups", action="index")#'>User Groups</a></li>
						</ul>		
					</cfif>	
				</li>
			</ul>								
		</cfsavecontent>
		
		<cfif checkPermission("admin_menu")>
			<li class="dropdown">
				<a href="##" class="dropdown-toggle" data-toggle="dropdown"><span class="elusive icon-th-list"></span> Content <b class="caret"></b></a>
				<ul class="dropdown-menu">
					
					<li class="dropdown-submenu">
						<a href='#urlFor(route="admin~Action", controller="pages", action="index")#'><span class="elusive icon-file-new"></span> Pages</a>
						<ul class="dropdown-menu">
							<li><a href='#urlFor(route="admin~Action", controller="pages", action="index")#'>All Pages</a></li>
							<li><a href='#urlFor(route="admin~Action", controller="pages", action="new")#'>Add New</a></li>
							<li><a href='#urlFor(
								route		= "admin~Field",
								controller	= "metafields",
								action		= "index",
								modelName	= "pagefield"
							)#'>Manage Fields</a></li>												
						</ul>
					</li>
					
					<li class="dropdown-submenu">
						<a href='#urlFor(route="admin~Action", controller="posts", action="index")#'><span class="elusive icon-pencil"></span> Posts</a>
						<ul class="dropdown-menu">
							<li><a href='#urlFor(route="admin~Action", controller="posts", action="index")#'>All Posts</a></li>
							<li><a href='#urlFor(route="admin~Action", controller="posts", action="new")#'>Add New</a></li>
						</ul>
					</li>
					
					<li class="dropdown-submenu">
						<a href='#urlFor(route="admin~Action", controller="videos", action="index")#'><span class="elusive icon-youtube"></span> Videos</a>
						<ul class="dropdown-menu">
							<li><a href='#urlFor(route="admin~Action", controller="videos", action="index")#'>All Videos</a></li>
							<li><a href='#urlFor(route="admin~Action", controller="videos", action="new")#'>Add New</a></li>											
							<li><a href='#urlFor(route="admin~Category", action="rearrange", modelName="videoCategory")#'>Categories</a></li>
						</ul>
					</li>
										
					<li><a href='#urlFor(route="admin~Action", controller="menus", action="rearrange")#'><span class="elusive icon-list"></span> Menus</a></li>
				</ul>
				<li><a href='#urlFor(route="admin~Action", controller="newsletters", action="index")#'><span class="elusive icon-envelope"></span> Newsletters</a></li>
			</li>
			
			<li class="dropdown hidden-md hidden-lg">
				#settingsNav#
			</li>
			
		</cfif>
        						
	
	</ul>
	
	<cfif checkPermission("user_save_role_admin")>
		<ul class="navbar-right nav navbar-nav hidden-xs hidden-sm" style="margin-right:10px;">
			<li></li>
			<li class="dropdown">#settingsNav#</li>
		</ul>						
	</cfif>
</cfoutput>