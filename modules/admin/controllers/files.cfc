<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index()
	{
		qVideos = model("File").findAll();
		
		if(!isNull(params.token))
		{
			video = model("File").findAll(where="id = #params.id#");
		}
	}	
	
	function videoConfirmModal()
	{
		usesLayout("/layouts/layout.blank");	
		if(!isNull(params.baseOauthUrl))
		{
			video 		 	 = model("File").findByKey(params.id);
			baseOauthUrlFull = params.baseOauthUrl;
		}
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			video 		= model("File").findByKey(params.id);
			
			// Video not found?
			if (!IsObject(video))
			{
				flashInsert(error="Not found");
				redirectTo(action="index");
			}			
		}
		
		renderView(action="editor");
		
	}

	function delete()
	{
		video = model("File").findByKey(params.id);
		
		if(video.delete())
		{
			flashInsert(success="The video was deleted successfully.");							
		} else 
		{
			flashInsert(error="The video could not be found.");
		}
		
		redirectTo(
			route="moduleIndex",
			module="admin",
			controller="files"
		);
	}
	
	function restDelete()
	{
		video = model("File").findByKey(params.id);
		
		try {
			if(video.delete())
			{
				writeOutput('{ "Message" : "", "Success" : true }');
			} else {
				writeOutput('{ "Message" : "", "Success" : false }');
			}
		} catch(e) {
			writeOutput('{ "Message" : "", "Success" : false }');
		}
		abort;
	}

	function save()
	{							
		param name="params.video.id" default="";
		
		// If submit button was trash then delete it
		if(!isNull(params.submit) and params.submit eq "trash")
		{
			params.id = params.video.id;
			delete();
		}
				
		// Enter video via youtube URL
		if(!isNull(params.video.youtubeId) OR !isNull(params.youtubeId))
		{
			if(!isNull(params.youtubeId)) 
			{
				params.video.youtubeId = params.youtubeId;
			}
			
			params.video.youtubeId = XMLFormat(trim(params.video.youtubeId));					
			params.video.filename = params.video.youtubeId;			
			params.video.filetype = "video";
			
			// If youtube thumb is selected, save the image
			if(!isNull(params.thumbid))
			{
				model("Video").saveYoutubeThumb(
					params.video.youtubeId,
					"http://i1.ytimg.com/vi/#params.thumbid#/hqdefault.jpg"
				);
			}
		}
		
		// Get video object
		if(!isNull(params.video.id)) {
			video = model("File").findByKey(params.video.id);
			saveResult = video.update(params.video);
		} else {
			video = model("File").new(params.video);
			saveResult = video.save();
		}
		
		// Insert or update video object with properties
		if (saveResult)
		{					
			flashInsert(success="Saved successfully.");
		} else {			
			flashInsert(error="There was an error.");	
		}
		
		// If called from js return json
		if (isDefined("params.returnJSON")) { 
			writeOutput(SerializeJSON({ videoid = video.id, name = video.filename })); abort; 			
		}	
		
		// Go Home
		index();
		renderView(route="moduleAction", module="admin", controller="files",action="index");		
	}
	
	function preHandler()
	{
		super.preHandler();
		
		param name="params.context" default="";
	}
}
</cfscript>