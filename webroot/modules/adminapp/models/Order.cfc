<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{						
			// Properties
			this.setWhere = setWhere;	
			
			// Relations
			hasOne(name="ordertransaction", foreignKey="orderid", joinKey="id", joinType="inner");
			hasMany(name="orderitems", foreignKey="orderid", joinKey="id", joinType="inner");
			belongsTo(name="User", foreignKey="customerid", joinKey="id", joinType="inner");
			
			// Other
			super.init();
		}		
		function setWhere()
		{
			return wherePermission('order');
		}	
	</cfscript>	
</cfcomponent>
	