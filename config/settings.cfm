<cfscript>
	// Settings
	set(passwordSalt			= "LKjx1/Yp+xy28SlcEh4EUQ==");	// AES HEX Key // passcrypt(type="generateKey");
	set(errorEmailAddress		= "changethis@wheelie.com");
	//set(reloadPassword		= "changethis");	
	set(dataSourceName			= "remotetest");
	set(URLRewriting			= "On");
	
	// Moved css/js to assets folder
	set(stylesheetPath			= "assets");
	set(javascriptPath			= "assets");	
	set(assetQueryString		= false); // If true, Prevents browser from caching js/css assets
	
	// Allows us to handle plugins manually, no autozip blackmagic	
	set(deletePluginDirectories	= false);
	set(overwritePlugins		= false);
	set(cachePlugins 			= false);
	
	//list all modules (use relative path, if you have differences between servers)
	//application.multimodule.modulePaths="/admin";

</cfscript>