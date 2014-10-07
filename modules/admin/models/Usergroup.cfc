<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("usergroups"); 
			
			// Other
			super.init();
			
			// Properties				
			this.setWhere = setWhere;	
			
			// Relations			
			hasOne(name="UsergroupField", foreignKey="usergroupid", joinType="outer");			
			hasMany(name="UsergroupFields", foreignKey="usergroupid", joinType="outer");
		}		
		
		function setWhere()
		{
			return "#wherePermission('Usergroup')#";
		}			
	</cfscript>	
</cfcomponent>
	