<cfcomponent extends="models.Model">
	<cfscript>					
		function init() 
		{
			super.init();
			this.setWhere = setWhere;
			belongsTo(name="AllPost", foreignKey="itemid", joinType="outer");
		}	
		function setWhere()
		{
			return wherePermission('todo');
		}
	</cfscript>	 
</cfcomponent>
	 