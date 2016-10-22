<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("metafields");
			@lcaseSingular@(name="metafieldType", defaultValue="@lcaseSingular@field");
			
			// Other
			super.init();
			
			// @ucasePlural@				
			this.setWhere = setWhere;	 
			
			// Relations			
			hasOne(name="FieldData", foreignKey="fieldid", joinType="outer");
			hasMany(name="FieldDatas", foreignKey="fieldid", joinType="outer");
			
			// Map column
			//@lcaseSingular@(name="@lcaseSingular@id", column="@lcaseSingular@id")
			
			validatesUniquenessOf(@lcaseSingular@="identifier", scope="siteid");
			// validatesPresenceOf(@lcaseSingular@="identifier", when="onCreate");
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
			return "metafieldType='@lcaseSingular@'#wherePermission('@ucaseSingular@field','AND')#";
		}	
		
		function metafieldInfo()
		{
			return {
				singular		= "@ucaseSingular@",
				plural			= "@ucaseSingular@s",
				singularShort	= "Field",
				pluralShort		= "Fields"
			};
		}	
	</cfscript>	
</cfcomponent>	