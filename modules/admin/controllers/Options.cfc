<cfscript>
	component extends="_main" 
	{
		function init() 
		{
			super.init();
		}
		
		function index()
		{			
			qOptions = model("Option").findAll(where="id NOT LIKE 'home%'#wherePermission("Option","AND")#", order="id asc");	
		}
		
		function save()
		{				
			model("Option").saveOptions(params.options);
			
			flashInsert(success="Saved successfully.");
			redirectTo(route="admin~Action", module="admin", controller="options", action="index");	
		}		
	}
</cfscript>