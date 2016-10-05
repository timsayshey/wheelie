<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Set
			table("videos_categories");
			
			// Relations
			belongsTo(name="Video", foreignKey="videoid");
			belongsTo(name="VideoCategory", foreignKey="videocategoryid", joinType="outer");	
		}					
	</cfscript>
	
</cfcomponent>