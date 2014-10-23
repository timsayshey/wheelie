<!--- Called from /models/services/global/global.cfm --->

<cfscript>
	// Override pretty much any application setting here
	
	// Override admin scope set in /models/services/global/init/setinfo.cfm
	application.info.adminUrlPath = "/manager";
</cfscript>