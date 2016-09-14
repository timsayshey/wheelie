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

		// if (!structKeyExists(application, 'markdown') or isReload) {
		
		// 	// Directory containing all the necessary jar files.
		// 	jarDir = expandPath("/models/services/vendor/cfmarkdown");

		// 	// Array of necessary classes
		// 	jClass = [
	 //        "#jarDir#/parboiled-java-1.1.3.jar"
	 //        ,"#jarDir#/asm-all-4.1.jar"
	 //        ,"#jarDir#/parboiled-core-1.1.3.jar"
	 //        ,"#jarDir#/pegdown-1.2.1.jar"
	 //        ];
		// 	javaloader = createObject('component','models.services.vendor.javaloader.JavaLoader').init(jClass, false);

		// 	// Hex values for different extensions can be found in org.pegdown.Extensions.java (0x20 is for tables support)

		// 	// Output the HTML conversion --->
		// 	//<cfoutput>#variables.pegdown.markdownToHtml(markdownString)#</cfoutput>
		// 	application.markdown = javaloader.create("org.pegdown.PegDownProcessor").init(javaCast("int", InputBaseN("0x20", 16)));;
		// } 
		// markdown = application.markdown;

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
		// if (!structKeyExists(application, 'privatefileMgr') or isReload) {
		// 	application.privateFileMgr = CreateObject("component","models.services.vendor.filemgr").init(info.privateroot,info.privateRootPath);
		// }	
		
		// Setup pagination
		application.pagination = CreateObject("component","models.services.vendor.pagination").init();
		
		//writeDump(application.pagination); abort;
		
		// Make them accessible from local scope	
		include "/models/services/global/init/setservices.cfm";
	</cfscript>
	
	<!--- Set User Permissions --->
	<cfif isNull(application.rbs.permissionsQuery) or isReload>	
		<cfscript>
			q = new query( datasource="wheelie" );
	        q.addParam( name="lastModifiedTime", cfsqltype="cf_sql_timestamp", value=now());
	        application.rbs.permissionsQuery = q.execute( sql="SELECT * FROM permissions" ).getResult();
		</cfscript>
		
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

