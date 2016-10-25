<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index()
	{	
		sites = model("site").findAll();
	}	
	
	function new()
	{
		// Queries
		site = model("Site").new(colStruct("Site"));
		
		// Default options has siteid set to zero
		siteOptions = model("option").findAll(where="siteid = 0");
		
		// If not allowed redirect
		wherePermission("Site");
		
		// Show site
		renderPage(action="editor");
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			site = model("Site").findAll(where="id = '#params.id#'", maxRows=1, returnAs="Object");
			siteOptions = model("option").findAll(where="siteid = '#params.id#'");
			
			if(ArrayLen(site))
			{				
				site = site[1];
			}
			
			// Site not found?
			if (!IsObject(site))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="sites");
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		siteOptions = model("option").findAll(where="siteid = 0");

		if(!params.site.containsKey("subdomin") || !len(trim(params.site.subdomain))) {
			params.site.subdomain = listFirst(params.site.urlid,".");
		}

		// Get site object
		if(!isNull(params.site.id)) 
		{
			site = model("Site").findByKey(params.site.id);
			saveResult = site.update(params.site);
		} else {
			site = model("Site").new(params.site);
			saveResult = site.save();
			isNewSite = true;
		}
		
		// Insert or update site object with properties
		if (saveResult)
		{	
			// Save options
			if(StructKeyExists(params,"options"))
			{			
				model("Option").saveOptions(params.options, site.id);
			}
			
			flashInsert(success='Site saved.');
			redirectTo(route="admin~Id", module="admin", controller="sites", action="edit", id=site.id);
		} else {						
			
			errorMessagesName = "site";
			param name="site.id" default="0";
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="sites", action="editor");		
		}		
	}
	
	function delete()
	{
		sites = model("site").findByKey(params.id);
		
		if(sites.delete())
		{
			flashInsert(success="The Site was deleted successfully.");							
		} else 
		{
			flashInsert(error="The Site could not be found.");
		}
		
		redirectTo(route="admin~Index", controller="sites");
	}
}
</cfscript>