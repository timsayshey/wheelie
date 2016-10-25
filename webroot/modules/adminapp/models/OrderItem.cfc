<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{						
			// Properties
			this.setWhere = setWhere;	
			
			// Relations		
			belongsTo(name="Order", foreignKey="id", joinKey="orderid", joinType="inner");
			belongsTo(name="User", foreignKey="ownerid", joinKey="id", joinType="inner");
			
			beforeValidation("sanitizePrice");
			afterFind("sanitizePrice");				
			
			// Other
			super.init(); 			
		}		
		function setWhere()
		{
			return wherePermission('order');
		}		
		function sanitizePrice()
		{
			if(!isNull(this.price))
			{
				this.price = cleanNumber(this.price);
				this.price = NumberFormat(this.price,"0.00");
			}
		}	
	</cfscript>	
</cfcomponent>
	