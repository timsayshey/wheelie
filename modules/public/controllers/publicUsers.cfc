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
			users = model("UserTagJoin").findAll(where="urlid LIKE '#params.id#'",include="User,UserTag");			
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