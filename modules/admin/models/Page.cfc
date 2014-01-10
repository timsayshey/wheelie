<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{									
			// Properties
			property(name="postType", defaultValue="page");			
			defaultScope(where="postType='page'#wherePermission('Page','AND')#");
			
			// Set
			table("posts");
			
			// Validations
			validatesUniquenessOf(property="urlid");
			validatesPresenceOf(property="urlid", when="onCreate");
			
			// Other
			super.init();			
			beforeSave("sanitizeNameAndURLId");
		}		
	}
</cfscript>	