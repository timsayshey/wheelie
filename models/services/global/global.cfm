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
		)
		{
			isReload = true;
		}
		
		// Setup DataMgr
		datamgrInit();
		
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
		
		/* Setup VideoConverter 
		if (!structKeyExists(application, 'videoConverter') or isReload) {
			videoFileMgr = CreateObject("component","models.services.vendor.videoconverter.FileMgr").init(info.fileuploads,info.uploadsPath);
			application.videoConverter = CreateObject("component","models.services.vendor.videoconverter.VideoConverter").init(videoFileMgr);
		}*/	
		
		// Setup filemanager
		if (!structKeyExists(application, 'fileMgr') or isReload) {
			
			
		}	
		
		application.fileMgr = CreateObject("component","models.services.vendor.filemgr").init(info.fileuploads,info.uploadsPath);
		
		// Setup filemanager
		if (!structKeyExists(application, 'privatefileMgr') or isReload) {
			application.privateFileMgr = CreateObject("component","models.services.vendor.filemgr").init(info.privateroot,info.privateRootPath);
		}	
		
		// Setup pagination
		if (!structKeyExists(application, 'pagination') or isReload) {
			application.pagination = CreateObject("component","models.services.vendor.pagination").init();
		}
		
		//writeDump(application.pagination); abort;
		
		// Make them accessible from local scope	
		validate		= application.validateit;
		//videoconverter	= application.videoConverter;
		db 				= application.db;
		youtube			= application.yt;
		_				= application._;
		fileMgr			= application.fileMgr;
		privateFileMgr	= application.privateFileMgr;
		pagination 		= application.pagination;
	</cfscript>
	
	<!--- Set User Permissions --->
	<cfif isNull(application.rbs.permissionsQuery) or isReload>
	
		<cfset application.rbs.permissionsQuery = db.getRecords("permissions")>
		<cfloop query="application.rbs.permissionsQuery">
			<cfscript>				
				application.rbs.permission["#id#"]["superuser"]		= superuser;
				application.rbs.permission["#id#"]["admin"]			= admin;
				application.rbs.permission["#id#"]["editor"]		= editor;
				application.rbs.permission["#id#"]["user"]			= user;
				application.rbs.permission["#id#"]["guest"]			= guest;
				
				/* For railo
				application.rbs.permission["#id#"]["admin"]		= application.rbs.permissionsQuery["admin"];
				application.rbs.permission["#id#"]["editor"]	= application.rbs.permissionsQuery["editor"];
				application.rbs.permission["#id#"]["author"]	= application.rbs.permissionsQuery["author"];
				application.rbs.permission["#id#"]["user"]		= application.rbs.permissionsQuery["user"];
				application.rbs.permission["#id#"]["guest"]		= application.rbs.permissionsQuery["guest"];		
				*/	
			</cfscript>
		</cfloop>
	</cfif>
	
</cfoutput>

