<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{									
			// Properties
			property(name="postType", defaultValue="post");			
			defaultScope(where="postType='post'#wherePermission('Post','AND')#");
			
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