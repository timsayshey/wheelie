<cfoutput>
	
	<!--- Globals: All values and functions are available to all parts of the app --->
	<cfscript>
		/* Globlal data */
		fileroot = "#expandPath("/")#";
		
		info.rootPath    = "/";
		info.assetsPath  = "/assets/";
		info.imagesPath  = "/assets/images/";
		info.uploadsPath = "/assets/uploads/";		
		info.videosPath  = "/assets/uploads/videos/";
		info.mediaPath   = "/assets/uploads/media/";
		
		info.fileroot    = fixFilePathSlashes("#fileroot#");
		info.fileassets  = fixFilePathSlashes("#fileroot##info.assetsPath#");
		info.fileimages  = fixFilePathSlashes("#fileroot##info.imagesPath#");
		info.fileuploads = fixFilePathSlashes("#fileroot##info.uploadsPath#");		
		info.filevideos  = fixFilePathSlashes("#fileroot##info.videosPath#");	
		info.filemedia	 = fixFilePathSlashes("#fileroot##info.mediaPath#");	
		
		// Table name reference
		tn = {
			files 			= "files"
		};
		
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
			// CHANGE THIS DEVKEY!!! ITS CONNECTED TO TIM'S ACCOUNT (For testing)
			application.yt = CreateObject("component","models.services.lib.youtube").init(
				devkey = "AI39si5Gl_pMyZrVaqGJclgsuSe9V3W5w8ZKdcO7hjqtFWQElYF92bBxo6dUfVdpNvKBHHq0dgB3as_F9UvZXfmNt_grvdsO6w"
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
	
	<!--- Script functions --->
	<cfscript>
		
		function colStruct(modelName)
		{
			return listToStruct(arrayToList(model(modelName).columns()));	
		}
		
		function listToStruct(list)
		{
			var myStruct = StructNew();
			var i = 0;
			var delimiter = ",";
			var tempList = arrayNew(1);
			if (ArrayLen(arguments) gt 1) {delimiter = arguments[2];}
			
			tempList = listToArray(list, delimiter);
			
			for (i=1; i LTE ArrayLen(tempList); i=i+1)
			{
				   if (not structkeyexists(myStruct, trim(ListFirst(tempList[i], "=")))) 
				   {
						   StructInsert(myStruct, trim(ListFirst(tempList[i], "=")), "");
				   }
			}
			return myStruct;
		}
		
	</cfscript>
	
	<!--- Tag functions --->	
	<cffunction name="queryOfQueries" output="no">
		<cfargument name="query" type="string">
		<cfargument name="where" type="string" default="">
		<cfargument name="select" type="string" default="*">
		<cfargument name="order" type="string" default="">
		
		<cfquery dbtype="query" name="qQuery">
			SELECT #arguments.select# FROM #arguments.query# 
			<cfif len(arguments.where)>WHERE #Replace(arguments.where,'"',"'","ALL")#</cfif>
			<cfif len(arguments.order)>ORDER BY #arguments.order#</cfif>
		</cfquery>
		
		<cfreturn qQuery>
	</cffunction>
	
	<cffunction name="paramThis" output="no">
		<cfargument name="varString">
		
		<cfif isDefined(varString)>
			<cfreturn Evaluate(varString)>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="formatOptionName" output="no">
		<cfargument name="dirtystring">
		
		<cfscript>
			cleanstring = replace(dirtystring,"_"," ","ALL");			
			cleanstring = capitalize(lcase(cleanstring));
		</cfscript>
		
		<cfreturn cleanstring>
	</cffunction>
	
	<cffunction name="listSearch" output="no">
		<cfargument name="list">
		<cfargument name="substring">
		<cfargument name="substring2">
		
		<cfloop list="#arguments.list#" index="listitem">
			<cfif Find(arguments.substring, listitem) AND Find(arguments.substring2, listitem)>
				<cfreturn listitem>
			</cfif>
		</cfloop>
		
		<cfreturn "">
	</cffunction>
	
	<cffunction name="fixFilePathSlashes" output="no">		
		<cfargument name="dirtystring">
		
		<cfscript>
			cleanstring = replace(dirtystring,"\/","\","ALL");	
			cleanstring = replace(cleanstring,"\\","\","ALL");	
			cleanstring = replace(cleanstring,"//","\","ALL");	
			cleanstring = replace(cleanstring,"/","\","ALL");	
		</cfscript>
		
		<cfreturn cleanstring>
	</cffunction>
	
	<cffunction name="bytesToMegabytes" output="no">		
		<cfargument name="byteInput">
		
		<cfscript>
			convertedOutput = byteInput;
			if(isNumeric(convertedOutput))
			{
				convertedOutput = convertedOutput / 1024 / 1024;
				convertedOutput = NumberFormat( convertedOutput, "0.00" );
			}
		</cfscript>
		
		<cfreturn convertedOutput>
	</cffunction>
	
	<cffunction name="arrayToUL"  output="no">
		<cfargument name="inArray" type="array">
		
		<cfsavecontent variable="convertedArray">
			<cfloop array="#arguments.inArray#" index="item">
				<li>#item#</li>
			</cfloop>
		</cfsavecontent>
		
		<cfreturn convertedArray>
	</cffunction>
	
	<cffunction name="paramVal"  output="no">
		<cfargument name="varString" type="string">
		<cfargument name="varVariable">
		
		<cfreturn event.getValue(varString,paramThis(varVariable))>
	</cffunction>
	
	<cffunction name="removehtml" output="no">
		<cfargument name="dirtystring">
		<cfreturn REReplace(dirtystring,'<[^>]*>','','all')>
	</cffunction>
	
	<!--- Cleans strings of html and special chars --->
	<cffunction name="sanitize" output="no">
		<cfargument name="dirtystring">
		
		<cfset sanitized = removehtml(dirtystring)>
		<cfset sanitized = REReplace(sanitized,"[^0-9A-Za-z ]","","all")>
		<cfreturn sanitized>
	</cffunction>
	
	<cffunction name="cleanseFilename" output="no">
		<cfargument name="dirtystring">
		
		<cfscript>
			cleanstring = REReplace(dirtystring,"[^0-9A-Za-z ]","","all");
			cleanstring = replace(cleanstring," ","_","ALL");	
		</cfscript>
		
		<cfreturn trim(cleanstring)>
	</cffunction>
	
	<cffunction name="cleanUrlId" output="no">
		<cfargument name="dirtystring">
		
		<cfscript>
			cleanstring = removehtml(dirtystring);
			cleanstring = REReplace(cleanstring,"[^0-9A-Za-z -]","","all");
			cleanstring = replace(trim(cleanstring)," ","-","ALL");	
		</cfscript>
		
		<cfreturn trim(cleanstring)>
	</cffunction>
	
	<cffunction name="logEntry" output="no">
		<cfargument name="subject" default="WebPanel Error">
		<cfargument name="varDump1" default="">
		<cfargument name="varDump2" default="">
		<cfargument name="varDump3" default="">
		
		<cfsavecontent variable="errorInfo">
			<cfoutput>
				<br><br>
				<h1>#subject# - #now()#</h1>
				<cfdump var="#varDump1#">
				<cfdump var="#varDump2#">
				<cfdump var="#varDump3#">
			</cfoutput>
		</cfsavecontent>
		
		<cfset cleantime = REReplace(now(),"[^0-9 ]","","all")>
		
		<cffile action = "append" file = "#expandPath('\errors\')##cleantime#-log-#subject#.html" attributes = normal output = "#errorInfo#">
		
		<!--- <cfmail from="timbadolato@gmail.com" to="tim@dreamstonemedia.com" subject="#subject#" type="html">
			#errorInfo#
		</cfmail> --->
	</cffunction>
	
	<cffunction name="getOption" output="no">
		<cfargument name="optionQuery">
		<cfargument name="optionId">
		
		<cfset var loc = {}>
		
		<cfquery name="loc.getOption" dbtype="query">
			SELECT * FROM arguments.optionQuery
			WHERE id = '#arguments.optionId#'
		</cfquery>
		
		<cfreturn loc.getOption>
	</cffunction>
	<cfinclude template="admin/defaults.cfm">
	<cfinclude template="admin/users.cfm">
	<cfinclude template="admin/plupload.cfm">
	<cfinclude template="admin/meta.cfm">
	<cfinclude template="admin/shared.cfm">
	<cfinclude template="shared/shared.cfm">
	
	<cfset setPermissions()>	
	
</cfoutput>