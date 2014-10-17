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
	fileroot = expandPath(".");
	privateroot = expandPath("../");
	
	info.domainshort = cgi.HTTP_HOST;
	info.domain		 = "http://#info.domainshort#";
	info.rootPath    = "/";
	info.assetsPath  = "/assets/";
	info.imagesPath  = "/assets/img/";
	info.uploadsPath = "/assets/uploads/";		
	info.videosPath  = "/assets/uploads/videos/";
	info.mediaPath   = "/assets/uploads/media/";
	info.videoThumbPath   = "/assets/uploads/videos/thumbs/";	
	info.privateRootPath  = "/Copy/";	
	
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
	
	siteUrl = info.domainshort;
</cfscript>