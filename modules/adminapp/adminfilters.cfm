<cfscript>
	// Custom App Filters Here - These run on every admin controller request
	/////////////////////////////////////////////////////////////////////////////////
	
	// Set Custom Info
	/////////////////////////////////////////////////////////////////////////////////
	// application.info.validCategoryModelsList = "itemcategory"; // lowercase
	// application.info.serverIp = "";
	
	// Add Custom Menu Item
	/////////////////////////////////////////////////////////////////////////////////
	/* menuitem = arrayAppend(adminNavMain,
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
	}); */
	
</cfscript>