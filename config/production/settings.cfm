<!---
	This file is used to configure specific settings for the "production" environment.
	A variable set in this file will override the one in "config/settings.cfm".
	Example: <cfset set(errorEmailAddress="someone@somewhere.com")>
--->
<cfscript>
	/* Cache */
	// set(maximumItemsToCache=5000);
	// set(cacheCullPercentage=10);
	// set(cacheCullIntervalMinutes=5);
	// set(cacheDatePart="n");
	// set(defaultCacheTime=60 * 24);
	// set(cacheQueriesDuringRequest=true);
	// set(clearQueryCacheOnReload=true);
	// set(cachePlugins=true);

	// set(cacheDatabaseSchema=true);
	// set(cacheFileChecking=true);
	// set(cacheImages=true);
	// set(cacheModelInitialization=true);

	set(cacheControllerInitialization=true); // Must be true or you'll run into the key doesn't exist error from controller init $initControllerObject's $simpleLock
	// MAJOR!!!! NEED TO MOVE LOGIC OUT OF INITS AND CALL FROM FILTERS
	// http://joeykrabacher.blogspot.com/2015/11/cfwheels-and-controller-init-caching.html

	// set(cacheRoutes=true);
	// set(cacheActions=true);
	// set(cachePages=true);
	// set(cachePartials=true);
	// set(cacheQueries=true);
</cfscript>
