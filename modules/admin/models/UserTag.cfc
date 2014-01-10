<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Other
			super.init();
			
			// Properties
			property(name="categoryType", defaultValue="user");			
			defaultScope(where="categoryType='user'#wherePermission('Category','AND')#");
			
			// Set
			table("categories");
			
			// Relations
			hasMany("UserTagJoins");
			
			// Validations
			validatesUniquenessOf(property="urlid");
			
			// Other		
			beforeSave("sanitizeNameAndURLId");
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
	