<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{		
			super.init();	
			hasOne("User");
			belongsTo(name="User");
			this.setWhere = setWhere;
		}	
		function setWhere()
		{
			return wherePermission('log');
		}		
	}
</cfscript>	