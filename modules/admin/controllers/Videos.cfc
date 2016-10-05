<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function sharedObjects(videoid)
	{		
		videocategories = model("VideoCategory").findAll();
		selectedvideocategories = model("VideoCategoryJoin").findAll(where="videoid = #arguments.videoid#",include="Video,VideoCategory");
		selectedvideocategories = ValueList(selectedvideocategories.videocategoryid);
		
		sites = model("Site").findAll();
		usStates = getStatesAndProvinces();
		countries = getCountries();	
	}
	
	function video()
	{		
		if(!isNull(params.id))
		{
			video = model("video").findAll(where="id = '#params.id#'");
		}
	}
	
	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);
				
		for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
		{
			sortVal = orderValues[i];
			
			sortItem = model("Video").findOne(where="id = #sortVal.fieldId#");
					
			if(isObject(sortItem))
			{
				sortItem.update(sortorder=sortVal.newIndex,validate=false);
			}
		}
		abort;
	}
	
	function category()
	{		
		sharedObjects(0);
		
		if(!isNull(params.id))
		{			
			videoCategory = model("VideoCategory").findAll(where="urlid = '#params.id#'#wherePermission("VideoCategory","AND")#");				
		} else {
			// Get default category
			videoCategory = model("VideoCategory").findAll(where="defaultadmin = 1#wherePermission("VideoCategory","AND")#");				
		}
		
		videoCategories = model("VideoCategory").findAll(where="parentid = '#videoCategory.id#'#wherePermission("VideoCategory","AND")#");
		
		if(videoCategory.recordcount)
		{				
			distinctVideoColumns = "id, sortorder, name, description, youtubeid, status, createdat, updatedat";
			videoColumns = "#distinctVideoColumns#, description, status, category_id";
			
			qVideos = model("Video").findAll(
				where	= buildWhereStatement(modelName="Video", prepend="videocategoryid = '#videoCategory.id#' AND"), 
				order	= "sortorder ASC", 
				select	= videoColumns,
				include = "videocategoryjoin(videocategory)"
			);
			
			filterResults();
		}
	}
	
	function index()
	{
		sharedObjects(0);
		distinctVideoColumns = "id, sortorder, name, description, youtubeid, status, createdat, updatedat";
		videoColumns = "#distinctVideoColumns#, description, status, category_id";
		
		statusTabs("video");
		
		qVideos = model("Video").findAll(
			where	= buildWhereStatement("Video"), 
			order	= !isNull(params.rearrange) ? "sortorder ASC" : session.videos.sortby & " " & session.videos.order, 
			select	= videoColumns,
			include = "videocategoryjoin(videocategory)"
		);
				
		if(!isNull(params.rearrange))
		{
			// Removes duplicates
			qVideos = queryOfQueries(
				query	= "qVideos", 
				select	= "DISTINCT #distinctVideoColumns#", 
				order	= "sortorder ASC"
			);
		} else {
			filterResults();
		}
		
		// Paginate me batman		
		pagination.setQueryToPaginate(qVideos);	
		pagination.setItemsPerPage(session.perPage);		
		paginator = pagination.getRenderedHTML();
		
		// If oauth comes back to homepage
		if(!isNull(params.token))
		{
			video = model("Video").findAll(where="id = #params.id#");
		}
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			sharedObjects(params.id);						
			video = model("Video").findAll(where="id = '#params.id#'#wherePermission("Video","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(video))
			{				
				video = video[1];
			}
			
			// Video not found?
			if (!IsObject(video))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="videos");
			}			
		}
		
		renderPage(action="editor");		
	}
	
	function new()
	{
		// Queries
		video = model("Video").new(colStruct("Video"));
		
		sharedObjects(0);
		
		// If not allowed redirect
		wherePermission("Video");
		
		// Show page
		renderPage(action="editor");
	}


	function delete()
	{
		video = model("Video").findByKey(params.id);
		
		if(video.delete())
		{
			flashInsert(success="The video was deleted successfully.");							
		} else 
		{
			flashInsert(error="The video could not be found.");
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="videos"
		);
	}

	function save()
	{			
		param name="params.video.videofileid" default="";
		param name="params.videocategories" default="";
		
		// Handle submit button type (publish,draft,trash,etc)
		if(!isNull(params.submit))
		{
			params.video.status = handleSubmitType("video", params.submit);	
		}
		
		// Get video object
		if(!isNull(params.video.id)) 
		{
			video = model("Video").findByKey(params.video.id);
			saveResult = video.update(params.video);	
			
			// Clear existing video category associations
			model("videoCategoryJoin").deleteAll(where="videoid = #params.video.id#");
		} else {
			video = model("Video").new(params.video);
			saveResult = video.save();
		}
		
		// Insert or update video object with properties
		if (saveResult)
		{								
			// Insert new video category associations			
			for(id in ListToArray(params.videocategories))
			{				
				model("videoCategoryJoin").create(videocategoryid = id, videoid = video.id);				
			}
			
			// Delete videothumb
			if(!isNull(params.videothumb_delete) AND !isNull(params.video.id))
			{
				deleteThisFile("#info.uploadsPath#videos/thumbs/#params.video.id#.jpg");
				deleteThisFile("#info.uploadsPath#videos/thumbs/#params.video.id#_full.jpg");
				params.video.customThumb = 1;
			}
			
			// Save videothumb
			if(!isNull(form.videothumb) AND len(form.videothumb) AND FileExists(form.videothumb))
			{								
				if(uploadVideoImage("videothumb",video))
				{
					params.video.portrait = "";
					params.video.customThumb = 1;
					
				}
			}
			
			// Update video with custom thumb boolean
			video.update(customThumb=params.video.customThumb);
			
			// Youtubeid cleanup and save thumb
			if(!isNull(params.video.youtubeId) AND len(params.video.youtubeId) AND !isNull(video.id) AND params.video.customThumb neq 1)
			{
				params.video.youtubeId = XMLFormat(trim(params.video.youtubeId));		
				model("Video").saveYoutubeThumb(
					filename	= params.video.youtubeId,
					imgUrl		= "http://i1.ytimg.com/vi/#params.video.youtubeId#/hqdefault.jpg",
					videoid		= video.id
				);
			}
			
			flashInsert(success="Video saved.");
			redirectTo(route="admin~Id", module="admin", controller="videos", action="edit", id=video.id);	
		} else {						
			
			errorMessagesName = "video";
			param name="video.id" default="0";
			sharedObjects(video.id);
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="videos", action="editor");		
		}		
	}
	
	function deleteSelection()
	{
		for(i=1; i LTE ListLen(params.deletelist); i++)
		{
			model("Video").findByKey(ListGetAt(params.deletelist,i)).delete();
		}
		
		flashInsert(success="Your videos were deleted successfully!");			
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="videos"
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
			controller="videos"
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
			// Get main query
			qqVideos = qVideos;	
			rememberParams = "";				
			
			// Set display type
			if(!isNull(params.display))
			{
				session.display = params.display;			
			}			
			
			// Set sort
			if(!isNull(params.sort))
			{
				session.videos.sortby = params.sort;			
			}
			
			// Set order
			if(!isNull(params.order))
			{
				session.videos.order = params.order;			
			}
			
			// Set "hosted" filter
			if(!isNull(params.hosted))
			{
				session.videos.hosted = params.hosted;
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
					ArrayAppend(whereKeywords, "description LIKE '%#keyword#%'");
				}
				
				// Include permission check if defined
				whereKeywords = ArrayToList(whereKeywords, " OR ");
				if(len(wherePermission("Video")))
				{
					whereClause = wherePermission("Video") & " AND (" & whereKeywords & ")";
				} else {
					whereClause = whereKeywords;	
				}					
				
				qqVideos = model("Video").findAll(
					where	= whereClause,
					order	= session.videos.sortby & " " & session.videos.order, 
					select	= videoColumns,
					include = "videocategoryjoin(videocategory)"
				);
			}
			
			// Apply "hosted" filter
			if(!isNull(params.hosted) AND len(params.hosted))
			{
				rememberParams = ListAppend(rememberParams,"hosted=#params.hosted#","&");	
				
				if(params.hosted eq "local")
				{				
					qqVideos = queryOfQueries("qqVideos","youtubeid IS NULL OR youtubeid = ''");
				} 
				else if(params.hosted eq "youtube")
				{
					qqVideos = queryOfQueries("qqVideos","youtubeid IS NOT NULL AND youtubeid != ''");
				} 
				else if(params.hosted eq "both") 
				{
					qqVideos = queryOfQueries("qqVideos","youtubeid IS NOT NULL AND youtubeid != '' AND fileid IS NOT NULL and fileid != ''");
				}
			}
			
			// Apply "category" filter
			if(!isNull(params.filtercategories) AND len(params.filtercategories))
			{
				rememberParams = ListAppend(rememberParams,"filtercategories=#params.filtercategories#","&");				
				var filtercategories = listToArray(params.filtercategories);
				var whereCategories = [];
				
				for(categoryid in filtercategories)
				{
					ArrayAppend(whereCategories, "category_id = #categoryid#");
				}
				
				whereCategories = ArrayToList(whereCategories, " OR ");
				
				qqVideos = queryOfQueries(
					query	= "qqVideos",
					where	= whereCategories
				);
			}
			
			// Clear out the duplicates
			qqVideos = queryOfQueries(
				query	= "qqVideos", 
				select	= "DISTINCT #distinctVideoColumns#", 
				order	= session.videos.sortby & " " & session.videos.order
			);
			
			qVideos = qqVideos;
			
			if(len(rememberParams))
			{
				pagination.setAppendToLinks("&#rememberParams#");
			}
			
			//renderPage(route="admin~Action", module="admin", controller="videos", action="index");		
		}
	}
	function uploadVideoImage(field,video)
	{
		var loc = {};
		loc.video = arguments.video;
		
		if(!isNull(loc.video.id))
		{							
			var result = fileUpload(getTempDirectory(),arguments.field, "image/*", "makeUnique");
			if(result.fileWasSaved) {
				var theFile = result.serverdirectory & "/" & result.serverFile;
				var newFile = expandPath("#info.uploadsPath#videos/thumbs/#loc.video.id#.jpg");
				var fullFile = expandPath("#info.uploadsPath#videos/thumbs/#loc.video.id#_full.jpg");
				if(!isImageFile(thefile)) {
					fileDelete(theFile);
					return false;
				} else {					
					var img = imageRead(thefile);
					try {
						imageWrite(img,fullFile,1);
						imageScaleToFit(img, 250, 250);
						imageWrite(img,newFile,1);
						fileDelete(theFile);
					} catch(e) {
						return false;
					}
					return true;
				}
			} else return false;			
		}
	}
}
</cfscript>