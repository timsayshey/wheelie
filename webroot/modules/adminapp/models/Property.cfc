<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{						
			// Properties
			this.setWhere = setWhere;	
			
			// Relations		
			belongsTo(name="PropertyCategoryJoin", foreignKey="id", joinKey="propertyid", joinType="inner");
			belongsTo(name="User", foreignKey="ownerid", joinKey="id", joinType="inner");
			
			beforeValidation("sanitizePrice");
			afterFind("sanitizePrice");
			beforeSave("sanitizeNameAndURLId");	
			validatesUniquenessOf(property="address");
			validatesUniquenessOf(property="urlid");
			
			// Other
			super.init(); 			
		}		
		function setWhere()
		{
			return wherePermission('Property');
		}		
		function sanitizePrice()
		{
			if(!isNull(this.price))
			{
				this.price = cleanNumber(this.price,true);
				if(isNumeric(this.price)) {
					this.price = NumberFormat(this.price,"0.00");
				} else {
					this.price = 0;
				}
			}
		}	
	</cfscript>	
</cfcomponent>
	