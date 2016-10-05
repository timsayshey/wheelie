<!--- Called from /models/services/global/init/setinfo.cfm --->

<cfscript>
	// Item filter defaults
	param name="session.items.sortby" default="sortorder";
	param name="session.items.order" default="asc";

	param name="session.properties.sortby" default="sortorder";
	param name="session.properties.order" default="asc";
</cfscript>