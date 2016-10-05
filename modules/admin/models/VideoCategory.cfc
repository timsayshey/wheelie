<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			// Properties
			property(name="categoryType", defaultValue="video");			
			this.setWhere = setWhere;	
			
			// Set
			table("categories");
			
			// Relations
			belongsTo(name="VideoCategoryJoin", foreignKey="id", joinKey="videocategoryid", joinType="outer");
			hasMany("VideoCategoryJoins");
			
			// Validations
			validatesUniquenessOf(property="urlid", scope="siteid");
			
			// Other
			beforeSave("sanitizeNameAndURLId");
		}	
		
		function setWhere()
		{
			return "categoryType='video'#wherePermission('Category','AND')#";
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
	