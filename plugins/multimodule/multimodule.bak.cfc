<cfcomponent output="false" displayname="Multi Module">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfset this.version = "1.1.8" />		
		<cfset $buildModulesCache()>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="doCheckAllModules" returntype="string">	
		<!--- 
			True: Check all module folders no matter what
			False: If [module] is defined in params then only check its models, views, etc no matter what
		--->
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getModuleFromUrl" returntype="string">		
		<cfset var loc = StructNew()>
		<cfparam name="request.module" default="">
		<cfscript>			
			if(!len(request.module))
			{			
				if(!structKeyExists(variables,"params") && isDefined("core.$paramParser"))
				{
					loc.params = core.$paramParser();
					
				} else if (structKeyExists(variables,"params")) {
					loc.params = params;
					
				} else {
					loc.params = {};
				}
					
				// Check to see if module param was found
				if(structKeyExists(loc.params,"module")) {
					request.module = loc.params.module;
				}
				// Else check route name for module (before ~)
				else if(StructKeyExists(loc.params,"route") && find("~",loc.params.route))
				{
					request.module = ListFirst(loc.params.route,"~");
				}				
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="$generateIncludeTemplatePath" returntype="string" access="public" output="false" mixin="controller">
		<cfargument name="$name" type="any" required="true">
		<cfargument name="$type" type="any" required="true">
		<cfargument name="$controllerName" type="string" required="false" default="#variables.params.controller#" />
		<cfargument name="$baseTemplatePath" type="string" required="false" default="#application.wheels.viewPath#" />
		<cfargument name="$prependWithUnderscore" type="boolean" required="false" default="true">
		<cfscript>
			var loc = StructNew();
			loc.include = arguments.$baseTemplatePath;
			loc.fileName = ReplaceNoCase(Reverse(ListFirst(Reverse(arguments.$name), "/")), ".cfm", "", "all") & ".cfm"; // extracts the file part of the path and replace ending ".cfm"
			if (arguments.$type == "partial" && arguments.$prependWithUnderscore)
				loc.fileName = Replace("_" & loc.fileName, "__", "_", "one"); // replaces leading "_" when the file is a partial
			loc.folderName = Reverse(ListRest(Reverse(arguments.$name), "/"));
			if (Left(arguments.$name, 1) == "/")
				loc.include = loc.include & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder to views
			else if (arguments.$name Contains "/")
				loc.include = loc.include & "/" & arguments.$controllerName & "/" & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder of the current controller
			else
				loc.include = loc.include & "/" & arguments.$controllerName & "/" & loc.fileName; // Include a file in the current controller's view folder
			if (!FileExists(ExpandPath(LCase(loc.include)))) loc.include = $findInModules(loc.include);
		</cfscript>
		<cfreturn LCase(loc.include) />
	</cffunction>
	
	<cffunction name="$findInModules" returntype="string">
		<cfargument name="baseInclude" type="string">
		<cfscript>
			var loc = StructNew();
			loc.modules = $modules();
			
			// Override module name via URL
			if(len(getModuleFromUrl())) { 
				loc.result = getModuleFromUrl() & "/" & baseInclude;
				if (FileExists(ExpandPath(LCase(loc.result)))) return loc.result;		
			}
			
			// Not in url? Go look through modules folder
			if (doCheckAllModules()) {
				
				for (loc.i = 1; loc.i <= ArrayLen(loc.modules); loc.i ++) {
					loc.result = loc.modules[loc.i] & "/" & baseInclude;
					if (FileExists(ExpandPath(LCase(loc.result)))) return loc.result;
				}
			
			}
			return baseInclude;
		</cfscript>
	</cffunction>

	<cffunction name="$modules" returntype="array">
		<cfscript>
			if (IsDefined("application.multimodule.modulesCache")) return application.multimodule.modulesCache;
			return $buildModulesCache();
		</cfscript>
	</cffunction>

	<cffunction name="$buildModulesCache" returntype="array">
		<cfscript>
			var loc = StructNew();
			if (IsDefined("application.multimodule.modulePaths")) {
				application.multimodule.modulesCache = listToArray(application.multimodule.modulePaths);
				return application.multimodule.modulesCache;
			}
		 	loc.modulesPath = getDirectoryFromPath(getBaseTemplatePath()) & '/modules';
		</cfscript>
		<cfdirectory action="list" directory="#loc.modulesPath#" type="dir" name="loc.q">
		<cfquery name="loc.q" dbtype="query">
		select name from loc.q where name not like '.%' 
		</cfquery>
		<cfscript>
			loc.results = ArrayNew( 1 );
			for (loc.i = 1 ; loc.i LTE loc.q.RecordCount ; loc.i ++){
				ArrayAppend( loc.results, 'modules/' & loc.q["name"][loc.i]);
			}
			application.multimodule.modulesCache = loc.results;
			return( loc.results );
		</cfscript>
	</cffunction>

	<cffunction name="$createControllerClass" returntype="any" access="public" output="false" mixin="global">
		<cfargument name="name" type="string" required="true">
		<cfargument name="controllerPaths" type="string" required="false" default="#application.wheels.controllerPath#">
		<cfargument name="type" type="string" required="false" default="controller" />
		<cfscript>
			var loc = StructNew();
			loc.args = duplicate(arguments);
			loc.basePath = arguments.controllerPaths;
			loc.modules = $modules();
			
			// Override module name via URL
			if(len(getModuleFromUrl())) { 
				loc.result = getModuleFromUrl() & "/" & loc.basePath;
				if (FileExists(ExpandPath("#loc.result#/#name#.cfc"))) {
					loc.args.controllerPaths = loc.result;					
				}
			}
			
			// Not in url? Go look through modules folder
			if (doCheckAllModules()) {
				for (loc.i = 1; loc.i <= ArrayLen(loc.modules); loc.i ++) {
					loc.result = loc.modules[loc.i] & "/" & loc.basePath;
					if (FileExists(ExpandPath("#loc.result#/#name#.cfc"))) {
						loc.args.controllerPaths = loc.result;
						break;
					}
				}
			}
			
			
			return core.$createControllerClass(loc.args.name,loc.args.controllerPaths,loc.args.type);
		</cfscript>
	</cffunction>

	<cffunction name="$createModelClass" returntype="any" access="public" mixin="global">
		<cfargument name="name" type="string" required="true">
		<cfargument name="modelPaths" type="string" required="false" default="#application.wheels.modelPath#">
		<cfargument name="type" type="string" required="false" default="model" />
		<cfscript>
			var loc = StructNew();
			loc.args = duplicate(arguments);
			loc.basePath = arguments.modelPaths;
			loc.modules = $modules();
			loc.results = arguments.modelPaths;
			
			// Go look through modules folder
			if (doCheckAllModules()) {
				for (loc.i = 1; loc.i <= ArrayLen(loc.modules); loc.i ++) {
					loc.result = loc.modules[loc.i] & "/" & loc.basePath;
					if (DirectoryExists(ExpandPath(loc.result))) {
						loc.results = loc.results & ",";
						loc.results = loc.results & loc.result;
					}
				}
			}
			
			// Override module name via URL
			if(len(getModuleFromUrl())) { 
				loc.result = getModuleFromUrl() & "/" & loc.basePath;
				if (DirectoryExists(ExpandPath(loc.result))) {
					loc.results = loc.results & ",";
					loc.results = loc.results & loc.result;
				}
			}
			
			loc.args.modelPaths = loc.results;
			return core.$createModelClass(loc.args.name,loc.args.modelPaths,loc.args.type);
		</cfscript>
	</cffunction>

	<cffunction name="$initControllerObject" returntype="any" access="public" output="false" mixin="controller">
		<cfargument name="name" type="string" required="true">
		<cfargument name="params" type="struct" required="true">
		<cfscript>
			var loc = {};
			loc.template = "#application.wheels.viewPath#/#LCase(arguments.name)#/helpers.cfm";
			if (! FileExists(ExpandPath(loc.template))) {
				if(len(getModuleFromUrl())) { 
					loc.result = getModuleFromUrl()
					loc.template = "#getModuleFromUrl()#/#application.wheels.viewPath#/#LCase(arguments.name)#/helpers.cfm";
					if (FileExists(ExpandPath(loc.template))) break;
				} else if (doCheckAllModules()) {
					loc.modules = $modules();
					for (loc.i = 1; loc.i <= ArrayLen(loc.modules); loc.i ++) {
						loc.template = "#loc.modules[loc.i]#/#application.wheels.viewPath#/#LCase(arguments.name)#/helpers.cfm";
						if (FileExists(ExpandPath(loc.template))) break;
					}
				}
			}
	
			// create a struct for storing request specific data
			variables.$instance = {};
			variables.$instance.contentFor = {};
	
			// include controller specific helper files if they exist, cache the file check for performance reasons
			loc.helperFileExists = false;
			if (!ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingHelperFiles, arguments.name))
			{
				if (FileExists(ExpandPath(loc.template)))
					loc.helperFileExists = true;
				if (application.wheels.cacheFileChecking)
				{
					if (loc.helperFileExists)
						application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
					else
						application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
				}
			}
			if (ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) || loc.helperFileExists)
				$include(template=loc.template);
	
			loc.executeArgs = {};
			loc.executeArgs.name = arguments.name;
			$simpleLock(name="controllerLock", type="readonly", execute="$setControllerClassData", executeArgs=loc.executeArgs);
	
			variables.params = arguments.params;
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="$abortInvalidRequest" returntype="void" access="public" output="false" mixin="global">
		<cfscript>
			var applicationPath = Replace(GetCurrentTemplatePath(), "\", "/", "all");
			var callingPath = Replace(GetBaseTemplatePath(), "\", "/", "all");
		</cfscript>
		<cfif FileExists(cgi.path_translated)>
		<cfinclude template="#cgi.script_name#">
		<cfreturn>
		</cfif>
		<cfscript>
			if (ListLen(callingPath, "/") GT ListLen(applicationPath, "/") || GetFileFromPath(callingPath) == "root.cfm")
			{
				$header(statusCode="404", statusText="Not Found");
				$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
				$abort();
			}
		</cfscript>
	</cffunction>

	<cffunction name="$include" returntype="void" access="public" output="false" mixin="global">
		<cfargument name="template" type="string" required="true">
		<cfset var loc = {}>
		<cfif template.startsWith("/")>
			<cfinclude template="#LCase(arguments.template)#">
		<cfelse>
			<cfinclude template="../../#LCase(arguments.template)#">
		</cfif>
	</cffunction>

	<cffunction name="$includeAndReturnOutput" returntype="string" access="public" output="false" mixin="global">
		<cfargument name="$template" type="string" required="true">
		<cfset var loc = {}>
		<cfif StructKeyExists(arguments, "$type") AND arguments.$type IS "partial">
			<!--- make it so the developer can reference passed in arguments in the loc scope if they prefer --->
			<cfset loc = arguments>
		</cfif>
		<!--- we prefix returnValue with "wheels" here to make sure the variable does not get overwritten in the included template --->
		<cfif $template.startsWith("/")>
			<cfsavecontent variable="loc.wheelsReturnValue"><cfinclude template="#LCase(arguments.$template)#"></cfsavecontent>
		<cfelse>
			<cfsavecontent variable="loc.wheelsReturnValue"><cfinclude template="../../#LCase(arguments.$template)#"></cfsavecontent>
		</cfif>
		<cfreturn loc.wheelsReturnValue>
	</cffunction>

	<cffunction name="$callAction" returntype="void" access="public" output="false" mixin="controller">
		<cfargument name="action" type="string" required="true">
		<cfscript>
			var loc = {};
	
			if (Left(arguments.action, 1) == "$" || ListFindNoCase(application.wheels.protectedControllerMethods, arguments.action))
				$throw(type="Wheels.ActionNotAllowed", message="You are not allowed to execute the `#arguments.action#` method as an action.", extendedInfo="Make sure your action does not have the same name as any of the built-in Wheels functions.");
	
			if (StructKeyExists(this, arguments.action) && IsCustomFunction(this[arguments.action]))
			{
				$invoke(method=arguments.action);
			}
			else if (StructKeyExists(this, "onMissingMethod"))
			{
				loc.invokeArgs = {};
				loc.invokeArgs.missingMethodName = arguments.action;
				loc.invokeArgs.missingMethodArguments = {};
				$invoke(method="onMissingMethod", invokeArgs=loc.invokeArgs);
			}
	
			if (!$performedRenderOrRedirect())
			{
				try
				{
					// Added to prevent error
					request.wheels.deprecation = [];
					renderPage(); // Change to renderView for 1.2
				}
				catch(Any e)
				{
					if (
						FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.$class.name)#/#LCase(arguments.action)#.cfm")) or
						FileExists(ExpandPath($findInModules("#application.wheels.viewPath#/#LCase(variables.$class.name)#/#LCase(arguments.action)#.cfm")))
						)
					{
						$throw(object=e);
					}
					else
					{
						if (application.wheels.showErrorInformation)
						{
							$throw(type="Wheels.ViewNotFound", message="Could not find the view page for the `#arguments.action#` action in the `#variables.$class.name#` controller.", extendedInfo="Create a file named `#LCase(arguments.action)#.cfm` in the `views/#LCase(variables.$class.name)#` directory (create the directory as well if it doesn't already exist).");
						}
						else
						{
							$header(statusCode="404", statusText="Not Found");
							$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
							$abort();
						}
					}
				}
			}
		</cfscript>
		
	</cffunction>

	<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false" mixin="global">
		<cfargument name="path" type="string" required="true">
		<cfargument name="fileName" type="string" required="true">
		<cfargument name="method" type="string" required="true">
		<cfscript>
			var returnValue = "";
			arguments.returnVariable = "returnValue";
			arguments.component = ListChangeDelims(arguments.path.replace("../",""), ".", "/") & "." & ListChangeDelims(arguments.fileName, ".", "/");
			arguments.argumentCollection = Duplicate(arguments);
			StructDelete(arguments, "path");
			StructDelete(arguments, "fileName");
		</cfscript>
		<cfinclude template="../../root.cfm">
		<cfreturn returnValue>
	</cffunction>

	<cffunction name="$renderLayout" returntype="string" access="public" output="false" mixin="controller">
		<cfargument name="$content" type="string" required="true">
		<cfargument name="$layout" type="any" required="true">
		<cfscript>
			var loc = {};
			if ((IsBoolean(arguments.$layout) && arguments.$layout) || (!IsBoolean(arguments.$layout) && Len(arguments.$layout)))
			{
				// store the content in a variable in the request scope so it can be accessed
				// by the includeContent function that the developer uses in layout files
				// this is done so we avoid passing data to/from it since it would complicate things for the developer
				contentFor(body=arguments.$content, overwrite=true);
				loc.include = application.wheels.viewPath;
				if (IsBoolean(arguments.$layout))
				{
					loc.layoutFileExists = false;
					if (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller))
					{
						if (FileExists(ExpandPath($findInModules("#application.wheels.viewPath#/#LCase(variables.params.controller)#/layout.cfm")))) 
							loc.layoutFileExists = true;
						if (application.wheels.cacheFileChecking)
						{
							if (loc.layoutFileExists)
								application.wheels.existingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
							else
								application.wheels.nonExistingLayoutFiles = ListAppend(application.wheels.nonExistingLayoutFiles, variables.params.controller);
						}
					}
					if (ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) || loc.layoutFileExists)
					{
						loc.include = $findInModules("#application.wheels.viewPath#/#LCase(variables.params.controller)#/layout.cfm");
					}
					else
					{
						loc.include = loc.include & "/" & "layout.cfm";
					}
					loc.returnValue = $includeAndReturnOutput($template=loc.include);
				}
				else
				{
					arguments.$name = arguments.$layout;
					arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
					loc.returnValue = $includeFile(argumentCollection=arguments);
				}
			}
			else
			{
				loc.returnValue = arguments.$content;
			}
			return loc.returnValue;
		</cfscript>
	</cffunction>
</cfcomponent>