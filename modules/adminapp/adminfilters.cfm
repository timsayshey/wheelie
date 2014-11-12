<cfscript>
	// Custom App Filters Here - These run on every admin controller request
	// If you need to run on application start or on request, edit /models/services/global/app/app.cfm
	/////////////////////////////////////////////////////////////////////////////////
	
	// Set Custom Info
	/////////////////////////////////////////////////////////////////////////////////
	// application.info.validCategoryModelsList = "itemcategory"; // lowercase
	// application.info.serverIp = "";
	
	// Add Custom Menu Item
	/////////////////////////////////////////////////////////////////////////////////
	/* 
		menuitem = arrayAppend(adminNavMain,
		{
			type	   = 'parent',
			name	   = 'Items',
			icon	   = 'icon-pencil',
			permission = 'item_save',
			url		   = urlFor(route="admin~Action", controller="items", action="index"),
			children   = [
				{
					type	   = 'link',
					name	   = 'All Items',
					url		   = urlFor(route="admin~Action", controller="items", action="index")
				},
				{
					type	   = 'link',
					name	   = 'Add New',
					url		   = urlFor(route="admin~Action", controller="items", action="new")
				},
				{
					type	   = 'link',
					name	   = 'Categories',
					url		   = urlFor(route="admin~Category", action="rearrange", modelName="itemCategory")
				}
			]
		});
		
		if(!isNull(adminNavMore[1].children))
		{
			menuitem = ArrayPrepend(adminNavMore[1].children,{
				type	   = 'link',
				name	   = 'All Items',
				url	   = urlFor(route="admin~Action", controller="items", action="index")
			});	
		}
	*/
	
</cfscript>