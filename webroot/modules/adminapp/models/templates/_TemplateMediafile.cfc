<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("mediafiles");
			property(name="mediafileType", defaultValue="@lcaseSingular@");
			
			// Other
			super.init();
			
			// @ucasePlural@				
			this.setWhere = setWhere;
		}
		
		function setWhere()
		{
			return "mediafileType='@lcaseSingular@'#wherePermission('@lcaseSingular@','AND')#";
		}	
		
		function mediafileInfo()
		{
			return {
				singular		= "@ucaseSingular@",
				plural			= "@ucasePlural@",
				singularShort	= "@ucaseSingular@",
				pluralShort		= "@ucasePlural@"
			};
		}	
	</cfscript>	
</cfcomponent>	