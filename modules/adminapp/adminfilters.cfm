<cfscript>
	// Custom App Filters Here - These run on every admin controller request
	// If you need to run on application start or on request, edit /models/services/global/app/app.cfm
	/////////////////////////////////////////////////////////////////////////////////
	
	// Set Custom Info
	/////////////////////////////////////////////////////////////////////////////////
	infoAppend.validCategoryModelsList = "itemcategory,propertycategory"; // lowercase
	infoAppend.serverIp = "";
	
	StructAppend(info,infoAppend,true);
	
	application.info = info;
	
	// Add Custom Menu Item
	/////////////////////////////////////////////////////////////////////////////////
	
	
</cfscript>