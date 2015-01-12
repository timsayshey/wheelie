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
		if (!structKeyExists(application, 'db') or isReload) 
		{
			application.db = CreateObject("component","models.services.vendor.datamgr.DataMgr").init(application.wheels.dataSourceName);		
		}
		db = application.db;
		
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
		application.fileMgr = CreateObject("component","models.services.vendor.filemgr").init(info.fileuploads,info.uploadsPath);
		
		// Setup private filemanager
		if (!structKeyExists(application, 'privatefileMgr') or isReload) {
			application.privateFileMgr = CreateObject("component","models.services.vendor.filemgr").init(info.privateroot,info.privateRootPath);
		}	
		
		// Setup pagination
		application.pagination = CreateObject("component","models.services.vendor.pagination").init();
		
		//writeDump(application.pagination); abort;
		
		// Make them accessible from local scope	
		include "/models/services/global/init/setservices.cfm";
	</cfscript>
	
	<!--- Set User Permissions --->
	<cfif isNull(application.rbs.permissionsQuery) or isReload>	
		<cfset application.rbs.permissionsQuery = db.getRecords("permissions")>
		
		<!--- Get role columns from permissions table - removed non role columns - convert array to remove list nulls - convert back to list --->
		<cfset application.rbs.roleslist = ArrayToList(ListToArray(ReplaceList(lcase(db.getDBFieldList("permissions")),lcase("ID,CREATEDBY,UPDATEDBY,UPDATEDAT,CREATEDAT,DELETEDAT,DELETEDBY"),"")))>
		
		<cfloop list="#application.rbs.roleslist#" index="thisRole">
			<cfloop query="application.rbs.permissionsQuery">
				<cfscript>
					application.rbs.permission["#id#"]["#thisRole#"]		= application.rbs.permissionsQuery["#thisRole#"];
				</cfscript>
			</cfloop>
		</cfloop>
	</cfif>
	
	<!--- Custom Overrides --->
	<cfinclude template="/models/services/global/app/app.cfm">
	
</cfoutput>

