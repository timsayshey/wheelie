<!--- Called from /models/services/global/global.cfm --->

<cfscript>
	// Override pretty much any application setting here
	// Override admin scope set in /models/services/global/init/setinfo.cfm
	infoAppend.adminUrlPath 		= "/manager";
	infoAppend.itemThumbPath		= "/assets/uploads/items/";	
	infoAppend.propertyThumbPath	= "/assets/uploads/properties/";	
	infoAppend.fileItemThumbs		= fixFilePathSlashes("#fileroot##infoAppend.itemThumbPath#");
	
	StructAppend(info,infoAppend,true);
	
	application.info = info;

	
</cfscript>