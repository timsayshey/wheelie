<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{						
			// Properties
			this.setWhere = setWhere;	
			
			// Relations		
			belongsTo(name="User", foreignKey="ownerid", joinKey="id", joinType="inner");
			
			// Other
			super.init();
		}		
		function setWhere()
		{ 
			return wherePermission('order');
		}	
	</cfscript>	
</cfcomponent>
	