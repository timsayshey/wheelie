<cfscript>
	// Add Custom Menu Item
	/////////////////////////////////////////////////////////////////////////////////
	if(!isNull(adminNavMain) && !isNull(adminNavMore))
	{		
		
		
		menuitem = ArrayAppend(adminNavMain,{
			type	= 'link',
			name	= 'IT Devices',
			icon	= 'icon-list-alt',
			permission = "itdevice_full_control",
			url		= urlFor(route="admin~Action", controller="itdevices", action="index")
		});
		
		if(!isNull(adminNavMore[1].children))
		{
			menuitem = ArrayPrepend(adminNavMore[1].children,{
				type	= 'link',
				name	= 'Praise',
				permission  = "user_save_others",
				url		= urlFor(route="admin~Action", controller="praise", action="index")
			});
			menuitem = ArrayPrepend(adminNavMore[1].children,{
				type	= 'link',
				name	= 'Inquiries',
				permission  = "user_save_others",
				url		= urlFor(route="admin~Action", controller="enquiries", action="index")
			});	
			menuitem = ArrayPrepend(adminNavMore[1].children,{
				type	= 'link',
				name	= 'Job Apps',
				permission  = "user_save_others",
				url		= urlFor(route="admin~Action", controller="jobapps", action="index")
			});	
		}		
	}
</cfscript>