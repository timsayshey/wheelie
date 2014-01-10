<cfscript>
	this.name = "Wheelie";
	rootPath = getDirectoryFromPath(getBaseTemplatePath());
	this.mappings["/"] 				= rootPath;
	this.mappings["/controllers"]	= rootPath & "controllers";
	this.mappings["/models"] 		= rootPath & "models";
</cfscript>