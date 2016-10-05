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
			validatesPresenceOf(property="name", when="onCreate");
			
			// Other
			super.init();			
			beforeSave("sanitizeNameAndURLId");
			beforeSave("sanitizeContentForMysql");
		}
		function setWhere()
		{
			return "postType='page'#wherePermission('Page','AND')#";
		}		
		function sanitizeContentForMysql()
		{
			if(!isNull(this.content))
			{
				this.content = CharsetDecode(this.content, "windows-1252");
				this.content = CharsetEncode(this.content, "utf-8");
				this.content = rereplace(this.content,"[^\x00-\x7F]","","all");
			}
		}
	}
</cfscript>	