<cfinclude template="/models/services/global/settings.cfm">
<cfscript>
	
	set(sendEmailOnError=true);	
	
	if(application.wheels.isBeta)
	{
		/* Beta Settings */		
		set(environment="design");
		
		/* Cache */	
		set(cacheQueriesDuringRequest=false);
		set(clearQueryCacheOnReload=true);
		set(cachePlugins=false);		
		set(cacheDatabaseSchema=false);
		set(cacheFileChecking=false); 
		set(cacheImages=false);
		set(cacheModelInitialization=false);
		set(cacheControllerInitialization=false);
		set(cacheRoutes=false);
		set(cacheActions=false);
		set(cachePages=false);
		set(cachePartials=false);
		set(cacheQueries=false);		
	
	} else {
		
		/* Live Settings */			 
		set(environment="production");
		
		/* Cache */
		set(maximumItemsToCache=5000);
		set(cacheCullPercentage=10); 
		set(cacheCullIntervalMinutes=5);
		set(cacheDatePart="n");
		set(defaultCacheTime=60 * 24);
		set(cacheQueriesDuringRequest=true);
		set(clearQueryCacheOnReload=true);
		set(cachePlugins=true);
		
		set(cacheDatabaseSchema=true); 
		set(cacheFileChecking=true);
		set(cacheImages=true);
		set(cacheModelInitialization=true);
		set(cacheControllerInitialization=true);
		set(cacheRoutes=true);
		set(cacheActions=true);
		set(cachePages=true);
		set(cachePartials=true);
		set(cacheQueries=true);		
	
	}
	set(errorEmailAddress=application.wheels.adminFromEmail);	
	set(errorEmailFromAddress=application.wheels.adminFromEmail);	
	set(errorEmailToAddress=application.wheels.adminEmail);	
	
</cfscript>
