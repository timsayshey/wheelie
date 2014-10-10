<cfscript>
	component extends="Wheels" 
	{
		function init()
		{
			filters(through="sharedGlobalData,setLogInfo");	
		}
		
		function sharedGlobalData()
		{
			qOptions = model("Option").findAll();
			qUsergroups = model("Usergroup").findAll();
		}
	
		/* Multisite: Set Site Settings
		private function setSiteInfo()  
		{			
			var loc = {};
			
			loc.domain = cgi.SERVER_NAME;			
			if(listlen(loc.domain,".") GT 2)
			{
				loc.domainName = ListGetAt(loc.domain,listlen(loc.domain,".") - 1,"."); // domain
				loc.domainExt  = ListGetAt(loc.domain,listlen(loc.domain,"."),"."); // .com
				loc.domain = loc.domainName & "." & loc.domainExt;				
			}
			
			loc.siteResult = model("site").findAll(where="urlid = '#loc.domain#'");	
			if(loc.siteResult.recordcount)
			{
				request.site = 
				{
					id = loc.siteResult.id,
					domain = loc.siteResult.urlid,
					ssl = loc.siteResult.ssl
				};
			}
			else 
			{
				writeOutput("Sorry, this site is currently unavailable."); abort;
			}
		}*/
		
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