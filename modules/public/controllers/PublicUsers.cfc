<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();	
	}
	
	function index()
	{
	}
	
	function usertag()
	{			
		if(!isNull(params.id)) 
		{
			// Queries				
			usertag = model("UserTag").findAll(where="#whereSiteid()# AND urlid LIKE '#params.id#'");
			users = model("UserTagJoin").findAll(
				where="#whereSiteid()# AND categories.id = '#usertag.id#' AND showOnSite = 1",
				include="User,UserTag",
				order="sortorder ASC, about DESC, jobtitle ASC, firstname ASC"
			);
		}
		
		if(isNull(users) OR !len(users.id))
		{
			users = {
				name = "User tag not found",
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