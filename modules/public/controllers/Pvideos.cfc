<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function video()
	{	
		if(!isNull(params.id)) 
		{
			video = model("Video").findAll(where="#whereSiteid()# AND urlid LIKE '#params.id#' AND onSite = 1");
			
			if(!isNull(params.password) AND params.password eq video.password)
			{
				session.videoaccess[video.id] = true;
			}
			else if(!isNull(params.password))
			{
				flashInsert(error="Oops, that password was incorrect. Please try again.");			
			}
		}
	}
	
	function category()
	{				
		if(!isNull(params.id))
		{			
			// Get single category
			categoryWhere = "urlid = '#params.id#' AND #whereSiteid()#";
			isSingleCategory = true;
			videoLimitPerCategory = 99999;						
		} else {
			// Get default category
			videoCategory = model("VideoCategory").findAll(where="#whereSiteid()# AND defaultpublic = 1");
			categoryWhere = "parentid = '#videoCategory.id#' AND #whereSiteid()#";
			isSingleCategory = false;
			videoLimitPerCategory = 4;
		}
		
		qCategoryOfVideos = model("videocategory").findAll(
			where	= categoryWhere, 
			order	= "sortorder,videocategoryid,videoid",
			include = "videocategoryjoin(video)"
		);
	}
}
</cfscript>