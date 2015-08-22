<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init(); 
	}
	
	function getCategoryType()
	{
		// model names in listfind must be lowercase
		if(!isNull(application.info.validCategoryModelsList) AND ListFind("videocategory,usertag,#application.info.validCategoryModelsList#",LCase(params.modelName)))
		{
			return params.modelName;
		} else {
			throw("#params.modelName# not found in application.info.validCategoryModelsList!");
			return "";
		}
	}
	
	function sharedData()
	{
		categoryInfo = model(getCategoryType()).categoryInfo();
	}
	
	function new()
	{					
		sharedData();
		
		category = model(getCategoryType()).new();
		categories = model(getCategoryType()).findAll();
		sites = model("Site").findAll();
		renderPage(action="editor");
	}
	
	function delete()
	{
		video = model(getCategoryType()).findByKey(params.id);
		
		try {
			if(video.delete())
			{
				writeOutput('{ "Message" : "", "Success" : true }');
			} else {
				writeOutput('{ "Message" : "", "Success" : false }');
			}
		} catch(any e) {
			writeOutput('{ "Message" : "", "Success" : false }');
		}
		abort;
	}
	
	function edit()
	{						
		sharedData();
		
		if(isDefined("params.id")) 
		{
			// Queries					
			category = model(getCategoryType()).findAll(where="id = '#params.id#'#wherePermission("Video","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(category))
			{				
				category = category[1];
			}	
		}
		
		categories = model(getCategoryType()).findAll();
		sites = model("Site").findAll();
		renderPage(action="editor");		
	}
	
	function rearrange()
	{
		sharedData();
		
		categories = model(getCategoryType()).findAll(order="sortOrder ASC, name ASC", select="id, name, parentid, sortOrder", distinct=true);
	}
	
	function saveRearrange()
	{
		var loc = {};
		
		loc.newOrder = DeserializeJSON(params.categoryOrder);
		
		for(i=1; i LTE arrayLen(loc.newOrder); i++)
		{
			loc.curr = loc.newOrder[i];
			
			if(!isNull(loc.curr.item_id))
			{
				if(isNull(loc.curr.parent_id) OR !IsNumeric(loc.curr.parent_id)) 
				{
					loc.curr.parent_id = 0;
				}
				
				videoCat = model(getCategoryType()).
				findByKey(loc.curr.item_id).
				update(
					parentid = loc.curr.parent_id,
					sortOrder = i
				);
			}
		}
		
		flashInsert(success="Updated successfully.");
		redirectTo(route="admin~Category", action="rearrange", modelName=params.modelName);	
	}
	
	function save()
	{				
		// Save
		if(!isNull(params.category.id)) 
		{
			category = model(getCategoryType()).findOne(where="id = '#params.category.id#'#wherePermission("Category","AND")#");
			saveResult = category.update(params.category);
			
		} else {
			category = model(getCategoryType()).new(params.category);
			saveResult = category.save();
		}
		
		// Redirect based on result
		if (saveResult)
		{			
			// Reset DefaultPublic
			if(!isNull(category.defaultpublic) AND category.defaultpublic eq 1)
			{
				model(getCategoryType()).updateAll(defaultpublic=0, where="defaultpublic = 1 AND id != '#category.id#'#wherePermission("Category","AND")#");
			}
			
			// Reset DefaultAdmin
			if(!isNull(category.defaultadmin) AND category.defaultadmin eq 1)
			{
				model(getCategoryType()).updateAll(defaultadmin=0, where="defaultadmin = 1 AND id != '#category.id#'#wherePermission("Category","AND")#");
			}
			
			if(isNull(isAjaxRequest))
			{
				flashInsert(success="Saved successfully.");
				redirectTo(route="admin~Category", action="index", modelName=params.modelName);	
			}
			else
			{
				json = SerializeJSON({
					response = "success",
					option = {
						value = category.id,
						text = category.name
					}
				});
				
				writeOutput(json); abort;
			}
						
					
		} else {	
		
			if(isNull(isAjaxRequest))
			{
				errorMessagesName = getCategoryType();
				flashInsert(error="There was an error.");
				redirectTo(route="admin~Category", action="editor", modelName=params.modelName);					
			}
			else
			{
				json = SerializeJSON({
					response = "error",
					errors = 
					'<div class="alert alert-danger alert-dismissable fade in">
							<button class="close" data-dismiss="alert">&times;</button>
							#errorMessagesFor("category")#
					</div>'
				});
				
				writeOutput(json); abort;
			}
		}		
	}
}
</cfscript>