<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("metafields");
			property(name="metafieldType", defaultValue="usergroupfield");
			
			// Other
			super.init();
			
			// Properties				
			this.setWhere = setWhere;	 
			
			// Relations			
			hasOne(name="FieldData", foreignKey="fieldid", joinType="outer");
			hasMany(name="FieldDatas", foreignKey="fieldid", joinType="outer");
			
			// Map column
			//property(name="usergroupid", column="usergroupid")
			
			validatesUniquenessOf(property="identifier", scope="siteid");
			validatesPresenceOf(property="identifier", when="onCreate");
			beforeSave("sanitizeIdentifier");
			
		}	
		
		// Clean strings
		private function sanitizeIdentifier()
		{
			if(!isNull(this.identifier) AND len(this.identifier))
			{		
				this.identifier 	= lcase(cleanUrlId(this.identifier));		
			}
		}	
		
		function setWhere()
		{
			return "metafieldType='usergroup'#wherePermission('Usergroupfield','AND')#";
		}	
		
		function metafieldInfo()
		{
			return {
				singular		= "Usergroup",
				plural			= "Usergroups",
				singularShort	= "Field",
				pluralShort		= "Fields"
			};
		}	
	</cfscript>	
</cfcomponent>	