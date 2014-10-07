<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
		filters(through="setCache");	
	}
	
	function index()
	{
	}
	
	function usertag()
	{	
		setCache();
		//params.id = ListLast(cgi.PATH_INFO,"/");
		//params.id = ListDeleteAt(params.id,ListLen(params.id,"_"),"_");
		
		if(!isNull(params.id)) 
		{
			// Queries
			userTag = model("UserTag").findAll(where="#whereSiteid()# AND urlid LIKE '#params.id#'");
			users = model("UserTagJoin").findAll(where="#whereSiteid()# AND urlid LIKE '#params.id#' AND showOnSite = 1",include="User,UserTag",order="sortorder ASC, about DESC, jobtitle ASC, firstname ASC");			
		}
		
		if(isNull(users) OR !len(users.id))
		{
			users = {
				name = "User tag not found",
				content = "We apologize for the inconvenience. Please try clicking the menu above to find the page you are looking for."
			};
		}
		
	}
	
	function setCache()
	{
		request.cacheThis = true;
	} 
	
	function preHandler()
	{
		super.preHandler();		
		param name="params.context" default="";
	}
}
</cfscript>