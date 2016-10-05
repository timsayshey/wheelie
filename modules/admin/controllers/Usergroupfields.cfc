<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index()
	{	
		if(!isNull(params.id))
		{
			usergroupfields = model("UsergroupField").findAll(where="usergroupid = #params.id#", order="sortorder ASC");
		}
	}	
	
	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);
				
		for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
		{
			fieldValue = orderValues[i];
			
			UsergroupField = model("UsergroupField").findOne(where="id = #fieldValue.fieldId#");
					
			if(isObject(UsergroupField))
			{
				UsergroupField.update(sortorder=fieldValue.newIndex,validate=false);
			}
		}
		abort;
	}
	
	function toggleRecord()
	{
		var loc = {};
		usergroupfields = model("UsergroupField").findByKey(params.id);
		if(usergroupfields[params.col] eq 1)
		{
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}
		
		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		usergroupfields.update(loc.newInsert);		
		
		flashInsert(success="Usergroup fields updated successfully.");
		redirectTo(route="admin~Index", controller="usergroups");
	}
	
	function new()
	{
		// Queries
		usergroupfield = model("UsergroupField").new(colStruct("UsergroupField"));
		
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
			usergroupfield = model("UsergroupField").findAll(where="id = '#params.id#'#wherePermission("Usergroup","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(usergroupfield))
			{				
				usergroupfield = usergroupfield[1];
			}
			
			// Usergroup not found?
			if (!IsObject(usergroupfield))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~id", module="admin", controller="UsergroupFields", action="index", id=params.usergroupid);
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		// Get usergroup object
		if(!isNull(params.usergroupfield.id)) 
		{
			usergroupfield = model("UsergroupField").findByKey(params.usergroupfield.id);
			saveResult = usergroupfield.update(params.usergroupfield);
		} else {
			usergroupfield = model("UsergroupField").new(params.usergroupfield);
			saveResult = usergroupfield.save();
			isNewUsergroupfield = true;
		}
		
		// Insert or update usergroup object with properties
		if (saveResult)
		{	
			flashInsert(success='Field saved.');
			redirectTo(route="admin~Id", module="admin", controller="usergroupfields", action="edit", id=usergroupfield.id, params="usergroupid=#usergroupfield.usergroupid#");
		} else {						
			
			errorMessagesName = "usergroupfield";
			param name="usergroupfield.id" default="0";
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="UsergroupFields", action="editor");		
		}		
	}
	
	function delete()
	{
		usergroups = model("UsergroupField").findByKey(params.id);
		
		if(usergroups.delete())
		{
			flashInsert(success="The field was deleted successfully.");							
		} else 
		{
			flashInsert(error="The field could not be found.");
		}
		
		redirectTo(route="admin~id", module="admin", controller="UsergroupFields", action="index", id=params.usergroupid);
	}
}
</cfscript>