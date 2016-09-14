<cfscript>
	component extends="Wheels" 
	{
		function init()
		{
			
			filters(through="sharedGlobalData,setLogInfo,setMenus,adminMenuDefaults");	
			filters(through="sharedfilter");
			filters(through="setUserInfo");

		}
		
		private function sharedfilter()
		{
			include "/models/services/global/app/sharedfilter.cfm";
		}
		
		function sharedGlobalData()
		{
			qOptions = model("Option").findAll();
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
			
			menuitems = model("Menu").findAll(where="#whereSiteid()# AND parentid = 0", order="sortOrder ASC, name ASC", include="AllPost");
			
			if(activeMenuItem.parentid neq 0)
			{
				subParentId = len(activeMenuItem.parentid) GT 0 ? activeMenuItem.parentid : 999;
				activeParent = model("Menu").findAll(where="#whereSiteid()# AND id = #subParentId#", maxRows=1, include="AllPost");
			}		
			else  
			{
				subParentId = activeMenuId;
			}
			
			subMenuItems = model("Menu").findAll(where="#whereSiteid()# AND parentid = #subParentId#", order="sortOrder ASC, name ASC", include="AllPost");
		}
		
		function renderPage(string template="") 
		{	
			if(!isNull(request.cacheThis))
			{
				arguments.cache = 60; 
			}
			super.renderPage(argumentCollection=arguments);			
			/*
			//Danger - prevents error pages from showing
			try {
				super.renderView(argumentCollection=arguments);
			} catch(e) {
				if(!isNull(session.user) AND !isNull(checkPermission) AND checkPermission("user_save_role_admin"))
				{
					writeOutput("Controller: Please copy and email this page to your webmaster");
					//writeDump(e); abort;	
				}
			}*/
		}
		
		private function setLogInfo() 
		{			
			var loc = {};
			loc.loguserid = "";
			
			if(!isNull(session.user.id))
			{
				loc.loguserid = session.user.id;
			}
			
			request.logit = 
			{
				userId		= loc.loguserid,
				controller	= params.controller,
				action		= params.action,
				modelid		= "", // set later in Model.cfc
				model		= "", // set later in Model.cfc
				savetype	= "", // set later in Model.cfc
				createdat	= $convertToString(now())
			};
			
		}
	}
</cfscript>