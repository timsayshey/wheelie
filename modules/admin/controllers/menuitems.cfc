<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function rearrange()
	{
		var loc = {};
		
		qOptions = model("Option").findAll(where=wherePermission("Option"), order="id asc");
		
		loc.menuId = !isNull(params.id) ? params.id : "primary";
		params.id = loc.menuId;
		menuitems = model("MenuItem").findAll(where="menuid = '#loc.menuId#'", order="sortOrder ASC, name ASC");
		videocategories = model("VideoCategory").findAll(order="sortOrder ASC, name ASC", select="id, urlid, name, parentid, sortOrder", distinct=true);	
		pages = model("Page").findAll(where=wherePermission("Page"), order=session.pages.sortby & " " & session.pages.order);			
		getOptions();	
	}
	
	function getOptions()
	{		
		// Do VideoCategories
		videoCategoryOptions = [];
		for (vcategory in videocategories)
		{
			ArrayAppend(
				videoCategoryOptions,
				{
					text	= vcategory.name,
					value	= "/video/c/#vcategory.urlid#"
				}
			);
		}
		
		// Do Pages
		pageOptions = [];
		for (page in pages)
		{
			ArrayAppend(
				pageOptions,
				{
					text	= page.name,
					value	= "/p/#page.urlid#"
				}
			);
		}
	}
	
	function saveRearrange()
	{
		var loc = {};	
				
		loc.newData = DeserializeJSON(params.data);		
		loc.newOrder = loc.newData.data;
		
		loc.menuId = !isNull(loc.newData.menuid) ? loc.newData.menuid : "primary";	
		
		model("MenuItem").deleteAll(where="menuid = '#loc.menuid#'");
		
		for(i=1; i LTE arrayLen(loc.newOrder); i++)
		{
			loc.item = loc.newOrder[i];
			
			if(!isNull(loc.item.itemname))
			{
				if(isNull(loc.item.parentid) OR !IsNumeric(loc.item.parentid)) 
				{
					loc.item.parentid = 0;
				}
				
				loc.menuitems = model("MenuItem").new({
					id			= loc.item.sortOrder,
					parentid 	= loc.item.parentid,
					name		= loc.item.itemname,
					sortOrder	= loc.item.sortOrder,
					menuid		= loc.menuId,
					urlPath		= loc.item.urlpath
				});	
				
				if(loc.menuitems.save())
				{
					flashInsert(success="Updated successfully.");
				} else {
					flashInsert(error="Update failed.");					
				}					
			}
		}
		
		writeOutput('{ "Message" : "", "Success" : true }');
		abort;
		
		redirectTo(route="moduleId", module="admin", controller="menuitems", action="rearrange", id=loc.menuId);	
	}
}
</cfscript>