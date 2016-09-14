<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Set
			table("forms_users"); 
			
			// Relations
			belongsTo(name="User", foreignKey="userid");
			belongsTo(name="Form", foreignKey="formid");		
			
		}					
	</cfscript>
	
</cfcomponent>