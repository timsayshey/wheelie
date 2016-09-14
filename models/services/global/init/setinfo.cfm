<cffunction name="fixFilePathSlashes" output="no">		
	<cfargument name="dirtystring">
	
	<cfscript>
		cleanstring = replace(dirtystring,"\/","\","ALL");	
		cleanstring = replace(cleanstring,"\\","\","ALL");	
		cleanstring = replace(cleanstring,"//","\","ALL");	
		cleanstring = replace(cleanstring,"/","\","ALL");	
	</cfscript>
	
	<cfreturn cleanstring>
</cffunction>

<cfscript>
	/* Globlal data */
	fileroot = expandPath("/");
	privateroot = expandPath("../");
	
	info.validCategoryModelsList = "itemcategory,propertycategory"; // lowercase
	info.serverIp = "";
	
	info.adminUrlPath = "/manager";
	info.domainshort = cgi.HTTP_HOST;
	siteUrl 		 = info.domainshort;
	info.domain		 = "http://#info.domainshort#";
	info.rootPath    = "/";
	info.assetsPath  = "/assets/";
	info.imagesPath  = "/assets/img/";
	info.uploadsPath = "/assets/uploads/";		
	info.videosPath  = "/assets/uploads/videos/";
	info.mediaPath   = "/assets/uploads/media/";
	info.videoThumbPath   = "/assets/uploads/videos/thumbs/";	
	info.privateRootPath  = "/privatedata/";	
	
	info.privateroot    = fixFilePathSlashes("#privateroot##info.privateRootPath#");
	info.fileroot    	= fixFilePathSlashes("#fileroot#");
	info.fileassets 	= fixFilePathSlashes("#fileroot##info.assetsPath#");
	info.fileimages  	= fixFilePathSlashes("#fileroot##info.imagesPath#");
	info.fileuploads 	= fixFilePathSlashes("#fileroot##info.uploadsPath#");		
	info.filevideos 	= fixFilePathSlashes("#fileroot##info.videosPath#");
	info.fileVideoThumbs= fixFilePathSlashes("#fileroot##info.videoThumbPath#");
	info.filemedia	 	= fixFilePathSlashes("#fileroot##info.mediaPath#");		
	
	if (isNull(Application.info) OR !isNull(url.reload))
	{	
		Application.info = info; // Set for ckeditor filemanager
	}
	
	// Set Admin Filter Defaults
	
	function filterDefaults()
	{
		// Filter defaults
		param name="params.status" default="all";
		param name="session.perPage" default="9";
		param name="session.display" default="grid";		
		param name="params.search" default="";
		param name="params.hosted" default="";
		param name="params.filtercategories" default="";
		
		param name="params.p" default="1";
		
		// Video filter defaults
		param name="session.videos.sortby" default="sortorder";
		param name="session.videos.order" default="asc";		
		
		// Item filter defaults
		param name="session.items.sortby" default="sortorder";
		param name="session.items.order" default="asc";
		
		// User filter defaults
		param name="session.users.sortby" default="firstname";
		param name="session.users.order" default="asc";
		
		// Page filter defaults
		param name="session.pages.sortby" default="name";
		param name="session.pages.order" default="asc";

		// Page filter defaults
		param name="session.pageblocks.sortby" default="name";
		param name="session.pageblocks.order" default="asc";
		
		// Post filter defaults
		param name="session.posts.sortby" default="name";
		param name="session.posts.order" default="asc";
		
		// Option filter defaults
		param name="session.options.sortby" default="label";
		param name="session.options.order" default="asc";
		
		// App specific
		include "/models/services/global/app/filterDefaults.cfm";
	}
	
	// Usually called when a user clicks the clear button
	function resetIndexFilters()
	{
		session.perPage = "10";
		//session.display = "grid";
		params.p = "1";		
		params.filtercategories = "";	
		params.search = "";
		params.hosted = "youtube";
		
		// Video filter defaults
		session.videos.sortby = "sortorder";
		session.videos.order = "asc";
		
		// Item filter defaults
		session.items.sortby = "sortorder";
		session.items.order = "asc";
		
		// User filter defaults
		session.users.sortby = "firstname";
		session.users.order = "asc";
		
		// Page filter defaults
		session.pages.sortby = "name";
		session.pages.order = "asc";

		// Page filter defaults
		session.pageblocks.sortby = "name";
		session.pageblocks.order = "asc";
		
		// Option filter defaults
		session.options.sortby = "label";
		session.options.order = "asc";
		
		// App specific
		include "/models/services/global/app/resetIndexFilters.cfm";
		
		Location(cgi.http_referer,false);
	}
</cfscript>