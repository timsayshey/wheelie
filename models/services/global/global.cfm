<cfoutput>

	<!--- Globals: All values and functions are available to all parts of the app --->
	<cfscript>
		// Set app functions
		// ---------------------------------------

		// Check for reload
		isReload = false;
		if(
			!isNull(url.reload) and
			!isNull(url.password) and
			!isNull(application.wheels.reloadPassword) and
			url.password eq application.wheels.reloadPassword
		) {
			isReload = true;
		}

		// Setup Underscore.cfc
		if (!structKeyExists(application, '_') or isReload) {
			application._ = CreateObject("component","models.services.vendor.underscore").init();
		}

		// Setup Youtube.cfc
		if (!structKeyExists(application, 'yt') or isReload) {
			application.yt = CreateObject("component","models.services.vendor.youtube").init(
				devkey = application.wheels.youtubeDevKey
			);
		}

		// Setup Validateit.cfc
		if (!structKeyExists(application, 'validateit') or isReload) {
			application.validateit = CreateObject("component","models.services.vendor.validateit").init();
		}

		// Setup filemanager
		application.fileMgr = CreateObject("component","models.services.vendor.filemgr").init(info.fileuploads,info.uploadsPath);

		// Setup pagination
		application.pagination = CreateObject("component","models.services.vendor.pagination").init();

		// Make them accessible from local scope
		include "/models/services/global/init/setservices.cfm";
	</cfscript>
	
	<!--- Custom Overrides --->
	<cfinclude template="/models/services/global/app/app.cfm">

</cfoutput>
