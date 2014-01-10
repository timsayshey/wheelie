<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Properties
			property(name="categoryType", defaultValue="video");			
			defaultScope(where="categoryType='video'#wherePermission('Category','AND')#");
			
			// Set
			table("categories");
			
			// Relations
			hasMany("VideoCategoryJoins");
			
			// Validations
			validatesUniquenessOf(property="urlid");
			
			// Other
			beforeSave("sanitizeNameAndURLId");
		}					
		
		function categoryInfo()
		{
			return {
				singular		= "Video Category",
				plural			= "Video Categories",
				singularShort	= "Category",
				pluralShort		= "Categories"
			};
		}
	</cfscript>	
</cfcomponent>
	