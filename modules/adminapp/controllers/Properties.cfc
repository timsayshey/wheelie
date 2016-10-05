<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function sharedObjects(propertyid)
	{		
		userlist = model("User").findAll(order="email ASC");
		
		propertycategories = model("PropertyCategory").findAll(where="categoryType = 'property'#wherePermission("PropertyCategory","AND")#");
		selectedpropertycategories = model("PropertyCategoryJoin").findAll(where="propertyid = #arguments.propertyid#",include="Property,PropertyCategory");
		selectedpropertycategories = ValueList(selectedpropertycategories.categoryid);
		
		sites = model("Site").findAll();
		usStates = getStatesAndProvinces();
		countries = getCountries();	

		dataFields = model("FormField").findAll(where="metafieldType = 'propertyfield' AND modelid = 3",order="sortorder ASC");
	}
	
	function property()
	{		
		if(!isNull(params.id))
		{
			property = model("property").findAll(where="id = '#params.id#'");
		}
	}

	function testEmail(){
		mailgun(
			mailTo	= application.wheels.noReplyEmail,
			from	= application.wheels.noReplyEmail,
			subject	= 'TEST EMAIL',
			html	= "TEST"
		);
		writeOutput("SUCCESS"); abort;
	}
	
	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);
				
		for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
		{
			sortVal = orderValues[i];
			
			sortProperty = model("Property").findOne(where="id = #sortVal.fieldId#");
					
			if(isObject(sortProperty))
			{
				sortProperty.update(sortorder=sortVal.newIndex);
			}
		}
		abort;
	}
	
	function category()
	{		
		sharedObjects(0);
		
		if(!isNull(params.id))
		{			
			propertyCategory = model("PropertyCategory").findAll(where="urlid = '#params.id#'#wherePermission("PropertyCategory","AND")#");				
		} else {
			// Get default category
			propertyCategory = model("PropertyCategory").findAll(where="defaultadmin = 1#wherePermission("PropertyCategory","AND")#");				
		}
		
		propertyCategories = model("PropertyCategory").findAll(where="parentid = '#propertyCategory.id#'#wherePermission("PropertyCategory","AND")#");
		
		if(propertyCategory.recordcount)
		{				
			distinctPropertyColumns = "id, sortorder, name, description, status, createdat, updatedat";
			propertyColumns = "#distinctPropertyColumns#, description, status, category_id";
			
			qProperties = model("Property").findAll(
				where	= buildWhereStatement(modelName="Property", prepend="categoryid = '#propertyCategory.id#' AND"), 
				order	= "sortorder ASC", 
				select	= propertyColumns,
				include = "propertycategoryjoin(propertycategory)"
			);
			
			filterResults();
		}
	}
	
	function index()
	{
		sharedObjects(0);
		distinctPropertyColumns = "id, sortorder, name, description, status, createdat, updatedat";
		propertyColumns = "#distinctPropertyColumns#, description, status, category_id";
		
		statusTabs("property");
		
		qProperties = model("Property").findAll(
			where	= buildWhereStatement("Property"), 
			order	= !isNull(params.rearrange) ? "sortorder ASC" : session.properties.sortby & " " & session.properties.order, 
			select	= propertyColumns
		);
				
		if(isNull(params.rearrange))
		{
			filterResults();
		}
		
		// Paginate me batman
		pagination = application.pagination;
		pagination.setQueryToPaginate(qProperties);	
		pagination.setItemsPerPage(session.perPage);		
		paginator = pagination.getRenderedHTML();
		
		// If oauth comes back to homepage
		if(!isNull(params.token))
		{
			property = model("Property").findAll(where="id = #params.id#");
		}
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			sharedObjects(params.id);						
			property = model("Property").findAll(where="id = '#params.id#'#wherePermission("Property","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(property))
			{				
				property = property[1];
			}

			photos = model("PropertyMediafile").findAll(where="modelid = '#params.id#' AND mediafileType = 'property'",order="sortorder ASC"); 
			
			// Property not found?
			if (!IsObject(property))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="properties");
			}		

			dataFields = model("FieldData").getAllFieldsAndUserData(
				modelid = 3,
				foreignid = params.id,
				metafieldType = "propertyfield"
			);

		}

		renderPage(action="editor");		
	}

	function panoedit()
	{						
		if(isDefined("params.id")) 
		{
			property = model("Property").findAll(where="id = '#params.id#'#wherePermission("Property","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(property))
			{				
				property = property[1];
			}
			panoramas = model("PanoramaMediafile").findAll(where="modelid = '#property.id#' AND mediafileType = 'panorama'",order="sortorder ASC"); 
		}	
	}

	function panoeditor()
	{						
		if(isDefined("params.id")) 
		{
			property = model("Property").findAll(where="id = '#params.propertyid#'#wherePermission("Property","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(property))
			{				
				property = property[1];
			}
			panorama = model("PanoramaMediafile").findAll(where="id = '#params.id#' AND mediafileType = 'panorama'",order="sortorder ASC"); 
			panoramas = model("PanoramaMediafile").findAll(where="modelid = '#params.propertyid#' AND mediafileType = 'panorama'",order="sortorder ASC"); 
			photos = model("PropertyMediafile").findAll(where="modelid = '#params.propertyid#' AND mediafileType = 'property'",order="sortorder ASC");
		}	
	}

	function panoramas()
	{						
		usesLayout("/layouts/layout.blank");
		if(isDefined("params.id")) {
			panoramas = model("PanoramaMediafile").findAll(where="modelid = '#params.id#' AND mediafileType = 'panorama'",order="sortorder ASC"); 
		} else {abort;}		
	}

	function addLink()
	{			
		mediafile = model("PanoramaMediafile").findByKey(key=params.parentid,reload=true);
		
		if(isJson(mediafile.settings) AND isArray(deserializeJSON(mediafile.settings))) {
			var settings = deserializeJSON(mediafile.settings);
		} else {
			var settings = [];
		}
		
		arrayAppend(settings, {"mediafileid":params.childid,"fileid":params.childfileid,"yaw":params.yaw,"uuid":params.containsKey("uuid") ? params.uuid : createUUID(),"caption": params.containsKey("caption") ? params.caption : "","type": params.containsKey("type") ? params.type : "pano"});

		saveResult = mediafile.update({ "id":params.parentid, "settings":serializeJSON(settings) });

		var response = getPageContext().getResponse(); 
		response.setContentType("application/json");
		writeOutput(serializeJSON({"success":saveResult,"save":settings})); abort;
	}

	function removeLink()
	{			
		mediafile = model("PanoramaMediafile").findByKey(key=params.parentid,reload=true);
		if(isJson(mediafile.settings) AND isArray(deserializeJSON(mediafile.settings))) {
			var settings = deserializeJSON(mediafile.settings);
			
			for (var i=1;i LTE ArrayLen(settings);i=i+1) {

				if(settings[i].containsKey("uuid") AND settings[i].uuid eq params.uuid) {
					if(params.containsKey("caption")) {
						structAppend(params, {"childid":settings[i].mediafileid,"childfileid":settings[i].fileid,"yaw":settings[i].yaw,"uuid":settings[i].uuid,"caption": params.caption,"type":settings[i].containsKey("type") ? settings[i].type : "pano"}, true);

					}
					arrayDeleteAt(settings, i);
				}
			}
		}
		
		saveResult = mediafile.update({ "id":params.parentid, "settings":serializeJSON(settings) });		
		
		if(params.action neq "updateLink") { 
			var response = getPageContext().getResponse(); 
			//response.setContentType("application/json"); 
			writeOutput(serializeJSON({"success":saveResult})); 
			abort; 
		}
	}

	function updateLink()
	{
		removeLink();
		addLink();
	}

	function panoLinks()
	{			
		usesLayout("/layouts/layout.blank");

		var mediafile = model("PanoramaMediafile").findByKey(params.id);
		if(isJson(mediafile.settings) AND isArray(deserializeJSON(mediafile.settings))) {
			var settingslist = deserializeJSON(mediafile.settings);
			settings = [];
			for(var setting in settingslist) {
				mediafile = model("PanoramaMediafile").findAll(where="id = '#setting.mediafileid#'");
				arrayAppend(settings,{"uuid":setting.uuid,"data":mediafile,"caption":setting.containsKey("caption") ? setting.caption : ""});
			}
		} else {
			settings = [];
		}
	}
	
	function photos()
	{						
		usesLayout("/layouts/layout.blank");
		if(isDefined("params.id")) {
			photos = model("PropertyMediafile").findAll(where="modelid = '#params.id#' AND mediafileType = 'property'",order="sortorder ASC"); 
		} else {abort;}		
	}

	function new()
	{
		// Queries
		property = model("Property").new(colStruct("Property"));

		dataFields = model("FormField").findAll(where="metafieldType = 'propertyfield' AND modelid = 3",order="sortorder ASC");

		sharedObjects(0);
		
		// If not allowed redirect
		wherePermission("Property");
		
		// Show page
		renderPage(action="editor");
	}


	function delete()
	{
		property = model("Property").findByKey(params.id);
		
		if(property.delete())
		{
			flashInsert(success="The property was deleted successfully.");							
		} else 
		{
			flashInsert(error="The property could not be found.");
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="properties"
		);
	}
	
	function save()
	{					
		// Spam check
		try {
			http method="GET" url="http://ip-api.com/json/#getIpAddress()#" result="jsonResult";
			jsonResult = DeserializeJSON(jsonResult.filecontent);
			if(jsonResult.containsKey("countryCode") AND jsonResult.countryCode NEQ "US") {
				throw("Sorry, there was an error. Please try again later.");
			}			
		} catch(e) {			
		}

		var loc = {};
		
		param name="params.property.propertyfileid" default="";
		param name="params.propertycategories" default="";
		
		// Handle submit button type (publish,draft,trash,etc)
		if(!isNull(params.submit))
		{
			params.property.status = handleSubmitType("property", params.submit);	
		}
		
		if(!isNull(params.property.ownerid) AND isNumeric(params.property.ownerid))
		{
			params.property.createdby = params.property.ownerid;
		} else {
			params.property.ownerid = session.user.id;
		}

		if(!isNull(params.property.name)) {
			params.property.urlid = lcase(cleanUrlId(params.property.address));
		}

		// Get property object
		if(!isNull(params.property.id)) 
		{
			property = model("Property").findByKey(params.property.id);
			saveResult = property.update(params.property);	
			
			// Clear existing property category associations
			model("propertyCategoryJoin").deleteAll(where="propertyid = #params.property.id#");
		} else {

			if(len(trim(params.property.address)) AND !len(trim(params.property.name))) {
				params.property.name = params.property.address;
			}

			property = model("Property").new(params.property);
			saveResult = property.save();
		}
		
		// Insert or update property object with properties
		if (saveResult) 
		{
			
			// Insert new property category associations			
			for(id in ListToArray(params.propertycategories)) {				
				model("propertyCategoryJoin").create(categoryid = id, propertyid = property.id);				
			}

			// Save custom metafeild data
			if(!isNull(params.fielddata)) { 
				model("FieldData").saveFielddata(
					fields		= params.fielddata,
					foreignid	= property.id
				);
			}
			
			flashInsert(success="Property saved.");
			redirectTo(route="admin~Id", module="admin", controller="properties", action="edit", id=property.id);	
		} else {						
			
			errorMessagesName = "property";
			param name="property.id" default="0";
			sharedObjects(property.id);
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="properties", action="editor");		
		}		
	}
	
	function deleteSelection()
	{
		for(var i=1; i LTE ListLen(params.deletelist); i++)
		{
			model("Property").findByKey(ListGetAt(params.deletelist,i)).delete();
		}
		
		flashInsert(success="Your properties were deleted successfully!");			
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="properties"
		);
	}
	
	function setPerPage()
	{
		if(!isNull(params.id) AND IsNumeric(params.id))
		{
			session.perPage = params.id;
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="properties"
		);
	}
	
	function filterResults()
	{
		if(!isNull(params.filtertype) AND params.filtertype eq "clear")
		{
			resetIndexFilters();
		}
		else
		{
			// Get main query
			qqProperties = qProperties;	
			rememberParams = "";				
			
			// Set display type
			if(!isNull(params.display))
			{
				session.display = params.display;			
			}			
			
			// Set sort
			if(!isNull(params.sort))
			{
				session.properties.sortby = params.sort;			
			}
			
			// Set order
			if(!isNull(params.order))
			{
				session.properties.order = params.order;			
			}
			
			// Set "hosted" filter
			if(!isNull(params.hosted))
			{
				session.properties.hosted = params.hosted;
			}	
			
			// Apply "search" filter
			if(!isNull(params.search) AND len(params.search))
			{
				rememberParams = ListAppend(rememberParams,"search=#params.search#","&");
				
				// Break apart search string into a keyword where clause
				var whereKeywords = [];			
				var keywords = listToArray(trim(params.search)," ");			
				for(keyword in keywords)
				{
					ArrayAppend(whereKeywords, "name LIKE '%#keyword#%'");
					ArrayAppend(whereKeywords, "description LIKE '%#keyword#%'");
				}
				
				// Include permission check if defined
				whereKeywords = ArrayToList(whereKeywords, " OR ");
				if(len(wherePermission("Property")))
				{
					whereClause = wherePermission("Property") & " AND (" & whereKeywords & ")";
				} else {
					whereClause = whereKeywords;	
				}					
				
				qqProperties = model("Property").findAll(
					where	= whereClause,
					order	= session.properties.sortby & " " & session.properties.order, 
					select	= propertyColumns,
					include = "propertycategoryjoin(propertycategory)"
				);
			}
			
			// Apply "category" filter
			if(!isNull(params.filtercategories) AND len(params.filtercategories))
			{
				rememberParams = ListAppend(rememberParams,"filtercategories=#params.filtercategories#","&");				
				var filtercategories = listToArray(params.filtercategories);
				var whereCategories = [];
				
				for(categoryid in filtercategories)
				{
					ArrayAppend(whereCategories, "category_id = #categoryid#");
				}
				
				whereCategories = ArrayToList(whereCategories, " OR ");
				
				qqProperties = queryOfQueries(
					query	= "qqProperties",
					where	= whereCategories
				);
			}
			
			// Clear out the duplicates
			qqProperties = queryOfQueries(
				query	= "qqProperties", 
				select	= "DISTINCT #distinctPropertyColumns#", 
				order	= session.properties.sortby & " " & session.properties.order
			);
			
			qProperties = qqProperties;
			
			if(len(rememberParams))
			{
				pagination.setAppendToLinks("&#rememberParams#");
			}
			
			//renderPage(route="admin~Action", module="admin", controller="properties", action="index");		
		}
	}
}
</cfscript>