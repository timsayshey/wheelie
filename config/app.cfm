<cfscript>
	this.applicationTimeout = "#createTimespan(30,0,0,0)#";
	this.sessionManagement 	= "true";
	this.sessionTimeout 	= "#createTimeSpan(30,0,0,0)#";
	this.name 				= "Wheelie";
	rootPath 				= getDirectoryFromPath(getBaseTemplatePath());
	
	//this.mappings["/"] 				= rootPath;
	//this.mappings["/controllers"]	= rootPath & "controllers";
	//this.mappings["/models"] 		= rootPath & "models";
	//this.mappings["/cachebox"] 		= rootPath & "models/services/cachebox";
</cfscript>
<cfif find("beta2",cgi.HTTP_HOST)>
    <cferror type="exception" template="/assets/scripts/error.cfm">
    <cferror type="request" template="/assets/scripts/error.cfm">
</cfif>
<cfinclude template="/models/services/global/settings.cfm">