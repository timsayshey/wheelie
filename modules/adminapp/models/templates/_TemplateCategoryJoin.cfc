<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Set
			table("@lcasePlural@_categories");
			
			// Relations
			belongsTo(name="@ucaseSingular@", foreignKey="@lcaseSingular@id");
			belongsTo(name="@ucaseSingular@Category", foreignKey="categoryid", joinType="inner");	
		}					
	</cfscript>
	
</cfcomponent>