<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function sharedData()
	{
		pages = model("Page").findAll(order="name ASC");
		posts = model("Post").findAll(order="name ASC");
	}
	
	function new()
	{					
		sharedData();
		
		menu = model("Menu").new(colStruct("Menu"));
		menus = model("Menu").findAll();
		renderPage(action="editor");
	}
	
	function delete()
	{
		video = model("Menu").findByKey(params.id);
		
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
			menu = model("Menu").findAll(where="id = '#params.id#'#wherePermission("Menu","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(menu))
			{				
				menu = menu[1]; 
			}	
		}
		
		menus = model("Menu").findAll();
		renderPage(action="editor");		
	}
	
	function rearrange()
	{
		sharedData();
		
		menus = model("Menu").findAll(order="sortOrder ASC, name ASC", select="id, name, parentid, sortOrder", distinct=true);
	}
	
	function saveRearrange()
	{
		var loc = {};
		
		loc.newOrder = DeserializeJSON(params.menuOrder);
		
		for(i=1; i LTE arrayLen(loc.newOrder); i++)
		{
			loc.curr = loc.newOrder[i];
			
			if(!isNull(loc.curr.item_id))
			{
				if(isNull(loc.curr.parent_id) OR !IsNumeric(loc.curr.parent_id)) 
				{
					loc.curr.parent_id = 0;
				}
				
				videoCat = model("Menu").
				findByKey(loc.curr.item_id).
				update(
					parentid = loc.curr.parent_id,
					sortOrder = i
				);
			}
		}
		
		flashInsert(success="Updated successfully.");
		redirectTo(route="admin~Menu", action="rearrange", modelName="Menu");	
	}
	
	function save()
	{				
		if(params.menu.itemType eq "page")
		{
			params.menu.itemId = params.menu.pageId;	
		} 
		else if(params.menu.itemType eq "post")
		{
			params.menu.itemId = params.menu.postId;
		}
		else
		{
			params.menu.itemId = "";
		}
		
		// Save
		if(!isNull(params.menu.id)) 
		{
			menu = model("Menu").findByKey(params.menu.id);
			saveResult = menu.update(params.menu);	
			
		} else {
			menu = model("Menu").new(params.menu);
			saveResult = menu.save();
		}
		
		// Redirect based on result
		if (saveResult)
		{			
			if(isNull(isAjaxRequest))
			{
				flashInsert(success="Saved successfully.");
				redirectTo(route="admin~Menu", action="index", modelName=params.modelName);	
			}
			else
			{
				json = SerializeJSON({
					response = "success",
					option = {
						value = menu.id,
						text = menu.name
					}
				});
				
				writeOutput(json); abort;
			}
			
					
		} else {	
		
			if(isNull(isAjaxRequest))
			{
				errorMessagesName = "Menu";
				flashInsert(error="There was an error.");
				redirectTo(route="admin~Menu", action="editor", modelName=params.modelName);					
			}
			else
			{
				json = SerializeJSON({
					response = "error",
					errors = 
					'<div class="alert alert-danger alert-dismissable fade in">
							<button class="close" data-dismiss="alert">&times;</button>
							#errorMessagesFor("menu")#
					</div>'
				});
				
				writeOutput(json); abort;
			}
		}		
	}
}
</cfscript>