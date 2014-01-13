<cfscript>
	this.applicationTimeout = "#createTimespan(1,0,0,0)#";
	this.sessionManagement = "true";
	this.sessionTimeout = "#createTimeSpan(0,0,20,0)#";
	this.name = "Wheelie";
	rootPath = getDirectoryFromPath(getBaseTemplatePath());
	this.mappings["/"] 				= rootPath;
	this.mappings["/controllers"]	= rootPath & "controllers";
	this.mappings["/models"] 		= rootPath & "models";
</cfscript>