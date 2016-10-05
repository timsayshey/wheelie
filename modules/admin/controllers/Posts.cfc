<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function sharedObjects(postid)
	{		
		
	}
	
	function index()
	{
		statusTabs("post","postType = 'post' AND");
		
		qPosts = model("Post").findAll(where=buildWhereStatement(modelName="Post",prepend="postType = 'post' AND"), order=session.posts.sortby & " " & session.posts.order);			
		filterResults();
			
		// Paginate me batman
		pagination.setQueryToPaginate(qPosts);	
		pagination.setItemsPerPage(session.perPage);		
		paginator = pagination.getRenderedHTML();
	}
		
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			sharedObjects(params.id);
			post = model("Post").findAll(where="id = '#params.id#'#wherePermission("Post","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(post))
			{				
				post = post[1];
			}
			
			// Post not found?
			if (!IsObject(post))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="posts");
			}			
		}
		
		renderPage(action="editor");		
	}
	
	function new()
	{
		// Queries
		sharedObjects(0);
		post = model("Post").new(colStruct("Post"));
		
		// If not allowed redirect
		wherePermission("Post");
		
		// Show post
		renderPage(action="editor");
	}


	function delete()
	{
		post = model("Post").findByKey(params.id);
		
		if(post.delete())
		{
			flashInsert(success="The post was deleted successfully.");							
		} else 
		{
			flashInsert(error="The post could not be found.");
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="posts"
		);
	}

	function save()
	{						
		// Handle submit button type (publish,draft,trash,etc)
		if(!isNull(params.submit))
		{
			params.post.status = handleSubmitType("post", params.submit);	
		}		
		
		// Auto generate meta tags
		if(StructKeyExists(params.post,"metagenerated") AND params.post.metagenerated eq 1)
		{
			params.post.metatitle 		= generatePageTitle(params.post.name);
			params.post.metadescription = generateMetaDescription(params.post.content);
			params.post.metakeywords 	= generateMetaKeywords(params.post.content);
		}
		
		// Get post object
		if(!isNull(params.post.id)) 
		{
			post = model("Post").findByKey(params.post.id);
			saveResult = post.update(params.post);
		} else {
			post = model("Post").new(params.post);
			saveResult = post.save();
		}
		
		// Insert or update post object with properties
		if (saveResult)
		{	
			flashInsert(success="Post saved. #linkto(text="View post", route="public~secondaryPage", id=post.urlid)#");
			redirectTo(route="admin~Id", module="admin", controller="posts", action="edit", id=post.id);				
					
		} else {						
			
			errorMessagesName = "post";
			param name="post.id" default="0";
			sharedObjects(post.id);
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="posts", action="editor");		
		}		
	}
	
	function deleteSelection()
	{
		for(i=1; i LTE ListLen(params.deletelist); i++)
		{
			model("Post").findByKey(ListGetAt(params.deletelist,i)).delete();
		}
		
		flashInsert(success="Your posts were deleted successfully!");			
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="posts"
		);
	}
	
	function setPerPage()
	{
		if(!isNull(params.id) AND IsNumeric(params.id))
		{
			session.perPage = params.id;
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="posts"
		);
	}
	
	function filterResults()
	{	
		if(!isNull(params.filtertype) AND params.filtertype eq "clear")
		{
			resetIndexFilters();
		}
		else
		{			
			rememberParams = "";	
			
			// Set display type
			if(!isNull(params.display))
			{
				session.display = params.display;			
			}
			
			// Set search query
			if(!isNull(params.search))
			{
				params.search = params.search;			
			}
			
			// Set sort by
			if(!isNull(params.sort))
			{
				session.posts.sortby = params.sort;			
			}
			
			// Set order
			if(!isNull(params.order))
			{
				session.posts.order = params.order;			
			}
			
			// Apply "search" filter
			if(!isNull(params.search) AND len(params.search))
			{
				rememberParams = ListAppend(rememberParams,"search=#params.search#","&");
				
				// Break apart search string into a keyword where clause
				var whereKeywords = [];			
				var keywords = listToArray(trim(params.search)," ");			
				for(keyword in keywords)
				{
					ArrayAppend(whereKeywords, "name LIKE '%#keyword#%'");
				}
				
				// Include permission check if defined
				whereKeywords = ArrayToList(whereKeywords, " OR ");
				if(len(wherePermission("Post")))
				{
					whereClause = wherePermission("Post") & " AND (" & whereKeywords & ")";
				} else {
					whereClause = whereKeywords;	
				}					
				
				qPosts = model("Post").findAll(
					where	= whereClause,
					order	= session.posts.sortby & " " & session.posts.order
				);
			}
			
			// Clear out the duplicates
			qPosts = queryOfQueries(
				query	= "qPosts",
				order	= session.posts.sortby & " " & session.posts.order
			);
			
			if(len(rememberParams))
			{
				pagination.setAppendToLinks("&#rememberParams#");
			}
			
			//renderPage(route="admin~Action", module="admin", controller="posts", action="index");		
		}
	}
	
	function preHandler()
	{
		super.preHandler();
	}
}
</cfscript>