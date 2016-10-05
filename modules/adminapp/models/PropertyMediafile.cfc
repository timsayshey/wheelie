<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("mediafiles");
			property(name="mediafileType", defaultValue="property");
			
			// Other
			super.init();
			
			// Properties				
			this.setWhere = setWhere;
		}
		
		function setWhere()
		{
			return "mediafileType='property'#wherePermission('property','AND')#";
		}	
		
		function mediafileInfo()
		{
			return {
				singular		= "Property",
				plural			= "Properties",
				singularShort	= "Property",
				pluralShort		= "Properties"
			};
		}	
	</cfscript>	
</cfcomponent>	