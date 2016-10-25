<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("metafields");
			property(name="metafieldType", defaultValue="propertyfield");
			
			// Other
			super.init();
			
			// Properties				
			this.setWhere = setWhere;	 
			
			// Relations			
			hasOne(name="FieldData", foreignKey="fieldid", joinType="outer");
			hasMany(name="FieldDatas", foreignKey="fieldid", joinType="outer");
			
			// Map column
			//property(name="propertyid", column="propertyid")
			
			validatesUniquenessOf(property="identifier", scope="siteid");
			// validatesPresenceOf(property="identifier", when="onCreate");
			beforeSave("sanitizeIdentifier");
			
		}	
		
		// Clean strings
		private function sanitizeIdentifier()
		{
			if(!isNull(this.identifier) AND len(this.identifier))
			{		
				this.identifier = lcase(cleanUrlId(this.identifier));		
			} else if (!isNull(this.name) AND len(this.name)) {
				this.identifier = lcase(cleanUrlId(this.name));
			}
		}	
		
		function setWhere()
		{
			return "metafieldType='property'#wherePermission('Propertyfield','AND')#";
		}	
		
		function metafieldInfo()
		{
			return {
				singular		= "Property",
				plural			= "Propertys",
				singularShort	= "Field",
				pluralShort		= "Fields"
			};
		}	
	</cfscript>	
</cfcomponent>	