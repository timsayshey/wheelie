<cfscript>

	// Moved css/js to assets folder
	set(dataSourceName			= application.wheels.dataSourceName);
	set(stylesheetPath			= "assets");
	set(javascriptPath			= "assets");	
	set(assetQueryString		= false); // If true, Prevents browser from caching js/css assets
	set(clearServerCacheOnReload= true); // Disabled for now due to 1.3.1 issue with Reload
	set(URLRewriting			= true);
	
	// Allows us to handle plugins manually, no autozip blackmagic	
	set(deletePluginDirectories	= false);
	set(overwritePlugins		= false);
	
	//list all modules (use relative path, if you have differences between servers)
	//application.multimodule.modulePaths="/admin";

</cfscript>