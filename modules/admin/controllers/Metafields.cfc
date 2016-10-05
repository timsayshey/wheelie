<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();		
	}
	
	function getMetafieldType()
	{
		if(ListFind("usergroupfield,pagefield,formfield,propertyfield",LCase(params.modelName)))
		{
			return params.modelName;
		} else {
			return "";
		}
	}

	function removeFirstChar(string) {
		if(Len(string) GT 0) {
			var n = Len(string)-1;
			return Right(string,n);
		}
		return string;
	}

	function importlistSubmit()
	{
		var linebreak = Chr(13) & Chr(10);
		var metafieldArray = ListToArray(params.importlist,linebreak);		
		
		var sortorder = 1;
		for(var metafield in metafieldArray)
		{
			if(len(metafield)) {
				var typeCheck = left(metafield,1);
				
				var data = { 
					modelid		   = params.modelid,		
					sortorder	   = sortorder++
				};

				// Checkbox
				if(typeCheck eq '/') {
					data.type 		    = 'checkbox';
					data.divwrap 	    = 1;
					data.divclass 	    = 'col-sm-6';
					data.labelplacement = 'after';
					data.styleattribute = 'margin-right:10px;';
					metafield = removeFirstChar(metafield);	
				}

				// Radio options
				if(typeCheck eq '*' AND find("%", metafield)) {
					data.type 		    = 'checkbox-options';
					data.divwrap 	    = 1;
					data.divclass 	    = 'col-sm-6';
					data.labelplacement = 'after';
					data.fieldvalues 	= replace(listLast(metafield,'%'),",",linebreak,"ALL");				
					metafield = listFirst(removeFirstChar(metafield), "%");
				}

				// Radio options
				if(typeCheck eq '+' AND find("%", metafield)) {
					data.type 		    = 'radio';
					data.divwrap 	    = 1;
					data.divclass 	    = 'col-sm-6';
					data.labelplacement = 'after';
					data.fieldvalues 	= replace(listLast(metafield,'%'),",",linebreak,"ALL");				
					metafield = listFirst(removeFirstChar(metafield), "%");
				}

				// Headline
				if(typeCheck eq '-') {
					data.type = 'headline';
					metafield = removeFirstChar(metafield);	
				}

				data.name 		   = metafield;
				data.identifier	   = metafield;	

				var savemetafield = model(getMetafieldType()).new(data);
				var saveResult = savemetafield.save();

				if(arrayLen(savemetafield.allErrors())) {
					writeDump([data,savemetafield.allErrors()]); abort;
				}
			}
		}
		flashInsert(success="Metafields imported successfully!");
		redirectTo(route="admin~Field", controller="metafields", action="index", modelName="propertyfield", params="modelid=3");
	}
	
	function sharedData()
	{
		metafieldInfo = model(getMetafieldType()).metafieldInfo();
		metafieldType = getMetafieldType();
		
		if(!isNull(params.modelid))
		{
			buttonParams = "modelid=#params.modelid#";
		}
		else if (!isNull(params.id))
		{
			buttonParams = "modelid=#params.id#";
		}
		else
		{
			buttonParams = "";	
		}
	}
	
	function index()
	{	
		sharedData();
		
		if(!isNull(params.modelid))
		{	
			metafields = model(getMetafieldType()).findAll(where="modelid = #params.modelid# AND metafieldType = '#getMetafieldType()#'", order="sortorder ASC");
		}
	}	
	
	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);
				
		for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
		{
			fieldValue = orderValues[i];
			
			metaField = model(getMetafieldType()).findOne(where="id = #fieldValue.fieldId#");
					
			if(isObject(metaField))
			{
				metaField.update(sortorder=fieldValue.newIndex,validate=false);
			}
		}
		abort;
	}
	
	function toggleRecord()
	{
		var loc = {};
		metafields = model(getMetafieldType()).findByKey(params.id);
		if(metafields[params.col] eq 1)
		{
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}
		
		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		metafields.update(loc.newInsert);		
		
		flashInsert(success="Fields updated successfully.");
		redirectTo(
			route		= "admin~Field",
			controller	= "metafields",
			action		= "index",
			modelName	= params.modelName, 
			params		= buttonParams
		);
	}
	
	function new()
	{
		sharedData();
		
		// Queries
		metafield = model(getMetafieldType()).new(colStruct(getMetafieldType()));
		
		// If not allowed redirect
		wherePermission("Metafield");
		
		// Show meta
		renderPage(action="editor");
	}
	
	function edit()
	{						
		sharedData();
		
		if(isDefined("params.id")) 
		{
			// Queries
			metafield = model(getMetafieldType()).findAll(where="id = '#params.id#'#wherePermission("Metafield","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(metafield))
			{				
				metafield = metafield[1];
			}
			
			// meta not found?
			if (!IsObject(metafield))
			{
				flashInsert(error="Not found");
				redirectTo(
					route		= "admin~Field",
					controller	= "metafields",
					action		= "index",
					modelName	= params.modelName, 
					params		= buttonParams
				);
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		sharedData();
		
		// Get metafield object
		if(!isNull(params.metafield.id)) 
		{
			metafield = model(getMetafieldType()).findByKey(params.metafield.id);
			saveResult = metafield.update(params.metafield);
		} else {
			metafield = model(getMetafieldType()).new(params.metafield);
			saveResult = metafield.save();
			isNewMetafield = true;
		}
		
		// Insert or update meta object with properties
		if (saveResult)
		{	
			flashInsert(success='Field saved.');
			redirectTo(
				route		= "admin~FieldId",
				controller	= "metafields",
				action		= "edit",
				modelName	= params.modelName, 
				id			= metafield.id, 
				params		= buttonParams
			);
		} else {						
			
			errorMessagesName = "metafield";
			param name="metafield.id" default="0";
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="metaFields", action="editor");		
		}		
	}
	
	function delete()
	{
		sharedData();
		
		metafield = model(getMetafieldType()).findByKey(params.id);
		// meta not found?
		if (!IsObject(metafield))
		{
			flashInsert(error="Not found");
		}
		else if(metafield.delete())
		{
			flashInsert(success="The field was deleted successfully.");							
		} else 
		{
			flashInsert(error="The field could not be found.");
		}
				
		redirectTo(
			route		= "admin~Field",
			controller	= "metafields",
			action		= "index",
			modelName	= params.modelName, 
			params		= buttonParams
		);
	}
}
</cfscript>