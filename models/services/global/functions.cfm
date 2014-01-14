<cfinclude template="/models/services/global/admin/plupload.cfm">
<cfinclude template="/models/services/global/admin/meta.cfm">
<cfinclude template="/models/services/global/admin/shared.cfm">
<cfinclude template="/models/services/global/admin/nestable.cfm">
<cfinclude template="/models/services/global/shared/shared.cfm">
<cfinclude template="/models/services/global/admin/users.cfm">

<cfscript>
	/* Globlal data */
	fileroot = expandPath(".");
	
	info.rootPath    = "/";
	info.assetsPath  = "/assets/";
	info.imagesPath  = "/assets/images/";
	info.uploadsPath = "/assets/uploads/";		
	info.videosPath  = "/assets/uploads/videos/";
	info.mediaPath   = "/assets/uploads/media/";
	
	info.fileroot    = fixFilePathSlashes("#fileroot#");
	info.fileassets  = fixFilePathSlashes("#fileroot##info.assetsPath#");
	info.fileimages  = fixFilePathSlashes("#fileroot##info.imagesPath#");
	info.fileuploads = fixFilePathSlashes("#fileroot##info.uploadsPath#");		
	info.filevideos  = fixFilePathSlashes("#fileroot##info.videosPath#");	
	info.filemedia	 = fixFilePathSlashes("#fileroot##info.mediaPath#");	
	
	if (isNull(Application.info))
	{	
		Application.info = info; // Set for ckeditor filemanager
	}
	
	// Table name reference
	tn = {
		files = "files"
	};
	
	if (!isNull(Application.db))
	{
		videoconverter	= application.videoConverter;
		db 				= application.db;
		youtube			= application.yt;
		_				= application._;
		fileMgr			= application.fileMgr;
		pagination 		= application.pagination;
	}
</cfscript>

