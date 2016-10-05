<!--- Called from /models/services/global/init/setinfo.cfm --->

<cfscript>
	// Item filter defaults
	session.items.sortby = "sortorder";
	session.items.order = "asc";

	// properties filter defaults
	session.properties.sortby = "sortorder";
	session.properties.order = "asc";
</cfscript>