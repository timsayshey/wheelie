<cfscript>
	// Settings
	set(passwordSalt			= "LKjx1/Yp+xy28SlcEh4EUQ==");	// AES HEX Key // passcrypt(type="generateKey");
	set(errorEmailAddress		= "changethis@wheelie.com");
	
	set(youtubeDevKey			= "AI39si5Gl_pMyZrVaqGJclgsuSe9V3W5w8ZKdcO7hjqtFWQElYF92bBxo6dUfVdpNvKBHHq0dgB3as_F9UvZXfmNt_grvdsO6w"); // CHANGE THIS DEVKEY!!! ITS CONNECTED TO TIM'S ACCOUNT (For testing)
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