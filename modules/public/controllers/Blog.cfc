<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
		filters(through="setMenu");	
		caches(actions="index,post", time=300);				
	}
	
	function setMenu()
	{
		request.overrideMenuId = 88;
	}
	
	function index()
	{		
		param name="params.currPage" default="1";
		posts = model("Post").findAll(where="#whereSiteid()# AND postType = 'post'", order="createdAt DESC", include="user");
		
		if(listlen(cgi.PATH_INFO,"/") gt 1)
		{
			goHome();
		}		
		
		pagination.setQueryToPaginate(posts);	
		pagination.setItemsPerPage(25);		
		paginator = pagination.getRenderedHTML();
	}  
	 
	function post()
	{			
		
		if(isDefined("params.id")) 
		{
			// Queries
			parsedUrlId = ListLast(params.id,"/");
			parsedUrlId = lcase(cleanUrlId(parsedUrlId));
			
			post = model("Post").findAll(where="#whereSiteid()# AND postType = 'post' AND urlid = '#parsedUrlId#'", include="user");		
		}
		
		if(isNull(post) OR !len(post.id))
		{
			post = {
				name = "Post not found",
				content = "We apologize for the inconvenience. Please try clicking the menu above to find the post you are looking for."
			};
		}
					
		
	}
	
	function goHome() 
	{
		if(isDefined("params.id")) 
		{
			// Queries
			post = model("Post").findAll(where="#whereSiteid()# AND postType = 'post' AND urlid = '#ListLast(params.id,"/")#'");		
			location("/blog/post/#params.id#", false, 301);
			abort;			
		}
		
		log404();
		location("/blog", false, 301);
	}
	
	function setCache()
	{
		request.cacheThis = true;
	} 
}
</cfscript>