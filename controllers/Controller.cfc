<cfscript>
	component extends="Wheels" 
	{
		function init()
		{
			filters(through="setLogInfo");	
		}
		
		private function setLogInfo() 
		{			
			var loc = {};
			loc.loguserid = "";
			
			if(!isNull(session.user.id))
			{
				loc.loguserid = session.user.id;
			}
			
			request.logit = 
			{
				userId		= loc.loguserid,
				controller	= params.controller,
				action		= params.action,
				modelid		= "", // set later in Model.cfc
				model		= "", // set later in Model.cfc
				savetype	= "", // set later in Model.cfc
				createdat	= $convertToString(now())
			};
			
		}
	}
</cfscript>