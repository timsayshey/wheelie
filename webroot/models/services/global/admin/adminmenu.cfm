<cfscript>	

	function adminMenuDefaults()
	{
		/*
			Type:
			divider
			link 		- just a link
			parent 		- has children 	- no link
			subparent 	- has children 	- link
			
			Permission:
			Minimum permission to see menu item, if not set will default to all
			
			Icon
		*/
		var qUsergroups = model("Usergroup").findAll();
		adminNavMain = [];
		adminNavMore = [];
		
		// menu item
		menuitem = arrayAppend(adminNavMain,{
			type	= 'link',
			name	= 'Dashboard',
			icon	= 'fa-dashboard',
			url		= urlFor(route="admin~Action", controller="main", action="home")
		});
		
		menuitem = adminNavMain.addAll([
				{
					type	   = 'parent',
					name	   = 'Pages',
					icon	   = 'fa-edit',
					permission = 'page_save',
					url		   = urlFor(route="admin~Action", controller="Pages", action="index"),
					children   = [
						{
							type	   = 'link',
							name	   = 'All Pages',
							url		   = urlFor(route="admin~Action", controller="Pages", action="index")
						},
						{
							type	   = 'link',
							name	   = 'Add New',
							url		   = urlFor(route="admin~Action", controller="Pages", action="new")
						},
						{
							type	   = 'link',
							name	   = 'Page Blocks',
							permission = 'page_save',
							url		   = urlFor(route="admin~Action", controller="pageblocks", action="index")
						}
					]
				}
				,{
					type	   = 'link',
					name	   = 'Blog',
					icon	   = 'fa-pencil',
					permission = 'post_save',
					url		   = urlFor(route="admin~Action", controller="posts", action="index")
				}
				,{
					type	   = 'parent',
					name	   = 'Videos',
					icon	   = 'fa-youtube-play',
					permission = 'video_save',
					url		   = urlFor(route="admin~Action", controller="videos", action="index"),
					children   = [
						{
							type	   = 'link',
							name	   = 'All Videos',
							url		   = urlFor(route="admin~Action", controller="videos", action="index")
						},
						{
							type	   = 'link',
							name	   = 'Add New',
							url		   = urlFor(route="admin~Action", controller="videos", action="new")
						},
						{
							type	   = 'link',
							name	   = 'Categories',
							url		   = urlFor(route="admin~Category", action="rearrange", modelName="videoCategory")
						}
					]
				}
				,{
					type	   = 'link',
					name	   = 'Site Menu',
					icon	   = 'fa-align-justify',
					permission = 'menu_save',
					url		   = urlFor(route="admin~Action", controller="menus", action="rearrange")
				}
		]);	
		
		// Create Children for People Menu
		usergroupLinks = [];
		for(usergroup in qUsergroups)
		{
			ArrayAppend(usergroupLinks,{
				type	= 'link',
				name	= pluralize(usergroup.groupname),
				url		= urlFor(route="admin~peopleTypes", currentGroup=usergroup.id)
			});
		}
		
		arrayAppend(usergroupLinks,[
		], true);
		
		peopleLinks = usergroupLinks;
		
		// menu item
		menuitem = arrayAppend(adminNavMain,{
			type	= 'parent',
			name	= 'Users',
			permission = 'page_save',
			icon	= 'fa-user',
			children= peopleLinks
		});		
		
		// adminNavMore
		menuitem = arrayAppend(adminNavMore,{
			type	= 'parent',
			name	= 'Advanced',
			icon	= 'fa-cog',
			permission= 'form_save_others',
			children= 
			[				
				{
					type	   = 'link',
					name	   = 'Permissions',
					url		   = urlFor(route="admin~index", controller="permissions")
				},
				{
					type	   = 'link',
					name	   = 'Sites',
					url		   = urlFor(route="admin~Action", controller="sites", action="index")
				},
				{
					type	   = 'link',
					// icon	   = 'fa-comment',
					name	   = 'Forms',
					url		   = urlFor(route="admin~Action", controller="forms", action="index"),
					permission  = "form_save_others"		
				}	
				,{
					type	   = 'link',
					name	   = 'Newsletters',
					// icon	   = 'fa-envelope',
					permission = 'newsletter_save',
					url		   = urlFor(route="admin~Action", controller="newsletters", action="index")
				},
				{
					type	= 'link',
					// name	= 'To-Dos',
					icon	= 'fa-list-alt',
					url		= urlFor(route="admin~Action", controller="todos", action="rearrange")
				},
				{
					type	   = 'link',
					name	   = 'User Tags',
					url		   = urlFor(route="admin~Category", action="rearrange", modelName="userTag"),
					permission = "user_save_others"
				},
				{
					type	   = 'link',
					name	   = 'User Groups',
					url		   = urlFor(route="admin~Action", controller="usergroups", action="index"),
					permission = "user_save_others"
				}
			]
		});	
	
	}
	function formatAdminMenuItem(currMenuItem,parentClass="")
	{
		itemreturn = '';
		menuitempermission = true;
		
		if(!isNull(currMenuItem.permission))
		{
			menuitempermission = checkPermission(currMenuItem.permission);
		}		
		
		if(!isNull(currMenuItem.type) AND menuitempermission)
		{
			itemicon = '';
			if(!isNull(currMenuItem.icon)) { itemicon = '<span class="fa #currMenuItem.icon#"></span> '; }
			
			if(currMenuItem.type eq 'link' and !isNull(currMenuItem.name) and !isNull(currMenuItem.url))
			{
				itemreturn = itemreturn & '<li><a href="#currMenuItem.url#">#itemicon##currMenuItem.name#</a></li>';
				
			} else if(currMenuItem.type eq 'divider') {
			
				itemreturn = itemreturn & '<li class="divider"></li>';
				
			} else if(currMenuItem.type eq 'parent' and !isNull(currMenuItem.name) and !isNull(currMenuItem.children)) {
				
				itemreturn = itemreturn & '<li class="dropdown #parentClass#">
				<a href="##" class="dropdown-toggle dropdown-toggle" data-toggle="dropdown">#itemicon##currMenuItem.name# <span class="fa fa-caret-down"></span></a>
				<ul class="dropdown-menu dropdown-menu">';
				
				for(childitem in currMenuItem.children)
				{
					itemreturn = itemreturn & formatAdminMenuItem(childitem);
				}
				itemreturn = itemreturn & '</ul></li>';
				
			} else if(currMenuItem.type eq 'subparent' and !isNull(currMenuItem.name) and !isNull(currMenuItem.url) and !isNull(currMenuItem.children)) {					
								
				itemreturn = itemreturn & '<li class="dropdown-submenu #parentClass#">';
				itemreturn = itemreturn & '<a href="#currMenuItem.url#" class="dropdown-toggle dropdown-toggle" data-toggle="dropdown">#itemicon##currMenuItem.name#  <span class="fa fa-caret-right"></span></a>
				<ul class="dropdown-menu dropdown-menu">';
				
				for(childitem in currMenuItem.children)
				{
					itemreturn = itemreturn & formatAdminMenuItem(childitem);
				}
				itemreturn = itemreturn & '</ul></li>';	
			}
		}
		
		return itemreturn;
	}
	
	function renderAdminMenu(menuArray,parentClass="")
	{
		menureturn = "";
		
		for(curritem in menuArray)

		{
			menureturn = menureturn & formatAdminMenuItem(currMenuItem=curritem,parentClass=parentClass);
		}
		
		return menureturn;
	}
		
</cfscript>