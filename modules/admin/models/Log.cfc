<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{		
			super.init();	
			hasOne("User");
			belongsTo(name="User");
		}			
	}
</cfscript>	