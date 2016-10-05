<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{										
			super.init();
			this.setWhere = setWhere;
			table("posts");
			hasOne(name="Menu", foreignKey="itemId");
		}
		function setWhere()
		{
			return "postType='post'#wherePermission('Post','AND')#";
		}		
	}
</cfscript>	