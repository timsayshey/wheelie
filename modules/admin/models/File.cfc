<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			super.init();
			
			belongsTo(name="Video",foreignKey="videofileid");
		}					
	</cfscript>
	
</cfcomponent>
	