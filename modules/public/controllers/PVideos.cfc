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
			video = model("Video").findAll(where="#whereSiteid()# AND id = '#params.id#' AND onSite = 1");
			
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
}
</cfscript>