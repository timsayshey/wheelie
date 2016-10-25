<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{									
			// Properties
			property(name="postType", defaultValue="pageblock");		
			this.setWhere = setWhere;	
			
			// Set
			table("posts");
			
			// Validations
			validatesPresenceOf(property="name");
			validatesPresenceOf(property="content");
			
			// Other
			super.init();			
			beforeSave("sanitizeContentForMysql");
		}
		function setWhere()
		{
			return "postType='pageblock'#wherePermission('PageBlock','AND')#";
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