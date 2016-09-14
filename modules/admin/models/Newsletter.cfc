<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{												
			// Set
			table("newsletters");
						
			// Relations
			hasMany(name="NewsletterSections",foreignKey="id");
			belongsTo(name="NewsletterSection",foreignKey="id");
			
			// Other
			super.init();			
		}		
	}
</cfscript>	