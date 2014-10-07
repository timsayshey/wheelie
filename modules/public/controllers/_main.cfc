<cfscript>
component output="false" extends="controllers.Controller"  
{	
	function init()
	{
		super.init();
		
		secureActions = "mailUs,jobapp,jobappSubmit,newsletter,newsletterSubmit,footerbar";
		forceHttps(only=secureActions);
		forceHttp(except=secureActions);
		filters(through="redirectSecureSubdomain",except=secureActions);	
		
		
		filters(through="preHandler,setMenus");	
		filters(through="loggedOutOnly",except="login,loginPost,recovery,recoveryPost,register,registerPost");
	}
	
	private function loggedOutOnly()
	{	
		// Authenticate
		if(!StructKeyExists(session,"user"))
		{			
			//redirectTo(route="moduleAction", module="admin", controller="users", action="login");
		}	
	}
	
	function setMenus()
	{
		cgiPathInfo = cgi.path_info;
		PagePathInfo = ListLast(listfirst(cgiPathInfo,"."),"/");
		
		// Set home
		cgiPathInfo = len(cgiPathInfo) GT 1 ? cgiPathInfo : "IsHome";
		
		// Set current menu item
		activeMenuItem 	= model("Menu").findAll(where="#whereSiteid()# AND (urlId LIKE '#PagePathInfo#' OR customurl LIKE '#cgiPathInfo#')", maxRows=1, include="AllPost");
		activeMenuId = activeMenuItem.id;
		
		// Override current menu item id
		if(!isNull(request.overrideMenuId))
		{
			activeMenuId = request.overrideMenuId;
		}
		
		if(isNumeric(activeMenuId))
		{
			activeMenuItem 	= model("Menu").findAll(where="#whereSiteid()# AND id = #activeMenuId#", maxRows=1, include="AllPost");
		}		
		
		menuitems = model("Menu").findAll(where="#whereSiteid()# AND menuid = 'primary' AND parentid = 0", order="sortOrder ASC, name ASC", include="AllPost");
		
		if(activeMenuItem.parentid neq 0)
		{
			subParentId = len(activeMenuItem.parentid) GT 0 ? activeMenuItem.parentid : 999;
			activeParent = model("Menu").findAll(where="#whereSiteid()# AND menuid = 'primary' AND id = #subParentId#", maxRows=1, include="AllPost");
		}		
		else  
		{
			subParentId = activeMenuId;
		}
		
		subMenuItems = model("Menu").findAll(where="#whereSiteid()# AND menuid = 'primary' AND parentid = #subParentId#", order="sortOrder ASC, name ASC", include="AllPost");
	}
	
	function preHandler()
	{		
		homeid 			= getOption(qOptions,'home_id').content;
		
		if(!isNull(params.format)) 
		{
			if(params.format eq "modal") {
				usesLayout("/layouts/layout.modal");			
			} else {
				usesLayout("/themes/#request.site.theme#/layout");	 
			}
		}
		else
		{
			usesLayout("/themes/#request.site.theme#/layout");		
		}
		
		if(params.action eq "testerror")
		{
			request.testthis = "/themes/#request.site.theme#/layout";
		}
		
		if(!isNull(params.ajax))
		{
			isAjaxRequest = 1;
			usesLayout("/layouts/layout.blank");	
		}
	}
		
}
</cfscript>