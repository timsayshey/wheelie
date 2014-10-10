<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Set
			table("videos_categories");
			
			// Relations
			belongsTo("Video");
			belongsTo("VideoCategory");
		}					
	</cfscript>
	
</cfcomponent>