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
			propertyfields = model("PropertyField").findAll(where="propertyid = #params.id#", order="sortorder ASC");
		}
	}	
	
	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);
				
		for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
		{
			fieldValue = orderValues[i];
			
			PropertyField = model("PropertyField").findOne(where="id = #fieldValue.fieldId#");
					
			if(isObject(PropertyField))
			{
				PropertyField.update(sortorder=fieldValue.newIndex,validate=false);
			}
		}
		abort;
	}
	
	function toggleRecord()
	{
		var loc = {};
		propertyfields = model("PropertyField").findByKey(params.id);
		if(propertyfields[params.col] eq 1)
		{
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}
		
		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		propertyfields.update(loc.newInsert);		
		
		flashInsert(success="Property fields updated successfully.");
		redirectTo(route="admin~Index", controller="propertys");
	}
	
	function new()
	{
		// Queries
		propertyfield = model("PropertyField").new(colStruct("PropertyField"));
		
		// If not allowed redirect
		wherePermission("Property");
		
		// Show property
		renderPage(action="editor");
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			propertyfield = model("PropertyField").findAll(where="id = '#params.id#'#wherePermission("Property","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(propertyfield))
			{				
				propertyfield = propertyfield[1];
			}
			
			// Property not found?
			if (!IsObject(propertyfield))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~id", module="admin", controller="PropertyFields", action="index", id=params.propertyid);
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		// Get property object
		if(!isNull(params.propertyfield.id)) 
		{
			propertyfield = model("PropertyField").findByKey(params.propertyfield.id);
			saveResult = propertyfield.update(params.propertyfield);
		} else {
			propertyfield = model("PropertyField").new(params.propertyfield);
			saveResult = propertyfield.save();
			isNewPropertyfield = true;
		}
		
		// Insert or update property object with properties
		if (saveResult)
		{	
			flashInsert(success='Field saved.');
			redirectTo(route="admin~Id", module="admin", controller="propertyfields", action="edit", id=propertyfield.id, params="propertyid=#propertyfield.propertyid#");
		} else {						
			
			errorMessagesName = "propertyfield";
			param name="propertyfield.id" default="0";
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="PropertyFields", action="editor");		
		}		
	}
	
	function delete()
	{
		propertys = model("PropertyField").findByKey(params.id);
		
		if(propertys.delete())
		{
			flashInsert(success="The field was deleted successfully.");							
		} else 
		{
			flashInsert(error="The field could not be found.");
		}
		
		redirectTo(route="admin~id", module="admin", controller="PropertyFields", action="index", id=params.propertyid);
	}
}
</cfscript>