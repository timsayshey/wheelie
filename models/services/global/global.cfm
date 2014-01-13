<cfoutput>
	
	<!--- Globals: All values and functions are available to all parts of the app --->
	<cfscript>
		// Set app functions
		// ---------------------------------------
		
		// Setup DataMgr
		if (!structKeyExists(application, 'db') or !isNull(url.reload)) {
			application.db = CreateObject("component","models.services.datamgr.DataMgr").init(application.wheels.dataSourceName);		
		}
		
		// Setup Underscore.cfc
		if (!structKeyExists(application, '_') or !isNull(url.reload)) {
			application._ = CreateObject("component","models.services.lib.underscore").init();
		}
		
		// Setup Youtube.cfc
		if (!structKeyExists(application, 'yt') or !isNull(url.reload)) {			
			application.yt = CreateObject("component","models.services.lib.youtube").init(
				devkey = application.wheels.youtubeDevKey
			);		
		}
		
		// Setup Validateit.cfc
		if (!structKeyExists(application, 'validateit') or !isNull(url.reload)) {
			application.validateit = CreateObject("component","models.services.lib.validateit").init();	
		}
		
		// Setup VideoConverter
		if (!structKeyExists(application, 'videoConverter') or !isNull(url.reload)) {
			videoFileMgr = CreateObject("component","models.services.videoconverter.FileMgr").init(info.fileuploads,"/assets/uploads/");
			application.videoConverter = CreateObject("component","models.services.videoconverter.VideoConverter").init(videoFileMgr);
		}	
		
		// Setup filemanager
		if (!structKeyExists(application, 'fileMgr') or !isNull(url.reload)) {
			application.fileMgr = CreateObject("component","models.services.lib.filemgr").init(info.fileuploads,"/assets/uploads/");
		}	
		
		// Setup pagination
		if (!structKeyExists(application, 'pagination') or !isNull(url.reload)) {
			application.pagination = CreateObject("component","models.services.lib.pagination").init();
		}
		
		// Make them accessible from local scope	
		validate		= application.validateit;
		videoconverter	= application.videoConverter;
		db 				= application.db;
		youtube			= application.yt;
		_				= application._;
		fileMgr			= application.fileMgr;
		pagination 		= application.pagination;
	</cfscript>
	
	<!--- Set User Permissions --->
	<cfif isNull(application.rbs.permissionsQuery) or !isNull(url.reload)>
	
		<cfset application.rbs.permissionsQuery = db.getRecords("Permissions")>
		<cfloop query="application.rbs.permissionsQuery">
			<cfscript>
				application.rbs.permission["#id#"]				= {};
				application.rbs.permission["#id#"]["admin"]		= admin;
				application.rbs.permission["#id#"]["editor"]	= editor;
				application.rbs.permission["#id#"]["author"]	= author;
				application.rbs.permission["#id#"]["user"]		= user;
				application.rbs.permission["#id#"]["guest"]		= guest;	
				
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

