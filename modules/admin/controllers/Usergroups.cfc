<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index()
	{	
		usergroups = model("usergroup").findAll();
	}	
	
	function toggleRecord()
	{
		var loc = {};
		usergroups = model("usergroup").findByKey(params.id);
		if(usergroups[params.col] eq 1)
		{
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}
		
		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		usergroups.update(loc.newInsert);		
		
		flashInsert(success="Usergroup updated successfully.");
		redirectTo(route="admin~Index", controller="usergroups");
	}
	
	function new()
	{
		// Queries
		usergroup = model("Usergroup").new(colStruct("Usergroup"));
		
		// If not allowed redirect
		wherePermission("Usergroup");
		
		// Show usergroup
		renderPage(action="editor");
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			usergroup = model("Usergroup").findAll(where="id = '#params.id#'#wherePermission("Usergroup","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(usergroup))
			{				
				usergroup = usergroup[1];
			}
			
			// Usergroup not found?
			if (!IsObject(usergroup))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="usergroups");
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		// Get usergroup object
		if(!isNull(params.usergroup.id)) 
		{
			usergroup = model("Usergroup").findByKey(params.usergroup.id);
			saveResult = usergroup.update(params.usergroup);
		} else {
			usergroup = model("Usergroup").new(params.usergroup);
			saveResult = usergroup.save();
			isNewUsergroup = true;
		}
		
		// Insert or update usergroup object with properties
		if (saveResult)
		{	
			// Reset DefaultPublic
			if(!isNull(usergroup.defaultgroup) AND usergroup.defaultgroup eq 1)
			{
				model("Usergroup").updateAll(defaultgroup=0, where="defaultgroup = 1 AND id != '#usergroup.id#' AND globalized = 0#wherePermission("Usergroup","AND")#");
			}
			
			flashInsert(success='Usergroup saved.');
			redirectTo(route="admin~Id", module="admin", controller="usergroups", action="edit", id=usergroup.id);
		} else {						
			
			errorMessagesName = "usergroup";
			param name="usergroup.id" default="0";
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="usergroups", action="editor");		
		}		
	}
	
	function delete()
	{
		usergroups = model("usergroup").findByKey(params.id);
		
		if(usergroups.delete())
		{
			flashInsert(success="The Usergroup was deleted successfully.");							
		} else 
		{
			flashInsert(error="The Usergroup could not be found.");
		}
		
		redirectTo(route="admin~Index", controller="usergroups");
	}
}
</cfscript>