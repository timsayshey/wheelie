<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{		
			super.init();
			this.setWhere = setWhere;	
		}	
		function setWhere()
		{
			return wherePermission('Form');
		}		
	}
</cfscript>	