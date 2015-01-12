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
			beforeSave("sanitizeContentForMysql");
		}	
		function setWhere()
		{
			return "postType='post'#wherePermission('Post','AND')#";
		}	
		function sanitizeContentForMysql()
		{
			if(!isNull(this.content))
			{
				this.content = CharsetDecode(this.content, "windows-1252");
				this.content = CharsetEncode(this.content, "utf-8");
				
				// Strip all those bad characters
				this.content = rereplace(this.content,"[^\x00-\x7F]","","all");
			}
		}
	}
</cfscript>	