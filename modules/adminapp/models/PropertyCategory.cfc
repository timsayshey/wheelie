<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Properties
			property(name="categoryType", defaultValue="property");			
			this.setWhere = setWhere();	
			
			// Set
			table("categories");
			
			// Relations
			hasMany("PropertyCategoryJoins");
			belongsTo(name="PropertyCategoryJoin", foreignKey="id", joinKey="categoryid", joinType="inner");
			
			// Validations
			validatesUniquenessOf(property="urlid", scope="siteid");
			validatesUniquenessOf(property="name", scope="siteid");
			
			// Other
			beforeSave("sanitizeNameAndURLId");
		}	
		
		function setWhere()
		{
			return "categoryType='property'#wherePermission('Category','AND')#";
		}				
		
		function categoryInfo()
		{
			return {
				singular		= "Property Category",
				plural			= "Property Categories",
				singularShort	= "Category",
				pluralShort		= "Categories"
			};
		}
	</cfscript>	
</cfcomponent>
	