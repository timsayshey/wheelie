<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{									
			// Properties
			property(name="postType", defaultValue="page");		
			this.setWhere = setWhere;	
			
			// Set
			table("posts");
			
			// Validations
			validatesUniquenessOf(property="urlid", scope="siteid");
			validatesPresenceOf(property="urlid", when="onCreate");
			
			// Other
			super.init();			
			beforeSave("sanitizeNameAndURLId");
		}
		function setWhere()
		{
			return "postType='page'#wherePermission('Page','AND')#";
		}		
	}
</cfscript>	