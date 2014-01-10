<cfscript>
component output="false" extends="controllers.Controller"  
{	
	function init()
	{
		filters(through="preHandler,setMenus");	
	}
	
	function setMenus()
	{
		cgiPathInfo = cgi.path_info;
		if(len(cgiPathInfo) GT 2)
		{
			cgiPathInfo 	= Left(cgiPathInfo, len(cgiPathInfo)-1);
		}	
		cgiPathInfo 	= len(cgiPathInfo) GT 1 ? cgiPathInfo : "IsHome";
		activeMenuItem 	= model("MenuItem").findAll(where="menuid = 'primary' AND urlPath LIKE '#cgiPathInfo#%'", maxRows=1);
		menuItems 		= model("MenuItem").findAll(where="menuid = 'primary' AND parentid = 0", order="sortOrder ASC, name ASC");
		footerMenuItems = model("MenuItem").findAll(where="menuid = 'secondary' AND parentid = 0", order="sortOrder ASC, name ASC");
		
		if(activeMenuItem.parentid eq 0)
		{
			subParentId = activeMenuItem.id;
		}
		else 
		{
			subParentId = len(activeMenuItem.parentid) GT 0 ? activeMenuItem.parentid : 999;
			activeParent = model("MenuItem").findAll(where="menuid = 'primary' AND id = #subParentId#", maxRows=1);
		}
		
		subMenuItems = model("MenuItem").findAll(where="menuid = 'primary' AND parentid = #subParentId#", order="sortOrder ASC, name ASC");
	}
	
	function preHandler()
	{		
		qOptions 		= model("Option").findAll();
		homeid 			= getOption(qOptions,'home_id').content;
		
		if(!isNull(params.format)) 
		{
			if(params.format eq "modal") {
				usesLayout("/layouts/layout.modal");			
			} else {
				usesLayout("/layouts/layout.front");		
			}
		}
		else
		{
			usesLayout("/layouts/layout.front");		
		}
		
		if(!isNull(params.ajax))
		{
			isAjaxRequest = 1;
			usesLayout("/layouts/layout.blank");	
		}
	}
		
}
</cfscript>