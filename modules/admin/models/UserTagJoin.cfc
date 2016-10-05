<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Set
			table("users_categories");
			
			// Relations
			belongsTo(name="User", foreignKey="userid");
			belongsTo(name="UserTag", foreignKey="categoryid");
		}					
	</cfscript>
	
</cfcomponent>