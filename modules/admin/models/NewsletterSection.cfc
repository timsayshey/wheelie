<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{												
			// Set
			table("newsletter_sections");
						
			// Relations
			hasOne(name="Newsletter",foreignKey="newsletterid");
			belongsTo(name="Newsletter",foreignKey="newsletterid");
			
			// Other
			super.init();			
		}		
	}
</cfscript>	