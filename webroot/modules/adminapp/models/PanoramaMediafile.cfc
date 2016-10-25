<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("mediafiles");
			property(name="mediafileType", defaultValue="panorama");
			
			// Other
			super.init();
			
			// Properties				
			this.setWhere = setWhere;
		}
		
		function setWhere()
		{
			return "mediafileType='panorama'#wherePermission('property','AND')#";
		}	
		
		function mediafileInfo()
		{
			return {
				singular		= "Panorama",
				plural			= "Panoramas",
				singularShort	= "Pano",
				pluralShort		= "Panos"
			};
		}	
	</cfscript>	
</cfcomponent>	