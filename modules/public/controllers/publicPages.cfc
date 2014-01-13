<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index()
	{		
		home = model("Page").findAll(where="id = '#homeid#'");
	}
	
	function page()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			page = model("Page").findAll(where="urlid = '#params.id#'");						
		}
		
		if(isNull(page) OR !len(page.id))
		{
			page = {
				name = "Page not found",
				content = "We apologize for the inconvenience. Please try clicking the menu above to find the page you are looking for."
			};
		}
	}
	
	function preHandler()
	{
		super.preHandler();
		
		param name="params.context" default="";
	}
}
</cfscript>