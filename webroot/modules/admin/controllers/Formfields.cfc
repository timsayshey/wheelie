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
			formfields = model("formField").findAll(where="formid = #params.id#", order="sortorder ASC");
		}
	}	
	
	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);
				
		for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
		{
			fieldValue = orderValues[i];
			
			formField = model("formField").findOne(where="id = #fieldValue.fieldId#");
					
			if(isObject(formField))
			{
				formField.update(sortorder=fieldValue.newIndex,validate=false);
			}
		}
		abort;
	}
	
	function toggleRecord()
	{
		var loc = {};
		formfields = model("formField").findByKey(params.id);
		if(formfields[params.col] eq 1)
		{
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}
		
		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		formfields.update(loc.newInsert);		
		
		flashInsert(success="form fields updated successfully.");
		redirectTo(route="admin~Index", controller="forms");
	}
	
	function new()
	{
		// Queries
		formfield = model("formField").new(colStruct("formField"));
		
		// If not allowed redirect
		wherePermission("form");
		
		// Show form
		renderPage(action="editor");
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			formfield = model("formField").findAll(where="id = '#params.id#'#wherePermission("form","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(formfield))
			{				
				formfield = formfield[1];
			}
			
			// form not found?
			if (!IsObject(formfield))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~id", module="admin", controller="formFields", action="index", id=params.formid);
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		// Get form object
		if(!isNull(params.formfield.id)) 
		{
			formfield = model("formField").findByKey(params.formfield.id);
			saveResult = formfield.update(params.formfield);
		} else {
			formfield = model("formField").new(params.formfield);
			saveResult = formfield.save();
			isNewformfield = true;
		}
		
		// Insert or update form object with properties
		if (saveResult)
		{	
			flashInsert(success='Field saved.');
			redirectTo(route="admin~Id", module="admin", controller="formfields", action="edit", id=formfield.id, params="formid=#formfield.formid#");
		} else {						
			
			errorMessagesName = "formfield";
			param name="formfield.id" default="0";
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="formFields", action="editor");		
		}		
	}
	
	function delete()
	{
		forms = model("formField").findByKey(params.id);
		
		if(forms.delete())
		{
			flashInsert(success="The field was deleted successfully.");							
		} else 
		{
			flashInsert(error="The field could not be found.");
		}
		
		redirectTo(route="admin~id", module="admin", controller="formFields", action="index", id=params.formid);
	}
}
</cfscript>