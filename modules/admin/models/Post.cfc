<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{									
			// Properties
			property(name="postType", defaultValue="post");						
			this.setWhere = setWhere;	
			
			// Set
			table("posts");
			
			// Validations
			validatesUniquenessOf(property="urlid", scope="siteid");
			validatesPresenceOf(property="urlid", when="onCreate");
			
			// Relations
			hasOne(name="user",foreignKey="id");
			belongsTo(name="user",foreignKey="createdBy");
			
			// Other
			super.init();			
			beforeSave("sanitizeNameAndURLId");
		}	
		function setWhere()
		{
			return "postType='post'#wherePermission('Post','AND')#";
		}	
	}
</cfscript>	