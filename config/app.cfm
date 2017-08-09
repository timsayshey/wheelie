<!--- <cferror type="exception" template="/assets/scripts/error.cfm">
<cferror type="request" template="/assets/scripts/error.cfm"> --->
<cfscript>
	include template="/models/services/global/app/systemvars.cfm";
	this.runtimeconfig = setRuntimeSettings();

	include template="/models/services/global/settings.cfm";

	this.applicationTimeout = "#createTimespan(30,0,0,0)#";
	this.sessionManagement 	= "true";
	this.sessionTimeout 	= "#createTimeSpan(30,0,0,0)#";
	this.name 				= "Wheelie";
	rootPath 				= getDirectoryFromPath(getBaseTemplatePath());
</cfscript>
