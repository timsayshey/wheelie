<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Other
			super.init();
			
			// Properties
			property(name="categoryType", defaultValue="user");						
			this.setWhere = setWhere;	
			
			// Set
			table("categories");
			
			// Relations
			hasMany("UserTagJoins");
			
			// Validations
			validatesUniquenessOf(property="urlid", scope="siteid");
			
			// Other		
			beforeSave("sanitizeNameAndURLId");
		}		
		
		function setWhere()
		{
			return "categoryType='user'#wherePermission('Category','AND')#";
		}	
		
		function categoryInfo()
		{
			return {
				singular		= "User Tag",
				plural			= "User Tags",
				singularShort	= "Tag",
				pluralShort		= "Tags"
			};
		}		
	</cfscript>	
</cfcomponent>
	