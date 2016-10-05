<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function sharedObjects(pageblockid)
	{		
		// Home PageBlock
		currentPageBlockIsHome = model("option").findAll(where="id = 'home_id' AND content = '#pageblockid#'#wherePermission("option","AND")#");		
		currentPageBlockIsHome = currentPageBlockIsHome.recordcount ? true : false;
		
		homeOptions = model("option").findAll(where="id LIKE 'home_%' AND (editContent = 1 OR editLabel = 1 OR editAttachment = 1)#wherePermission("option","AND")#");		
	}
	
	function index()
	{
		statusTabs("pageblock","postType = 'pageblock' AND");
		
		qPageBlocks = model("PageBlock").findAll(where=buildWhereStatement(modelName="PageBlock",prepend="postType = 'pageblock' AND"), order=session.pageblocks.sortby & " " & session.pageblocks.order);			
		filterResults();
			
		// Paginate me batman
		pagination.setQueryToPaginate(qPageBlocks);	
		pagination.setItemsPerPage(session.perPage);		
		paginator = pagination.getRenderedHTML();
	}
		
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			sharedObjects(params.id);
			pageblock = model("PageBlock").findAll(where="id = '#params.id#'#wherePermission("PageBlock","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(pageblock))
			{				
				pageblock = pageblock[1];
			}
			
			// PageBlock not found?
			if (!IsObject(pageblock))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="pageblocks");
			}			
		}
		
		renderPage(action="editor");		
	}
	
	function new()
	{
		// Queries
		sharedObjects(0);
		pageblock = model("PageBlock").new(colStruct("PageBlock"));
		
		// If not allowed redirect
		wherePermission("PageBlock");
		
		// Show pageblock
		renderPage(action="editor");
	}


	function delete()
	{
		pageblock = model("PageBlock").findByKey(params.id);
		
		if(pageblock.delete())
		{
			flashInsert(success="The pageblock was deleted successfully.");							
		} else 
		{
			flashInsert(error="The pageblock could not be found.");
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="pageblocks"
		);
	}

	function save()
	{						
		// Handle submit button type (publish,draft,trash,etc)
		if(!isNull(params.submit))
		{
			params.pageblock.status = handleSubmitType("pageblock", params.submit);	
		}
		
		// Save homepageblock settings
		if(StructKeyExists(params,"options") AND StructKeyExists(params,"isHome"))
		{			
			model("Option").saveOptions(params.options);
		}
		
		// Auto generate meta tags
		if(StructKeyExists(params.pageblock,"metagenerated") AND params.pageblock.metagenerated eq 1)
		{
			params.pageblock.metatitle 		= generatePageBlockTitle(params.pageblock.name);
			params.pageblock.metadescription = generateMetaDescription(params.pageblock.content);
			params.pageblock.metakeywords 	= generateMetaKeywords(params.pageblock.content);
		}
		
		// Get pageblock object
		if(!isNull(params.pageblock.id)) 
		{
			pageblock = model("PageBlock").findByKey(params.pageblock.id);
			saveResult = pageblock.update(params.pageblock);
		} else {
			pageblock = model("PageBlock").new(params.pageblock);
			saveResult = pageblock.save();
		}
		
		// Insert or update pageblock object with properties
		if (saveResult)
		{				
			if(StructKeyExists(params,"isHome")) 
			{
				option = model("Option").findOne(where="id = 'home_id'#wherePermission("option","AND")#");
				option.update(content=pageblock.id,validate=false);
			}			
			
			flashInsert(success="PageBlock saved.");
			redirectTo(route="admin~Id", module="admin", controller="pageblocks", action="edit", id=pageblock.id);				
					
		} else {						
			
			errorMessagesName = "pageblock";
			param name="pageblock.id" default="0";
			sharedObjects(pageblock.id);
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="pageblocks", action="editor");		
		}		
	}
	
	function deleteSelection()
	{
		for(i=1; i LTE ListLen(params.deletelist); i++)
		{
			model("PageBlock").findByKey(ListGetAt(params.deletelist,i)).delete();
		}
		
		flashInsert(success="Your pageblocks were deleted successfully!");			
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="pageblocks"
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
			controller="pageblocks"
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
				session.pageblocks.sortby = params.sort;			
			}
			
			// Set order
			if(!isNull(params.order))
			{
				session.pageblocks.order = params.order;			
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
				if(len(wherePermission("PageBlock")))
				{
					whereClause = wherePermission("PageBlock") & " AND (" & whereKeywords & ")";
				} else {
					whereClause = whereKeywords;	
				}					
				
				qPageBlocks = model("PageBlock").findAll(
					where	= whereClause,
					order	= session.pageblocks.sortby & " " & session.pageblocks.order
				);
			}
			
			// Clear out the duplicates
			qPageBlocks = queryOfQueries(
				query	= "qPageBlocks",
				order	= session.pageblocks.sortby & " " & session.pageblocks.order
			);
			
			if(len(rememberParams))
			{
				pagination.setAppendToLinks("&#rememberParams#");
			}
			
			//renderPage(route="admin~Action", module="admin", controller="pageblocks", action="index");		
		}
	}
	
	function preHandler()
	{
		super.preHandler();
	}
}
</cfscript>