<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Set
			table("properties_categories");
			
			// Relations
			belongsTo(name="Property", foreignKey="propertyid");
			belongsTo(name="PropertyCategory", foreignKey="categoryid", joinType="inner");	
		}					
	</cfscript>
	
</cfcomponent>