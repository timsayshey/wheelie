<cfinclude template="/models/services/global/settings.cfm">

<cfinclude template="/models/services/global/admin/plupload.cfm">
<cfinclude template="/models/services/global/admin/meta.cfm">
<cfinclude template="/models/services/global/admin/shared.cfm">
<cfinclude template="/models/services/global/admin/nestable.cfm">
<cfinclude template="/models/services/global/shared/shared.cfm">
<cfinclude template="/models/services/global/shared/utilities.cfm">
<cfinclude template="/models/services/global/shared/forms.cfm">
<cfinclude template="/models/services/global/admin/users.cfm">
<cfinclude template="/models/services/global/shared/redirect.cfm">

<cfscript>
	/* Globlal data */
	fileroot = expandPath(".");
	privateroot = expandPath("../");
	
	info.domainshort = cgi.HTTP_HOST;
	info.domain		 = "http://#info.domainshort#";
	info.rootPath    = "/";
	info.assetsPath  = "/assets/";
	info.imagesPath  = "/assets/images/";
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
	
	// Table name reference
	tn = {
		files = "files"
	};
	
	// Only available after initial run
	if (!isNull(Application.videoConverter))
	{
		videoconverter	= application.videoConverter;
		db 				= application.db;
		youtube			= application.yt;
		_				= application._;
		fileMgr			= application.fileMgr;
		privateFileMgr	= application.privateFileMgr;
		pagination 		= application.pagination;
	}
	
	siteUrl = info.domainshort;
</cfscript>

