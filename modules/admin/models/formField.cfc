<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("metafields");
			property(name="metafieldType", defaultValue="formfield");
			
			// Other
			super.init();
			
			// Properties				
			this.setWhere = setWhere;	 
			
			// Relations			
			hasOne(name="FieldData", foreignKey="fieldid", joinType="outer");
			hasMany(name="FieldDatas", foreignKey="fieldid", joinType="outer");
			
			// Map column
			//property(name="formid", column="formid")
		}		
		
		function setWhere()
		{
			return "metafieldType='formfield'#wherePermission('formfield','AND')#";
		}	
		
		function metafieldInfo()
		{
			return {
				singular		= "form",
				plural			= "forms",
				singularShort	= "Field",
				pluralShort		= "Fields"
			};
		}	
	</cfscript>	
</cfcomponent>
	