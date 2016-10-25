<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index() {
		var catCheck = params.containsKey('categoryid') ? " AND categories.urlid LIKE '" & params.categoryid & "'" : '';
		var userCheck = params.containsKey('ownerid') ? " AND users.id = " & params.ownerid : '';
		items = model("item").findAll(
			where	= "hidden = 0 AND market_enabled = 1 AND " & whereSiteid() & catCheck & userCheck,
			order	= "items.isfeatured DESC, items.createdAt DESC", 
			include = "user" & (params.containsKey('categoryid') ? ",ItemCategoryJoin(ItemCategory)" : ""),
			select="items.id,items.ownerid,items.name,items.description,items.inventory,items.unit,items.price,items.hidden,items.isfeatured,items.sortorder,items.status,items.siteid,items.createdat,items.createdby,items.updatedat,items.updatedby,items.todelete,items.deletedat,items.deletedby,items.globalized,items.oodleData,items.location,items.oodleid,items.contactDetails,items.contactType,items.urlid,items.locationid,users.id AS Userid,users.sortorder AS Usersortorder,users.market_enabled,users.approval_flag,users.securityApproval,users.username,users.zx_company"
		);		

		user = model("User").new(colStruct("User"));

		item = model("Item").new(colStruct("Item"));

		categories = model("ItemCategory").findAll(where="categoryType = 'item'");

		pagination.setQueryToPaginate(items);	
		pagination.setItemsPerPage(20);		
		paginator = pagination.getRenderedHTML();
	}

	function rss(){
		usesLayout("/layouts/layout.blank");
		items = model("item").findAll(
			where	= "#whereSiteid()#",
			order	= "updatedat DESC,createdat DESC",
			maxRows = 2
		);	
	}

	function itemForm() {
		var itemParams = params.containsKey("item") ? params.item : colStruct("Item");
		item = model("Item").new(itemParams);
		user = model("User").new(colStruct("User"));
	}

	function itemPost() {
		preserveImage();

		var itemData = params.containsKey("item") ? params.item : colStruct("Item");
		item = model("Item").new(itemData);

		if(params.containsKey("id")) {
			item = model("Item").findOne(where="id = '#params.id#'");
		}		
		
		user = model("User").new(colStruct("User"));

		if(!params.containsKey("id") AND session.containsKey("user") AND !params.containsKey("itemPosted") AND !isNull(params.item)) {
			saveItem(params.item,session.user.id);

			if(!isNull(item.id)) {
				flashInsert(success="Your listing has been created!");
				redirectTo(route='public~itemPage', urlid=item.urlid, locationid=item.locationid);
			}
		}
	}

	function item() {	
		if(isNull(params.locationid) OR isNull(params.urlid)) {
			header statuscode="301" statustext="Moved Permanently";
			header name="Location" value="/";
			abort;
		}

		item = model("item").findAll(
			where	= "locationid LIKE '#params.locationid#' AND urlid LIKE '#params.urlid#' AND hidden = 0 AND #whereSiteid()#",
			include = "user"
		);

		if(!item.recordcount) {
			header statuscode="301" statustext="Moved Permanently";
			header name="Location" value="/";
			abort;
		}
	}

	function loginPost()
	{
		param name="params.email" default="";

		// Don't check siteId for main site (that way we can redirect them to their correct site)
		var siteIdEqualsCheck = "AND #siteIdEqualsCheck()#";
		// if(request.site.subdomain eq "www") {
		// 	siteIdEqualsCheck = "";
		// }
		
		var getUser = model("User").findAll(where="email = '#params.email#' AND password = '#passcrypt(params.pass, "encrypt")#'");
		
		if(getUser.recordcount AND getUser.securityApproval eq 1)
		{
			session.user.id = getUser.id;
			setUserInfo();
			params.item = deserializeJSON(params.item);
			saveItem(params.item,getUser.id);

			if(!isNull(item.id)) {
				flashInsert(success="Your listing has been created!");	
				params.itemPosted = true;
				redirectTo(route='public~itemPage', urlid=item.urlid, locationid=item.locationid);
			}
		
		} else {	
			user = model("user").new();	
			item = deserializeJSON(params.item);
			if(!isStruct(item)) {
				item = deserializeJSON(item);
			} 
			if(!isStruct(item)) {
				item = deserializeJSON(item);
			} 
			flashInsert(error="Email or password incorrect, please try again.");	
			renderPage(route="public~Action", controller="pitems", action="itemPost");	
		}
	}

	function preserveImage() {
		if(!isNull(params.item.photo) AND fileExists(expandPath(params.item.photo))) {
			// Save temp
			var tempImage = "/assets/uploads/items/#CreateUUID()#.jpg";
			var tempImagePath = expandPath(tempImage);
			var img = imageRead(params.item.photo);
			imageWrite(img,tempImagePath,1);

			fileDelete(expandPath(params.item.photo));

			itemParams.photo = tempImage;
			params.item.photo = tempImage;	
		}		
	}

	function saveItem(itemParams,userid) {
		// Spam check
		try {
			http method="GET" url="http://ip-api.com/json/#getIpAddress()#" result="jsonResult";
			jsonResult = DeserializeJSON(jsonResult.filecontent);
			if(jsonResult.containsKey("countryCode") AND jsonResult.countryCode NEQ "US") {
				throw("Sorry, there was an error. Please try again later.");
			}			
		} catch(e) {			
		}
		
		if(findNoCase('fifa', itemParams.name)) {
			throw("Sorry, there was an error. Please try again later.");
		}	

		itemParams.urlid = replaceNoCase(itemParams.name & "-" & ListGetAt(CreateUUID(),2,"-"),"&","and");
		itemParams.urlid = lcase(cleanUrlId(itemParams.urlid));
		if(!len(trim(itemParams.urlid))) itemParams.urlid = ListGetAt(CreateUUID(),2,"-");

		itemParams.locationid = replaceNoCase(itemParams.location,",","");
		itemParams.locationid = lcase(cleanUrlId(itemParams.locationid));
		if(!len(trim(itemParams.locationid))) itemParams.locationid = ListGetAt(CreateUUID(),2,"-");

		itemParams.ownerid = userid;
		item = model("Item").new(itemParams);
		var saveResult = item.save();

		if(isNull(item.id)) 
		{
			errorMessagesName = "item";
			flashInsert(error="There was an error.");
			renderPage(route="public~Action", controller="pitems", action="itemPost");		
		} else {								
			if(uploadItemImage("photo",item.id))
			{
				params.item.photo = "";
			}
		}
	}

	function registerPost()
	{			
		request.newRegistration = true;
		
		// Save user
		params.user.password = passcrypt(params.user.password, "encrypt");
		user = model("User").new(params.user);
		saveResult = user.save(); 

		// Insert or update user object with properties
		if (saveResult)
		{			
			// Default usergroup to staff ("1")
			defaultUsergroup = model("Usergroup").findOne(where="defaultgroup = 1#wherePermission("Usergroup","AND")#");
			model("UsergroupJoin").create(usergroupid = defaultUsergroup.id, userid = user.id);
			
			session.user.id = user.id;
			setUserInfo();

			params.item = deserializeJSON(params.item);
			saveItem(params.item,user.id);

			if(!isNull(item.id)) {
				flashInsert(success="Your account and listing have been created!");
				params.itemPosted = true;
				redirectTo(route='public~itemPage', urlid=item.urlid, locationid=item.locationid);
			}
											
		} 
		else 
		{
			item = deserializeJSON(params.item);
			if(!isStruct(item)) {
				item = deserializeJSON(item);
			} 
			item = model("item").new(item);
			errorMessagesName = "user";
			flashInsert(error="There was an error.");
			renderPage(route="public~Action", controller="pitems", action="itemPost");		
		}		
	}

	function vendors()
	{
		qVendorWithItems = model("User").findAll(
			where	= "ownerid IS NOT NULL AND hidden = 0 AND market_enabled = 1 AND #whereSiteid()#",
			order	= "ownerid DESC, categoryid ASC", 
			include = "item(itemcategoryjoin(itemcategory)),UsergroupJoin(usergroup)",
			order	= "ownerid,categoryid,itemid"	
		);
	}

	function uploadItemImage(field,filename,nonfieldpath)
	{
		var loc = {};
		
		if(!isNull(arguments.filename) AND !isNull(params.item.photo) AND fileExists(expandPath(params.item.photo)))
		{		
			var result.fileWasSaved = true;
			var theFile = expandPath(params.item.photo);			

			if(result.fileWasSaved) {
				
				var smFile = expandPath("/assets/uploads/items/sm/#arguments.filename#.jpg");
				var mdFile = expandPath("/assets/uploads/items/md/#arguments.filename#.jpg");
				var lgFile = expandPath("/assets/uploads/items/lg/#arguments.filename#.jpg");
				if(!isImageFile(thefile)) 
				{
					fileDelete(theFile);
					return false;
				} else {					
					var img = imageRead(thefile);
					var imgLg = imageRead(thefile);
					try {					
						imageScaleToFit(img, 850, 850);
						imageWrite(img,mdFile,1);
						
						imageScaleToFit(img, 250, 250);
						imageWrite(img,smFile,1);

						imageWrite(imgLg,lgFile,1);
						
						fileDelete(theFile);
					} catch(e) {
						flashInsert(error="There was an issue with the image you tried to upload. Try uploading a JPG.");
						return false;
					}
					return true;
				}
			} 						
		}
		return false;
	}
}
</cfscript>