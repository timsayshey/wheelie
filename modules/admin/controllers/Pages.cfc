<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function sharedObjects(pageid)
	{		
		// Home Page
		currentPageIsHome = model("option").findAll(where="id = 'home_id' AND content = '#pageid#'#wherePermission("option","AND")#");		
		currentPageIsHome = currentPageIsHome.recordcount ? true : false;
		
		homeOptions = model("option").findAll(where="id LIKE 'home_%' AND (editContent = 1 OR editLabel = 1 OR editAttachment = 1)#wherePermission("option","AND")#");
		
		qPageBlocks = model("PageBlock").findAll();
		pageBlockOptions = [];

		for(var pageBlock in qPageBlocks){
			arrayAppend(
				pageBlockOptions,
				{
					text=pageBlock.name,
					value=pageBlock.id
				}
			);
		}
	}
	
	function index()
	{
		statusTabs("page","postType = 'page' AND");
		
		qPages = model("Page").findAll(where=buildWhereStatement(modelName="Page",prepend="postType = 'page' AND"), order=session.pages.sortby & " " & session.pages.order);			
		filterResults();
			
		// Paginate me batman
		pagination.setQueryToPaginate(qPages);	
		pagination.setItemsPerPage(session.perPage);		
		paginator = pagination.getRenderedHTML();
	}
		
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			sharedObjects(params.id);
			page = model("Page").findAll(where="id = '#params.id#'#wherePermission("Page","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(page))
			{				
				page = page[1];
			}
			
			// Page not found?
			if (!IsObject(page))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="pages");
			}			
		}
		
		renderPage(action="editor");		
	}
	
	function new()
	{
		// Queries
		sharedObjects(0);
		page = model("Page").new(colStruct("Page"));
		
		// If not allowed redirect
		wherePermission("Page");
		
		// Show page
		renderPage(action="editor");
	}


	function delete()
	{
		page = model("Page").findByKey(params.id);
		
		if(page.delete())
		{
			flashInsert(success="The page was deleted successfully.");							
		} else 
		{
			flashInsert(error="The page could not be found.");
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="pages"
		);
	}

	function save()
	{						
		// Handle submit button type (publish,draft,trash,etc)
		if(!isNull(params.submit))
		{
			params.page.status = handleSubmitType("page", params.submit);	
		}
		
		// Save homepage settings
		if(StructKeyExists(params,"options") AND StructKeyExists(params,"isHome"))
		{			
			model("Option").saveOptions(params.options);
		}
		
		// Auto generate meta tags
		if(StructKeyExists(params.page,"metagenerated") AND params.page.metagenerated eq 1)
		{
			params.page.metatitle 		= generatePageTitle(params.page.name);
			params.page.metadescription = generateMetaDescription(params.page.content);
			params.page.metakeywords 	= generateMetaKeywords(params.page.content);
		}
		
		// Get page object
		if(!isNull(params.page.id)) 
		{
			page = model("Page").findByKey(params.page.id);
			saveResult = page.update(params.page);
		} else {
			page = model("Page").new(params.page);
			saveResult = page.save();
		}

		// Insert or update page object with properties
		if (saveResult)
		{				
			// Delete featuredImg
			if(!isNull(params.featuredImg_delete))
			{
				deleteThisFile("/assets/images/featured/feat-#page.id#.jpg");
			}

			// Save featuredImg
			if(!isNull(form.featuredImg) AND len(form.featuredImg) AND FileExists(form.featuredImg))
			{								
				if(uploadImage(field="featuredImg",filename='feat-#page.id#'))
				{
					user.featuredImg = "";
				}
			}

			if(StructKeyExists(params,"isHome")) 
			{
				option = model("Option").findOne(where="id = 'home_id'#wherePermission("option","AND")#");
				option.update(content=page.id,validate=false);
			}			
			
			flashInsert(success="Page saved. #linkto(text="View page", route="public~secondaryPage", id=page.urlid)#");
			redirectTo(route="admin~Id", module="admin", controller="pages", action="edit", id=page.id);				
					
		} else {						
			
			errorMessagesName = "page";
			param name="page.id" default="0";
			sharedObjects(page.id);
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="pages", action="editor");		
		}		
	}

	function uploadImage(field,filename)
	{
		var loc = {};
		
		if(arguments.containsKey("filename"))
		{
			var result = fileUpload(getTempDirectory(),arguments.field, "image/*", "makeUnique");

			if(result.fileWasSaved) {
				var theFile = result.serverdirectory & "/" & result.serverFile;
				var fullFile = expandPath("/assets/images/featured/#arguments.filename#.jpg");
				if(!isImageFile(thefile)) {
					fileDelete(theFile);
					return false;
				} else {					
					var img = imageRead(thefile);
					try {
						imageWrite(img,fullFile,1,1);
						fileDelete(theFile);
					} catch(e) {
						flashInsert(error="File Error: #e.message#");
						return false;
					}
					return true;
				}
			} else return false;			
		}
	}
	
	function deleteSelection()
	{
		for(i=1; i LTE ListLen(params.deletelist); i++)
		{
			model("Page").findByKey(ListGetAt(params.deletelist,i)).delete();
		}
		
		flashInsert(success="Your pages were deleted successfully!");			
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="pages"
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
			controller="pages"
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
				session.pages.sortby = params.sort;			
			}
			
			// Set order
			if(!isNull(params.order))
			{
				session.pages.order = params.order;			
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
				if(len(wherePermission("Page")))
				{
					whereClause = wherePermission("Page") & " AND (" & whereKeywords & ")";
				} else {
					whereClause = whereKeywords;	
				}					
				
				qPages = model("Page").findAll(
					where	= whereClause,
					order	= session.pages.sortby & " " & session.pages.order
				);
			}
			
			// Clear out the duplicates
			qPages = queryOfQueries(
				query	= "qPages",
				order	= session.pages.sortby & " " & session.pages.order
			);
			
			if(len(rememberParams))
			{
				pagination.setAppendToLinks("&#rememberParams#");
			}
			
			//renderPage(route="admin~Action", module="admin", controller="pages", action="index");		
		}
	}
	
	function preHandler()
	{
		super.preHandler();
	}
}
</cfscript>