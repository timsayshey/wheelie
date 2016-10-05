<cfscript>
component extends="_main" 
{
	function init() 
	{
		super.init();
	}
	
	function usermenu()
	{
		usesLayout("/layouts/layout.blank");
	}
	
	function home() 
	{
		if(checkPermission("log_read_others"))
		{
			qLog = model("Log").findAll(where=wherePermission("Log"),include="User", maxRows=3, order="createdAt DESC");	
			qLogFull = model("Log").findAll(where=wherePermission("Log"),include="User", maxRows=50, order="createdAt DESC");	
		}
	}
}
</cfscript>